//
//  BRChainCodingDemo.h
//  BrickKit
//
//  Created by jinxiaofei on 16/8/16.
//  Copyright © 2016年 JJ.sevn. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CalculateMaker;
//这里简单介绍链式编程的思想和简单应用, 代表有masonry

//- 链式编程的思想的特点: 方法返回的是block, 且block本必须返回本身的操作对象

@interface ChainCodingUseDemo : NSObject
- (int)use;
@end

@interface BRChainCodingDemo : NSObject

+ (int)caculate:(void (^)(CalculateMaker *maker))calculate;
@end


@interface CalculateMaker : NSObject

@property(nonatomic, assign) int reult;

- (CalculateMaker *(^)(int))add;

- (CalculateMaker *(^)(int))minus;

- (CalculateMaker *(^)(int))multiply;

- (CalculateMaker *(^)(int))divide;
@end