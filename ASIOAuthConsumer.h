//
//  ASIOAuthConsumer.h
//
//  Created by Andrei Mikhailov on 2/8/12.
//  Copyright (c) 2012 Andrei Mikhailov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIOAuthConsumerDelegate.h"
#import "ASIOAuthWebHelperDelegate.h"
#import "ASIOAuthWebHelper.h"
#import "ASIHTTPRequest+OAuth.h"
#import "ASIFormDataRequest+OAuth.h"

// common constants
#define kASIOAuthConsumerTokenKey @"oauth_token"
#define kASIOAuthConsumerTokenSecretKey @"oauth_token_secret"
#define kASIOAuthConsumerDummyCallbackURL @"http://localhost/oauth_callback/"
#define kASIOAuthConsumerErrorDomain @"ASIOAuthConsumerErrorDomain"

// error codes
#define kASIOAuthConsumerRequestTokenParseError 100
#define kASIOAuthConsumerRequestTokenNetworkError 101
#define kASIOAuthConsumerAccessTokenParseError 102
#define kASIOAuthConsumerAccessTokenNetworkError 103

@interface ASIOAuthConsumer : NSObject<ASIOAuthWebHelperDelegate> {
	NSString* _consumerKey;
	NSString* _consumerSecret;
	NSString* _oauthToken;
	NSString* _oauthTokenSecret;
	NSString* _oauthCallbackURL;
	NSString* _oauthLocale;
	NSDictionary* _oauthUserData;

	NSString* _oauthRequestTokenURL;
	NSString* _oauthAuthorizeURL;
	NSString* _oauthAccessTokenURL;

	id<ASIOAuthWebHelperProtocol> _authorizeHelper;
	id<ASIOAuthConsumerDelegate> _delegate;
}

@property (copy) NSString* consumerKey;
@property (copy) NSString* consumerSecret;
@property (copy) NSString* oauthToken;
@property (copy) NSString* oauthTokenSecret;
@property (copy) NSString* oauthCallbackURL;
@property (copy) NSString* oauthLocale;
@property (readonly, retain) NSDictionary* oauthUserData;
@property (copy) NSString* oauthRequestTokenURL;
@property (copy) NSString* oauthAuthorizeURL;
@property (copy) NSString* oauthAccessTokenURL;
@property (retain) id<ASIOAuthWebHelperProtocol> authorizeHelper;
@property (assign) id<ASIOAuthConsumerDelegate> delegate;

- (id)initWithConsumerKey:(NSString*)key consumerSecret:(NSString*)secret;
- (id)init;
- (void)dealloc;

- (void)requestToken;
- (void)authorize;
- (void)requestAccessToken;

- (void)signRequest:(ASIHTTPRequest*)request;

@end

@interface ASIOAuthConsumer(PrivateMethods)

- (void)requestTokenFailed:(ASIHTTPRequest*)request;
- (void)requestTokenFinished:(ASIHTTPRequest*)request;
- (void)accessTokenFailed:(ASIHTTPRequest*)request;
- (void)accessTokenFinished:(ASIHTTPRequest*)request;

- (NSString*)encodeToPercentEscapeString:(NSString*)string;
- (NSString*)decodeFromPercentEscapeString:(NSString*)string;
- (NSString*)dictionaryToQueryString:(NSDictionary*)dict;
- (NSDictionary*)parseQueryString:(NSString*)query;

@end
