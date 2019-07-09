//
//  TemplateView.m
//  YXY
//
//  Created by jinxiaofei on 16/10/25.
//  Copyright © 2016年 Guangzhou TalkHunt Information Technology Co., Ltd. All rights reserved.
//

#import "TemplateView.h"

@interface TemplateView ()

@end

@implementation TemplateView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self drawViews];
        [self addActionForViews];
    }
    return self;
}

- (void)updateConstraints
{
    [self makeConstraints];
    [super updateConstraints];
}
- (void)addActionForViews
{
    
}
#pragma mark - draw views
- (void)drawViews
{
    
}

- (void)makeConstraints
{
    
}

#pragma mark - protocol

#pragma mark - public

#pragma mark - action

#pragma mark - private

#pragma mark - setter

#pragma mark - getter

@end
