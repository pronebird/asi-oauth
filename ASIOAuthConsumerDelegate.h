//
//  ASIOAuthConsumerDelegate.h
//
//  Created by Andrei Mikhailov on 2/8/12.
//  Copyright (c) 2012 Andrei Mikhailov. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ASIOAuthConsumer;

@protocol ASIOAuthConsumerDelegate <NSObject>

@optional
- (void)oauthConsumerDidGetRequestToken:(ASIOAuthConsumer*)consumer;
- (void)oauthConsumerDidGetAccessToken:(ASIOAuthConsumer*)consumer;
- (void)oauthConsumer:(ASIOAuthConsumer*)consumer didFailGetRequestTokenWithError:(NSError*)error;
- (void)oauthConsumer:(ASIOAuthConsumer*)consumer didFailGetAccessTokenWithError:(NSError*)error;
- (void)oauthConsumerDidAuthorize:(ASIOAuthConsumer*)consumer;

@end
