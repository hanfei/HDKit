//
//  UIGestureRecognizer+HDKit.m
//  HDKitDemo
//
//  Created by ceo on 9/8/15.
//  Copyright (c) 2015 harvey. All rights reserved.
//

#import "UIGestureRecognizer+HDKit.h"
#import <objc/runtime.h>

static const int HD_UIGestureRecognizer_Block_Key;

@interface _HDUIGestureRecognizerBlockTarget : NSObject

@property (nonatomic, copy) void (^block)(id sender);

- (id)initWithBlock:(void (^)(id sender))block;
- (void)invoke:(id)sender;

@end

@implementation _HDUIGestureRecognizerBlockTarget

- (id)initWithBlock:(void (^)(id sender))block{
    self = [super init];
    if (self) {
        self.block = block;
    }
    return self;
}

- (void)invoke:(id)sender {
    if (self.block) self.block(sender);
}

@end


@implementation UIGestureRecognizer (HDKit)

- (instancetype)initWithActionBlock:(void (^)(id sender))block {
    self = [super init];
    if (self) {
        [self addActionBlock:block];
    }
    return self;
}

- (void)addActionBlock:(void (^)(id sender))block {
    _HDUIGestureRecognizerBlockTarget *target = [[_HDUIGestureRecognizerBlockTarget alloc] initWithBlock:block];
    [self addTarget:target action:@selector(invoke:)];
    NSMutableArray *targets = [self _hd_allUIGestureRecognizerBlockTargets];
    [targets addObject:target];
}

- (void)removeAllActionBlocks {
    NSMutableArray *targets = [self _hd_allUIGestureRecognizerBlockTargets];
    [targets enumerateObjectsUsingBlock:^(id target, NSUInteger idx, BOOL *stop) {
        [self removeTarget:target action:@selector(invoke:)];
    }];
    [targets removeAllObjects];
}

- (NSMutableArray *)_hd_allUIGestureRecognizerBlockTargets {
    NSMutableArray *targets = objc_getAssociatedObject(self, &HD_UIGestureRecognizer_Block_Key);
    if (!targets) {
        targets = [NSMutableArray array];
        objc_setAssociatedObject(self, &HD_UIGestureRecognizer_Block_Key, targets, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return targets;
}

@end
