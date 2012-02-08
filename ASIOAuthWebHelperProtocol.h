//
//  ASIOAuthWebHelperProtocol.h
//
//  Created by Andrei Mikhailov on 2/8/12.
//  Copyright (c) 2012 Andrei Mikhailov. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ASIOAuthWebHelperDelegate;

@protocol ASIOAuthWebHelperProtocol <NSObject>

@required
- (void)setDelegate:(id<ASIOAuthWebHelperDelegate>)delegate;
- (id<ASIOAuthWebHelperDelegate>)delegate;
- (void)showWithURL:(NSURL*)url;
- (void)hide;

@end
