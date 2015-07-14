//
//  NSDate+HDKit.m
//  HDKitDemo
//
//  Created by harvey.ding on 5/21/15.
//  Copyright (c) 2015 harvey. All rights reserved.
//

#import "NSDate+HDKit.h"

@implementation NSDate (HDKit)

- (BOOL)isSameDay:(NSDate *)date {
    HDDateInformation info = [self dateInformation];
    HDDateInformation info1 = [date dateInformation];
    return (info.year == info1.year && info.month == info1.month && info.day == info1.day);
}

- (BOOL)isToday {
    return [self isSameDay:[NSDate date]];
}

- (NSDate *)dateByAddDays:(NSUInteger)days {
    NSDateComponents *comp = [[NSDateComponents alloc] init];
    comp.day = days;
    return [[NSCalendar currentCalendar] dateByAddingComponents:comp toDate:self options:0];
}

- (NSInteger)daysBetweenDate:(NSDate *)toDate {
    NSDate *fromDate;
    NSDate *toDate;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar rang]
}

+ (NSDate *)dateFromDateInformation:(HDDateInformation)information timeZone:(NSTimeZone *)timezone {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    if (timezone) {
        [calendar setTimeZone:timezone];
    }
    NSDateComponents *comp = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth fromDate:[NSDate date]];
    comp.year = information.year;
    comp.month = information.month;
    comp.day = information.day;
    comp.hour = information.hour;
    comp.minute = information.minute;
    comp.second = information.second;
    
    return [calendar dateFromComponents:comp];
}

+ (NSDate *)dateFromDateInformation:(HDDateInformation)information {
    
    return [self dateFromDateInformation:information timeZone:nil];
}

- (HDDateInformation)dateInformation {
    return [self dateInformationWithTimeZone:nil];
}

- (HDDateInformation)dateInformationWithTimeZone:(NSTimeZone *)timeZone {
    HDDateInformation info;
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    if (timeZone) {
        [calendar setTimeZone:timeZone];
    }
    
    NSDateComponents *comps = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:self];
    info.year = [comps year];
    info.month = [comps month];
    info.day = [comps day];
    info.weekday = [comps weekday];
    info.hour = [comps hour];
    info.minute = [comps minute];
    info.second = [comps second];
    return info;
}

@end
