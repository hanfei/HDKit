//
//  UIApplication+HDKit.m
//  HDKitDemo
//
//  Created by ceo on 7/22/15.
//  Copyright (c) 2015 harvey. All rights reserved.
//

#import "UIApplication+HDKit.h"

@implementation UIApplication (HDKit)

+ (UIViewController *)topmostViewController {
    UIViewController *vc = [[[UIApplication sharedApplication].windows firstObject] rootViewController];
    while (vc.presentedViewController) {
        vc = vc.presentedViewController;
    }
    
    if ([vc isKindOfClass:[UINavigationController class]]) {
        vc = ((UINavigationController *)vc).topViewController;
    }
    
    return vc;
    
}


+ (void)gotoAppStoreUserRevicesPageWithApp:(NSString *)appId {
    if ([appId length] <= 0) {
        return;
    }
    
    NSString *reviewURL = nil;
    NSComparisonResult result = [[[UIDevice currentDevice] systemVersion]
                                 compare:@"7.0"
                                 options:NSNumericSearch];
    if (result != NSOrderedAscending) {
        //iOS Version>= 7.0
        reviewURL = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@", appId];
    }
    else {
        reviewURL = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@",
                     appId];
    }
    
    
    NSURL *url = [NSURL URLWithString:reviewURL];
    if (![[UIApplication sharedApplication] canOpenURL:url]) {
        return;
    }
    
    [[UIApplication sharedApplication] openURL:url];
}

@end
