//
//  NSObject+HDKit.m
//  HDKitDemo
//
//  Created by harvey.ding on 5/20/15.
//  Copyright (c) 2015 harvey. All rights reserved.
//

#import "NSObject+HDKit.h"
#import <objc/runtime.h>

@implementation NSObject (HDKit)

+ (BOOL)swizzleInstanceMethod:(SEL)originalSel with:(SEL)newSel {
    Class class = [self class];
    Method originalMethod = class_getInstanceMethod(class, originalSel);
    Method swizzledMethod = class_getInstanceMethod(class, newSel);
    
    if (!originalMethod || !swizzledMethod) {
        return NO;
    }
    
    BOOL didAddMethod = class_addMethod(class, originalSel, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    if (didAddMethod) {
        class_replaceMethod(class, newSel, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    }else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
    
    return YES;
}

+ (BOOL)swizzleClassMethod:(SEL)originalSel with:(SEL)newSel {
    Class class = object_getClass(self);
    Method originalMethod = class_getClassMethod(class, originalSel);
    Method swizzledMethod = class_getClassMethod(class, newSel);
    
    if (!originalMethod || !swizzledMethod) {
        return NO;
    }
    
    BOOL didAddMethod = class_addMethod(class, originalSel, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    if (didAddMethod) {
        class_replaceMethod(class, newSel, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    }else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
    
    return YES;
}

@end

static const int HDObserverBlockKey;

@interface _HDNSObectKVOBlockTarget : NSObject

@property (nonatomic, copy) void (^block)(__weak id obj, id oldVal, id newVal);

- (instancetype)initWithBlock:(void(^)(__weak id obj, id oldVal, id newVal))block;

@end

@implementation _HDNSObectKVOBlockTarget

- (instancetype)initWithBlock:(void (^)(__weak id, id, id))block {
    self = [super init];
    if (self) {
        _block = block;
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (!self.block) {
        return;
    }
    
    BOOL isPrior = [[change objectForKey:NSKeyValueChangeNotificationIsPriorKey] boolValue];
    if (isPrior) {
        return;
    }
    
    NSKeyValueChange changeKind = [[change objectForKey:NSKeyValueChangeKindKey] integerValue];
    if (changeKind != NSKeyValueChangeSetting) {
        return;
    }
    
    id oldVal = [change objectForKey:NSKeyValueChangeOldKey];
    if (oldVal == [NSNull null]) {
        oldVal = nil;
    }
    
    id newVal = [change objectForKey:NSKeyValueChangeNewKey];
    if (newVal == [NSNull null]) {
        newVal = nil;
    }
    
    self.block(object, oldVal, newVal);
}

@end

@implementation NSObject (HDKit_KVO)

- (void)addObserverBlockForKeyPath:(NSString *)keyPath block:(void (^)(__weak id, id, id))block {
    if ([keyPath length] == 0 || !block) {
        return;
    }
    
    _HDNSObectKVOBlockTarget *target = [[_HDNSObectKVOBlockTarget alloc] initWithBlock:block];
    NSMutableDictionary *dic = [self _hd_allNSObjectObserverBlocks];
    NSMutableArray *arr = dic[keyPath];
    if (arr == nil) {
        arr = @[].mutableCopy;
        dic[keyPath] = arr;
    }
    [arr addObject:target];
    
    [self addObserver:target forKeyPath:keyPath options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:NULL];
}


- (void)removeObserverBlocksForKeyPath:(NSString *)keyPath {
    NSMutableDictionary *dic = [self _hd_allNSObjectObserverBlocks];
    NSMutableArray *arr = dic[keyPath];
    [arr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [self removeObserver:obj forKeyPath:keyPath];
    }];
}

- (void)removeObserverBlocks {
    NSMutableDictionary *dic = [self _hd_allNSObjectObserverBlocks];
    [dic enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSMutableArray *arr, BOOL *stop) {
        [arr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [self removeObserver:obj forKeyPath:key];
        }];
    }];
}

- (NSMutableDictionary *)_hd_allNSObjectObserverBlocks {
    NSMutableDictionary *targets = objc_getAssociatedObject(self, &HDObserverBlockKey);
    if (targets == nil) {
        targets = @[].mutableCopy;
        objc_setAssociatedObject(self, &HDObserverBlockKey, targets, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return targets;
}

@end

























