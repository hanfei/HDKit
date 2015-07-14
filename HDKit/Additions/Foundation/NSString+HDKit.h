//
//  NSString+HDKit.h
//  HDKitDemo
//
//  Created by harvey.ding on 5/20/15.
//  Copyright (c) 2015 harvey. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSString (HDKit)

- (NSString *)MD5;
- (NSString *)SHA1;
- (NSString *)SHA256;
- (NSString *)SHA512;

- (BOOL)hasString:(NSString *)str;
- (BOOL)isEmail;
+ (BOOL)isEmpty:(NSString *)str;

- (NSString *)trimHead;
- (NSString *)trimTail;
- (NSString *)trimBoth;

- (NSString *)encodeToBase64;
- (NSString *)decodeBase64;

- (NSString *)URLEncodingUTF8String;
- (NSString *)URLDecodingUTF8String;

- (CGFloat)heightByFont:(NSFont *)font width:(CGFloat)width;
- (CGFloat)widthByFont:(NSFont *)font;
@end
