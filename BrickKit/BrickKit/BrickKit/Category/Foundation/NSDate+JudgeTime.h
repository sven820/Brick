//
//  NSDate+JudgeTime.h
//  MyYaoChuFaApp
//
//  Created by CLJian on 13-11-18.
//  Copyright (c) 2013年 建. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (JudgeTime)
+(NSString *)judgeTimeWithTimeString:(NSString*)tempString;

@end


/**
 *  NSDate(Helpers)
 */
@interface NSDate (Helpers)

/*
 
 * This guy can be a little unreliable and produce unexpected results,
 
 * you're better off using daysAgoAgainstMidnight
 
 */

//获取年月日如:19871127.

- (NSString *)getFormatYearMonthDay;

//返回当前月一共有几周(可能为4,5,6)

- (NSInteger)getWeekNumOfMonth;

//该日期是该年的第几周

- (NSInteger)getWeekOfYear;

// 改日是该月的第几周

- (NSInteger)getWeekOfMonth;

//返回day天后的日期(若day为负数,则为|day|天前的日期)

- (NSDate *)dateAfterDay:(NSInteger)day;

//month个月后的日期

- (NSDate *)dateAfterMonth:(NSInteger)month;

//获取日

- (NSUInteger)getDay;

//获取月

- (NSUInteger)getMonth;

//获取年

- (NSUInteger)getYear;

//获取小时

- (NSInteger)getHour ;

//获取分钟

- (NSInteger)getMinute ;

- (NSInteger)getHour:(NSDate *)date ;
- (NSInteger)getMinute:(NSDate *)date ;

//在当前日期前几天

- (NSUInteger)daysAgo ;

//午夜时间距今几天

- (NSUInteger)daysAgoAgainstMidnight ;


- (NSString *)stringDaysAgo ;


- (NSString *)stringDaysAgoAgainstMidnight:(BOOL)flag ;

// 返回一周的第几天(周末为第一天)

- (NSUInteger)weekday ;
- (BOOL)isWeekends;

//转为NSString类型的

+ (NSDate *)dateFromString:(NSString *)string ;

+ (NSDate *)dateFromDefaultFormatedString:(NSString *)string;//使用默认格式转化，转化不成功则返回nil

+ (NSDate *)dateFromString:(NSString *)string withFormat:(NSString *)format ;


+ (NSString *)stringFromDate:(NSDate *)date withFormat:(NSString *)format ;



+ (NSString *)stringFromDate:(NSDate *)date ;



+ (NSString *)stringForDisplayFromDate:(NSDate *)date prefixed:(BOOL)prefixed;



+ (NSString *)stringForDisplayFromDate:(NSDate *)date ;


- (NSString *)stringWithFormat:(NSString *)format ;



- (NSString *)string ;



- (NSString *)stringWithDateStyle:(NSDateFormatterStyle)dateStyle timeStyle:(NSDateFormatterStyle)timeStyle ;

//返回周日的的开始时间

- (NSDate *)beginningOfWeek ;

//返回当前天的年月日.

- (NSDate *)beginningOfDay ;

//返回该月的第一天

- (NSDate *)beginningOfMonth;

//该月的最后一天

- (NSDate *)endOfMonth;

//返回当前周的周末

- (NSDate *)endOfWeek ;

//返回周几
-(NSString*)whatDayIs;

+ (NSString *)dateFormatString ;



+ (NSString *)timeFormatString ;



+ (NSString *)timestampFormatString ;



// preserving for compatibility

+ (NSString *)dbFormatString ;

@end