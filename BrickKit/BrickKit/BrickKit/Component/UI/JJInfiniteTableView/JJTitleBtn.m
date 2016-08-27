//
//  JJTitleBtn.m
//  网易新闻框架
//
//  Created by jxf on 16/1/15.
//  Copyright © 2016年 JJ.sevn. All rights reserved.
//

#import "JJTitleBtn.h"

@implementation JJTitleBtn

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.textAlignment = NSTextAlignmentCenter;
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    [self.fillColor set];
    rect.size.width = self.frame.size.width * self.progress;
    UIRectFillUsingBlendMode(rect, kCGBlendModeSourceIn);
}

- (void)setProgress:(CGFloat)progress
{
    _progress = progress;
    [self setNeedsDisplay];
}
@end
