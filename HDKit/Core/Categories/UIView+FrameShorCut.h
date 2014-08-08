//
//  UIView+FrameShorCut.h
//  HDKit
//
//  Created by harvey.ding on 8/8/14.
//  Copyright (c) 2014 harvey. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIView (FrameShorCut)

@property (nonatomic) CGPoint frameOrigion;
@property (nonatomic) CGFloat frameX;
@property (nonatomic) CGFloat frameY;

@property (nonatomic) CGSize  frameSize;
@property (nonatomic) CGFloat frameWidth;
@property (nonatomic) CGFloat frameHeight;

@property (nonatomic) CGFloat frameRight;
@property (nonatomic) CGFloat frameBottom;

@end
