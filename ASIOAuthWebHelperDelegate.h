//
//  ASIOAuthWebHelperDelegate.h
//
//  Created by Andrei Mikhailov on 2/8/12.
//  Copyright (c) 2012 Andrei Mikhailov. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ASIOAuthWebHelperProtocol;

@protocol ASIOAuthWebHelperDelegate <NSObject>

@required
- (BOOL)oauthWebHelper:(id<ASIOAuthWebHelperProtocol>)webHelper shouldFollowRedirect:(NSURLRequest*)request;

@end
