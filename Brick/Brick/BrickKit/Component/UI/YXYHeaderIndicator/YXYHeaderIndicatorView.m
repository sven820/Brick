//
//  YXYHeaderIndicatorView.m
//  Brick
//
//  Created by jinxiaofei on 16/10/2.
//  Copyright © 2016年 jinxiaofei. All rights reserved.
//

#import "YXYHeaderIndicatorView.h"

@interface YXYHeaderIndicatorView ()
@property (nonatomic, strong) UIView *leftLine;
@property (nonatomic, strong) UILabel *leftLabel;
@property (nonatomic, strong) UILabel *rightLabel;
@end

@implementation YXYHeaderIndicatorView
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self drawViews];
        [self makeConstraints];
    }
    return self;
}

- (void)addTargetForLeft:(id)target sel:(SEL)sel
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:target action:sel];
    [self.leftLabel addGestureRecognizer:tap];
}

- (void)addTargetForRight:(id)target sel:(SEL)sel
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:target action:sel];
    [self.rightLabel addGestureRecognizer:tap];
}
#pragma mark - draw views 
- (void)drawViews
{
    [self addSubview:self.leftLine];
    [self addSubview:self.leftLabel];
    [self addSubview:self.rightLabel];
}

- (void)makeConstraints
{
    [self.leftLine mas_makeConstraints:^(MASConstraintMaker *make) {
        __weak UIView *superView = self.leftLine.superview;
        make.left.equalTo(superView).offset(8);
        make.centerY.equalTo(superView);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(kOnePixel);
    }];
    
    [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        __weak UIView *superView = self.leftLabel.superview;
        make.left.equalTo(self.leftLine.mas_right);
        make.centerY.equalTo(superView);
    }];
    
    [self.rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        __weak UIView *superView = self.rightLabel.superview;
        make.right.equalTo(superView).offset(-8);
        make.centerY.equalTo(superView);
    }];
}

#pragma mark - getter
- (UIView *)leftLine
{
    if (!_leftLine)
    {
        _leftLine = [[UIView alloc]init];
        _leftLine.backgroundColor = [UIColor orangeColor];
    }
    return _leftLine;
}

- (UILabel *)leftLabel
{
    if (!_leftLabel)
    {
        _leftLabel = [[UILabel alloc]init];
        _leftLabel.text = self.left;
        
    }
    return _leftLabel;
}

- (UILabel *)rightLabel
{
    if (!_rightLabel)
    {
        _rightLabel = [[UILabel alloc]init];
        _rightLabel.text = self.right;
    }
    return _rightLabel;
}
@end
