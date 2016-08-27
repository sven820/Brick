//
//  BRCalendarModel.m
//  BrickKit
//
//  Created by jinxiaofei on 16/6/29.
//  Copyright © 2016年 JJ.sevn. All rights reserved.
//

#import "BRCalendarModel.h"

@implementation BRCalendarModel

- (void)setDate:(NSDate *)date
{
    _date = date;
    
    NSString *dateStr = [NSDate stringFromDate:date];
    if (dateStr.length >= 10)
    {
        self.dateStr = [[NSDate stringFromDate:date] substringToIndex:10];
    }
    else
    {
        self.dateStr = @"";
    }
    
    self.isWeekDay = [date isWeekends];
    
    if(([[date getFormatYearMonthDay] doubleValue] == [[[NSDate date] getFormatYearMonthDay] doubleValue]))
    {
        self.isToday = YES;
    }
    
    if (([[date getFormatYearMonthDay] doubleValue] < [[[NSDate date] getFormatYearMonthDay] doubleValue]))
    {
        self.isDayBeforToday = YES;
    }
}


@end
