//
//  NSArray+HDKit.m
//  HDKitDemo
//
//  Created by harvey.ding on 5/21/15.
//  Copyright (c) 2015 harvey. All rights reserved.
//

#import "NSArray+HDKit.h"

@implementation NSArray (HDKit)

- (id)randomObject {
    if (self.count > 0) {
        return self[arc4random_uniform((u_int32_t)self.count)];
    }
    return nil;
}

- (id)safeObjectAtIndex:(NSUInteger)index {
    if (self.count > index) {
        return [self objectAtIndex:index];
    }else {
        return nil;
    }
}

- (NSArray *)reversedArray {
    NSMutableArray *mArr = [NSMutableArray arrayWithCapacity:[self count]];
    for (id obj in [self reverseObjectEnumerator]) {
        [mArr addObject:obj];
    }
    return [mArr copy];
}

- (NSString *)arrayToJson {
    if ([NSJSONSerialization isValidJSONObject:self]) {
        NSError *error = nil;
        NSData *data = [NSJSONSerialization dataWithJSONObject:self options:0 error:&error];
        if (error) {
            NSLog(@"array convert to json error: %@",error);
        }
        return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    return nil;
}

- (NSArray *)sortedByKey:(NSString *)key ascending:(BOOL)ascending {
    NSSortDescriptor *descriptior = [NSSortDescriptor sortDescriptorWithKey:key
                                                                  ascending:ascending];
    NSArray *sortedArr = [self sortedArrayUsingDescriptors:@[descriptior]];
    return sortedArr;
}

@end
