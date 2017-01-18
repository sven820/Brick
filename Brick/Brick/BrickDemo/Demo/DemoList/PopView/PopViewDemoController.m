//
//  PopViewDemoController.m
//  Brick
//
//  Created by jinxiaofei on 16/10/1.
//  Copyright © 2016年 jinxiaofei. All rights reserved.
//

#import "PopViewDemoController.h"
#import "YXYPopView.h"
#import "YXYNavBar.h"

@interface PopViewDemoController ()
@property (nonatomic, strong) YXYPopView *popView;
@property (nonatomic, strong) YXYNavBar *bar;
@end

@implementation PopViewDemoController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    YXYPopView *popView = [[YXYPopView alloc]init];
    popView.backgroundColor = [UIColor lightGrayColor];
        popView.title = @"title";
    popView.subImage = [UIImage imageNamed:@"Icon"];
    popView.subTitle = @"detail";
    popView.count = 10;
    
    self.popView = popView;

    YXYNavBar *bar = [[YXYNavBar alloc]init];
    [self.view addSubview:bar];
    
    bar.leftView = popView;
    bar.title = @"biaoti";
    bar.right = @"right";
    
    [bar mas_makeConstraints:^(MASConstraintMaker *make) {
        __weak UIView *superView = bar.superview;
        make.top.equalTo(superView).offset(200);
        make.left.equalTo(superView);
        make.width.mas_equalTo([UIScreen mainScreen].bounds.size.width);
        make.height.mas_equalTo(44);
    }];
    
    self.bar = bar;
    
    
    UIButton *btn = [[UIButton alloc]init];
    [self.view addSubview:btn];
    [btn setTitle:@"btn" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.frame = CGRectMake(0, 300, 100, 30);
    [btn addTarget:self action:@selector(hideTip) forControlEvents:UIControlEventTouchUpInside];
}

- (void)hideTip
{
    [self.bar hideTip];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.bar.tip = @"tip";
    [self.bar showTip];
    [self.bar mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(64);
    }];
}
@end
