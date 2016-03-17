//
//  NSString+HDKit.h
//  HDKitDemo
//
//  Created by harvey.ding on 5/20/15.
//  Copyright (c) 2015 harvey. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSString (HDKit)

- (BOOL)hasString:(NSString *)str;
- (BOOL)isVaildEmail;
+ (BOOL)isEmpty:(NSString *)str;
+ (BOOL)isVaildURLString:(NSString *)urlStr;

- (NSString *)trimHead;
- (NSString *)trimTail;
- (NSString *)trimBoth;

- (NSString *)encodeToBase64;
- (NSString *)decodeBase64;

- (NSString *)URLEncodingUTF8String;
- (NSString *)URLDecodingUTF8String;
- (NSString *)stringByEscapingHTML;

- (CGSize)sizeByFont:(UIFont *)font width:(CGFloat)width mode:(NSLineBreakMode)lineBreakMode;
- (CGSize)sizeByFont:(UIFont *)font;
@end
