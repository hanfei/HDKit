//
//  UIDevice+HDKit.m
//  HDKitDemo
//
//  Created by ceo on 7/22/15.
//  Copyright (c) 2015 harvey. All rights reserved.
//

#import "UIDevice+HDKit.h"


#define HDSystemVersionIs(v)           ([[[UIDevice currentDevice] systemVersion] compare:(v) options:NSNumericSearch] == NSOrderedSame)
#define HDSystemVersionAbove(v)        ([[[UIDevice currentDevice] systemVersion] compare:(v) options:NSNumericSearch] == NSOrderedDescending)
#define HDSystemVersionAboveOrIs(v)    ([[[UIDevice currentDevice] systemVersion] compare:(v) options:NSNumericSearch] != NSOrderedAscending)
#define HDSystemVersionBelow(v)        ([[[UIDevice currentDevice] systemVersion] compare:(v) options:NSNumericSearch] == NSOrderedAscending)
#define HDSystemVersionBelowOrIs(v)    ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

@implementation UIDevice (HDKit)

@end
