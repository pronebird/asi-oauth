//
//  ASIOAuthClientDelegate.h
//
//  Created by Andrei Mikhailov on 2/9/12.
//  Copyright (c) 2012 Up! Smith. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ASIOAuthClient;

@protocol ASIOAuthClientDelegate <NSObject>

@optional
- (void)oauthClientDidAuthorize:(ASIOAuthClient*)client;
- (void)oauthClientDidCancelAuthorization:(ASIOAuthClient*)client;
- (void)oauthClient:(ASIOAuthClient*)client didFailWithError:(NSError*)error;

@end
