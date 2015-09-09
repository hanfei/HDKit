//
//  CALayer+HDKit.h
//  JFI
//
//  Created by ceo on 7/21/15.
//  Copyright (c) 2015 harvey. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CALayer (HDKit)

@property (nonatomic, assign) UIColor *borderUIColor;

@property (nonatomic) CGFloat transformRotation;     ///< key path "tranform.rotation"
@property (nonatomic) CGFloat transformRotationX;    ///< key path "tranform.rotation.x"
@property (nonatomic) CGFloat transformRotationY;    ///< key path "tranform.rotation.y"
@property (nonatomic) CGFloat transformRotationZ;    ///< key path "tranform.rotation.z"
@property (nonatomic) CGFloat transformScale;        ///< key path "tranform.scale"
@property (nonatomic) CGFloat transformScaleX;       ///< key path "tranform.scale.x"
@property (nonatomic) CGFloat transformScaleY;       ///< key path "tranform.scale.y"
@property (nonatomic) CGFloat transformScaleZ;       ///< key path "tranform.scale.z"
@property (nonatomic) CGFloat transformTranslationX; ///< key path "tranform.translation.x"
@property (nonatomic) CGFloat transformTranslationY; ///< key path "tranform.translation.y"
@property (nonatomic) CGFloat transformTranslationZ; ///< key path "tranform.translation.z"

/**
 Shortcut for transform.m34, -1/1000 is a good value.
 It should be set before other transform shortcut.
 */
@property (nonatomic, assign) CGFloat transformDepth;

@end
