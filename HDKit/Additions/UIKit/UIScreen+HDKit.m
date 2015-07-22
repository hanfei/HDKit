//
//  UIScreen+HDKit.m
//  HDKitDemo
//
//  Created by ceo on 7/22/15.
//  Copyright (c) 2015 harvey. All rights reserved.
//

#import "UIScreen+HDKit.h"

#define HDScreenWidth                       (CGRectGetWidth([[UIScreen mainScreen] bounds]))
#define HDScreenHeight                      (CGRectGetHeight([[UIScreen mainScreen] bounds]))
#define HDScreenHeightIs4SAndLower          (UIScreenHeight <= 480)
#define HDScreenHeightIs5                   (UIScreenHeight == 568)
#define HDScreenHeightIs6                   (UIScreenHeight == 667)
#define HDScreenHeightIs6PlusAndHigher      (UIScreenHeight >= 736)

@implementation UIScreen (HDKit)

@end
