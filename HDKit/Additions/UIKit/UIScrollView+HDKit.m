//
//  UIScrollView+HDKit.m
//  HDKitDemo
//
//  Created by ceo on 7/14/15.
//  Copyright (c) 2015 harvey. All rights reserved.
//

#import "UIScrollView+HDKit.h"
#import "UIView+HDKit.h"
@implementation UIScrollView (HDKit)

- (void)scrollToView:(UIView *)v {
    UIView *originV = v;
    if (v && [self haveSubview:v]) {
        while (v && ![[v class] isSubclassOfClass:[self class]]) {
            v = v.superview;
        }
    }
    
    if (v) {
        [self scrollRectToVisible:[self convertRect:originV.bounds fromView:originV] animated:YES];
    }
}

- (void)killScroll {
    CGPoint offset = self.contentOffset;
    offset.x -= 1.0;
    offset.y -= 1.0;
    [self setContentOffset:offset animated:NO];
    offset.x += 1.0;
    offset.y += 1.0;
    [self setContentOffset:offset animated:NO];
}

@end
