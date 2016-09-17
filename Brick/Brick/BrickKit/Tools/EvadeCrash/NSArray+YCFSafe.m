//
//  NSArray+YCFSafe.m
//  YCFComponentKit_OC
//
//  Created by 林小程 on 16/8/9.
//  Copyright © 2016年 yaochufa. All rights reserved.
//

#import "NSArray+YCFSafe.h"
#import "YCFUtils.h"

@implementation NSArray (YCFSafe)

+ (NSUInteger)safe_indexOfObject:(id)obj inArray:(NSArray *)array
{
    if (obj == nil || [NSArray checkIsEmptyOrNotArray:array])
    {
        return NSNotFound;
    }
    else
    {
        NSUInteger index = [array indexOfObject:obj];
        return index;
    }
}


+ (BOOL)checkIsEmptyOrNotArray:(NSArray *)array
{
    if (array && [array isKindOfClass:[NSArray class]] && array.count > 0)
    {
        return NO;
    }
    
    return YES;
}
@end
