//
//  NSParagraphStyle+HDKit.h
//  HDKitDemo
//
//  Created by ceo on 9/9/15.
//  Copyright (c) 2015 harvey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>

@interface NSParagraphStyle (HDKit)

/**
 Creates a new NSParagraphStyle object from the CoreText Style.
 
 @param CTStyle CoreText Paragraph Style.
 
 @return a new NSParagraphStyle
 */
+ (NSParagraphStyle *)styleWithCTStyle:(CTParagraphStyleRef)CTStyle;

/**
 Creates and returns a CoreText Paragraph Style. (need call CFRelease() after used)
 */
- (CTParagraphStyleRef)CTStyle CF_RETURNS_RETAINED;

@end
