//
//  UIButton+HDKit.h
//  HDKitDemo
//
//  Created by ceo on 7/22/15.
//  Copyright (c) 2015 harvey. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (HDKit)

#pragma mark -
// with size (32, 32)
+ (instancetype)createBarButtonItem:(UIBarButtonItem **)item
                          withImage:(UIImage *)image
                             target:(id)target
                             action:(SEL)action;

+ (instancetype)createBarButtonItem:(UIBarButtonItem **)item
                     withButtonSize:(CGSize)size
                              image:(UIImage *)image
                             target:(id)target
                             action:(SEL)action;

#pragma mark - VerticallyLayout
- (void)centerVertically;
- (void)centerVerticallyWithPadding:(float)padding;

@end
