//
//  NSArray+YCFSafe.m
//  YCFComponentKit_OC
//
//  Created by JJ.sven on 16/8/9.
//  Copyright © 2016年 yaochufa. All rights reserved.
//

#import "NSArray+YXYSafe.h"

@implementation NSArray (YXYSafe)

+ (BOOL)checkIsEmptyOrNotArray:(NSArray *)array
{
    if (array && [array isKindOfClass:[NSArray class]] && array.count > 0)
    {
        return NO;
    }
    
    return YES;
}

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

+ (id)safe_objectAtIndex:(NSInteger)index array:(NSArray *)array
{
    if (!([array isKindOfClass:[NSArray class]])) {
        return nil;
    }
    if (array && array.count > index) {
        return array[index];
    } else {
        return nil;
    }
}
+ (id)safe_objectAtIndex:(NSInteger)index array:(NSArray *)array classType:(Class)classType
{
    id element = [self safe_objectAtIndex:index array:array];
    if ([element isKindOfClass:classType]) {
        return element;
    }
    return nil;
}
+ (void)safe_addObject:(id)obj array:(NSMutableArray *)array
{
    if (obj == nil ||![array isKindOfClass:[NSMutableArray class]] || [obj isEqual:[NSNull null]])
    {
        return;
    }
    [array addObject:obj];
}
+ (void)safe_insertObject:(id)obj index:(NSInteger)index array:(NSMutableArray *)array
{
    if (obj == nil ||![array isKindOfClass:[NSMutableArray class]] || [obj isEqual:[NSNull null]] || index < 0)
    {
        return;
    }
    [array insertObject:obj atIndex:index];
}
+ (void)safe_insertObjects:(NSArray *)objs indexSet:(NSIndexSet *)indexSet array:(NSMutableArray *)array
{
    if ([self checkIsEmptyOrNotArray:objs] ||![array isKindOfClass:[NSMutableArray class]])
    {
        return;
    }
    if (indexSet == nil || indexSet.count == 0 || ![indexSet isKindOfClass:[NSIndexSet class]])
    {
        return;
    }
    [array insertObjects:objs atIndexes:indexSet];
}
@end
