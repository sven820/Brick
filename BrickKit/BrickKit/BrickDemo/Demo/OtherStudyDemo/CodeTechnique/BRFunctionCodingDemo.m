//
//  BRFunctionCodingDemo.m
//  BrickKit
//
//  Created by jinxiaofei on 16/8/16.
//  Copyright © 2016年 JJ.sevn. All rights reserved.
//

#import "BRFunctionCodingDemo.h"

@implementation BRFunctionCodingDemo

- (int)use
{
    FunctionCodingCalculateMaker *maker = [[FunctionCodingCalculateMaker alloc] init];
    
    BOOL isequal = [[maker sum:^int(int result) {
        result += 2;
        result += 5;
        return result;
    }] equal:^BOOL(int result) {
        
        return result == 7;
    }].isEqual;
    
    
    return maker.reult;
}

@end



@implementation FunctionCodingCalculateMaker

- (FunctionCodingCalculateMaker *)sum:(int (^)(int value))sum
{
    self.reult = sum(self.reult);
    return self;
}

- (FunctionCodingCalculateMaker *)equal:(BOOL (^)(int))equal
{
    self.isEqual = equal(self.reult);
    return self;
}
@end