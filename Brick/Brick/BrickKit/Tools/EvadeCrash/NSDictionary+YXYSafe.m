//
//  NSDictionary+YCFSafe.m
//  YCFComponentKit_OC
//
//  Created by JJ.sven on 16/8/22.
//  Copyright © 2016年 yaochufa. All rights reserved.
//

#import "NSDictionary+YXYSafe.h"
#import "NSObject+YXYSafe.h"
#import "NSString+YXYSafe.h"

@implementation NSDictionary (YXYSafe)
+ (BOOL)checkIsEmptyOrNotDict:(NSDictionary *)dict
{
    if (dict && [dict isKindOfClass:[NSDictionary class]] && dict.count > 0)
    {
        return NO;
    }
    
    return YES;
}

+ (id)safe_objectForKey:(id)key inDictionary:(NSDictionary *)dict
{
    if (!([dict isKindOfClass:[NSDictionary class]] || [dict isKindOfClass:[NSMutableDictionary class]])) {
        return nil;
    }
    if (!key) {
        return nil;
    }
    id object = [dict objectForKey:key];
    return [object isEqual:[NSNull null]] ? nil : object;
}
+ (id)safe_objectForKey:(id)key dict:(NSDictionary *)dict classType:(Class)classType
{
    id element = [self safe_objectForKey:key dict:dict];
    if ([element isKindOfClass:classType])
    {
        return element;
    }
    return nil;
}
+ (void)safe_setObject:(id)value forKey:(id)key inDictionary:(NSMutableDictionary *)dict
{
    if (dict == nil || ![dict isKindOfClass:[NSMutableDictionary class]])
    {
        return;
    }
    if ([NSObject isEmpty:key] || ([key isKindOfClass:[NSString class]] && [NSString checkIsEmptyOrNull:key]) || ![key conformsToProtocol:@protocol(NSCopying)])
    {
        return;
    }
    if ([NSObject isEmpty:value] || ([value isKindOfClass:[NSString class]] && [NSString checkIsEmptyOrNull:value]))
    {
        return;
    }
    [dict setObject:value forKey:key];
}

@end
