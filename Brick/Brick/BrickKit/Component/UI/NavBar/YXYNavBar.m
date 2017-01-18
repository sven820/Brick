//
//  YXYNavBar.m
//  Brick
//
//  Created by jinxiaofei on 16/10/2.
//  Copyright © 2016年 jinxiaofei. All rights reserved.
//

#import "YXYNavBar.h"

@interface YXYNavBar ()
@property (nonatomic, strong) UIView *container;
@property (nonatomic, strong) UILabel *tipLabel;
@end

@implementation YXYNavBar

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.container];
        [self.container mas_makeConstraints:^(MASConstraintMaker *make) {
            __weak UIView *superView = self.container.superview;
            make.edges.equalTo(superView);
        }];
    }
    return self;
}

- (void)addTargetForTipView:(id)target sel:(SEL)sel
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:target action:sel];
    [self.tipLabel addGestureRecognizer:tap];
}

#pragma mark - public
- (void)showTip
{
    if (!_tip || _tip.length <= 0 ) {
        return;
    }
    [self addSubview:self.tipLabel];
    [self.tipLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        __weak UIView *superView = self.tipLabel.superview;
        make.left.top.right.equalTo(superView);
    }];
    [self.container mas_remakeConstraints:^(MASConstraintMaker *make) {
        __weak UIView *superView = self.container.superview;
        make.top.equalTo(self.tipLabel.mas_bottom);
        make.left.bottom.right.equalTo(superView);
    }];
}

- (void)hideTip
{
    [self.tipLabel removeFromSuperview];
    [self.container mas_remakeConstraints:^(MASConstraintMaker *make) {
        __weak UIView *superView = self.container.superview;
        make.edges.equalTo(superView);
    }];
}

#pragma mark - setter
- (UIView *)container
{
    if (!_container)
    {
        _container = [[UIView alloc]init];
    }
    return _container;
}

- (void)setLeftView:(UIView *)leftView
{
    [self.leftView removeFromSuperview];
    _leftView = leftView;
    [self.container addSubview:leftView];
    [leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        __weak UIView *superView = leftView.superview;
        make.left.equalTo(superView);
        make.centerY.equalTo(superView);
    }];
}

- (void)setTitleView:(UIView *)titleView
{
    [self.titleView removeFromSuperview];
    _titleView = titleView;
    [self.container addSubview:titleView];
    [titleView mas_remakeConstraints:^(MASConstraintMaker *make) {
        __weak UIView *superView = titleView.superview;
        make.center.equalTo(superView);
    }];
}

- (void)setRightView:(UIView *)rightView
{
    [self.rightView removeFromSuperview];
    _rightView = rightView;
    [self.container addSubview:rightView];
    [rightView mas_makeConstraints:^(MASConstraintMaker *make) {
        __weak UIView *superView = rightView.superview;
        make.right.equalTo(superView);
        make.centerY.equalTo(superView);
    }];
}

- (void)setLeft:(NSString *)left
{
    _left = left;
    UILabel *label = [[UILabel alloc]init];
    label.text = left;
    self.leftView = label;
}

- (void)setLeftImage:(UIImage *)leftImage
{
    _leftImage = leftImage;
    UIImageView *imageV = [[UIImageView alloc]init];
    imageV.image = leftImage;
    self.leftView = imageV;
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    UILabel *label = [[UILabel alloc]init];
    label.text = title;
    self.titleView = label;
}

- (void)setRight:(NSString *)right
{
    _right = right;
    UILabel *label = [[UILabel alloc]init];
    label.text = right;
    self.rightView = label;
}

- (void)setRightImage:(UIImage *)rightImage
{
    _rightImage = rightImage;
    UIImageView *imageV = [[UIImageView alloc]init];
    imageV.image = rightImage;
    self.rightView = imageV;
}

- (UILabel *)tipLabel
{
    if (!_tipLabel)
    {
        _tipLabel = [[UILabel alloc]init];
        _tipLabel.text = self.tip;
        _tipLabel.backgroundColor = [UIColor redColor];
        _tipLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _tipLabel;
}
@end
