//
//  UIBarButtonItem+HDKit.m
//  HDKitDemo
//
//  Created by ceo on 9/8/15.
//  Copyright (c) 2015 harvey. All rights reserved.
//

#import "UIBarButtonItem+HDKit.h"
#import <objc/runtime.h>

static int HD_UIBarButtonItem_Block_Key;

@interface _HDUIBarButtonItemBlockTarget : NSObject

@property (nonatomic, copy) void (^block)(id sender);

- (instancetype)initWithBlock:(void (^)(id sender))block;
- (void)invoke:(id)sender;

@end

@implementation _HDUIBarButtonItemBlockTarget

- (instancetype)initWithBlock:(void (^)(id))block {
    self = [super init];
    if (self) {
        _block = block;
    }
    return self;
}

- (void)invoke:(id)sender {
    if (_block) {
        _block(sender);
    }
}

@end

@implementation UIBarButtonItem (HDKit)

- (void)setActionBlock:(void (^)(id sender))block {
    _HDUIBarButtonItemBlockTarget *target = [[_HDUIBarButtonItemBlockTarget alloc] initWithBlock:block];
    objc_setAssociatedObject(self, &HD_UIBarButtonItem_Block_Key, target, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [self setTarget:target];
    [self setAction:@selector(invoke:)];
}

- (void (^)(id)) actionBlock {
    _HDUIBarButtonItemBlockTarget *target = objc_getAssociatedObject(self, &HD_UIBarButtonItem_Block_Key);
    return target.block;
}

@end
