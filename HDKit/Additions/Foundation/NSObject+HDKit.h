//
//  NSObject+HDKit.h
//  HDKitDemo
//
//  Created by harvey.ding on 5/20/15.
//  Copyright (c) 2015 harvey. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (HDKit)

+ (BOOL)swizzleInstanceMethod:(SEL)originalSel with:(SEL)newSel;
+ (BOOL)swizzleClassMethod:(SEL)originalSel with:(SEL)newSel;

@end

@interface NSObject (HDKit_KVO)

- (void)addObserverBlockForKeyPath:(NSString *)keyPath block:(void (^)(__weak id obj, id oldVal, id newVal))block;
- (void)removeObserverBlocksForKeyPath:(NSString *)keyPath;
- (void)removeObserverBlocks;

@end
