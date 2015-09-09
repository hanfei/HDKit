//
//  UIGestureRecognizer+HDKit.h
//  HDKitDemo
//
//  Created by ceo on 9/8/15.
//  Copyright (c) 2015 harvey. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIGestureRecognizer (HDKit)

- (instancetype)initWithActionBlock:(void (^)(id sender))block;

- (void)addActionBlock:(void (^)(id sender))block;

- (void)removeAllActionBlocks;

@end
