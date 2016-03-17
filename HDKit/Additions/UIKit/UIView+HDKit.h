//
//  UIView+HDKit.h
//  HDKitDemo
//
//  Created by harvey.ding on 5/20/15.
//  Copyright (c) 2015 harvey. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (HDKit)

@property (nonatomic) CGFloat left;
@property (nonatomic) CGFloat top;
@property (nonatomic) CGFloat right;
@property (nonatomic) CGFloat bottom;
@property (nonatomic) CGFloat width;
@property (nonatomic) CGFloat height;
@property (nonatomic) CGFloat centerX;
@property (nonatomic) CGFloat centerY;
@property (nonatomic) CGPoint origin;
@property (nonatomic) CGSize  size;

@property (nonatomic, readonly) UIViewController *viewController;

- (UIView *)getFirstResponder;
- (BOOL)haveSubview:(UIView *)subView;

- (void)setRoundedCornersRadius:(CGFloat)radius;
- (void)setRoundedCorners:(UIRectCorner)corners radius:(CGFloat)radius;
- (void)setShadowRadius:(CGFloat)radius;
- (void)setShadowCorners:(UIRectCorner)corners radius:(CGFloat)radius;
- (void)pauseAnimation;
- (void)resumeAnimation;

- (void)hd_removeAllSubViews;
- (NSData *)hd_snapshotPDF;

@end

@interface UIView (HDKit_Call)

- (void)hd_callWithPhoneNumber:(NSString *)phone;

@end

@interface UIView (HDKit_Debug)

- (void)hd_printAutoLayoutTrace;
- (void)hd_exerciseAmbiguityInLayoutRepeatedly:(BOOL)recursive;

@end

@interface UIView (HDKit_Transform)

@property (nonatomic) CGFloat rotation;
@property (nonatomic) CGFloat xscale;
@property (nonatomic) CGFloat yscale;
@property (nonatomic) CGFloat tx;
@property (nonatomic) CGFloat ty;

@property (nonatomic, readonly) CGRect originalFrame;
@property (nonatomic, readonly) CGPoint originalCenter;

@property (nonatomic, readonly) CGPoint transformedTopLeft;
@property (nonatomic, readonly) CGPoint transformedTopRight;
@property (nonatomic, readonly) CGPoint transformedBottomLeft;
@property (nonatomic, readonly) CGPoint transformedBottomRight;

@property (nonatomic, readonly) NSString *transformDescription;

- (CGPoint) pointInTransformedView: (CGPoint) pointInParentCoordinates;
- (BOOL) intersectsView: (UIView *) aView;

@end
