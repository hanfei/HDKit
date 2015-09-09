//
//  UITextField+HDKit.h
//  HDKitDemo
//
//  Created by ceo on 9/8/15.
//  Copyright (c) 2015 harvey. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (HDKit)

- (void)hd_selectAllText;
- (void)hd_setSelectedRange:(NSRange)range;

@end
