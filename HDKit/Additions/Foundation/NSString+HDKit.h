//
//  NSString+HDKit.h
//  HDKitDemo
//
//  Created by harvey.ding on 5/20/15.
//  Copyright (c) 2015 harvey. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (HDKit)

- (NSString *)MD5;
- (NSString *)SHA1;
- (NSString *)SHA256;
- (NSString *)SHA512;

- (BOOL)hasString:(NSString *)str;
- (BOOL)isEmail;
+ (BOOL)isEmpty:(NSString *)str;

- (NSString *)encodeToBase64;
- (NSString *)decodeBase64;
- (NSString *)urlEncode;

@end
