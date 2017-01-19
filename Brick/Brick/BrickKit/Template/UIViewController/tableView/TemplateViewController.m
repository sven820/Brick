//
//  TemplateViewController.m
//  Brick
//
//  Created by jinxiaofei on 16/9/21.
//  Copyright © 2016年 jinxiaofei. All rights reserved.
//

#import "TemplateViewController.h"

@interface TemplateViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSArray<NSArray*> *dataSource;
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation TemplateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = @"yourTitle";
    
    [self drawViews];
    [self makeConstraints];
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
        make.left.right.bottom.equalTo(superView);
    }];
}

#pragma mark - request

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - action

#pragma mark - private

#pragma mark - getter & setter

- (NSArray *)dataSource
{
    if (!_dataSource)
    {
        _dataSource = [NSArray array];
    }
    return _dataSource;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        //        [_tableView registerClass:[YXYContactGroupCell class] forCellReuseIdentifier:NSStringFromClass([YXYContactGroupCell class])];
    }
    return _tableView;
}
@end
