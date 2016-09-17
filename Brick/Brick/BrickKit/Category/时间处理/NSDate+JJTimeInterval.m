//
//  NSDate+JJTimeInterval.m
//  date
//
//  Created by jxf on 16/1/30.
//  Copyright © 2016年 JJ.sevn. All rights reserved.
//

#import "NSDate+JJTimeInterval.h"
#import "NSCalendar+JJInitCalendar.h"

@implementation JJTimeInterval

@end

@implementation NSDate (JJTimeInterval)

- (JJTimeInterval *)jj_timeIntervalSince
{
    JJTimeInterval *timeInterval = [[JJTimeInterval alloc] init];
    
    NSInteger interval = [self timeIntervalSinceDate:[NSDate date]];
    
    // 将时间差转化为对应的时分秒...
    // 1分钟 = 60秒
    NSInteger secondsPerMinute = 60;
    
    // 1小时 = 60 * 60秒 = 3600秒
    NSInteger secondsPerHour = 60 * secondsPerMinute;
    
    // 1天 = 24 * 60  * 60秒
    NSInteger secondsPerDay = 24 * secondsPerHour;
    
    timeInterval.day = interval / secondsPerDay;
    timeInterval.hour = (interval % secondsPerDay) / secondsPerHour;
    timeInterval.minute = ((interval % secondsPerDay) % secondsPerHour) / secondsPerMinute;
    timeInterval.second = interval % secondsPerMinute;

    return timeInterval;
}

- (BOOL)jj_isInToday
{
    // 不呢仅仅判断cmp.year == 0 && cmp.month == 0 && cmp.day == 0, 该方法会结合时分秒,如果时间差在24小时内, 就算差一天, 而我们的需求是, 只要日期day差一天就算差一天, 相同则为同一天, 所以要提出时分秒的影响
    NSCalendar *calendar = [NSCalendar jj_calendar];
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *selfCmp = [calendar components:unit fromDate:self];
    NSDateComponents *nowCmp = [calendar components:unit fromDate:[NSDate date]];
    if ([selfCmp isEqual:nowCmp]) {
        return YES;
    }
    return NO;
}

- (BOOL)jj_isInTomorrow
{
    NSCalendar *calendar = [NSCalendar jj_calendar];
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyyMMdd";
    NSString *selfStr = [fmt stringFromDate:self];
    NSString *nowStr = [fmt stringFromDate:[NSDate date]];
    // 获得只有年月日的格式化date
    NSDate *selfDate = [fmt dateFromString:selfStr];
    NSDate *nowDate = [fmt dateFromString:nowStr];
    NSDateComponents *cmp = [calendar components:NSCalendarUnitDay fromDate:selfDate toDate:nowDate options:0];
    if (cmp.day == -1) {
        return YES;
    }
    return NO;
}

- (BOOL)jj_isInYesterday
{
    // 注意deltaDay == -1, deltaMonth == 0,deltaYear == 0, | 注意deltaDay == 1, deltaMonth == 0,deltaYear == 0, 并不能表示,一定是昨天或明天
    NSCalendar *calendar = [NSCalendar jj_calendar];
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyyMMdd";
    NSString *selfStr = [fmt stringFromDate:self];
    NSString *nowStr = [fmt stringFromDate:[NSDate date]];
    // 获得只有年月日的格式化date
    NSDate *selfDate = [fmt dateFromString:selfStr];
    NSDate *nowDate = [fmt dateFromString:nowStr];
    NSDateComponents *cmp = [calendar components:NSCalendarUnitDay fromDate:selfDate toDate:nowDate options:0];
    if (cmp.day == 1) {
        return YES;
    }
    return NO;
}

- (BOOL)jj_isInThisYear
{
    NSCalendar *calendar = [NSCalendar jj_calendar];
    NSCalendarUnit unit = NSCalendarUnitYear;
    NSDateComponents *selfCmp = [calendar components:unit fromDate:self];
    NSDateComponents *nowCmp = [calendar components:unit fromDate:[NSDate date]];
    if ([selfCmp isEqual:nowCmp]) {
        return YES;
    }
    return NO;
}
@end
