//
//  CALayer+HDKit.m
//  JFI
//
//  Created by ceo on 7/21/15.
//  Copyright (c) 2015 harvey. All rights reserved.
//

#import "CALayer+HDKit.h"

@implementation CALayer (HDKit)

- (UIColor *)borderUIColor {
    return [UIColor colorWithCGColor:self.borderColor];
}

- (void)setBorderUIColor:(UIColor *)borderUIColor {
    self.borderColor = borderUIColor.CGColor;
}

@end
