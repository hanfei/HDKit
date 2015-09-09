//
//  UIView+HDKit.m
//  HDKitDemo
//
//  Created by harvey.ding on 5/20/15.
//  Copyright (c) 2015 harvey. All rights reserved.
//

#import "UIView+HDKit.h"
#import <objc/runtime.h>

@implementation UIView (HDKit)

- (CGFloat)left {
    return self.frame.origin.x;
}

- (void)setLeft:(CGFloat)left {
    CGRect frame = self.frame;
    frame.origin.x = left;
    self.frame = frame;
}

- (CGFloat)top {
    return self.frame.origin.y;
}

- (void)setTop:(CGFloat)top {
    CGRect frame = self.frame;
    frame.origin.y = top;
    self.frame = frame;
}

- (CGFloat)right {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setRight:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = right - self.frame.size.width;
    self.frame = frame;
}

- (CGFloat)bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setBottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - self.frame.size.height;
    self.frame = frame;
}

- (CGFloat)width {
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)height {
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)centerX {
    return self.center.x;
}

- (void)setCenterX:(CGFloat)centerX {
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

- (CGFloat)centerY {
    return self.center.y;
}

- (void)setCenterY:(CGFloat)centerY {
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

- (CGPoint)origin {
    return self.frame.origin;
}

- (void)setOrigin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGSize)size {
    return self.frame.size;
}

- (void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}


- (UIView *)getFirstResponder {
    if (self.isFirstResponder) {
        return self;
    }
    
    for (UIView *subView in self.subviews) {
        UIView *firstResponder = [subView getFirstResponder];
        if (firstResponder != nil) {
            return firstResponder;
        }
    }
    
    return nil;
}

- (BOOL)haveSubview:(UIView *)subView {
    UIView *v = subView;
    while (v) {
        if (self == v) {
            return YES;
        }
        
        v = v.superview;
    }
    
    return NO;
}

- (void)setRoundedCornersRadius:(CGFloat)radius {
    [self setRoundedCorners:UIRectCornerAllCorners radius:radius];
}

- (void)setRoundedCorners:(UIRectCorner)corners radius:(CGFloat)radius {
    CGRect rect = self.bounds;
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:rect
                                                   byRoundingCorners:corners
                                                         cornerRadii:CGSizeMake(radius, radius)];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = rect;
    maskLayer.path = maskPath.CGPath;
    
    self.layer.mask = maskLayer;
}

- (void)setShadowRadius:(CGFloat)radius {
    [self setShadowCorners:UIRectCornerAllCorners radius:radius];
}

- (void)setShadowCorners:(UIRectCorner)corners radius:(CGFloat)radius {
    CGRect rect = self.bounds;
    
    
    self.layer.shadowRadius = 2.0f;
    self.layer.shadowColor = [UIColor darkGrayColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(1.0f, 1.0f);
    self.layer.shadowOpacity = 1.0f;
    self.layer.shadowPath = [[UIBezierPath bezierPathWithRoundedRect:rect
                                                   byRoundingCorners:corners
                                                         cornerRadii:CGSizeMake(radius, radius)] CGPath];
}

- (void)pauseAnimation {
    CALayer *layer = self.layer;
    CFTimeInterval pausedTime = [layer convertTime:CACurrentMediaTime() fromLayer:nil];
    layer.speed = 0.0;
    layer.timeOffset = pausedTime;
}

- (void)resumeAnimation {
    CALayer *layer = self.layer;
    CFTimeInterval paused = [layer timeOffset];
    layer.speed = 1.0;
    layer.timeOffset = 0.0;
    layer.beginTime = 0.0;
    CFTimeInterval timeSincePause = [layer convertTime:CACurrentMediaTime() fromLayer:nil] - paused;
    layer.beginTime = timeSincePause;
}


- (NSData *)hd_snapshotPDF {
    CGRect bounds = self.bounds;
    NSMutableData* data = [NSMutableData data];
    CGDataConsumerRef consumer = CGDataConsumerCreateWithCFData((__bridge CFMutableDataRef)data);
    CGContextRef context = CGPDFContextCreate(consumer, &bounds, NULL);
    CGDataConsumerRelease(consumer);
    if (!context) return nil;
    CGPDFContextBeginPage(context, NULL);
    CGContextTranslateCTM(context, 0, bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    [self.layer renderInContext:context];
    CGPDFContextEndPage(context);
    CGPDFContextClose(context);
    CGContextRelease(context);
    return data;
}

- (void)hd_removeAllSubViews {
    NSArray *subViews = [self subviews];
    for (UIView *sView in subViews) {
        [sView removeFromSuperview];
    }
}

- (UIViewController *)viewController {
    for (UIView *view = self; view; view = view.superview) {
        UIResponder *nextResponder = [view nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}









































@end

static void * KCall_WebView_Identify = &KCall_WebView_Identify;


@implementation UIView (HDKit_Call)

- (void)hd_callWithPhoneNumber:(NSString *)phone {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return;
    }
    
    UIWebView *webView = objc_getAssociatedObject(self, KCall_WebView_Identify);
    if (webView == nil) {
        webView = [[UIWebView alloc] init];
        objc_setAssociatedObject(self, KCall_WebView_Identify, webView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    if (webView.superview == nil) {
        [self addSubview:webView];
    }
    
    NSString *callPhoneStr = [NSString stringWithFormat:@"tel://%@",phone];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:callPhoneStr]]];
}

@end

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
@implementation UIView (HDKit_Debug)

- (void)hd_printAutoLayoutTrace {

#if DEBUG
    NSLog(@"%@",[self performSelector:@selector(_autolayoutTrace)]);
#endif
}

- (void)hd_exerciseAmbiguityInLayoutRepeatedly:(BOOL)recursive {
#if DEBUG
    if (self.hasAmbiguousLayout) {
        [NSTimer scheduledTimerWithTimeInterval:.5
                                         target:self
                                       selector:@selector(exerciseAmbiguityInLayout)
                                       userInfo:nil
                                        repeats:YES];
    }
    
    if (recursive) {
        for (UIView *subView in self.subviews) {
            [subView hd_exerciseAmbiguityInLayoutRepeatedly:YES];
        }
    }
#endif
    
}
#pragma clang diagnostic pop

@end
