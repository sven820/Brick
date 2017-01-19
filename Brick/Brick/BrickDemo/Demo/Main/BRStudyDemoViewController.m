//
//  BRStudyDemoViewController.m
//  BrickKit
//
//  Created by jinxiaofei on 16/8/25.
//  Copyright © 2016年 jinxiaofei. All rights reserved.
//

#import "BRStudyDemoViewController.h"
#import "BRDemoModel.h"
#import "BRRACDemoViewController.h"
#import "FMDBViewDemoController.h"

@interface BRStudyDemoViewController ()<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong) UITableView * tableView;
@property(nonatomic, strong) NSMutableArray * demoModels;
@end

@implementation BRStudyDemoViewController
#pragma mark - static consts
static NSString * const kDemoCellIdentify = @"demoCellIdentify";

#pragma mark - life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self drawViews];
    
    [self makeContraints];
    
    [self loadDemoDatas];
    
}

#pragma mark - carry forward

#pragma mark - override

#pragma mark - draw views

- (void)drawViews
{
    [self.view addSubview:self.tableView];
}

- (void)makeContraints
{
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        __weak UIView *superView = self.tableView.superview;
        make.edges.equalTo(superView);
    }];
}
#pragma mark - draw subViews

#pragma mark - load data
- (void)loadDemoDatas
{
    /** Demo1*/
    BRDemoModel *demo1 = [[BRDemoModel alloc] init];
    demo1.demoName = @"rac学习";
    demo1.demoDetail = @"rac学习";
    demo1.className = NSStringFromClass([BRRACDemoViewController class]);
    [self.demoModels addObject:demo1];

    /** Demo2*/
    BRDemoModel *demo2 = [[BRDemoModel alloc] init];
    demo1.demoName = @"rac学习";
    demo2.demoDetail = @"rac学习";
    demo2.className = NSStringFromClass([FMDBViewDemoController class]);
    [self.demoModels addObject:demo2];
    
    [self.tableView reloadData];
}

#pragma mark - delegate

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.demoModels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDemoCellIdentify];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kDemoCellIdentify];
    }
    BRDemoModel *model = self.demoModels[indexPath.row];
    cell.textLabel.text = model.demoName;
    cell.detailTextLabel.text = model.demoDetail;
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BRDemoModel *model = objectAtArrayIndex(self.demoModels, indexPath.row);
    
    Class className = NSClassFromString(model.className);
    
    UIViewController *vc = [[className alloc] init];
    
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - notification

#pragma mark - action

#pragma mark - private methods

#pragma mark - public methods

#pragma mark - getter
- (UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (NSMutableArray *)demoModels
{
    if (!_demoModels)
    {
        _demoModels = [NSMutableArray array];
    }
    return _demoModels;
}
@end
