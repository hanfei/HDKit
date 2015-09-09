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
+ (UIImageOrientation)hd_imageOrientationFromImageData:(NSData *)imageData;

+ (UIImage *)hd_imageWithPDF:(id)dataOrPath;
+ (UIImage *)hd_imageWithPDF:(id)dataOrPath size:(CGSize)size;

- (UIColor *)hd_colorAtPoint:(CGPoint)point;
- (BOOL)hd_hasAlphaChannel;
- (UIImage *)hd_imageByResizeToSize:(CGSize)size contentMode:(UIViewContentMode)contentMode;
- (UIImage *)hd_imageByRoundCornerRadius:(CGFloat)radius;
- (UIImage *)hd_flipHorizontal:(BOOL)horizontal vertical:(BOOL)vertical;

- (UIImage *)hd_imageByGrayscale;
- (UIImage *)hd_imageByBlurSoft;
- (UIImage *)hd_imageByBlurLight;
- (UIImage *)hd_imageByBlurExtraLight;
- (UIImage *)hd_imageByBlurDark;
- (UIImage *)hd_imageByBlurWithTint:(UIColor *)tintColor;

@end

@interface UIImage (HDKit_GIF)

+ (UIImage *)hd_animatedGIFWithData:(NSData *)data;

@end
