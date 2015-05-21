//
//  NSMutableDictionary+HDKit.h
//  HDKitDemo
//
//  Created by harvey.ding on 5/21/15.
//  Copyright (c) 2015 harvey. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary (HDKit)

- (BOOL)safeSetObject:(id)obj forKey:(id<NSCopying>)key;

@end
