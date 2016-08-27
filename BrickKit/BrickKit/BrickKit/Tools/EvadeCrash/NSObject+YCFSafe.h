//
//  NSObject+YCFSafe.h
//  YCFComponentKit_OC
//
//  Created by 林小程 on 16/8/9.
//  Copyright © 2016年 yaochufa. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, YCFSafeCompareOption) {
    YCFSafeCompareOptionNilIsSmaller, //为nil的一方更小
    YCFSafeCompareOptionNilIsGreater  //为nil的一方更大
};

@interface NSObject (YCFSafe)

/**
 *  直接调用 safe_compare:withAnother:option，option传入YCFSafeCompareOptionNilIsSmaller
 */
+ (NSComparisonResult)safe_compare:(id)obj withAnother:(id)anotherObj;

/**
 *  compare:方法的容错API，NSString,NSDate,NSNumber,NSDecimalNumber,NSIndexPaths这几个类调用compare方法要使用本容错API。确保不传入空的参数。具体逻辑如下：
 *          1.双方都为nil，返回NSOrderedSame
 *          2.一方为nil，另一方非nil，根据option，配置了YCFSafeCompareOptionNilIsSmaller把nil值看作更小，配置了YCFSafeCompareOptionNilIsGreater把nil看作更大
 *          3.双方都不为nil，先做类型检查，双方需要是同一种类型，并且都能响应compare:消息，检查通过则返回[obj compare:anotherObj]的结果，类型错误返回NSOrderedSame
 *
 *  @param obj        相当于compare:方法的调用方
 *  @param anotherObj 相当于compare:方法的参数
 *  @param option     指定当有一方为nil时，比较结果是nil更大还是nil更小
 *
 *  @return 与[obj compare:anotherObj]的逻辑一致，NSOrderedAscending：obj更小，NSOrderedDescending：obj更大，NSOrderedSame：两者相等
 */
+ (NSComparisonResult)safe_compare:(id)obj withAnother:(id)anotherObj option:(YCFSafeCompareOption)option;

@end
