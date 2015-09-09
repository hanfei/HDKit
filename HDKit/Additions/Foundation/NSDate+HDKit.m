//
//  NSDate+HDKit.m
//  HDKitDemo
//
//  Created by harvey.ding on 5/21/15.
//  Copyright (c) 2015 harvey. All rights reserved.
//

#import "NSDate+HDKit.h"

#define DATE_COMPONENTS (NSCalendarUnitYear | NSCalendarUnitQuarter | NSCalendarUnitMonth | NSCalendarUnitWeekOfYear | NSCalendarUnitWeekOfMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitEra | NSCalendarUnitWeekday | NSCalendarUnitWeekdayOrdinal | NSCalendarUnitWeekOfYear)
#define CURRENT_CALENDAR [NSCalendar currentCalendar]

@implementation NSDate (HDKit)

#pragma mark - decomposing dates

- (NSInteger)nearestHour {
    
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] + HD_MINUTE * 30;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    NSDateComponents *components = [CURRENT_CALENDAR components:NSCalendarUnitHour fromDate:newDate];
    return components.hour;
}

- (NSInteger)hour {
    NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
    return components.hour;
}

- (NSInteger)minute {
    NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
    return components.minute;
}

- (NSInteger)seconds {
    NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
    return components.second;
}

- (NSInteger)day {
    NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
    return components.day;
}

- (NSInteger)month {
    NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
    return components.month;
}

- (NSInteger)weekOfYear {
    NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
    return components.weekOfYear;
}

- (NSInteger)weekOfMonth {
    NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
    return components.weekOfMonth;
}

- (NSInteger)weekday {
    NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
    return components.weekday;
}

- (NSInteger)year {
    NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
    return components.year;
}

#pragma mark -  Relative Dates

+ (NSDate *)dateWithDaysFromNow:(NSInteger)days {
    return [[NSDate date] dateByAddingDays:days];
}

+ (NSDate *)dateWithDaysBeforeNow:(NSInteger)days {
    return [[NSDate date] dateBySubtractingDays:days];
}

+ (NSDate *)dateTomorrow {
    return [NSDate dateWithDaysFromNow:1];
}

+ (NSDate *)dateYesterday {
    return [NSDate dateWithDaysBeforeNow:1];
}

+ (NSDate *)dateWithHoursFromNow:(NSInteger)dHours {
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] + HD_HOUR * dHours;
    return [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
}

+ (NSDate *)dateWithHoursBeforeNow:(NSInteger)dHours {
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] - HD_HOUR * dHours;
    return [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
}

+ (NSDate *)dateWithMinutesFromNow:(NSInteger)dMinutes {
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] + HD_MINUTE * dMinutes;
    return [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
}

+ (NSDate *)dateWithMinutesBeforeNow:(NSInteger)dMinutes {
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] - HD_MINUTE * dMinutes;
    return [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
}

#pragma mark - comparing dates

- (BOOL)isEqualToDateIgnoringTime:(NSDate *)aDate {
    NSDateComponents *components1 = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
    NSDateComponents *components2 = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:aDate];
    return ((components1.year == components2.year) &&
            (components1.month == components2.month) &&
            (components1.day == components2.day));
}

- (BOOL)isToday {
    return [self isEqualToDateIgnoringTime:[NSDate date]];
}

- (BOOL)isTomorrow {
    return [self isEqualToDateIgnoringTime:[NSDate dateTomorrow]];
}

- (BOOL)isYesterday {
    return [self isEqualToDateIgnoringTime:[NSDate dateYesterday]];
}

- (BOOL)isSameWeekAsDate:(NSDate *)aDate {
    NSDateComponents *components1 = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
    NSDateComponents *components2 = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:aDate];
    return components1.weekOfMonth == components2.weekOfMonth;
}

- (BOOL)isThisWeek {
    return [self isSameWeekAsDate:[NSDate date]];
}

- (BOOL)isNextWeek {
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] + HD_WEEK;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return [self isSameWeekAsDate:newDate];
}

- (BOOL)isLastWeek {
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] - HD_WEEK;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return [self isSameWeekAsDate:newDate];
}

- (BOOL)isSameMonthAsDate:(NSDate *)aDate {
    NSDateComponents *components1 = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
    NSDateComponents *components2 = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:aDate];
    return ((components1.month == components2.month) && (components1.year == components2.year));
}

- (BOOL)isThisMonth {
    return [self isSameMonthAsDate:[NSDate date]];
}

- (BOOL)isSameYearAsDate:(NSDate *)aDate {
    NSDateComponents *components1 = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
    NSDateComponents *components2 = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:aDate];
    return components1.year == components2.year;
}

- (BOOL)isThisYear {
    return [self isSameYearAsDate:[NSDate date]];
}

- (BOOL)isNextYear {
    NSDateComponents *components1 = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
    NSDateComponents *components2 = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:[NSDate date]];
    return (components1.year == (components2.year + 1));
}

- (BOOL)isLastYear {
    NSDateComponents *components1 = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
    NSDateComponents *components2 = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:[NSDate date]];
    return (components1.year == (components2.year - 1));
}

- (BOOL)isLeapYear {
    NSUInteger year = self.year;
    if ((year % 400 == 0) || (year % 100 == 0) || (year % 4 == 0)) {
        return YES;
    }
    return NO;
}

- (BOOL)isEarlierThanDate:(NSDate *)aDate {
    return [self compare:aDate] == NSOrderedAscending;
}

- (BOOL)isLaterThanDate:(NSDate *)aDate {
    return [self compare:aDate] == NSOrderedDescending;
}

- (BOOL)isInFuture {
    return [self isLaterThanDate:[NSDate date]];
}

- (BOOL)isInPast {
    return [self isEarlierThanDate:[NSDate date]];
}

- (BOOL)isTypicallyWeekend {
    NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
    if (components.weekday == 1 || components.weekday == 7) {
        return YES;
    }
    return NO;
}

- (BOOL)isTypicallyWorkday {
    return ![self isTypicallyWeekend];
}

#pragma mark - Adjusting Dates

- (NSDate *)dateByAddingDays:(NSInteger)dDays {
    NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + HD_DAY * dDays;
    return [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
}

- (NSDate *)dateBySubtractingDays:(NSInteger)dDays {
    return [self dateByAddingHours:(dDays * -1)];
}

- (NSDate *)dateByAddingHours:(NSInteger)dHours {
    NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] - HD_HOUR * dHours;
    return [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
}

- (NSDate *)dateBySubtractingHours:(NSInteger)dHours {
    return [self dateByAddingHours:(dHours * -1)];
}

- (NSDate *)dateByAddingMinutes:(NSInteger)dMinutes {
    NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] - HD_MINUTE * dMinutes;
    return [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
}

- (NSDate *)dateBySubtractingMinutes:(NSInteger)dMinutes {
    return [self dateByAddingMinutes:(dMinutes * -1)];
}

- (NSDate *)dateAtStartOfDay {
    NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
    components.hour = 0;
    components.minute = 0;
    components.second = 0;
    return [CURRENT_CALENDAR dateFromComponents:components];
}

- (NSDateComponents *)componentsWithOffsetFromDate:(NSDate *)aDate {
    return [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:aDate toDate:self options:0];
}

#pragma mark -

- (NSInteger)minutesAfterDate:(NSDate *)aDate {
    NSTimeInterval ti = [self timeIntervalSinceDate:aDate];
    return (NSInteger)(ti / HD_MINUTE);
}

- (NSInteger)minutesBeforeDate:(NSDate *)aDate {
    NSTimeInterval ti = [aDate timeIntervalSinceDate:self];
    return (NSInteger)(ti / HD_MINUTE);
}

- (NSInteger)hoursAfterDate:(NSDate *)aDate {
    NSTimeInterval ti = [self timeIntervalSinceDate:aDate];
    return (NSInteger)(ti / HD_HOUR);
}

- (NSInteger)hoursBeforeDate:(NSDate *)aDate {
    NSTimeInterval ti = [aDate timeIntervalSinceDate:self];
    return (NSInteger)(ti / HD_HOUR);
}

- (NSInteger)daysAfterDate:(NSDate *)aDate {
    NSTimeInterval ti = [aDate timeIntervalSinceDate:aDate];
    return (NSInteger)(ti / HD_DAY);
}

- (NSInteger)daysBeforeDate:(NSDate *)aDate {
    NSTimeInterval ti = [aDate timeIntervalSinceDate:self];
    return (NSInteger)(ti / HD_DAY);
}

- (NSInteger)distanceInDaysToDate:(NSDate *)anotherDate {
    NSDateComponents *components = [CURRENT_CALENDAR components:NSCalendarUnitDay fromDate:self toDate:anotherDate options:0];
    return ABS(components.day);
}

#pragma mark - date format
- (NSString *)stringWithISOFormat {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.locale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
    formatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ssZ";
    return [formatter stringFromDate:self];
}

+ (NSDate *)dateWithISOFormatString:(NSString *)dateString {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.locale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
    formatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ssZ";
    return [formatter dateFromString:dateString];
}

@end
