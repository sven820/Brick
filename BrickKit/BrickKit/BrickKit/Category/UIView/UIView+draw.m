//
//  UIView+draw.m
//  BrickKit
//
//  Created by jinxiaofei on 16/6/28.
//  Copyright © 2016年 JJ.sevn. All rights reserved.
//

#import "UIView+draw.h"

@implementation UIView (draw)

+ (instancetype)drawLineWithWidth:(CGFloat)width
{
    return [self drawLineWithWidth:width color:nil];
}

+ (instancetype)drawLineWithWidth:(CGFloat)width color:(UIColor *)color
{
    UIView *line = [[UIView alloc] init];
    if (!width)
    {
        width = kSCREEN_WIDTH;
    }
    line.bounds = CGRectMake(0, 0, width, kOnePixel);
    if (!color)
    {
        color = [UIColor lightGrayColor];
    }
    line.backgroundColor = color;
    return line;
}

+ (instancetype)drawLineWithWidth:(CGFloat)width height:(CGFloat)height color:(UIColor *)color
{
    UIView *line = [UIView drawLineWithWidth:width color:color];

    if (height)
    {
        line.jj_height = height;
    }
    return line;
}
@end
