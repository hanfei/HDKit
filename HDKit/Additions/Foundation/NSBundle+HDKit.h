//
//  NSBundle+HDKit.h
//  HDKitDemo
//
//  Created by ceo on 7/22/15.
//  Copyright (c) 2015 harvey. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSBundle (HDKit)

+ (NSString *)displayName;
+ (NSString *)appBundleIdentifier;
+ (NSString *)releaseVersion;
+ (NSString *)buildVersion;

@end
