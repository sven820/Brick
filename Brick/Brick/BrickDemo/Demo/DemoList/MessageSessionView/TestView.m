
//
//  TestView.m
//  Brick
//
//  Created by jinxiaofei on 16/11/1.
//  Copyright © 2016年 jinxiaofei. All rights reserved.
//

#import "TestView.h"
#import "TestViewTwo.h"

@interface TestView ()
@property (nonatomic, strong) TestViewTwo *v;
@end

@implementation TestView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.v = [[TestViewTwo alloc]init];
        [self addSubview:self.v];
        self.backgroundColor = [UIColor greenColor];
    }
    return self;
}

- (void)updateConstraints
{
    [self.v mas_makeConstraints:^(MASConstraintMaker *make) {
        __weak UIView *superView = self.v.superview;
        make.width.height.mas_equalTo(200);
//        make.center.equalTo(superView);
        make.left.top.equalTo(superView);
    }];
    [super updateConstraints];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}
@end
