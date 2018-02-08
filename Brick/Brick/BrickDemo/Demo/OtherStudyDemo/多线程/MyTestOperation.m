//
//  MyTestOperation.m
//  Brick
//
//  Created by 靳小飞 on 2018/2/8.
//  Copyright © 2018年 jinxiaofei. All rights reserved.
//

#import "MyTestOperation.h"

@implementation MyTestOperation
- (void)main
{
    for (int i = 0; i < 10; i++) {
        NSLog(@"%zd---%@", i, [NSThread currentThread]);
    }
}
@end
