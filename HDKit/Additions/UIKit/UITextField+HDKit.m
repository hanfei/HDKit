//
//  UITextField+HDKit.m
//  HDKitDemo
//
//  Created by ceo on 9/8/15.
//  Copyright (c) 2015 harvey. All rights reserved.
//

#import "UITextField+HDKit.h"

@implementation UITextField (HDKit)

- (void)hd_selectAllText {
    UITextRange *range = [self textRangeFromPosition:self.beginningOfDocument toPosition:self.endOfDocument];
    [self setSelectedTextRange:range];
}

- (void)hd_setSelectedRange:(NSRange)range {
    UITextPosition *beginning = self.beginningOfDocument;
    UITextPosition *startPosition = [self positionFromPosition:beginning offset:range.location];
    UITextPosition *endPosition = [self positionFromPosition:beginning offset:NSMaxRange(range)];
    UITextRange *selectionRange = [self textRangeFromPosition:startPosition toPosition:endPosition];
    [self setSelectedTextRange:selectionRange];
}

@end
