//
//  BRChainCodingDemo.m
//  BrickKit
//
//  Created by jinxiaofei on 16/8/16.
//  Copyright © 2016年 JJ.sevn. All rights reserved.
//

#import "BRChainCodingDemo.h"
#import <ReactiveCocoa/ReactiveCocoa-Bridging-Header.h>

@implementation BRChainCodingDemo

+ (int)caculate:(void (^)(CalculateMaker *))calculate
{
    CalculateMaker *maker = [[CalculateMaker alloc] init];
    calculate(maker);
    return maker.reult;
}
@end


@implementation CalculateMaker

- (CalculateMaker *(^)(int))add
{
    return ^CalculateMaker *(int value) {
        self.reult += value;
        return self;
    };
}

- (CalculateMaker *(^)(int))minus
{
    return ^CalculateMaker *(int value) {
        self.reult -= value;
        return self;
    };
}

- (CalculateMaker *(^)(int))multiply
{
    return ^CalculateMaker *(int value) {
        self.reult *= value;
        return self;
    };
}

- (CalculateMaker *(^)(int))divide
{
    return ^CalculateMaker *(int value) {
        self.reult /= value;
        return self;
    };
}
@end


@implementation ChainCodingUseDemo

- (int)use
{
    int res = [BRChainCodingDemo caculate:^(CalculateMaker *maker) {
        maker.add(10).minus(3).multiply(2).divide(5);
    }];
    return res;
}

@end