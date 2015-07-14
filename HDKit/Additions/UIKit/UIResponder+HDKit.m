//
//  UIResponder+HDKit.m
//  HDKitDemo
//
//  Created by ceo on 7/14/15.
//  Copyright (c) 2015 harvey. All rights reserved.
//

#import "UIResponder+HDKit.h"

static BOOL hasAlreadyCacheKeyboard;

@implementation UIResponder (HDKit)

+ (void)cancheKeyboard:(BOOL)onNextRunloop {
    if (!hasAlreadyCacheKeyboard) {
        hasAlreadyCacheKeyboard = YES;
        if (onNextRunloop) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [[self class] __cacheKeyboard];
            });
        }else {
            [[self class] __cacheKeyboard];
        }
    }
}

+ (void)__cacheKeyboard {
    UITextField *field = [UITextField new];
    [[[[UIApplication sharedApplication] windows] lastObject] addSubview:field];
    [field becomeFirstResponder];
    [field resignFirstResponder];
    [field removeFromSuperview];
}

@end
