//
//  NSObject+HDKit.m
//  HDKitDemo
//
//  Created by harvey.ding on 5/20/15.
//  Copyright (c) 2015 harvey. All rights reserved.
//

#import "NSObject+HDKit.h"

@implementation NSObject (HDKit)

- (id)performSelector:(SEL)aSelector withObject:(id)object, ... {
    NSMethodSignature *signature = [self methodSignatureForSelector:aSelector];
    if (signature) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
        [invocation setTarget:self];
        [invocation setSelector:aSelector];
        
        va_list args;
        va_start(args, object);
        [invocation setArgument:&object atIndex:2];
        id arg = nil;
        int index = 3;
        
        while ((arg = va_arg(args, id))) {
            [invocation setArgument:&arg atIndex:index];
            index++;
        }
        
        [invocation invoke];
        if (signature.methodReturnLength) {
            id retObj = nil;
            [invocation getReturnValue:&retObj];
            return retObj;
        }else {
            return nil;
        }
    }else {
        return nil;
    }
}

@end
