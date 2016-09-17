//
//  BRFunctionCodingDemo.h
//  BrickKit
//
//  Created by jinxiaofei on 16/8/16.
//  Copyright © 2016年 JJ.sevn. All rights reserved.
//

#import <Foundation/Foundation.h>
@class FunctionCodingCalculateMaker;


@interface BRFunctionCodingDemo : NSObject
- (int)use;
@end


/*
 - 函数编程, 方法必须返回关联的操作对象
 - block或函数作为参数
 */
@interface FunctionCodingCalculateMaker : NSObject

@property(nonatomic, assign) int reult;

@property(nonatomic, assign) BOOL isEqual;

- (FunctionCodingCalculateMaker *)sum:(int (^)(int result))sum;

- (FunctionCodingCalculateMaker *)equal:(BOOL (^)(int result))equal;

@end