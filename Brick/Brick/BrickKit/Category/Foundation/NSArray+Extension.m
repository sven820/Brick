//
//  NSArray+YCF.m
//  MyYaoChuFaApp
//
//  Created by vic on 15/6/26.
//  Copyright (c) 2015年 要出发. All rights reserved.
//

#import "NSArray+Extension.h"

@implementation NSArray (Extension)

+ (BOOL)checkIsEmptyOrNotArray:(NSArray *)array
{
    if (array && [array isKindOfClass:[NSArray class]])
    {
        return NO;
    }
    
    return YES;
}

@end
