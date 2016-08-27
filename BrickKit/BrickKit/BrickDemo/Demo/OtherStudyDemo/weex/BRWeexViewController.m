//
//  BRWeexViewController.m
//  BrickKit
//
//  Created by jinxiaofei on 16/8/25.
//  Copyright © 2016年 jinxiaofei. All rights reserved.
//

#import "BRWeexViewController.h"
#import <WeexSDK/WXSDKInstance.h>

@interface BRWeexViewController ()
@property(nonatomic, strong) WXSDKInstance *instance;
@property(nonatomic, strong) UIView *weexView;
@end

@implementation BRWeexViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self render];
}

- (void)dealloc
{
    [_instance destroyInstance];
}

- (void)render
{
    self.url = self.url ? : [[NSBundle mainBundle] pathForResource:@"bundlejs/index" ofType:@"js"];
    NSURL *url = [NSURL URLWithString:self.url];
    
    [self.instance destroyInstance];
    self.instance = [[WXSDKInstance alloc] init];
    self.instance.viewController = self;
    self.instance.frame = CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height - 20);
    
    __weak typeof(self) weakSelf = self;
    self.instance.onCreate = ^(UIView *view)
    {
        [weakSelf.weexView removeFromSuperview];
        weakSelf.weexView = view;
        [weakSelf.view addSubview:view];
    };
    
    [self.instance renderWithURL:url options:@{@"bundleUrl" : [url absoluteString]} data:nil];
}

@end
