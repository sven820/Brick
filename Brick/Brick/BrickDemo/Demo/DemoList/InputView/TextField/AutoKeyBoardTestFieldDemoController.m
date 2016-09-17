//
//  TestViewController.m
//  test
//
//  Created by jinxiaofei on 16/5/29.
//  Copyright © 2016年 JJ.sevn. All rights reserved.
//

#import "AutoKeyBoardTestFieldDemoController.h"
#import "YCFTextField.h"
#import "YCFDemoTextFieldCell.h"


@interface AutoKeyBoardTestFieldDemoController ()<UITableViewDataSource, UITableViewDelegate>
@property(nonatomic, strong) UITableView * tableView;
@end

@implementation AutoKeyBoardTestFieldDemoController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // textField at tableView
    self.automaticallyAdjustsScrollViewInsets = NO;

    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.view addSubview:tableView];
    tableView.delegate = self;
    tableView.dataSource = self;
    
    tableView.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 150);

    self.tableView = tableView;
    
    // textField at normal view
    [self p_setupToolBarEdit];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YCFDemoTextFieldCell *cell = [YCFDemoTextFieldCell demoTextFieldCellWithTableView:tableView];
    
    return cell;
}

- (void)p_setupToolBarEdit
{
    UIView *toolBarView = [[UIView alloc] init];
    YCFTextField *toolBarEdit = [[YCFTextField alloc]init];
    [self.view addSubview:toolBarView];
    [toolBarView addSubview:toolBarEdit];
    toolBarView.frame = CGRectMake(0, self.view.frame.size.height - 35, self.view.frame.size.width, 35);
    toolBarEdit.frame = toolBarView.bounds;
    toolBarEdit.backgroundColor = [UIColor redColor];
    toolBarEdit.containerView = toolBarView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row % 2 == 0) {
        return 100;
    }
    return 50;
}

@end
