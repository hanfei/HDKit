//
//  NSArray+HDKit.m
//  HDKitDemo
//
//  Created by harvey.ding on 5/21/15.
//  Copyright (c) 2015 harvey. All rights reserved.
//

#import "NSArray+HDKit.h"

@implementation NSArray (HDKit)

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
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&error];
    if (error) {
        return error.localizedDescription;
    }else{
        return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
}

- (NSArray *)sortedByKey:(NSString *)key ascending:(BOOL)ascending {
    NSSortDescriptor *descriptior = [NSSortDescriptor sortDescriptorWithKey:key
                                                                  ascending:ascending];
    NSArray *sortedArr = [self sortedArrayUsingDescriptors:@[descriptior]];
    return sortedArr;
}

@end
