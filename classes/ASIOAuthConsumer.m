//
//  ASIOAuthConsumer.m
//
//  Created by Andrei Mikhailov on 2/8/12.
//  Copyright (c) 2012 Andrei Mikhailov. All rights reserved.
//

#import "ASIOAuthConsumer.h"

@interface ASIOAuthConsumer()
@property (readwrite, retain) NSDictionary* oauthUserData;
@end

@implementation ASIOAuthConsumer

@synthesize consumerKey = _consumerKey;
@synthesize consumerSecret = _consumerSecret;
@synthesize oauthToken = _oauthToken;
@synthesize oauthTokenSecret = _oauthTokenSecret;
@synthesize oauthCallbackURL = _oauthCallbackURL;
@synthesize oauthLocale = _oauthLocale;
@synthesize oauthUserData = _oauthUserData;
@synthesize oauthRequestTokenURL = _oauthRequestTokenURL;
@synthesize oauthAuthorizeURL = _oauthAuthorizeURL;
@synthesize oauthAccessTokenURL = _oauthAccessTokenURL;
@synthesize authorizeHelper = _authorizeHelper;
@synthesize delegate = _delegate;

- (id)initWithConsumerKey:(NSString*)key consumerSecret:(NSString*)secret {
	self = [super init];
	
	if(self) {
		self.consumerKey = key;
		self.consumerSecret = secret;
		self.oauthToken = nil;
		self.oauthTokenSecret = nil;
		self.oauthCallbackURL = kASIOAuthConsumerDummyCallbackURL;
		self.oauthLocale = nil;
		self.oauthRequestTokenURL = nil;
		self.oauthAuthorizeURL = nil;
		self.oauthAccessTokenURL = nil;
		self.authorizeHelper = nil;
		self.delegate = nil;
	}

	return self;
}

- (id)init {
	return [self initWithConsumerKey:nil consumerSecret:nil];
}

- (void)dealloc {
	self.consumerKey = nil;
	self.consumerSecret = nil;
	self.oauthToken = nil;
	self.oauthTokenSecret = nil;
	self.oauthCallbackURL = kASIOAuthConsumerDummyCallbackURL;
	self.oauthLocale = nil;
	self.oauthRequestTokenURL = nil;
	self.oauthAuthorizeURL = nil;
	self.oauthAccessTokenURL = nil;
	self.authorizeHelper = nil;
	self.delegate = nil;
	
	[super dealloc];
}

- (void)requestToken {
	NSURL* url = [NSURL URLWithString:self.oauthRequestTokenURL];
	ASIHTTPRequest* request = [ASIHTTPRequest requestWithURL:url];
	
	NSAssert(self.oauthRequestTokenURL != nil, @"oauthRequestTokenURL must be specified.");

	request.requestMethod = @"POST";
	request.delegate = self;
	request.didFailSelector = @selector(requestTokenFailed:);
	request.didFinishSelector = @selector(requestTokenFinished:);

	// reset any tokens while re-authentication
	self.oauthToken = nil;
	self.oauthTokenSecret = nil;

	[self signRequest:request];
	[request startAsynchronous];
}

- (void)authorize {
	NSURL* authorizeURL;
	NSMutableDictionary* params = [[[NSMutableDictionary alloc] init] autorelease];
	
	NSAssert(self.oauthAuthorizeURL != nil, @"oauthAuthorizeURL must be specified.");
	
	// create generic webview helper if none assigned
	if(!self.authorizeHelper) {
		self.authorizeHelper = [[ASIOAuthWebHelper alloc] initWithConsumer:self];
	}
	
	[params setObject:self.oauthToken forKey:kASIOAuthConsomerTokenKey];

	if(self.oauthCallbackURL)
		[params setObject:self.oauthCallbackURL forKey:@"oauth_callback"];

	if(self.oauthLocale)
		[params setObject:self.oauthLocale forKey:@"oauth_locale"];
	
	authorizeURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@?%@", self.oauthAuthorizeURL, [self dictionaryToQueryString:params]]];
	
	[self.authorizeHelper showWithURL:authorizeURL];
}

- (void)requestAccessToken {
	NSURL* url = [NSURL URLWithString:self.oauthAccessTokenURL];
	ASIHTTPRequest* request = [ASIHTTPRequest requestWithURL:url];
	
	NSAssert(self.oauthAccessTokenURL != nil, @"oauthAccessTokenURL must be specified.");
	
	request.requestMethod = @"POST";
	request.delegate = self;
	request.didFailSelector = @selector(accessTokenFailed:);
	request.didFinishSelector = @selector(accessTokenFinished:);
	
	[self signRequest:request];
	[request startAsynchronous];
}

- (void)signRequest:(ASIHTTPRequest*)request {
	[request signRequestWithClientIdentifier:self.consumerKey secret:self.consumerSecret tokenIdentifier:self.oauthToken secret:self.oauthTokenSecret usingMethod:ASIOAuthHMAC_SHA1SignatureMethod];
}

- (void)requestTokenFailed:(ASIHTTPRequest*)request {
	NSError* err = [NSError errorWithDomain:kASIOAuthConsumerErrorDomain 
									   code:kASIOAuthConsumerRequestTokenNetworkError 
								   userInfo:[NSDictionary dictionaryWithObject:NSLocalizedString(@"Unable to receive request token.", @"") forKey:NSLocalizedDescriptionKey]];

	if([self.delegate respondsToSelector:@selector(oauthConsumer:didFailGetRequestTokenWithError:)])
		[self.delegate oauthConsumer:self didFailGetRequestTokenWithError:err];
}

- (void)requestTokenFinished:(ASIHTTPRequest*)request {
	NSDictionary* response = [self parseQueryString:[request responseString]];
	NSError* err = [NSError errorWithDomain:kASIOAuthConsumerErrorDomain 
									   code:kASIOAuthConsumerRequestTokenNetworkError 
								   userInfo:[NSDictionary dictionaryWithObject:NSLocalizedString(@"Invalid request token response.", @"") forKey:NSLocalizedDescriptionKey]];
	
	self.oauthToken = [response objectForKey:kASIOAuthConsomerTokenKey];
	self.oauthTokenSecret = [response objectForKey:kASIOAuthConsumerTokenSecretKey];
	
	if(self.oauthToken && self.oauthTokenSecret) {
		if([self.delegate respondsToSelector:@selector(oauthConsumerDidGetRequestToken:)])
			[self.delegate oauthConsumerDidGetRequestToken:self];
	} else {
		if([self.delegate respondsToSelector:@selector(oauthConsumer:didFailGetRequestTokenWithError:)])
			[self.delegate oauthConsumer:self didFailGetRequestTokenWithError:err];
	}
}

- (void)accessTokenFailed:(ASIHTTPRequest*)request {
	NSError* err = [NSError errorWithDomain:kASIOAuthConsumerErrorDomain 
									   code:kASIOAuthConsumerAccessTokenNetworkError 
								   userInfo:[NSDictionary dictionaryWithObject:NSLocalizedString(@"Unable to receive access token.", @"") forKey:NSLocalizedDescriptionKey]];

	if([self.delegate respondsToSelector:@selector(oauthConsumer:didFailGetAccessTokenWithError:)])
		[self.delegate oauthConsumer:self didFailGetAccessTokenWithError:err];
}

- (void)accessTokenFinished:(ASIHTTPRequest*)request {
	NSMutableArray* keys;
	NSArray* values;
	NSDictionary* dict = [self parseQueryString:[request responseString]];
	NSError* err = [NSError errorWithDomain:kASIOAuthConsumerErrorDomain 
									   code:kASIOAuthConsumerAccessTokenParseError 
								   userInfo:[NSDictionary dictionaryWithObject:NSLocalizedString(@"Invalid access token response.", @"") forKey:NSLocalizedDescriptionKey]];

	self.oauthToken = [dict objectForKey:kASIOAuthConsomerTokenKey];
	self.oauthTokenSecret = [dict objectForKey:kASIOAuthConsumerTokenSecretKey];

	if(self.oauthToken && self.oauthTokenSecret)
	{
		keys = [[[NSMutableArray alloc] initWithArray:[dict allKeys]] autorelease];

		[keys removeObject:kASIOAuthConsomerTokenKey];
		[keys removeObject:kASIOAuthConsumerTokenSecretKey];

		values = [dict objectsForKeys:keys notFoundMarker:[NSNull null]];

		self.oauthUserData = [NSDictionary dictionaryWithObjects:values forKeys:keys];
		
		if([self.delegate respondsToSelector:@selector(oauthConsumerDidGetAccessToken:)])
			[self.delegate oauthConsumerDidGetAccessToken:self];
	} 
	else 
	{
		if([self.delegate respondsToSelector:@selector(oauthConsumer:didFailGetAccessTokenWithError:)])
			[self.delegate oauthConsumer:self didFailGetAccessTokenWithError:err];
	}
}

- (NSString*)encodeToPercentEscapeString:(NSString*)string {
	return (NSString *)CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef) string, NULL, (CFStringRef) @"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8);
}

- (NSString*)decodeFromPercentEscapeString:(NSString*)string {
	return (NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL, (CFStringRef)string, CFSTR(""), kCFStringEncodingUTF8);
}

- (NSString*)dictionaryToQueryString:(NSDictionary*)dict {
	NSArray* keys = [dict allKeys];
	NSString* key, *val;
	NSMutableString* ret = [[[NSMutableString alloc] init] autorelease];
	
	for(uint i = 0, c = keys.count; i < c; i++) {
		key = [keys objectAtIndex:i];
		val = [dict objectForKey:key];
		
		if(i > 0) 
			[ret appendString:@"&"];
		
		[ret appendFormat:@"%@=%@", [self encodeToPercentEscapeString:key], [self encodeToPercentEscapeString:val]];
	}
	
	return ret;
}

- (NSDictionary*)parseQueryString:(NSString*)query {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    NSArray *pairs = [query componentsSeparatedByString:@"&"], *elements = nil;

    for (NSString *pair in pairs) 
	{
		elements = [pair componentsSeparatedByString:@"="];

		[dict setObject:[self decodeFromPercentEscapeString:[elements objectAtIndex:1]] 
				 forKey:[self decodeFromPercentEscapeString:[elements objectAtIndex:0]]];
    }

    return [dict autorelease];
}

@end
