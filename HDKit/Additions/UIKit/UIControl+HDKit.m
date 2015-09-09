//
//  UIControl+HDKit.m
//  HDKitDemo
//
//  Created by ceo on 9/8/15.
//  Copyright (c) 2015 harvey. All rights reserved.
//

#import "UIControl+HDKit.h"
#import <objc/runtime.h>

static const int hd_control_block_key;

@interface _HDUIControlBlockTarget : NSObject

@property (nonatomic, copy) void (^block)(id sender);
@property (nonatomic, assign) UIControlEvents events;

- (instancetype)initWithBlock:(void (^)(id sender))block events:(UIControlEvents)events;
- (void)invoke:(id)sender;

@end

@implementation _HDUIControlBlockTarget

- (instancetype)initWithBlock:(void (^)(id sender))block events:(UIControlEvents)events {
    self = [super init];
    if (self) {
        _block = block;
        _events = events;
    }
    return self;
}

- (void)invoke:(id)sender {
    if (self.block) {
        _block(sender);
    }
}

@end

@implementation UIControl (HDKit)

- (void)hd_removeAllTargets {
    for (id target in [self allTargets]) {
        [self removeTarget:target action:NULL forControlEvents:UIControlEventAllEvents];
    }
}

- (void)hd_setTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents {
    for (id currentTarget in [self allTargets]) {
        NSArray *actions = [self actionsForTarget:currentTarget forControlEvent:controlEvents];
        for (NSString *action in actions) {
            [self removeTarget:currentTarget action:NSSelectorFromString(action) forControlEvents:controlEvents];
        }
    }
    [self addTarget:target action:action forControlEvents:controlEvents];
}

- (void)hd_addBlockForControlEvents:(UIControlEvents)controlEvents block:(void (^)(id sender))block {
    _HDUIControlBlockTarget *target = [[_HDUIControlBlockTarget alloc] initWithBlock:block events:controlEvents];
    [self addTarget:target action:@selector(invoke:) forControlEvents:controlEvents];
    NSMutableArray *targets = [self _hd_allUIControlBlockTargets];
    [targets addObject:target];
}

- (void)hd_setBlockForControlEvents:(UIControlEvents)controlEvents block:(void (^)(id sender))block {
    [self hd_removeAllBlockForControlEvents:controlEvents];
    [self hd_addBlockForControlEvents:controlEvents block:block];
}

- (void)hd_removeAllBlockForControlEvents:(UIControlEvents)controlEvents {
    NSMutableArray *targets = [self _hd_allUIControlBlockTargets];
    NSMutableArray *removes = [NSMutableArray array];
    [targets enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        _HDUIControlBlockTarget *target = (_HDUIControlBlockTarget *)obj;
        if (target.events == controlEvents) {
            [self removeTarget:target action:@selector(invoke:) forControlEvents:controlEvents];
            [removes addObject:target];
        }
    }];
    [targets removeObjectsInArray:removes];
}

- (NSMutableArray *)_hd_allUIControlBlockTargets {
    NSMutableArray *targets = objc_getAssociatedObject(self, &hd_control_block_key);
    if (targets == nil) {
        targets = [NSMutableArray array];
        objc_setAssociatedObject(self, &hd_control_block_key, targets, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return targets;
}























@end
