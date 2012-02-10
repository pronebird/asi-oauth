//
//  ASIOAuthWebHelper.m
//
//  Created by Andrei Mikhailov on 2/8/12.
//  Copyright (c) 2012 Andrei Mikhailov. All rights reserved.
//

#import "ASIOAuthWebHelper.h"

#define kASIOAuthWebHelperAnimDuration .5

@interface ASIOAuthWebHelper()

@property (retain, readwrite) UIWebView* webView;
@property (retain, readwrite) UINavigationBar* webViewNavBar;
@property (retain, readwrite) UIActivityIndicatorView* spinner;
@property (assign, readwrite) BOOL isShown;

@end

@implementation ASIOAuthWebHelper

@synthesize webView = _webView;
@synthesize webViewNavBar = _webViewNavBar;
@synthesize spinner = _spinner;
@synthesize isShown = _isShown;
@synthesize delegate = _delegate;

- (id)init
{
	self = [super init];
	
	if(self) {
		self.webView = nil;
		self.webViewNavBar = nil;
		self.spinner = nil;
		self.isShown = FALSE;
		self.delegate = nil;
	}
	
	return self;
}

- (void)dealloc
{
	if(self.webView) {
		[self.webView stopLoading];
		[self.webView removeFromSuperview];
	}

	self.webView = nil;
	self.webViewNavBar = nil;
	self.spinner = nil;
	self.delegate = nil;
	
	[super dealloc];
}

- (void)showWithURL:(NSURL*)url
{
	UIWindow* wnd = [[UIApplication sharedApplication] keyWindow];
	CGRect windowRect = wnd.frame;
	
	NSURLRequest* request = [NSURLRequest requestWithURL:url];
	
	self.isShown = TRUE;
	
	// create controller if it's not created yet
	if(!self.view) {
		[self loadView];
	}
	
	self.webView.hidden = TRUE;
	[self.webView loadRequest:request];
	
	windowRect.origin.y = 20;
	windowRect.size.height -= windowRect.origin.y;
	
	self.view.hidden = FALSE;
	[wnd bringSubviewToFront:self.view];
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationBeginsFromCurrentState:TRUE];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:kASIOAuthWebHelperAnimDuration];
	self.view.frame = windowRect;
	[UIView commitAnimations];
	
	[self retain];
}

- (void)hide
{
	UIWindow* wnd = [[UIApplication sharedApplication] keyWindow];
	CGRect windowRect = wnd.frame;
	
	self.isShown = FALSE;
	
	windowRect.origin.y = windowRect.size.height;
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationBeginsFromCurrentState:TRUE];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:kASIOAuthWebHelperAnimDuration];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(webViewHideAnimationDidStop:finished:context:)];
	self.view.frame = windowRect;
	[UIView commitAnimations];
	
	if([self.webView isLoading])
		[self.webView stopLoading];
	
	[self.webView endEditing:TRUE];
}

- (void)webViewHideAnimationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
	self.view.hidden = TRUE;
	
	[self release];
}

- (void)loadView
{
	UIWindow* wnd = [[UIApplication sharedApplication] keyWindow];
	CGRect windowRect = wnd.frame;
	
	self.view = [[[UIView alloc] initWithFrame:CGRectMake(0, windowRect.size.height, windowRect.size.width, windowRect.size.height-20)] autorelease];
	self.view.hidden = TRUE;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	UIWindow* wnd = [[UIApplication sharedApplication] keyWindow];
	CGRect windowRect = wnd.frame;
	
	windowRect.origin.y = 44.0;
	windowRect.size.height -= 64.0;
	
	UINavigationItem* navItem = [[[UINavigationItem alloc] initWithTitle:NSLocalizedString(@"Authorization", @"")] autorelease];
	UIBarButtonItem* closeButton = [[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Close", @"") style:UIBarButtonItemStylePlain target:self action:@selector(onCloseButton)] autorelease];
	[navItem setRightBarButtonItem:closeButton animated:TRUE];
	
	self.webViewNavBar = [[[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, windowRect.size.width, 44.0)] autorelease];
	[self.webViewNavBar pushNavigationItem:navItem animated:FALSE];
	
	self.spinner = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray] autorelease];
	self.spinner.hidden = TRUE;
	CGRect spinnerRect = self.spinner.frame;
	self.spinner.frame = CGRectMake(windowRect.size.width / 2.0 - spinnerRect.size.width / 2.0, 
									windowRect.origin.y + (windowRect.size.height / 2.0 - spinnerRect.size.height / 2.0), spinnerRect.size.width, spinnerRect.size.height);
	
	self.webView = [[[UIWebView alloc] initWithFrame:windowRect] autorelease];
	self.webView.delegate = self;
	
	[self.view addSubview:self.webViewNavBar];
	[self.view addSubview:self.webView];
	[self.view addSubview:self.spinner];
	
	[[[UIApplication sharedApplication] keyWindow] addSubview:self.view];
}

- (void)viewDidUnload
{
	self.webView = nil;
	self.webViewNavBar = nil;
	self.spinner = nil;
	
	[super viewDidUnload];
}

- (BOOL)webView:(UIWebView*)aWebView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType
{
	NSURL* pageURL = [request URL];
	
	NSLog(@"redirect: %@", [pageURL absoluteString]);
	
	if([self.delegate respondsToSelector:@selector(oauthWebHelper:shouldFollowRedirect:)])
		if(![self.delegate oauthWebHelper:self shouldFollowRedirect:request])
			return FALSE;
	
	self.spinner.hidden = FALSE;
	[self.spinner startAnimating];
	
	return TRUE;
}

- (void)webView:(UIWebView*)webView didFailLoadWithError:(NSError*)error
{	
	// ignore cancel errors
	if(error.code != 102 && error.code != -999) 
	{
		[self showErrorWithTitle:NSLocalizedString(@"Authorization failed", @"") message:[error localizedDescription]];
		[self hide];
	}
}

- (void)webViewDidFinishLoad:(UIWebView*)aWebView
{
	self.spinner.hidden = TRUE;
	self.webView.hidden = FALSE;
	[self.spinner stopAnimating];
	
	NSLog(@"webViewDidFinishLoad: %@", [[aWebView.request URL] absoluteString]);
	
	//self.webView.hidden = TRUE;
	//[self hide];
}

- (void)onCloseButton {
	[self hide];
}

- (void)showErrorWithTitle:(NSString*)title message:(NSString*)msg {
	UIAlertView* errorAlert = [[[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
	
	[errorAlert show];
}

@end
