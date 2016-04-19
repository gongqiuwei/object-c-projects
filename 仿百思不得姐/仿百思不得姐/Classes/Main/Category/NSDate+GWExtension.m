//
//  NSDate+GWExtension.m
//  仿百思不得姐
//
//  Created by gongqiuwei on 16/4/19.
//  Copyright © 2016年 gongqiuwei. All rights reserved.
//  

#import "NSDate+GWExtension.h"

@implementation NSDate (GWExtension)
- (NSDateComponents *)deltaFrom:(NSDate *)from
{
    // 日历
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    // 比较时间
    NSCalendarUnit unit = NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    return [calendar components:unit fromDate:from toDate:self options:0];
}

- (BOOL)isThisYear
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSInteger nowYear = [calendar component:NSCalendarUnitYear fromDate:[NSDate date]];
    NSInteger selfYear = [calendar component:NSCalendarUnitYear fromDate:self];
    
    return nowYear == selfYear;
}

//- (BOOL)isToday
//{
//    NSCalendar *calendar = [NSCalendar currentCalendar];
//    
//    NSDateComponents *nowCmps = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:[NSDate date]];
//    NSDateComponents *selfCmps = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:self];
//    
//    return (nowCmps.year == selfCmps.year) && (nowCmps.month == selfCmps.month) && (nowCmps.day == selfCmps.day);
//}

- (BOOL)isToday
{
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    
    NSString *nowStr = [fmt stringFromDate:[NSDate date]];
    NSString *selfStr = [fmt stringFromDate:self];
    
    return [nowStr isEqualToString:selfStr];
}

//- (BOOL)isYesterday
//{
//    NSDate *yedterdayDate = [NSDate dateWithTimeIntervalSinceNow:-24*60*60];
//    
//    return [yedterdayDate isToday];
//}

- (BOOL)isYesterday
{
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    
    NSDate *nowDate = [fmt dateFromString:[fmt stringFromDate:[NSDate date]]];
    NSDate *selfDate = [fmt dateFromString:[fmt stringFromDate:self]];
    
    NSDateComponents *cmps = [[NSCalendar currentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:selfDate toDate:nowDate options:0];
    
    return (cmps.year == 0) && (cmps.month == 0) && (cmps.day == 1);
}
@end
