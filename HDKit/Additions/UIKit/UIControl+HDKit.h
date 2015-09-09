//
//  UIControl+HDKit.h
//  HDKitDemo
//
//  Created by ceo on 9/8/15.
//  Copyright (c) 2015 harvey. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIControl (HDKit)

- (void)hd_removeAllTargets;
- (void)hd_setTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;
- (void)hd_addBlockForControlEvents:(UIControlEvents)controlEvents block:(void (^)(id sender))block;
- (void)hd_setBlockForControlEvents:(UIControlEvents)controlEvents block:(void (^)(id sender))block;
- (void)hd_removeAllBlockForControlEvents:(UIControlEvents)controlEvents;

@end
