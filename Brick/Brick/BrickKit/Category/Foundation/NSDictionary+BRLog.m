//
//  NSDictionary+BRLog.m
//  JJKit
//
//  Created by jinxiaofei on 16/6/16.
//  Copyright © 2016年 JJ.sevn. All rights reserved.
//

#import "NSDictionary+BRLog.h"

@implementation NSDictionary (BRLog)
- (NSString *)descriptionWithLocale:(id)locale
{
    NSMutableString *string = [NSMutableString string];
    [string appendString:@"{\n"];
    [self enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [string appendFormat:@"%@:", key];
        [string appendFormat:@"%@,\n", obj];
    }];
    [string appendString:@"}"];
    NSRange range = [string rangeOfString:@"," options:NSBackwardsSearch];
    if (range.location != NSNotFound) {
        [string deleteCharactersInRange:range];
    }
    return string;
}

@end

@implementation NSArray (JJLog)

- (NSString *)descriptionWithLocale:(id)locale
{
    NSMutableString *string = [NSMutableString string];
    [string appendString:@"["];
    [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [string appendFormat:@"%@,", obj];
    }];
    [string appendString:@"]"];
    NSRange range = [string rangeOfString:@"," options:NSBackwardsSearch];
    if (range.location != NSNotFound) {
        [string deleteCharactersInRange:range];
    }
    return string;
}

@end
