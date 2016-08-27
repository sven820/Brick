//
//  NSString+YCFSafe.m
//  YCFComponentKit_OC
//
//  Created by 林小程 on 16/8/9.
//  Copyright © 2016年 yaochufa. All rights reserved.
//

#import "NSString+YCFSafe.h"

@implementation NSString (YCFSafe)

+ (NSRange)safe_rangeOfString:(NSString *)searchString inSourceString:(NSString *)source
{
    if ([NSString checkIsEmptyOrNull:source] || [NSString checkIsEmptyOrNull:searchString])
    {
        return NSMakeRange(NSNotFound, 0);
    }
    else
    {
        NSRange range = [source rangeOfString:searchString];
        return range;
    }
}

+ (NSRange)safe_rangeOfCharacterFromSet:(NSCharacterSet *)searchSet inSourceString:(NSString *)source
{
    if (searchSet == nil || [NSString checkIsEmptyOrNull:source])
    {
        return NSMakeRange(NSNotFound, 0);
    }
    else
    {
        NSRange range = [source rangeOfCharacterFromSet:searchSet];
        return range;
    }
}


+ (BOOL)checkIsEmptyOrNull:(NSString *) string
{
    if (string && ![string isEqual:[NSNull null]] && ![string isEqual:@"(null)"] && ![string isEqualToString:@"<null>"] && [string length] > 0)
    {
        return NO;
    }
    return YES;
}
@end
