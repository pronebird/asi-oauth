//
//  ASIOAuthClient.h
//
//  Created by Andrei Mikhailov on 2/8/12.
//  Copyright (c) 2012 Andrei Mikhailov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIOAuthConsumer.h"

@interface ASIOAuthClient : ASIOAuthConsumer<ASIOAuthConsumerDelegate> {
}

- (id)initWithConsumerKey:(NSString*)key consumerSecret:(NSString*)secret;
- (void)dealloc;

- (void)startAuthorization;

@end
