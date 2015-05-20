//
//  NSObject+HDKit.h
//  HDKitDemo
//
//  Created by harvey.ding on 5/20/15.
//  Copyright (c) 2015 harvey. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (HDKit)

- (id)performSelector:(SEL)aSelector withObject:(id)object, ... NS_REQUIRES_NIL_TERMINATION;

@end
