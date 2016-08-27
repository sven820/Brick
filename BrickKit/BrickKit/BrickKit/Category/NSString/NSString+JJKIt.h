//
//  NSString+JJKIt.h
//  JJKit
//
//  Created by jinxiaofei on 16/5/2.
//  Copyright © 2016年 JJ.sevn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (JJKIt)
// 获取字符串的字符长度
- (NSUInteger)getMixCharacterLength;

// 计算文字的尺寸
- (CGSize)sizeOfFont:(UIFont *)font;

//处理手机号,身份证等中间带*
- (NSString *)showStrWithStarMiddle;
@end
