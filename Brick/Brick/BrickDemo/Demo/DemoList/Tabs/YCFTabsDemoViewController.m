//
//  YCFTabsDemoViewController.m
//  YCFComponentKit_OC
//
//  Created by jinxiaofei on 16/8/15.
//  Copyright © 2016年 yaochufa. All rights reserved.
//

#import "YCFTabsDemoViewController.h"
#import "YCFTabsView.h"

@interface YCFTabsDemoViewController ()
@property(nonatomic, strong) YCFTabsView *tabView;
@end

@implementation YCFTabsDemoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    
    YCFTabsView *tabView = [YCFTabsView quickCreateTabsViewWithTitles:@[@"标题1",@"标题2",@"标题3",@"标题4",@"标题5",]isNeedEqualWidth:YES];
    [self.view addSubview:tabView];
    tabView.frame = CGRectMake(0, 80 , self.view.frame.size.width, 39);
    tabView.tabsStyle = YCFTabsStyleLine;
    tabView.selectedIndex = 3;
    tabView.backgroundColor = [UIColor greenColor];
    self.tabView = tabView;
    
    YCFTabsView *tabView1 = [YCFTabsView quickCreateTabsViewWithIcons:@[@"Icon",@"Icon",@"Icon",@"Icon",@"Icon",@"Icon",@"Icon",@"Icon",@"Icon",@"Icon",@"Icon",@"Icon",@"Icon",@"Icon",@"Icon",]isNeedEqualWidth:NO];
    [self.view addSubview:tabView1];
    tabView1.frame = CGRectMake(0, 140 , self.view.frame.size.width, 39);
    tabView1.backgroundColor = [UIColor greenColor];
    [tabView1 configTabItemBtn:0 contentInsets:UIEdgeInsetsZero titleInsets:UIEdgeInsetsZero iconInsets:UIEdgeInsetsZero isSetIconRound:YES];
    
    YCFTabsView *tabView2 = [YCFTabsView quickCreateTabsViewWithTitles:@[@"标题1",@"标题23332",@"标题333",@"标题4",@"标xx题5",@"标噢噢噢噢题1",@"标题1",@"题1",]isNeedEqualWidth:NO];
    tabView2.columnMargin = 15;
    [self.view addSubview:tabView2];
    tabView2.frame = CGRectMake(0, 200, self.view.frame.size.width, 39);
    tabView2.tabsStyle = YCFTabsStyleLine;
    tabView2.backgroundColor = [UIColor greenColor];
    tabView2.borderPadding = UIEdgeInsetsMake(0, 10, 0, 10);
    tabView2.isShowSplitLine = NO;
    
    NSMutableArray *arr = [NSMutableArray array];
    for (int i = 0; i < 10; i ++)
    {
        UIButton *btn = [[UIButton alloc] init];
        [btn setTitle:@"测试标题" forState:UIControlStateNormal];
        btn.userInteractionEnabled = NO;
        [arr addObject:btn];
        [btn sizeToFit];
    }
    YCFTabsView *tabView3 = [YCFTabsView layoutForCustomTabs:arr isNeedEqualWidth:NO];
    tabView3.columnMargin = 15;
    [self.view addSubview:tabView3];
    tabView3.frame = CGRectMake(0, 300, self.view.frame.size.width, 39);
    tabView3.tabsStyle = YCFTabsStyleLine;
    tabView3.backgroundColor = [UIColor greenColor];
    
    YCFTabsView *tabView4 = [YCFTabsView quickCreateTabsViewWithTitles:@[@"标题1",@"标题2",@"标题3"]isNeedEqualWidth:YES];
    [self.view addSubview:tabView4];
    tabView4.frame = CGRectMake(0, 365, 65, 200);
    tabView4.layoutType = YCFTabsLayoutTypeVertical;
    tabView4.tabsStyle = YCFTabsStyleLine;
    tabView4.backgroundColor = [UIColor greenColor];
    
    YCFTabsView *tabView5 = [YCFTabsView quickCreateTabsViewWithTitles:@[@"Icon", @"ceshi"] iconImage:@[@"Icon", @"", @"Icon"] iconImageH:nil iconImageS:nil isNeedEqualWidth:NO];
    [self.view addSubview:tabView5];
    tabView5.frame = CGRectMake(100, 365, 250, 30);
    tabView5.columnMargin = 5;
    tabView5.backgroundColor = [UIColor greenColor];
    
    YCFTabsView *tabView6 = [YCFTabsView quickCreateTabsViewWithTitles:@[@"Icon", @"ceshi"] iconImage:@[@"Icon", @"", @"Icon"] iconImageH:nil iconImageS:nil isNeedEqualWidth:NO];
    [self.view addSubview:tabView6];
    tabView6.columnMargin = 5;
    tabView6.frame = CGRectMake(100, 420, 250, 60);
    tabView6.backgroundColor = [UIColor greenColor];
    
    YCFTabsView *tabView7 = [YCFTabsView quickCreateTabsViewWithTitles:@[@"Icon", @"ceshi"] iconImage:@[@"Icon", @"", @"Icon"] iconImageH:nil iconImageS:nil isNeedEqualWidth:NO];
    [self.view addSubview:tabView7];
    tabView7.frame = CGRectMake(100, 420, 250, 60);
    tabView7.columnMargin = 5;
    tabView7.backgroundColor = [UIColor greenColor];
    [tabView7 configTabItemBtn:EasyBtnTypeBtnTypeVerticalTitleIcon contentInsets:UIEdgeInsetsZero titleInsets:UIEdgeInsetsZero iconInsets:UIEdgeInsetsMake(10, 0, 0, 0) isSetIconRound:NO];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.tabView selectedTabItemAtIndex:2];
}
@end
