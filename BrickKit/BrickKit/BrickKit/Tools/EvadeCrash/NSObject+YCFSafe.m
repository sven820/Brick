//
//  NSObject+YCFSafe.m
//  YCFComponentKit_OC
//
//  Created by 林小程 on 16/8/9.
//  Copyright © 2016年 yaochufa. All rights reserved.
//

#import "NSObject+YCFSafe.h"

@implementation NSObject (YCFSafe)

+ (NSComparisonResult)safe_compare:(id)obj withAnother:(id)anotherObj
{
    NSComparisonResult result = [self safe_compare:obj withAnother:anotherObj option:YCFSafeCompareOptionNilIsSmaller];
    return result;
}

+ (NSComparisonResult)safe_compare:(id)obj withAnother:(id)anotherObj option:(YCFSafeCompareOption)option
{
    if (obj == nil && anotherObj == nil) //两者都为nil，则返回相等
    {
        return NSOrderedSame;
    }
    else if (obj && anotherObj) //两者都不为nil
    {
        Class classOfObj = [obj class];
        Class classOfAnother = [anotherObj class];

        //双方是否是同一类型，双方类型相同或者一方是另一方的子类，则为YES
        BOOL isSameKindClass = [classOfObj isSubclassOfClass:classOfAnother] || [classOfAnother isSubclassOfClass:classOfObj];
        //双方是否都能响应compare:消息
        BOOL bothCanCompare = [obj isKindOfClass:[anotherObj class]] && [obj respondsToSelector:@selector(compare:)] && [anotherObj respondsToSelector:@selector(compare:)];

        if (bothCanCompare && isSameKindClass)
        {
            NSComparisonResult result = [obj compare:anotherObj];
            return result;
        }
        else
        {
            return NSOrderedSame;
        }
    }
    else //一方为nil，另一方非nil
    {
        NSComparisonResult result;
        switch (option)
        {
        case YCFSafeCompareOptionNilIsSmaller:
        {
            result = obj == nil ? NSOrderedAscending : NSOrderedDescending;
            break;
        }
        case YCFSafeCompareOptionNilIsGreater:
        {
            result = obj == nil ? NSOrderedDescending : NSOrderedAscending;
            break;
        }
        }

        return result;
    }
}

@end
