//
//  ASIOAuthClient.m
//
//  Created by Andrei Mikhailov on 2/8/12.
//  Copyright (c) 2012 Andrei Mikhailov. All rights reserved.
//

#import "ASIOAuthClient.h"

@implementation ASIOAuthClient

- (id)initWithConsumerKey:(NSString*)key consumerSecret:(NSString*)secret {
	self = [super initWithConsumerKey:key consumerSecret:secret];
	
	if(self) {
		self.delegate = self;
	}
	
	return self;
}
- (void)dealloc {
	self.delegate = nil;
	[super dealloc];
}

- (void)startAuthorization {
	[self requestToken];
}

- (void)oauthConsumerDidGetRequestToken:(ASIOAuthConsumer*)consumer {
	[consumer authorize];
}

- (void)oauthConsumerDidGetAccessToken:(ASIOAuthConsumer*)consumer {
	
}

- (void)oauthConsumer:(ASIOAuthConsumer*)consumer didFailGetRequestTokenWithError:(NSError*)error {
	
}

- (void)oauthConsumer:(ASIOAuthConsumer*)consumer didFailGetAccessTokenWithError:(NSError*)error {
	
}

@end
