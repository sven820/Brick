//
//  TouchChainView.m
//  Brick
//
//  Created by 靳小飞 on 2018/3/1.
//  Copyright © 2018年 jinxiaofei. All rights reserved.
//

#import "TouchChainView.h"

@implementation TouchChainView

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touch begin tag:%zd", self.tag);
}
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
//    NSLog(@"hitTest tag:%zd", self.tag);
//    return nil;
    return [super hitTest:point withEvent:event];
}
@end
