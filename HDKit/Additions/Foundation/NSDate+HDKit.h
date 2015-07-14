//
//  NSDate+HDKit.h
//  HDKitDemo
//
//  Created by harvey.ding on 5/21/15.
//  Copyright (c) 2015 harvey. All rights reserved.
//

#import <Foundation/Foundation.h>

struct HDDateInformation {
    NSInteger day;
    NSInteger month;
    NSInteger year;
    NSInteger weekday;
    NSInteger hour;
    NSInteger minute;
    NSInteger second;
};

typedef struct HDDateInformation HDDateInformation;

@interface NSDate (HDKit)

- (BOOL)isSameDay:(NSDate *)date;
- (BOOL)isToday;
- (NSDate *)dateByAddDays:(NSUInteger)days;
- (NSInteger)daysBetweenDate:(NSDate *)toDate;

+ (NSDate *)dateFromDateInformation:(HDDateInformation)information;
+ (NSDate *)dateFromDateInformation:(HDDateInformation)information timeZone:(NSTimeZone *)timezone;
- (HDDateInformation)dateInformation;
- (HDDateInformation)dateInformationWithTimeZone:(NSTimeZone *)timeZone;


@end
