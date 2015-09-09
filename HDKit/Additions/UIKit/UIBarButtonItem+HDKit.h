//
//  UIBarButtonItem+HDKit.h
//  HDKitDemo
//
//  Created by ceo on 9/8/15.
//  Copyright (c) 2015 harvey. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (HDKit)

@property (nonatomic, copy) void (^actionBlock)(id);

@end
