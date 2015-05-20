//
//  UIImage+HDKit.m
//  HDKitDemo
//
//  Created by harvey.ding on 5/20/15.
//  Copyright (c) 2015 harvey. All rights reserved.
//

#import "UIImage+HDKit.h"

@implementation UIImage (HDKit)

+ (UIImage *)renderImageFromView:(UIView *)view {
    return [self renderImageFromView:view withRect:view.bounds];
}

+ (UIImage *)renderImageFromView:(UIView *)view withRect:(CGRect)rect {
    UIGraphicsBeginImageContextWithOptions(rect.size, YES, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, -rect.origin.x, -rect.origin.y);
    [view.layer renderInContext:context];
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return result;
}

+ (UIImage *)renderImageFromView:(UIView *)view withRect:(CGRect)rect transparentInsets:(UIEdgeInsets)insets {
    CGSize sizeWithBorder = CGSizeMake(view.frame.size.width + insets.left + insets.right,
                                       view.frame.size.height + insets.top + insets.bottom);
    UIGraphicsBeginImageContextWithOptions(sizeWithBorder, UIEdgeInsetsEqualToEdgeInsets(insets, UIEdgeInsetsZero), 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClipToRect(context, (CGRect){{insets.left, insets.top}, rect.size});
    CGContextTranslateCTM(context, -rect.origin.x + insets.left, -rect.origin.y + insets.top);
    [view.layer renderInContext:context];
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return result;
}

+ (UIImage *)renderImageForAntialiasing:(UIImage *)image {
    return [self renderImageForAntialiasing:image withInsets:UIEdgeInsetsMake(1, 1, 1, 1)];
}

+ (UIImage *)renderImageForAntialiasing:(UIImage *)image withInsets:(UIEdgeInsets)insets {
    CGSize sizeWithBorder = CGSizeMake(image.size.width + insets.left + insets.right,
                                       image.size.height + insets.top + insets.bottom);
    UIGraphicsBeginImageContextWithOptions(sizeWithBorder, UIEdgeInsetsEqualToEdgeInsets(insets, UIEdgeInsetsZero), 0);
    CGRect imgRect = (CGRect){{insets.left, insets.top}, image.size};
    [image drawInRect:imgRect];
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return result;
}

+ (UIImage *)renderImage:(UIImage *)image margin:(CGFloat)margin color:(UIColor *)color {
    CGSize sizeWithBorder = CGSizeMake(image.size.width + 2 * (margin + 1), image.size.height + 2 * (margin + 1));
    UIGraphicsBeginImageContextWithOptions(sizeWithBorder, NO, 0);
    CGRect bgRect = (CGRect){{1,1},{image.size.width + 2 * margin, image.size.height + 2 * margin}};
    [color set];
    UIRectFill(bgRect);
    [image drawInRect:(CGRect){{(margin + 1), (margin + 1)},image.size}];
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return result;
}

@end
