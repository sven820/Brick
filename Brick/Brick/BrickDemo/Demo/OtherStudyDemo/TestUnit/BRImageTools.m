//
//  BRImageTools.m
//  BrickKit
//
//  Created by jinxiaofei on 16/8/24.
//  Copyright © 2016年 JJ.sevn. All rights reserved.
//

#import "BRImageTools.h"

@implementation BRImageTools

static id tool;
static dispatch_once_t onceToken;

+ (instancetype)shareTools
{
    dispatch_once(&onceToken, ^{
        tool = [[self alloc] init];
    });
    
    return tool;
}

- (NSString *)dealImage:(NSString *)image
{
    return [NSString stringWithFormat:@"%@超人", image];
}

+ (NSString *)dealImage:(NSString *)image
{
    return [NSString stringWithFormat:@"%@超人", image];
}
@end
