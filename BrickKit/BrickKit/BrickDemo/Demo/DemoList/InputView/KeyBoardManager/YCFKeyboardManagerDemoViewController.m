//
//  YCFKeyboardManagerDemoViewController.m
//  YCFComponentKit_OC
//
//  Created by jinxiaofei on 16/8/8.
//  Copyright © 2016年 yaochufa. All rights reserved.
//

#import "YCFKeyboardManagerDemoViewController.h"
#import "YCFTextView.h"

@interface YCFKeyboardManagerDemoViewController ()<YCFKeyBoardToolBarDelegate>
@end

@implementation YCFKeyboardManagerDemoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    YCFTextView *textView1 = [[YCFTextView alloc] init];
    textView1.text = @"textView1";
    textView1.frame =CGRectMake(10, 100, 150, 35);
    [self.view addSubview:textView1];
    textView1.delegate = self;
    textView1.isNeedAdjustHeight = YES;
    textView1.adjustMaxHeight = 100;
}


@end
