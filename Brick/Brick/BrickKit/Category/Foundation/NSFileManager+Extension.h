//
//  NSFileManager+Extension.h
//  MyYaoChuFaApp
//
//  Created by liangliang on 16/1/20.
//  Copyright © 2016年 要出发. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSFileManager (Extension)

/**
 *  统计某目录下文件大小
 *
 *  @param path
 *
 *  @return
 */
+ (NSInteger)calculateSizeAtPath:(NSString *)path;

@end
