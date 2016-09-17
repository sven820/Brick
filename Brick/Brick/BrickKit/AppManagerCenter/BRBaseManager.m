//
//  BRBaseManager.m
//  BrickKit
//
//  Created by jinxiaofei on 16/7/22.
//  Copyright © 2016年 JJ.sevn. All rights reserved.
//

#import "BRBaseManager.h"

@implementation BRBaseManager


static id manager;
static dispatch_once_t onceToken;

+ (instancetype)shareManager
{
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    
    return manager;
}

@end
