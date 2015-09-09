//
//  HDWeakProxy.m
//  HDKitDemo
//
//  Created by ceo on 9/9/15.
//  Copyright (c) 2015 harvey. All rights reserved.
//

#import "HDWeakProxy.h"

@implementation HDWeakProxy

- (instancetype)initWithTarget:(id)target {
    _target = target;
    return self;
}

+ (instancetype)proxyWithTarget:(id)target {
    return [[HDWeakProxy alloc] initWithTarget:target];
}

- (id)forwardingTargetForSelector:(SEL)selector {
    return _target;
}

- (void)forwardInvocation:(NSInvocation *)invocation {
    void *null = NULL;
    [invocation setReturnValue:&null];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)selector {
    return [NSObject instanceMethodSignatureForSelector:@selector(init)];
}

- (NSString *)description {
    return [_target description];
}

- (NSString *)debugDescription {
    return [_target debugDescription];
}

- (BOOL)respondsToSelector:(SEL)aSelector {
    return [_target respondsToSelector:aSelector];
}

- (Class)class {
    return [_target class];
}

- (BOOL)isKindOfClass:(Class)aClass {
    return [_target isKindOfClass:aClass];
}

- (BOOL)isMemberOfClass:(Class)aClass {
    return [_target isMemberOfClass:aClass];
}

- (BOOL)conformsToProtocol:(Protocol *)aProtocol {
    return [_target conformsToProtocol:aProtocol];
}

- (BOOL)isProxy {
    return YES;
}


@end
