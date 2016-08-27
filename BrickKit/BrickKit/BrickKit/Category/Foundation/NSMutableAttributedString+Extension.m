//
//  NSMutableAttributedString+Extension.m
//  MyYaoChuFaApp
//
//  Created by liangliang on 15/7/31.
//  Copyright (c) 2015年 要出发. All rights reserved.
//

#import "NSMutableAttributedString+Extension.h"

@implementation NSMutableAttributedString (Extension)

#if TARGET_OS_IOS
+ (instancetype)attributedString:(NSString *)text font:(NSInteger)font color:(NSString *)color
{
    NSMutableAttributedString *placeholderAttr = [[NSMutableAttributedString alloc] initWithString:text];
    [placeholderAttr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:font] range:NSMakeRange(0, text.length)];
    [placeholderAttr addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0, text.length)];
    return placeholderAttr;
}
#endif

@end
