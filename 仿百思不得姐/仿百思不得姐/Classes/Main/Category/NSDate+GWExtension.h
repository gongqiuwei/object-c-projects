//
//  NSDate+GWExtension.h
//  仿百思不得姐
//
//  Created by gongqiuwei on 16/4/19.
//  Copyright © 2016年 gongqiuwei. All rights reserved.
//  日期工具

#import <Foundation/Foundation.h>

@interface NSDate (GWExtension)
/**
 * 比较from和self的时间差值
 */
- (NSDateComponents *)deltaFrom:(NSDate *)from;

/**
 *  是否为今年
 */
- (BOOL)isThisYear;
/**
 *  是否为今天
 */
- (BOOL)isToday;

/**
 *  是否为昨天
 */
- (BOOL)isYesterday;
@end
