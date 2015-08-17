//
//  HDBorderView.h
//  ViewBorderTest
//
//  Created by ceo on 8/17/15.
//  Copyright (c) 2015 ceo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSUInteger, HDBorderViewEdge) {
    HDBorderViewEdgeLeft     = 1 << 0,
    HDBorderViewEdgeTop      = 1 << 1,
    HDBorderViewEdgeRight    = 1 << 2,
    HDBorderViewEdgeBottom   = 1 << 3,
    HDBorderViewEdgeAll      = ~0UL
};

@interface HDBorderView : UIView

@property (nonatomic, strong) NSOrderedSet *drawOrder;

- (void)setBorderWidth:(CGFloat)width color:(UIColor *)color forEdges:(HDBorderViewEdge)edges;

@end
