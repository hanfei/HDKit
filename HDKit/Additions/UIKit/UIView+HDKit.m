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

@implementation UIView (HDKit_Transform)

CGAffineTransform makeTransform(CGFloat xScale, CGFloat yScale, CGFloat theta, CGFloat tx, CGFloat ty)
{
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    transform.a = xScale * cos(theta);
    transform.b = yScale * sin(theta);
    transform.c = xScale * -sin(theta);
    transform.d = yScale * cos(theta);
    transform.tx = tx;
    transform.ty = ty;
    
    return transform;
    
}

- (CGFloat) xscale
{
    CGAffineTransform t = self.transform;
    return sqrt(t.a * t.a + t.c * t.c);
}

- (void) setXscale: (CGFloat) xScale
{
    self.transform = makeTransform(xScale, self.yscale, self.rotation, self.tx, self.ty);
}

- (CGFloat) yscale
{
    CGAffineTransform t = self.transform;
    return sqrt(t.b * t.b + t.d * t.d);
}

- (void) setYscale: (CGFloat) yScale
{
    self.transform = makeTransform(self.xscale, yScale, self.rotation, self.tx, self.ty);
}


- (CGFloat) rotation
{
    CGAffineTransform t = self.transform;
    return atan2f(t.b, t.a);
}

- (void) setRotation: (CGFloat) theta
{
    self.transform = makeTransform(self.xscale, self.yscale, theta, self.tx, self.ty);
}


- (CGFloat) tx
{
    CGAffineTransform t = self.transform;
    return t.tx;
}

- (void) setTx:(CGFloat)tx
{
    self.transform = makeTransform(self.xscale, self.yscale, self.rotation, tx, self.ty);
}

- (CGFloat) ty
{
    CGAffineTransform t = self.transform;
    return t.ty;
}

- (void) setTy:(CGFloat)ty
{
    self.transform = makeTransform(self.xscale, self.yscale, self.rotation, self.tx, ty);
}

- (CGPoint) offsetPointToParentCoordinates: (CGPoint) aPoint
{
    return CGPointMake(aPoint.x + self.center.x, aPoint.y + self.center.y);
}

- (CGPoint) pointInViewCenterTerms: (CGPoint) aPoint
{
    return CGPointMake(aPoint.x - self.center.x, aPoint.y - self.center.y);
}

- (CGPoint) pointInTransformedView: (CGPoint) aPoint
{
    CGPoint offsetItem = [self pointInViewCenterTerms:aPoint];
    CGPoint updatedItem = CGPointApplyAffineTransform(offsetItem, self.transform);
    CGPoint finalItem = [self offsetPointToParentCoordinates:updatedItem];
    
    return finalItem;
}

- (CGRect) originalFrame
{
    CGAffineTransform currentTransform = self.transform;
    self.transform = CGAffineTransformIdentity;
    CGRect originalFrame = self.frame;
    self.transform = currentTransform;
    
    return originalFrame;
}

- (CGPoint) originalCenter
{
    CGAffineTransform currentTransform = self.transform;
    self.transform = CGAffineTransformIdentity;
    CGPoint originalCenter = self.center;
    self.transform = currentTransform;
    
    return originalCenter;
}

- (NSString *) transformDescription
{
    NSMutableString *descriptionString = [NSMutableString string];
    
    [descriptionString appendFormat:@"Frame: %@; ", NSStringFromCGRect(self.originalFrame)];
    [descriptionString appendFormat:@"Transformed Frame: %@; ", NSStringFromCGRect(self.frame)];
    [descriptionString appendFormat:@"Scale: [%0.5f, %0.5f]; ", self.xscale, self.yscale];
    [descriptionString appendFormat:@"Rotation: [%0.5f]; ", self.rotation];
    [descriptionString appendFormat:@"Translation: [%0.5f, %0.5f]; ", self.tx, self.ty];
    [descriptionString appendFormat:@"Transform: %@", CGAffineTransformIsIdentity(self.transform) ? @"Identity" : NSStringFromCGAffineTransform(self.transform)];
    
    return descriptionString;
}

- (CGPoint) transformedTopLeft
{
    CGRect frame = self.originalFrame;
    CGPoint point = frame.origin;
    return [self pointInTransformedView:point];
}

- (CGPoint) transformedTopRight
{
    CGRect frame = self.originalFrame;
    CGPoint point = frame.origin;
    point.x += frame.size.width;
    return [self pointInTransformedView:point];
}

- (CGPoint) transformedBottomRight
{
    CGRect frame = self.originalFrame;
    CGPoint point = frame.origin;
    point.x += frame.size.width;
    point.y += frame.size.height;
    return [self pointInTransformedView:point];
}

- (CGPoint) transformedBottomLeft
{
    CGRect frame = self.originalFrame;
    CGPoint point = frame.origin;
    point.y += frame.size.height;
    return [self pointInTransformedView:point];
}

BOOL halfPlane(CGPoint p1, CGPoint p2, CGPoint testPoint)
{
    CGPoint base = CGPointMake(p2.x - p1.x, p2.y - p1.y);
    CGPoint orthog = CGPointMake(-base.y, base.x);
    return (((orthog.x * (testPoint.x - p1.x)) + (orthog.y * (testPoint.y - p1.y))) >= 0);
}

BOOL intersectionTest(CGPoint p1, CGPoint p2, UIView *aView)
{
    BOOL tlTest = halfPlane(p1, p2, aView.transformedTopLeft);
    BOOL trTest = halfPlane(p1, p2, aView.transformedTopRight);
    if (tlTest != trTest) return YES;
    
    BOOL brTest = halfPlane(p1, p2, aView.transformedBottomRight);
    if (tlTest != brTest) return YES;
    
    BOOL blTest = halfPlane(p1, p2, aView.transformedBottomLeft);
    if (tlTest != blTest) return YES;
    
    return NO;
}

- (BOOL) intersectsView: (UIView *) aView
{
    if (!CGRectIntersectsRect(self.frame, aView.frame)) return NO;
    
    CGPoint A = self.transformedTopLeft;
    CGPoint B = self.transformedTopRight;
    CGPoint C = self.transformedBottomRight;
    CGPoint D = self.transformedBottomLeft;
    
    if (!intersectionTest(A, B, aView))
    {
        BOOL test = halfPlane(A, B, aView.transformedTopLeft);
        BOOL t1 = halfPlane(A, B, C);
        BOOL t2 = halfPlane(A, B, D);
        if ((t1 != test) && (t2 != test)) return NO;
    }
    
    if (!intersectionTest(B, C, aView))
    {
        BOOL test = halfPlane(B, C, aView.transformedTopLeft);
        BOOL t1 = halfPlane(B, C, A);
        BOOL t2 = halfPlane(B, C, D);
        if ((t1 != test) && (t2 != test)) return NO;
    }
    
    if (!intersectionTest(C, D, aView))
    {
        BOOL test = halfPlane(C, D, aView.transformedTopLeft);
        BOOL t1 = halfPlane(C, D, A);
        BOOL t2 = halfPlane(C, D, B);
        if ((t1 != test) && (t2 != test)) return NO;
    }
    
    if (!intersectionTest(D, A, aView))
    {
        BOOL test = halfPlane(D, A, aView.transformedTopLeft);
        BOOL t1 = halfPlane(D, A, B);
        BOOL t2 = halfPlane(D, A, C);
        if ((t1 != test) && (t2 != test)) return NO;
    }
    
    A = aView.transformedTopLeft;
    B = aView.transformedTopRight;
    C = aView.transformedBottomRight;
    D = aView.transformedBottomLeft;
    
    if (!intersectionTest(A, B, self))
    {
        BOOL test = halfPlane(A, B, self.transformedTopLeft);
        BOOL t1 = halfPlane(A, B, C);
        BOOL t2 = halfPlane(A, B, D);
        if ((t1 != test) && (t2 != test)) return NO;
    }
    
    if (!intersectionTest(B, C, self))
    {
        BOOL test = halfPlane(B, C, self.transformedTopLeft);
        BOOL t1 = halfPlane(B, C, A);
        BOOL t2 = halfPlane(B, C, D);
        if ((t1 != test) && (t2 != test)) return NO;
    }
    
    if (!intersectionTest(C, D, self))
    {
        BOOL test = halfPlane(C, D, self.transformedTopLeft);
        BOOL t1 = halfPlane(C, D, A);
        BOOL t2 = halfPlane(C, D, B);
        if ((t1 != test) && (t2 != test)) return NO;
    }
    
    if (!intersectionTest(D, A, self))
    {
        BOOL test = halfPlane(D, A, self.transformedTopLeft);
        BOOL t1 = halfPlane(D, A, B);
        BOOL t2 = halfPlane(D, A, C);
        if ((t1 != test) && (t2 != test)) return NO;
    }
    
    return YES;
    
}


@end
