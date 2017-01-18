//
//  TestViewTwo.m
//  Brick
//
//  Created by jinxiaofei on 16/11/1.
//  Copyright © 2016年 jinxiaofei. All rights reserved.
//

#import "TestViewTwo.h"

@interface TestViewTwo ()
@property (nonatomic, strong) UISwitch *s;
@end

@implementation TestViewTwo

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor blueColor];
        UISwitch *s = [[UISwitch alloc]init];
        s.on = YES;
        [self addSubview:s];
        
        self.s = s;
    }
    return self;
}

- (void)updateConstraints
{
    [self.s mas_makeConstraints:^(MASConstraintMaker *make) {
        __weak UIView *superView = self.s.superview;
        make.left.equalTo(superView).offset(20);
        make.top.equalTo(superView).offset(50);
    }];
    [super updateConstraints];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}
@end
