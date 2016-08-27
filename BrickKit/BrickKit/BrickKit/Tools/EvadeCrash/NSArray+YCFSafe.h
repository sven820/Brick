//
//  NSArray+YCFSafe.h
//  YCFComponentKit_OC
//
//  Created by 林小程 on 16/8/9.
//  Copyright © 2016年 yaochufa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (YCFSafe)

/**
 *  [NSArray indexOfObject]的容错API，当要查找的object为空，数组为空或者非数组类型时，返回NSNotFound
 *
 *  @param obj   相当于[NSArray indexOfObject]中的参数
 *  @param array 相当于[NSArray indexOfObject]的调用方
 *
 */
+ (NSUInteger)safe_indexOfObject:(id)obj inArray:(NSArray *)array;

+ (BOOL)checkIsEmptyOrNotArray:(NSArray *)array;

@end
