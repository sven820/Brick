//
//  NSString+YCFSafe.h
//  YCFComponentKit_OC
//
//  Created by JJ.sven on 16/8/9.
//  Copyright © 2016年 yaochufa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (YXYSafe)


#pragma mark - 仿止crash容错API
//检查字符串是否为空
+ (BOOL)checkIsEmptyOrNull:(NSString *) string;

/**
 *  [NSString rangeOfString]的容错API，当源字符串或者要查找的字符串为空时，返回NotFound
 *
 *  @param searchString 要查找的字符串，对应[NSString rangeOfString]方法里的参数
 *  @param source       源字符串，对应[NSString rangeOfString]方法的调用方
 *
 */
+ (NSRange)safe_rangeOfString:(NSString *)searchString inSourceString:(NSString *)source;

/**
 *  [NSString rangeOfCharacterFromSet]的容错API，当源字符串为空或者searchSet为nil时，返回NotFound
 *
 *  @param searchSet 对应[NSString rangeOfCharacterFromSet]方法里的参数
 *  @param source    对应[NSString rangeOfCharacterFromSet]方法的调用方
 *
 */
+ (NSRange)safe_rangeOfCharacterFromSet:(NSCharacterSet *)searchSet inSourceString:(NSString *)source;

//返回安全的字符串，不会返回nil，至少返回空字符串，主要使用场景：使用字面量初始化字典时
+ (NSString *)safe_string:(NSString *)aString;

/**
 *  安全拼接字符串,解决使用NSString的stringByAppendingString:方法不小心传入空参数导致crash的问题
 *
 *  @param aString 要拼接到原字符串后面的字符串
 *
 *  @return 若aString为null字符串或者nil则返回self，否则返回拼接后的字符串
 */
- (NSString *)safe_stringByAppendingString:(NSString *)aString;

@end
