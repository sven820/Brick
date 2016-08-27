//
//  NSString+JJKIt.m
//  JJKit
//
//  Created by jinxiaofei on 16/5/2.
//  Copyright © 2016年 JJ.sevn. All rights reserved.
//

#import "NSString+JJKIt.h"

@implementation NSString (JJKIt)

//获取中英文字符串的字符数
- (NSUInteger)getMixCharacterLength
{
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSData* da = [self dataUsingEncoding:enc];
    return [da length];
}
// 计算文字的尺寸
- (CGSize)sizeOfFont:(UIFont *)font
{
    return [self boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT)
                              options:NSStringDrawingUsesLineFragmentOrigin
                           attributes:@{NSFontAttributeName : font}
                              context:nil].size;
}
//处理手机号,身份证等中间带*
- (NSString *)showStrWithStarMiddle
{
    if (self.length <= 4) {
        return self;
    }
    NSMutableString *replaceStr = [NSMutableString string];
    for (int i = 0; i < self.length - 4; i++) {
        [replaceStr appendString:@"*"];
    }
    NSString *str = [self stringByReplacingCharactersInRange:NSMakeRange(2, self.length - 4) withString:replaceStr];
    
    return str;
}


@end
