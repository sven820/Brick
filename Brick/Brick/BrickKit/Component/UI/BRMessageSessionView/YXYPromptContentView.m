//
//  YXYChatPromptContentHelper.m
//  Brick
//
//  Created by jinxiaofei on 16/9/23.
//  Copyright © 2016年 jinxiaofei. All rights reserved.
//

#import "YXYPromptContentView.h"


@implementation YXYPromptContentView

@end

@implementation YXYChatPromptContentTimeView
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        UILabel *time = [[UILabel alloc]init];
        [self addSubview:time];
        [time mas_makeConstraints:^(MASConstraintMaker *make) {
            __weak UIView *superView = time.superview;
            make.center.equalTo(superView);
        }];
    }
    return self;
}

@end

@implementation YXYChatPromptContentTipsView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        UILabel *tips = [[UILabel alloc]init];
        [self addSubview:tips];
        [tips mas_makeConstraints:^(MASConstraintMaker *make) {
            __weak UIView *superView = tips.superview;
            make.center.equalTo(superView);
        }];
    }
    return self;
}
@end
