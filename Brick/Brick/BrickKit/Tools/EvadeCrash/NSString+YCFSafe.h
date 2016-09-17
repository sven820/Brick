//
//  NSString+YCFSafe.h
//  YCFComponentKit_OC
//
//  Created by 林小程 on 16/8/9.
//  Copyright © 2016年 yaochufa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (YCFSafe)

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


//检查字符串是否为空
+ (BOOL)checkIsEmptyOrNull:(NSString *) string;

@end
