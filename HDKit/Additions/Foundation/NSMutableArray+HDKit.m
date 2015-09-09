//
//  NSMutableArray+HDKit.m
//  HDKitDemo
//
//  Created by ceo on 9/4/15.
//  Copyright (c) 2015 harvey. All rights reserved.
//

#import "NSMutableArray+HDKit.h"

@implementation NSMutableArray (HDKit)

- (void)shuffle {
    for (NSUInteger i = self.count; i > 1; i--) {
        [self exchangeObjectAtIndex:i - 1 withObjectAtIndex:arc4random_uniform((u_int32_t)i)];
    }
}

@end
