//
//  NSAttributedString+HDKit.m
//  HDKitDemo
//
//  Created by ceo on 7/14/15.
//  Copyright (c) 2015 harvey. All rights reserved.
//

#import "NSAttributedString+HDKit.h"
#import <CoreText/CoreText.h>

@implementation NSAttributedString (HDKit)

- (CGFloat)heightByWidth:(CGFloat)width {
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)self);
    CGSize targetSize = CGSizeMake(width, CGFLOAT_MAX);
    CGSize fitSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0, [self length]), NULL, targetSize, NULL);
    CFRelease(framesetter);
    return fitSize.height;
}

@end
