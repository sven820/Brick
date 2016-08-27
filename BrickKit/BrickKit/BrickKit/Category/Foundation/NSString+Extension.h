//
//  NSString+YCF.h
//  MyYaoChuFaApp
//
//  Created by Hugo Xie on 14/12/12.
//  Copyright (c) 2014年 要出发. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, YCFNameStringCheckingStyle) {
    // 姓名字符合法
    YCFNameStringCheckingLegal,
    // 空
    YCFNameStringCheckingEmptyOrNull,
    // 字符数不合法(4-20)
    YCFNameStringCheckingOverCharLimit,
    // 包含数字
    YCFNameStringCheckingContainNum,
    // 包含非中英文字符
    YCFNameStringCheckingContainSpcicalChar,
    
};

@interface NSString (Extension)
//double型转变为NSString,把double型小数点后面多余的0去掉
+(NSString *)changeDouble:(double)doubleNumber;

//把CGFloat型小数点后面多余的0去掉
+(NSString *)changeFloat:(float)floatNumber;

//检查字符串是否为空
+ (BOOL)checkIsEmptyOrNull:(NSString *) string;

// 检查是否是 http:// URL
+ (BOOL)checkIsHTTPURL:(NSString *)string;

//得到中英文混合字符串长度  !!!中英文字符串
- (NSUInteger)getMixCharacterLength;

//判断是否包含中文字符
- (BOOL)isContainChineseChar;

//校验姓名字符串, 结果为枚举
- (YCFNameStringCheckingStyle)checkForNameString;

// 计算文字的尺寸
- (CGSize)sizeOfFont:(UIFont *)font;

// 判定是否为URL
- (BOOL)isWebURL;

//xss攻击过滤script，image，SQL Injection，Eval，Simple，Exec
-(BOOL)avoidXSSAtackWithURL:(NSString*)url;

//处理手机号,身份证等中间带*
- (NSString *)showStrWithStarMiddle;

// 校验是否是手机号,只校验11位数字
- (BOOL)checkIsPhoneNumber;
// 校验是否是省份证,18为数字或'X'
- (BOOL)checkIsIdCard;
// 校验是否是10-15位注册电话,可带'-'
- (BOOL)checkIsRegisterPhoneNumber;

//生成随机字符串
+ (NSString *)createRandomString:(NSInteger)length;

#pragma mark -
- (NSString *)stringByURLEncoding;
- (NSString *)stringByURLDecoding;

#pragma mark - XSS
-(BOOL)avoidXSSAtackWithURL:(NSString*)url;
@end


