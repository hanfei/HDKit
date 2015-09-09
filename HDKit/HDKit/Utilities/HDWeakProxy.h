//
//  HDWeakProxy.h
//  HDKitDemo
//
//  Created by ceo on 9/9/15.
//  Copyright (c) 2015 harvey. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 A proxy used to hold a weak object.
 It can be used to avoid retain cycles, such as the target in CADisplayLink and
 NSTimer.
 
 sample code:
 
 @implementation MyView {
 NSTimer *_timer;
 }
 
 - (void)initTimer {
 YYWeakProxy *proxy = [YYWeakProxy proxyWithTarget:self];
 MyView *_self = (id)proxy;
 _timer = [NSTimer timerWithTimeInterval:0.1 target:_self selector:@selector(tick:) userInfo:nil repeats:YES];
 }
 
 - (void)tick:(NSTimer *)timer {...}
 @end
 */


@interface HDWeakProxy : NSProxy

/**
 The proxy target.
 */
@property (nonatomic, weak, readonly) id target;

/**
 Creates a new weak proxy for target.
 
 @param target Target object.
 
 @return A new proxy object.
 */
- (instancetype)initWithTarget:(id)target;

/**
 Creates a new weak proxy for target.
 
 @param target Target object.
 
 @return A new proxy object.
 */
+ (instancetype)proxyWithTarget:(id)target;

@end
