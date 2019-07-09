//
//  TemplateScrollerController.m
//  YXY
//
//  Created by jinxiaofei on 16/11/13.
//  Copyright © 2016年 Guangzhou TalkHunt Information Technology Co., Ltd. All rights reserved.
//

#import "TemplateScrollerController.h"

@interface TemplateScrollerController ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *container;
@end

@implementation TemplateScrollerController

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
    [self.container mas_makeConstraints:^(MASConstraintMaker *make) {
        __weak UIView *superView = self.container.superview;
        make.top.equalTo(superView).offset(64);
        make.left.right.bottom.equalTo(superView);
    }];
}

#pragma mark - protocol

#pragma mark - public

#pragma mark - action
//- (void)actionForRefrsh {}
//- (void)actionForLoadMore {}

#pragma mark - private

#pragma mark - setter

#pragma mark - getter

- (UIScrollView *)container
{
    if (!_container)
    {
        _container = [[UIScrollView alloc]init];
        /*
         MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(actionForRefrsh)];
         [header setTitle:@"下拉刷新" forState:MJRefreshStateIdle];
         [header setTitle:@"松开刷新" forState:MJRefreshStatePulling];
         [header setTitle:@"嘿咻嘿咻" forState:MJRefreshStateRefreshing];
         [header setTitle:@"新增20条" forState:MJRefreshStateNoMoreData];
         _container = header;
         
         MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(actionForLoadMore)];
         [footer setTitle:@"上拉刷新更多" forState:MJRefreshStateIdle];
         [footer setTitle:@"正在加载更多" forState:MJRefreshStateRefreshing];
         [footer setTitle:@"没更多房间啦" forState:MJRefreshStateNoMoreData];
         _container = footer ;
         */
    }
    return _container;
}

@end
