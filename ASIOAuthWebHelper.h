//
//  ASIOAuthWebHelper.h
//
//  Created by Andrei Mikhailov on 2/8/12.
//  Copyright (c) 2012 Andrei Mikhailov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIOAuthWebHelper.h"

@class ASIOAuthConsumer;
@interface ASIOAuthWebHelper : UIViewController<UIWebViewDelegate> {
	ASIOAuthConsumer* _consumer;
	UIWebView* _webView;
	UIActivityIndicatorView* _spinner;
	UINavigationBar* _webViewNavBar;
	BOOL _isShown;
}

@property (retain, readonly) ASIOAuthConsumer* consumer;
@property (retain, readonly) UIWebView* webView;
@property (retain, readonly) UINavigationBar* webViewNavBar;
@property (retain, readonly) UIActivityIndicatorView* spinner;
@property (assign, readonly) BOOL isShown;

- (id)initWithConsumer:(ASIOAuthConsumer*)consumer;
- (void)dealloc;

- (void)showWithURL:(NSURL*)url;
- (void)hide;

@end

@interface ASIOAuthWebHelper(ProtectedMethods)

- (void)onCloseButton;
- (void)showErrorWithTitle:(NSString*)title message:(NSString*)msg;

@end
