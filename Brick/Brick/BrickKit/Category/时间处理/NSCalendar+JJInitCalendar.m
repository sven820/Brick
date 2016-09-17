//
//  NSCalendar+JJInitCalendar.m
//  date
//
//  Created by jxf on 16/1/31.
//  Copyright © 2016年 JJ.sevn. All rights reserved.
//

#import "NSCalendar+JJInitCalendar.h"

@implementation NSCalendar (JJInitCalendar)

+ (instancetype)jj_calendar
{
    if ([self respondsToSelector:@selector(calendarWithIdentifier:)]) {
        return [self calendarWithIdentifier:NSCalendarIdentifierGregorian];
    }
    return [self currentCalendar];
}
@end
