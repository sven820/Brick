//
//  TemplateTableController.m
//  YXY
//
//  Created by jinxiaofei on 16/11/13.
//  Copyright © 2016年 Guangzhou TalkHunt Information Technology Co., Ltd. All rights reserved.
//

#import "TemplateTableController.h"

@interface TemplateTableController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, strong) UIView *headerView;
@end

@implementation TemplateTableController

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
    [self.view addSubview:self.tableView];
}

- (void)makeConstraints
{
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        __weak UIView *superView = self.tableView.superview;
        make.top.equalTo(superView).offset(64);
        make.left.bottom.right.equalTo(superView);
    }];
}

#pragma mark - protocol

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    YXYTableItemCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([YXYTableItemCell class])];
    
    return nil;
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}


//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section

#pragma mark - public

#pragma mark - action
//- (void)actionForRefrsh {}
//- (void)actionForLoadMore {}

#pragma mark - private

#pragma mark - setter

#pragma mark - getter

- (UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc]init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
//        [_tableView registerClass:[YXYTableItemCell class] forCellReuseIdentifier:NSStringFromClass([YXYTableItemCell class])];
        
//        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        _tableView.tableHeaderView = self.headerView;
        
        //refresh
//        [_tableView addTargetForRefresh:self sel:@selector(actionForRefresh)];
//        [_tableView addTargetForLoadMore:self sel:@selector(actionForLoadMore)];
        

    }
    return _tableView;
}

- (NSMutableArray *)dataSource
{
    if (!_dataSource)
    {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (UIView *)headerView
{
    if (!_headerView)
    {
        _headerView = [[UIView alloc]init];
//        _headerView.bounds = CGRectMake(0, 0, kSCREEN_WIDTH, 200);
    }
    return _headerView;
}
@end
