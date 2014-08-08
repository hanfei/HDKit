//
//  UIView+FrameShorCut.m
//  HDKit
//
//  Created by harvey.ding on 8/8/14.
//  Copyright (c) 2014 harvey. All rights reserved.
//

#import "UIView+FrameShorCut.h"

@implementation UIView (FrameShorCut)

- (CGPoint)frameOrigion{
    return self.frame.origin;
}

- (void)setFrameOrigion:(CGPoint)frameOrigion{
    self.frame = CGRectMake(frameOrigion.x, frameOrigion.y, self.frame.size.width, self.frame.size.height);
}

- (CGFloat)frameX{
    return self.frame.origin.x;
}

- (void)setFrameX:(CGFloat)frameX{
    self.frame = CGRectMake(frameX, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
}

- (CGFloat)frameY{
    return self.frame.origin.y;
}

- (void)setFrameY:(CGFloat)frameY{
    self.frame = CGRectMake(self.frame.origin.x, frameY, self.frame.size.width, self.frame.size.height);
}

- (CGSize)frameSize{
    return self.frame.size;
}

- (void)setFrameSize:(CGSize)frameSize{
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, frameSize.width, frameSize.height);
}

- (CGFloat)frameWidth{
    return self.frame.size.width;
}

- (void)setFrameWidth:(CGFloat)frameWidth{
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, frameWidth, self.frame.size.height);
}

- (CGFloat)frameHeight{
    return self.frame.size.height;
}

- (void)setFrameHeight:(CGFloat)frameHeight{
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, frameHeight);
}

- (CGFloat)frameRight{
    return (self.frame.origin.x + self.frame.size.width);
}

- (void)setFrameRight:(CGFloat)frameRight{
    self.frame = CGRectMake(frameRight - self.frame.size.width, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
}

- (CGFloat)frameBottom{
    return (self.frame.origin.y + self.frame.size.height);
}

- (void)setFrameBottom:(CGFloat)frameBottom{
    self.frame = CGRectMake(self.frame.origin.x, frameBottom - self.frame.size.height, self.frame.size.width, self.frame.size.height);
}

@end
