//
//  NSNumber+HDKit.m
//  HDKitDemo
//
//  Created by ceo on 9/4/15.
//  Copyright (c) 2015 harvey. All rights reserved.
//

#import "NSNumber+HDKit.h"

@implementation NSNumber (HDKit)

+ (NSNumber *)numberWithString:(NSString *)str {
    NSString *targetStr = [[str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] lowercaseString];
    if ([targetStr length] == 0) {
        return nil;
    }
    
    int sign = 0;
    if ([targetStr hasPrefix:@"0x"]) {
        sign = 1;
    }else if ([targetStr hasPrefix:@"-0x"]) {
        sign = -1;
    }
    
    if (sign != 0) {
        NSScanner *scan = [NSScanner scannerWithString:targetStr];
        unsigned num = 0;
        BOOL suc = [scan scanHexInt:&num];
        if (suc) {
            return [NSNumber numberWithLong:num * sign];
        }else {
            return nil;
        }
    }
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    return [formatter numberFromString:targetStr];
}

@end
