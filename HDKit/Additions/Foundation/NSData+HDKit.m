//
//  NSData+HDKit.m
//  HDKitDemo
//
//  Created by ceo on 8/5/15.
//  Copyright (c) 2015 harvey. All rights reserved.
//

#import "NSData+HDKit.h"

@implementation NSData (HDKit)

+ (NSString *)hd_contentTypeForImageData:(NSData *)data {
    uint8_t c;
    [data getBytes:&c length:1];
    switch (c) {
        case 0xFF:
            return @"image/jpeg";
        case 0x89:
            return @"image/png";
        case 0x47:
            return @"image/gif";
        case 0x49:
        case 0x4D:
            return @"image/tiff";
        case 0x52:{
            if ([data length] < 12) {
                return nil;
            }
            
            NSString *testStr = [[NSString alloc] initWithData:[data subdataWithRange:NSMakeRange(0, 12)] encoding:NSASCIIStringEncoding];
            if ([testStr hasPrefix:@"RIFF"] && [testStr hasSuffix:@"WEBP"]) {
                return @"image/webp";
            }
            return nil;
        }
    }
    
    return nil;
}

@end
