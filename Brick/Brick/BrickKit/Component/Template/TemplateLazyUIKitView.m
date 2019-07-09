//
//  TemplateLazyUIKitView.m
//  YXY
//
//  Created by jinxiaofei on 16/11/30.
//  Copyright © 2016年 Guangzhou TalkHunt Information Technology Co., Ltd. All rights reserved.
//

#import "TemplateLazyUIKitView.h"

@interface TemplateLazyUIKitView ()

@property (nonatomic, strong) UIView *topLine;
@property (nonatomic, strong) UIView *bottomLine;
@property (nonatomic, strong) UIButton *btn;
@end

@implementation TemplateLazyUIKitView
#pragma mark - protocol

#pragma mark - public

#pragma mark - action
- (void)actionForBtn:(UIButton *)btn
{
    
}
#pragma mark - private

#pragma mark - set & get
- (UIButton *)enterBtn
{
    if (!_btn)
    {
        _btn = [[UIButton alloc]init];
        [_btn setTitle:@"" forState:UIControlStateNormal];
        [_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _btn.backgroundColor = [UIColor blueColor];
        [_btn addTarget:self action:@selector(actionForBtn:) forControlEvents:UIControlEventTouchUpInside];

    }
    return _btn;
}

@end
