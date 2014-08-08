//
//  UIImage+SnapShot.h
//  HDKit
//
//  Created by harvey.ding on 8/8/14.
//  Copyright (c) 2014 harvey. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (SnapShot)

+ (UIImage *)renderImageFromView:(UIView *)view;

+ (UIImage *)renderImageFromView:(UIView *)view withRect:(CGRect)rect;

+ (UIImage *)renderImageFromView:(UIView *)view withRect:(CGRect)rect transparentInsets:(UIEdgeInsets)insets;

+ (UIImage *)renderImageForAntialiasing:(UIImage *)image;

+ (UIImage *)renderImageForAntialiasing:(UIImage *)image withInsets:(UIEdgeInsets)insets;

+ (UIImage *)renderImage:(UIImage *)image withMargin:(CGFloat)margin color:(UIColor *)color;

@end
