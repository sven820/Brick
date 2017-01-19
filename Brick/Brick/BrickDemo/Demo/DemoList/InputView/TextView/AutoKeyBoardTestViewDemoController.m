//
//  TestViewController.m
//  test
//
//  Created by jinxiaofei on 16/5/29.
//  Copyright © 2016年 JJ.sevn. All rights reserved.
//

#import "AutoKeyBoardTestViewDemoController.h"
#import "YCFTextView.h"
#import "YCFDemoTextViewCell.h"
#import "YCFTestCellModel.h"


@interface AutoKeyBoardTestViewDemoController ()<UITableViewDataSource, UITableViewDelegate, YCFTextViewDelegate>
@property(nonatomic, strong) UITableView * tableView;
@property(nonatomic, strong) NSMutableArray *models;
@end

@implementation AutoKeyBoardTestViewDemoController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // textView at tableView
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.models = [NSMutableArray array];
    for (int i = 0; i < 30; i++)
    {
        YCFTestCellModel *model = [[YCFTestCellModel alloc] init];
        model.text = @"demo textView";
        model.height = 77;
        [self.models addObject:model];
    }
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.view addSubview:tableView];
    tableView.delegate = self;
    tableView.dataSource = self;
    
    tableView.frame = CGRectMake(0, 64, self.view.frame.size.width/2, self.view.frame.size.height - 64);
    
    self.tableView = tableView;
    
    // textView at normal view
    [self demoAtView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.models.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YCFDemoTextViewCell *cell = [YCFDemoTextViewCell demoTextViewCellWithTableView:tableView];
    YCFTestCellModel *model = self.models[indexPath.row];
    model.indexPath = indexPath;
    [cell configWithModel:model];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YCFTestCellModel *model = self.models[indexPath.row];
    return model.height;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.tableView reloadData];
}

- (void)demoAtView
{
    UILabel *label = [UILabel new];
    label.text = @"我是参照";
    label.textColor = [UIColor whiteColor];
    label.frame = CGRectMake(0, 50, 100, 35);
    [label sizeToFit];
    
    UIView *view = [[UIView alloc] init];
    [view addSubview:label];
    
    view.frame = CGRectMake(self.view.frame.size.width/2, 64, self.view.frame.size.width/2, self.view.frame.size.height - 64);

    YCFTextView *toolBarEdit = [[YCFTextView alloc]init];
    toolBarEdit.delegate = self;
    YCFTextView *toolBarEdit1 = [[YCFTextView alloc]init];
    toolBarEdit1.delegate = self;
    YCFTextView *toolBarEdit2 = [[YCFTextView alloc]init];
    toolBarEdit2.delegate = self;
    
    [self.view addSubview:view];
    [view addSubview:toolBarEdit];
    [view addSubview:toolBarEdit1];
    [view addSubview:toolBarEdit2];
    
    
    toolBarEdit.backgroundColor = [UIColor redColor];
    toolBarEdit.containerView = view;
    toolBarEdit.isNeedAdjustHeight = YES;
    toolBarEdit.adjustMaxHeight = 100;
    YCFInputAttribute *attr = [[YCFInputAttribute alloc] init];
    attr.placeHolder = @"placeHolder";
    toolBarEdit.inputAttribute = attr;
    
    toolBarEdit1.backgroundColor = [UIColor yellowColor];
    toolBarEdit1.containerView = view;
    toolBarEdit1.isNeedAdjustHeight = YES;
    toolBarEdit1.adjustMaxHeight = 200;
    YCFInputAttribute *attr1 = [[YCFInputAttribute alloc] init];
    attr1.text = @"texttexttexttexttexttexttexttextte";
    attr1.placeHolder = @"placeHolder1";
    toolBarEdit1.inputAttribute = attr1;
    //适配内容大小
    [toolBarEdit1 fitSizeWithMaxSize:100];
    
    toolBarEdit2.backgroundColor = [UIColor yellowColor];
    toolBarEdit2.containerView = view;
    toolBarEdit2.isNeedAdjustHeight = YES;
    toolBarEdit2.adjustMaxHeight = 150;
    toolBarEdit2.adjustMinHeight = 50;
    YCFInputAttribute *attr2 = [[YCFInputAttribute alloc] init];
    attr2.text = @"text2";
    attr2.placeHolder = @"placeHolder2";
    toolBarEdit2.inputAttribute = attr2;
    toolBarEdit2.isShowTextLengthLabel = YES;
    [toolBarEdit2 fitSizeWithMaxSize:100];
    
    [toolBarEdit mas_makeConstraints:^(MASConstraintMaker *make) {
        __weak UIView *superView = toolBarEdit.superview;
        make.left.equalTo(superView);
        make.top.equalTo(superView).offset(100);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(30);
    }];
    [toolBarEdit1 mas_makeConstraints:^(MASConstraintMaker *make) {
        __weak UIView *superView = toolBarEdit1.superview;
        make.left.equalTo(superView);
        make.top.equalTo(superView).offset(230);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(150);
    }];
    
    [toolBarEdit2 mas_makeConstraints:^(MASConstraintMaker *make) {
        __weak UIView *superView = toolBarEdit2.superview;
        make.left.equalTo(superView);
        make.top.equalTo(superView).offset(450);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(toolBarEdit2.bounds.size.height);
    }];
}

#pragma mark - textView 大小改变后再代理中更新约束或frame
- (void)textView:(YCFTextView *)textView didChangeToHeight:(CGFloat)height oriHeight:(CGFloat)oriHeight keyBoardIsResign:(BOOL)isResign
{
    [textView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(height);
    }];
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    return YES;
}
@end
