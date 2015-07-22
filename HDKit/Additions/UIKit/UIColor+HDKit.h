//
//  UIColor+HDKit.h
//  HDKitDemo
//
//  Created by ceo on 7/14/15.
//  Copyright (c) 2015 harvey. All rights reserved.
//

#import <UIKit/UIKit.h>

#define HDRGBColor(r, g, b) HDRGBAColor(r, g, b, 1.0)
#define HDRGBAColor(r, g, b, a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]

@interface UIColor (HDKit)

+ (UIColor *)colorWithHex:(int)color;

+ (UIColor *)colorWithHexColorString:(NSString *)hexString;

@end
