//
//  UIScrollView+JJExtension.m
//  TableViewInfinite
//
//  Created by jxf on 16/3/27.
//  Copyright © 2016年 JJ.sevn. All rights reserved.
//

#import "UIScrollView+JJExtension.h"

@implementation UIScrollView (JJExtension)
- (void)setJj_insetT:(CGFloat)jj_insetT
{
    UIEdgeInsets inset = self.contentInset;
    inset.top = jj_insetT;
    self.contentInset = inset;
}

- (CGFloat)jj_insetT
{
    return self.contentInset.top;
}

- (void)setJj_insetB:(CGFloat)jj_insetB
{
    UIEdgeInsets inset = self.contentInset;
    inset.bottom = jj_insetB;
    self.contentInset = inset;
}

- (CGFloat)jj_insetB
{
    return self.contentInset.bottom;
}

- (void)setJj_insetL:(CGFloat)jj_insetL
{
    UIEdgeInsets inset = self.contentInset;
    inset.left = jj_insetL;
    self.contentInset = inset;
}

- (CGFloat)jj_insetL
{
    return self.contentInset.left;
}

- (void)setJj_insetR:(CGFloat)jj_insetR
{
    UIEdgeInsets inset = self.contentInset;
    inset.right = jj_insetR;
    self.contentInset = inset;
}

- (CGFloat)jj_insetR
{
    return self.contentInset.right;
}

- (void)setJj_offsetX:(CGFloat)jj_offsetX
{
    CGPoint offset = self.contentOffset;
    offset.x = jj_offsetX;
    self.contentOffset = offset;
}

- (CGFloat)jj_offsetX
{
    return self.contentOffset.x;
}

- (void)setJj_offsetY:(CGFloat)jj_offsetY
{
    CGPoint offset = self.contentOffset;
    offset.y = jj_offsetY;
    self.contentOffset = offset;
}

- (CGFloat)jj_offsetY
{
    return self.contentOffset.y;
}

- (void)setJj_contentW:(CGFloat)jj_contentW
{
    CGSize size = self.contentSize;
    size.width = jj_contentW;
    self.contentSize = size;
}

- (CGFloat)jj_contentW
{
    return self.contentSize.width;
}

- (void)setJj_contentH:(CGFloat)jj_contentH
{
    CGSize size = self.contentSize;
    size.height = jj_contentH;
    self.contentSize = size;
}

- (CGFloat)jj_contentH
{
    return self.contentSize.height;
}
@end
