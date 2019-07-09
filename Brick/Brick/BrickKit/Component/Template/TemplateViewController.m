//
//  TemplateViewController.m
//  YXY
//
//  Created by jinxiaofei on 16/11/13.
//  Copyright © 2016年 Guangzhou TalkHunt Information Technology Co., Ltd. All rights reserved.
//

#import "TemplateViewController.h"

@interface TemplateViewController ()
@property (nonatomic, strong) UIView *container;
@end

@implementation TemplateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self drawViews];
    [self configActionForViews];
}
- (void)updateViewConstraints
{
    [self makeConstraints];
    [super updateViewConstraints];
}

- (void)configActionForViews
{
    
}

#pragma mark - draw views
- (void)drawViews
{
    [self.view addSubview:self.container];
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

- (UIView *)container
{
    if (!_container)
    {
        _container = [[UIView alloc]init];
    }
    return _container;
}
@end
