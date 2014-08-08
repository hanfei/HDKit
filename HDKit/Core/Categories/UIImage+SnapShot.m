//
//  UIImage+SnapShot.m
//  HDKit
//
//  Created by harvey.ding on 8/8/14.
//  Copyright (c) 2014 harvey. All rights reserved.
//

#import "UIImage+SnapShot.h"

@implementation UIImage (SnapShot)

+ (UIImage *)renderImageFromView:(UIView *)view{
    return [UIImage renderImageFromView:view withRect:view.bounds];
}

+ (UIImage *)renderImageFromView:(UIView *)view withRect:(CGRect)rect{
    UIGraphicsBeginImageContextWithOptions(rect.size, YES, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, -rect.origin.x, -rect.origin.y);
    [view.layer renderInContext:context];
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return result;
}

+ (UIImage *)renderImageFromView:(UIView *)view withRect:(CGRect)rect transparentInsets:(UIEdgeInsets)insets{
    CGSize imageSizeWithBorder = CGSizeMake(rect.size.width + insets.left + insets.right, rect.size.height + insets.top + insets.bottom);
    UIGraphicsBeginImageContextWithOptions(imageSizeWithBorder, UIEdgeInsetsEqualToEdgeInsets(insets, UIEdgeInsetsZero), 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClipToRect(context, (CGRect){{insets.left,insets.top},rect.size});
    CGContextTranslateCTM(context, -rect.origin.x + insets.left, -rect.origin.y + insets.top);
    [view.layer renderInContext:context];
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return result;
}

+ (UIImage *)renderImageForAntialiasing:(UIImage *)image{
    return [UIImage renderImageForAntialiasing:image withInsets:UIEdgeInsetsMake(1, 1, 1, 1)];
}

+ (UIImage *)renderImageForAntialiasing:(UIImage *)image withInsets:(UIEdgeInsets)insets{
    CGSize imageSizeWithBorder = CGSizeMake([image size].width + insets.left + insets.right, [image size].height + insets.top + insets.bottom);
    UIGraphicsBeginImageContextWithOptions(imageSizeWithBorder, UIEdgeInsetsEqualToEdgeInsets(insets, UIEdgeInsetsZero), 0);
    [image drawInRect:(CGRect){{insets.left,insets.top},[image size]}];
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return result;
}

+ (UIImage *)renderImage:(UIImage *)image withMargin:(CGFloat)margin color:(UIColor *)color{
    CGSize imageSizeWithBorder = CGSizeMake([image size].width + 2 *(margin + 1), [image size].height + 2 * (margin + 1));
    UIGraphicsBeginImageContextWithOptions(imageSizeWithBorder, NO, 0);
    CGRect rect = (CGRect){{1,1},{[image size].width + 2 * margin,[image size].height + 2 * margin}};
    [color set];
    UIRectFill(rect);
    
    [image drawInRect:(CGRect){{margin + 1,margin + 1},[image size]}];
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return result;
}

@end
