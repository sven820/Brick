//
//  TouchChainController.m
//  Brick
//
//  Created by 靳小飞 on 2018/2/27.
//  Copyright © 2018年 jinxiaofei. All rights reserved.
//

#import "TouchChainController.h"

@interface TouchChainController ()

@end

@implementation TouchChainController

/**
 *  事件响应者链
 *
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"vc touch began");
}
@end
