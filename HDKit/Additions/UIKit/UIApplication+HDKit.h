//
//  UIApplication+HDKit.h
//  HDKitDemo
//
//  Created by ceo on 7/22/15.
//  Copyright (c) 2015 harvey. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIApplication (HDKit)

+ (UIViewController *)topmostViewController;

+ (void)gotoAppStoreUserRevicesPageWithApp:(NSString *)appId;

@end
