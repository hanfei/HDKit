//
//  UIScreen+HDKit.h
//  HDKitDemo
//
//  Created by ceo on 7/22/15.
//  Copyright (c) 2015 harvey. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScreen (HDKit)

@property (nonatomic, readonly) CGSize sizeInPixel;

/**
 The screen's PPI.
 This value may not be very accurate in an unknown device, or simulator.
 Default value is 96.
 */
@property (nonatomic, readonly) CGFloat pixelsPerInch;

@end
