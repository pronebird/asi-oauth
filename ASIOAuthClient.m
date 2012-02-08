//
//  ASIOAuthClient.m
//
//  Created by Andrei Mikhailov on 2/8/12.
//  Copyright (c) 2012 Andrei Mikhailov. All rights reserved.
//

#import "ASIOAuthClient.h"

@implementation ASIOAuthClient

@synthesize consumer = _consumer;
@synthesize delegate = _delegate;

- (id)init {
	self = [super init];
	
	if(self) {
		self.consumer = [[[ASIOAuthConsumer alloc] init] autorelease];
		self.consumer.delegate = self;
		self.delegate = nil;
	}
	
	return self;
}
- (void)dealloc {
	self.consumer.delegate = nil;
	self.consumer = nil;
	self.delegate = nil;

	[super dealloc];
}

- (void)authorize {
	[self.consumer requestToken];
}

- (void)oauthConsumerDidGetRequestToken:(ASIOAuthConsumer*)consumer {
	NSLog(@"oauthConsumer requestToken: %@, secret: %@.", consumer.oauthToken, consumer.oauthTokenSecret);
	[self.consumer authorize];
}

- (void)oauthConsumerDidAuthorize:(ASIOAuthConsumer*)consumer {
	[consumer requestAccessToken];
}

- (void)oauthConsumerDidGetAccessToken:(ASIOAuthConsumer*)consumer {
	NSLog(@"oauthConsumer access token received: %@, secret: %@.", consumer.oauthToken, consumer.oauthTokenSecret);
	NSLog(@"oauthConsumer userdata: %@", consumer.oauthUserData);
	
	if([self.delegate respondsToSelector:@selector(oauthClientDidAuthorize:)])
		[self.delegate oauthClientDidAuthorize:self];
}

- (void)oauthConsumer:(ASIOAuthConsumer*)consumer didFailGetRequestTokenWithError:(NSError*)error {
	[self failWithError:error];
}

- (void)oauthConsumer:(ASIOAuthConsumer*)consumer didFailGetAccessTokenWithError:(NSError*)error {
	[self failWithError:error];
}

- (void)failWithError:(NSError*)error {
	NSLog(@"oauthConsumer error: %@", [error localizedDescription]);
	
	if([self.delegate respondsToSelector:@selector(oauthClient:didFailWithError:)])
		[self.delegate oauthClient:self didFailWithError:error];
}

@end
