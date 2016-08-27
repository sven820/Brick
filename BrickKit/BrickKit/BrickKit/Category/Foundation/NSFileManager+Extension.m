//
//  NSFileManager+Extension.m
//  MyYaoChuFaApp
//
//  Created by liangliang on 16/1/20.
//  Copyright © 2016年 要出发. All rights reserved.
//

#import "NSFileManager+Extension.h"

@implementation NSFileManager (Extension)

/**
 *  统计某目录下文件大小
 *
 *  @param path
 *
 *  @return
 */
+ (NSInteger)calculateSizeAtPath:(NSString *)path
{
    NSInteger size = 0;
    NSDirectoryEnumerator *fileEnumerator = [[NSFileManager defaultManager] enumeratorAtPath:path];
    for (NSString *fileName in fileEnumerator)
    {
        NSString *filePath = [path stringByAppendingPathComponent:fileName];
        NSDictionary *attrs = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
        size += [attrs fileSize];
    }
    return size;
}

@end
