//
//  UIImage+HDKit.h
//  HDKitDemo
//
//  Created by harvey.ding on 5/20/15.
//  Copyright (c) 2015 harvey. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (HDKit)

+ (UIImage *)renderImageFromView:(UIView *)view;
+ (UIImage *)renderImageFromView:(UIView *)view withRect:(CGRect)rect;
+ (UIImage *)renderImageFromView:(UIView *)view withRect:(CGRect)rect transparentInsets:(UIEdgeInsets)insets;
+ (UIImage *)renderImageForAntialiasing:(UIImage *)image;
+ (UIImage *)renderImageForAntialiasing:(UIImage *)image withInsets:(UIEdgeInsets)insets;
+ (UIImage *)renderImage:(UIImage *)image margin:(CGFloat)margin color:(UIColor *)color;
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

- (UIImage *)resizedImageWithSize:(CGSize)size;
- (UIImage *)capturedImaeInRect:(CGRect)rect;
- (UIImage *)fixOrientation;
- (UIImage *)decompressedImage;

- (UIImage *)imageWithTintColor:(UIColor *)tintColor;
- (UIImage *)imageWithGradientTintColor:(UIColor *)tintColor;
- (UIImage *)imageWithTintColor:(UIColor *)tintColor blendMode:(CGBlendMode)blendMode;
- (UIImage *)grayImage;

- (UIImage *)imageRotateByRadians:(CGFloat)radians;

@end
