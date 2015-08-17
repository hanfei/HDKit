//
//  HDBorderView.m
//  ViewBorderTest
//
//  Created by ceo on 8/17/15.
//  Copyright (c) 2015 ceo. All rights reserved.
//

#import "HDBorderView.h"

@interface HDBorderView ()

@property (nonatomic, assign) CGFloat leftWidth;
@property (nonatomic, strong) UIColor *leftColor;

@property (nonatomic, assign) CGFloat topWidth;
@property (nonatomic, strong) UIColor *topColor;

@property (nonatomic, assign) CGFloat rightWidth;
@property (nonatomic, strong) UIColor *rightColor;

@property (nonatomic, assign) CGFloat bottomWidth;
@property (nonatomic, strong) UIColor *bottomColor;

@end

@implementation HDBorderView

- (void)setBorderWidth:(CGFloat)width color:(UIColor *)color forEdges:(HDBorderViewEdge)edges {
    
    if (edges & HDBorderViewEdgeLeft) {
        _leftWidth = width;
        _leftColor = color;
    }
    
    if (edges & HDBorderViewEdgeTop) {
        _topWidth = width;
        _topColor = color;
    }
    
    if (edges & HDBorderViewEdgeRight) {
        _rightWidth = width;
        _rightColor = color;
    }
    
    if (edges & HDBorderViewEdgeBottom) {
        _bottomWidth = width;
        _bottomColor = color;
    }
    
    [self setNeedsDisplay];
}

- (void)setDrawOrder:(NSOrderedSet *)drawOrder {
    if (_drawOrder != drawOrder) {
        _drawOrder = drawOrder;
        [self setNeedsDisplay];
    }
}

- (void)drawRect:(CGRect)rect {
    CGFloat xMin = CGRectGetMinX(self.bounds);
    CGFloat xMax = CGRectGetMaxX(self.bounds);
    
    CGFloat yMin = CGRectGetMinY(self.bounds);
    CGFloat yMax = CGRectGetMaxY(self.bounds);
    
    CGFloat fWidth = self.bounds.size.width;
    CGFloat fHeight = self.bounds.size.height;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (!_drawOrder) {
        _drawOrder = [NSOrderedSet orderedSetWithArray:@[@(HDBorderViewEdgeLeft),@(HDBorderViewEdgeTop),@(HDBorderViewEdgeRight),@(HDBorderViewEdgeBottom)]];
    }
    
    
    for (id item in _drawOrder)
    {
        if ([item isKindOfClass:[NSNumber class]])
        {
            [self drawBorder:(NSNumber *)item
                   inContext:context
                        xMin:xMin
                        xMax:xMax
                        yMin:yMin
                        yMax:yMax
                  frameWidth:fWidth
                 frameHeight:fHeight];
        }
    }

}

- (void) drawBorder:(NSNumber *)borderName
          inContext:(CGContextRef)context
               xMin:(CGFloat)xMin
               xMax:(CGFloat)xMax
               yMin:(CGFloat)yMin
               yMax:(CGFloat)yMax
         frameWidth:(CGFloat)fWidth
        frameHeight:(CGFloat)fHeight
{
    
    if ([borderName integerValue] == HDBorderViewEdgeLeft)
    {
        if ( _leftWidth > 0 && _leftColor != nil) {
            CGContextSetFillColorWithColor(context, _leftColor.CGColor);
            CGContextFillRect(context, CGRectMake(xMin, yMin, _leftWidth, fHeight));
        }
    }
    else if ([borderName integerValue] == HDBorderViewEdgeRight)
    {
        if (_rightWidth > 0 && _rightColor != nil) {
            CGContextSetFillColorWithColor(context, _rightColor.CGColor);
            CGContextFillRect(context, CGRectMake(xMax - _rightWidth, yMin, _rightWidth, fHeight));
        }
    }
    else if ([borderName integerValue] == HDBorderViewEdgeBottom)
    {
        if ( _bottomWidth > 0 && _bottomColor != nil) {
            CGContextSetFillColorWithColor(context, _bottomColor.CGColor);
            CGContextFillRect(context, CGRectMake(xMin, yMax - _bottomWidth, fWidth, _bottomWidth));
        }
    }
    else if ([borderName integerValue] == HDBorderViewEdgeTop)
    {
        if ( _topWidth > 0 && _topColor != nil) {
            CGContextSetFillColorWithColor(context, _topColor.CGColor);
            CGContextFillRect(context, CGRectMake(xMin, yMin, fWidth, _topWidth));
        }
    }
}



@end
