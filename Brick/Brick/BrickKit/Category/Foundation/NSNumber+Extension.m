//
//  NSNumber+Extension.m
//  MyYaoChuFaApp
//
//  Created by vic on 16/1/14.
//  Copyright © 2016年 要出发. All rights reserved.
//

#import "NSNumber+Extension.h"

@implementation NSNumber (Extension)

+ (BOOL)checkIsNull:(NSNumber *)num
{
    if ([num isKindOfClass:[NSNull class]] || num == nil)
    {
        return YES;
    }
    
    return NO;
}

@end
