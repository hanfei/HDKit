//
//  UIView+HDKit.h
//  HDKitDemo
//
//  Created by harvey.ding on 5/20/15.
//  Copyright (c) 2015 harvey. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (HDKit)

@property (nonatomic) CGFloat left;
@property (nonatomic) CGFloat top;
@property (nonatomic) CGFloat right;
@property (nonatomic) CGFloat bottom;
@property (nonatomic) CGFloat width;
@property (nonatomic) CGFloat height;
@property (nonatomic) CGFloat centerX;
@property (nonatomic) CGFloat centerY;
@property (nonatomic) CGPoint origin;
@property (nonatomic) CGSize  size;

- (UIView *)getFirstResponder;
- (BOOL)haveSubview:(UIView *)subView;

- (void)setRoundedCornersRadius:(CGFloat)radius;
- (void)setRoundedCorners:(UIRectCorner)corners radius:(CGFloat)radius;
- (void)setShadowRadius:(CGFloat)radius;
- (void)setShadowCorners:(UIRectCorner)corners radius:(CGFloat)radius;
- (void)pauseAnimation;
- (void)resumeAnimation;

@end
