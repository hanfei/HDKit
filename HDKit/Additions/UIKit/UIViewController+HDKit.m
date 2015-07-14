//
//  UIViewController+HDKit.m
//  HDKitDemo
//
//  Created by ceo on 7/14/15.
//  Copyright (c) 2015 harvey. All rights reserved.
//

#import "UIViewController+HDKit.h"

@implementation UIViewController (HDKit)

+ (UIViewController *)topViewController:(UIViewController *)rootViewController {
    if (rootViewController.presentedViewController == nil) {
        return rootViewController;
    }
    
    if ([rootViewController.presentedViewController isMemberOfClass:[UINavigationController class]]) {
        UINavigationController *navigationController = (UINavigationController *)rootViewController.presentedViewController;
        UIViewController *lastViewController = [navigationController topViewController];
        return [self topViewController:lastViewController];
    }
    
    UIViewController *presentedViewController = rootViewController.presentedViewController;
    return [self topViewController:presentedViewController];
}

@end
