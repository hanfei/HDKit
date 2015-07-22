//
//  UIColor+HDKit.m
//  HDKitDemo
//
//  Created by ceo on 7/14/15.
//  Copyright (c) 2015 harvey. All rights reserved.
//

#import "UIColor+HDKit.h"

@implementation UIColor (HDKit)

+ (UIColor *)colorWithHex:(int)color {
    float red = (color & 0xff000000) >> 24;
    float green = (color & 0x00ff0000) >> 16;
    float blue = (color & 0x0000ff00) >> 8;
    float alpha = (color & 0x000000ff);
    return [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:alpha];
}

+ (UIColor *)colorWithHexColorString:(NSString *)hexString {
    NSString *colorStr = [[hexString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    const NSInteger kNumberLength = 6;
    if (colorStr.length < kNumberLength) {
        return nil;
    }
    
    if ([colorStr hasPrefix:@"0X"]) {
        colorStr = [colorStr substringFromIndex:2];
    }
    
    if ([colorStr hasPrefix:@"#"]) {
        colorStr = [colorStr substringFromIndex:1];
    }
    
    if (colorStr.length != kNumberLength) {
        return nil;
    }
    
    NSString *rString = [colorStr substringWithRange:NSMakeRange(0, 2)];
    NSString *gString = [colorStr substringWithRange:NSMakeRange(2, 2)];
    NSString *bString = [colorStr substringWithRange:NSMakeRange(4, 2)];
    
    if (rString.length == 0 || bString.length == 0 || gString.length == 0) {
        return nil;
    }
    
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1.0];
    
}







































@end
