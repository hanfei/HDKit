//
//  NSArray+HDKit.h
//  HDKitDemo
//
//  Created by harvey.ding on 5/21/15.
//  Copyright (c) 2015 harvey. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (HDKit)

- (id)randomObject;
- (id)safeObjectAtIndex:(NSUInteger)index;
- (NSArray *)reversedArray;
- (NSString *)arrayToJson;

- (NSArray *)sortedByKey:(NSString *)key ascending:(BOOL)ascending;

@end
