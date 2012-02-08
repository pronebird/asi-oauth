//
//  ASIOAuthClient.h
//
//  Created by Andrei Mikhailov on 2/8/12.
//  Copyright (c) 2012 Andrei Mikhailov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIOAuthConsumer.h"
#import "ASIOAuthClientDelegate.h"

@interface ASIOAuthClient : NSObject<ASIOAuthConsumerDelegate> {
	ASIOAuthConsumer* _consumer;
	id<ASIOAuthClientDelegate> _delegate;
}

@property (retain) ASIOAuthConsumer* consumer;
@property (assign) id<ASIOAuthClientDelegate> delegate;

- (id)init;
- (void)dealloc;

- (void)authorize;

@end

@interface ASIOAuthClient(ProtectedMethods)

- (void)failWithError:(NSError*)error;

@end
