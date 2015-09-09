//
//  HDTextRunDelegate.m
//  HDKitDemo
//
//  Created by ceo on 9/9/15.
//  Copyright (c) 2015 harvey. All rights reserved.
//

#import "HDTextRunDelegate.h"

@implementation HDTextRunDelegate

- (instancetype)init {
    self = super.init;
    _userInfo = @{}.mutableCopy;
    return self;
}

static void DeallocCallback(void *ref) {
    HDTextRunDelegate *self = (__bridge_transfer HDTextRunDelegate *)(ref);
    self = nil;
}

static CGFloat GetAscentCallback(void *ref) {
    HDTextRunDelegate *self = (__bridge HDTextRunDelegate *)(ref);
    return self.ascent;
}

static CGFloat GetDecentCallback(void *ref) {
    HDTextRunDelegate *self = (__bridge HDTextRunDelegate *)(ref);
    return self.descent;
}

static CGFloat GetWidthCallback(void *ref) {
    HDTextRunDelegate *self = (__bridge HDTextRunDelegate *)(ref);
    return self.width;
}

- (CTRunDelegateRef)CTRunDelegate CF_RETURNS_RETAINED {
    CTRunDelegateCallbacks callbacks;
    callbacks.version = kCTRunDelegateCurrentVersion;
    callbacks.dealloc = DeallocCallback;
    callbacks.getAscent = GetAscentCallback;
    callbacks.getDescent = GetDecentCallback;
    callbacks.getWidth = GetWidthCallback;
    return CTRunDelegateCreate(&callbacks, (__bridge_retained void *)(self));
}


@end
