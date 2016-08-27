//
//  UIView+AdjustFrame.m
//  QQ_Zone
//
//  Created by apple on 14-12-7.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import "UIView+AdjustFrame.h"

@implementation UIView (AdjustFrame)

- (void)setJj_x:(CGFloat)jj_x
{
    CGRect frame = self.frame;
    frame.origin.x = jj_x;
    self.frame = frame;
}

- (CGFloat)jj_x
{
    return self.frame.origin.x;
}

- (void)setJj_y:(CGFloat)jj_y
{
    CGRect frame = self.frame;
    frame.origin.y = jj_y;
    self.frame = frame;
}

- (CGFloat)jj_y
{
    return self.frame.origin.y;
}

- (void)setJj_width:(CGFloat)jj_width
{
    CGRect frame = self.frame;
    frame.size.width = jj_width;
    self.frame = frame;
}

- (CGFloat)jj_width
{
    return self.frame.size.width;
}

- (void)setJj_height:(CGFloat)jj_height
{
    CGRect frame = self.frame;
    frame.size.height = jj_height;
    self.frame = frame;
}

- (CGFloat)jj_height
{
    return self.frame.size.height;
}

- (void)setJj_size:(CGSize)jj_size
{
    CGRect frame = self.frame;
    frame.size = jj_size;
    self.frame = frame;
}

- (CGSize)jj_size
{
    return self.frame.size;
}

- (void)setJj_origin:(CGPoint)jj_origin
{
    CGRect frame = self.frame;
    frame.origin = jj_origin;
    self.frame = frame;
}

- (CGPoint)jj_origin
{
    return self.frame.origin;
}

- (void)setJj_centerX:(CGFloat)jj_centerX
{
    CGPoint center = self.center;
    center.x = jj_centerX;
    self.center = center;
}
- (CGFloat)jj_centerX
{
    return self.center.x;
}
- (void)setJj_centerY:(CGFloat)jj_centerY
{
    CGPoint center = self.center;
    center.y = jj_centerY;
    self.center = center;
}
- (CGFloat)jj_centerY
{
    return self.center.y;
}

@end
