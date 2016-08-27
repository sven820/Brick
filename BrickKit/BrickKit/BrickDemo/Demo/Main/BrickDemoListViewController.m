//
//  BrickDemoViewController.m
//  BrickKit
//
//  Created by jinxiaofei on 16/6/19.
//  Copyright © 2016年 JJ.sevn. All rights reserved.
//

#import "BrickDemoListViewController.h"
#import "BRDemoModel.h"
//demo vc
#import "BRCalendarDemoViewController.h"
#import "AutoKeyBoardTestFieldDemoController.h"
#import "AutoKeyBoardTestViewDemoController.h"
#import "YCFInfiniteDemoViewController.h"
#import "YCFTabsDemoViewController.h"


@interface BrickDemoListViewController ()<UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, strong) UITableView * tableView;
@property(nonatomic, strong) NSMutableArray * demoModels;
@end

#pragma mark - static consts
static NSString * const kDemoCellIdentify = @"demoCellIdentify";

#pragma mark - life cycle

@implementation BrickDemoListViewController

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
    demo1.demoName = @"日历";
    demo1.demoDetail = @"日历";
    demo1.className = NSStringFromClass([BRCalendarDemoViewController class]);
    [self.demoModels addObject:demo1];
    /** Demo2*/
    BRDemoModel *demo2 = [[BRDemoModel alloc] init];
    demo2.demoName = @"autoKeyBoardTextField";
    demo2.demoDetail = @"autoKeyBoardTextField";
    demo2.className = NSStringFromClass([AutoKeyBoardTestFieldDemoController class]);
    [self.demoModels addObject:demo2];
    /** Demo3*/
    BRDemoModel *demo3 = [[BRDemoModel alloc] init];
    demo3.demoName = @"autoKeyBoardTextView";
    demo3.demoDetail = @"autoKeyBoardTextView";
    demo3.className = NSStringFromClass([AutoKeyBoardTestViewDemoController class]);
    [self.demoModels addObject:demo3];
    /** Demo4*/
    BRDemoModel *Demo4 = [[BRDemoModel alloc] init];
    Demo4.demoName = @"轮播器";
    Demo4.demoDetail = @"轮播器";
    Demo4.className = NSStringFromClass([YCFInfiniteDemoViewController class]);
    [self.demoModels addObject:Demo4];
    /** Demo5*/
    BRDemoModel *Demo5 = [[BRDemoModel alloc] init];
    Demo5.demoName = @"tabs";
    Demo5.demoDetail = @"tabs";
    Demo5.className = NSStringFromClass([YCFTabsDemoViewController class]);
    [self.demoModels addObject:Demo5];
    
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
