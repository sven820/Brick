//
//  YCFInfiniteDemoViewController.m
//  YCFComponentKit_OC
//
//  Created by jinxiaofei on 16/8/10.
//  Copyright © 2016年 yaochufa. All rights reserved.
//

#import "YCFInfiniteDemoViewController.h"
#import "YCFInfiniteView.h"

@interface YCFInfiniteDemoViewController ()<YCFInfiniteViewDelegate>
@property(nonatomic, strong) YCFInfiniteView *infiniteView;
@end

@implementation YCFInfiniteDemoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.infiniteView];
    self.infiniteView.frame = CGRectMake(0, 100, self.view.frame.size.width, 200);
    
    UIButton *button = [[UIButton alloc] init];
    [self.view addSubview:button];
    button.frame = CGRectMake(0, 70, 200, 39);
    [button setTitle:@"点击切换滚动方向" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(switchScrollDirection) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *button1 = [[UIButton alloc] init];
    [self.view addSubview:button1];
    button1.frame = CGRectMake(0, 300, 200, 39);
    [button1 setTitle:@"滚动到第3页" forState:UIControlStateNormal];
    [button1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(scrollToPage) forControlEvents:UIControlEventTouchUpInside];

}

- (void)switchScrollDirection
{
    self.infiniteView.scrollType = !self.infiniteView.scrollType;
    [self.infiniteView reloadData];
}

- (void)scrollToPage
{
    [self.infiniteView scrollToPage:3];
}

- (NSInteger)numberOfItemAtInfiniteView:(YCFInfiniteView *)infiniteView
{
    return 5;
}

- (YCFInfiniteViewItem *)infiniteView:(YCFInfiniteView *)infiniteView itemViewAtIndex:(NSInteger)index
{
    YCFInfiniteViewItem *item = [infiniteView dequeueReusableItemViewWithIdentifier:@"item"];
    UILabel *label = [[UILabel alloc] init];
    label.text = [NSString stringWithFormat:@"---%zd", index];
    [item addSubview:label];
    label.frame = CGRectMake(0, 0, 100, 30);
    return item;
}

- (YCFInfiniteView *)infiniteView
{
    if (!_infiniteView)
    {
        _infiniteView = [[YCFInfiniteView alloc] init];
        _infiniteView.delegate = self;
        _infiniteView.pageControlSize = CGSizeMake(150, 44);
        _infiniteView.infiniteTime = 1.5;
        _infiniteView.scrollType = YCFInfiniteViewScrollHorizontal;
        _infiniteView.isNeedInfinite = YES;
        _infiniteView.isNeedTimer = YES;
        [_infiniteView registerItemViewClass:[YCFInfiniteViewItem class] forItemViewReuseIdentifier:@"item"];
    }
    return _infiniteView;
}
@end
