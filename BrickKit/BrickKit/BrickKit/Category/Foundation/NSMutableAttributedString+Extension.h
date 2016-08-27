//
//  NSMutableAttributedString+Extension.h
//  MyYaoChuFaApp
//
//  Created by liangliang on 15/7/31.
//  Copyright (c) 2015年 要出发. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableAttributedString (Extension)

#if TARGET_OS_IOS
+ (instancetype)attributedString:(NSString *)text font:(NSInteger)font color:(UIColor *)color;
#endif

@end
