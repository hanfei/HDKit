//
//  NSMutableDictionary+HDKit.m
//  HDKitDemo
//
//  Created by harvey.ding on 5/21/15.
//  Copyright (c) 2015 harvey. All rights reserved.
//

#import "NSMutableDictionary+HDKit.h"

@implementation NSMutableDictionary (HDKit)

- (BOOL)safeSetObject:(id)obj forKey:(id<NSCopying>)key {
    if (obj) {
        [self setObject:obj forKey:key];
        return YES;
    }else {
        return NO;
    }
}

@end
