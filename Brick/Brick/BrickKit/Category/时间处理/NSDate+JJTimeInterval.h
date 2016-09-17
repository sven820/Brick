//
//  NSDate+JJTimeInterval.h
//  date
//
//  Created by jxf on 16/1/30.
//  Copyright © 2016年 JJ.sevn. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface JJTimeInterval : NSObject

/** 天 */
@property (nonatomic, assign) NSInteger day;
/** 小时 */
@property (nonatomic, assign) NSInteger hour;
/** 分钟 */
@property (nonatomic, assign) NSInteger minute;
/** 秒 */
@property (nonatomic, assign) NSInteger second;

@end


@interface NSDate (JJTimeInterval)

- (JJTimeInterval *)jj_timeIntervalSince;

/**
 * 是否为今天
 */
- (BOOL)jj_isInToday;

/**
 * 是否为昨天
 */
- (BOOL)jj_isInYesterday;

/**
 * 是否为明天
 */
- (BOOL)jj_isInTomorrow;

/**
 * 是否为今年
 */
- (BOOL)jj_isInThisYear;
@end
