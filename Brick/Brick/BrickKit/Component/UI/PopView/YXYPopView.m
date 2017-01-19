//
//  YXYPopView.m
//  YXY
//
//  Created by jinxiaofei on 16/9/27.
//  Copyright © 2016年 Guangzhou TalkHunt Information Technology Co., Ltd. All rights reserved.
//

#import "YXYPopView.h"

@interface YXYPopView ()
@property (nonatomic, strong) UIButton *popBtn;
@property (nonatomic, strong) UILabel *countLabel;
@property (nonatomic, strong) UIView *subContainerView;
@property (nonatomic, strong) UIView *titleContainer;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subTitleLabel;
@property (nonatomic, strong) UIImageView *subImageView;

@property (nonatomic, strong) UIView *segmentLine;

@property (nonatomic, strong) UILabel *tipLabel;
@end

@implementation YXYPopView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self drawViews];
        [self makeContraints];
    }
    return self;
}

#pragma mark - draw view
- (void)drawViews
{
    [self addSubview:self.popBtn];
    [self addSubview:self.segmentLine];
}

- (void)makeContraints
{
    [self.popBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        __weak UIView *superView = self.popBtn.superview;
        make.left.equalTo(superView).offset(4);
        make.centerY.equalTo(superView);
    }];
    [self.segmentLine mas_makeConstraints:^(MASConstraintMaker *make) {
        __weak UIView *superView = self.segmentLine.superview;
        make.left.equalTo(self.popBtn.mas_right);
        make.centerY.equalTo(superView);
        make.width.mas_equalTo(kOnePixel);
        make.height.mas_equalTo(40);
    }];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(44);
        make.right.greaterThanOrEqualTo(self.popBtn);
    }];
}

#pragma mark - public
- (void)addTargetForPop:(id)target action:(SEL)sel controlEvents:(UIControlEvents)events
{
    [self.popBtn addTarget:target action:sel forControlEvents:events];
}

- (void)addTargetForSubAera:(id)target action:(SEL)sel controlEvents:(UIControlEvents)events
{
    if (!_subContainerView.superview)
    {
        return;
    }
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:target action:sel];
    [self.subContainerView addGestureRecognizer:tap];
}
#pragma mark - setter
- (void)setCount:(NSInteger)count
{
    _count = count;
    if (!_countLabel.superview)
    {
        [self addSubview:self.countLabel];
        [self.countLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            __weak UIView *superView = self.countLabel.superview;
            make.left.equalTo(self.popBtn.mas_right);
            make.centerY.equalTo(superView);
        }];
        if (_subContainerView.superview)
        {
            [self.subContainerView mas_remakeConstraints:^(MASConstraintMaker *make) {
                __weak UIView *superView = self.subContainerView.superview;
                make.left.equalTo(self.countLabel.mas_right).offset(1);
                make.top.right.bottom.equalTo(superView);
            }];
        }
    }
    if (!_subContainerView.superview) {
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.greaterThanOrEqualTo(self.countLabel);
        }];
    }
    [self.segmentLine mas_remakeConstraints:^(MASConstraintMaker *make) {
        __weak UIView *superView = self.segmentLine.superview;
        make.left.equalTo(self.countLabel.mas_right);
        make.centerY.equalTo(superView);
        make.width.mas_equalTo(kOnePixel);
        make.height.mas_equalTo(40);
    }];
    self.countLabel.text = [@(count) stringValue];
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    if (!_subContainerView.superview)
    {
        [self addSubview:self.subContainerView];
        [self.subContainerView mas_remakeConstraints:^(MASConstraintMaker *make) {
            __weak UIView *superView = self.subContainerView.superview;
            make.top.right.bottom.equalTo(superView);
            if (_countLabel.superview)
            {
                make.left.equalTo(self.countLabel.mas_right).offset(1);
            }else
            {
                make.left.equalTo(self.popBtn.mas_right).offset(1);
            }
        }];
    }
    if (!_titleContainer.superview) {
        [self.subContainerView addSubview:self.titleContainer];
    }
    
    if (!_titleLabel.superview)
    {
        [self.titleContainer addSubview:self.titleLabel];
        [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            __weak UIView *superView = self.titleLabel.superview;
            make.left.equalTo(superView);
            make.top.equalTo(superView);
        }];
        if (!_subTitleLabel.superview) {
            [self.titleContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
                __weak UIView *superView = self.titleContainer.superview;
                make.top.bottom.equalTo(self.titleLabel);
                make.right.greaterThanOrEqualTo(self.titleLabel);
                make.left.equalTo(superView);
                make.centerY.equalTo(superView);
            }];
        }
        else
        {
            [self.subTitleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.titleLabel);
                make.top.equalTo(self.titleLabel.mas_bottom);
            }];
            [self.titleContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
                __weak UIView *superView = self.titleContainer.superview;
                make.top.equalTo(self.titleLabel);
                make.right.greaterThanOrEqualTo(self.titleLabel);
                make.right.greaterThanOrEqualTo(self.subTitleLabel);
                make.bottom.equalTo(self.subTitleLabel);
                make.left.equalTo(superView);
                make.centerY.equalTo(superView);
            }];
        }
    }
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.greaterThanOrEqualTo(self.titleContainer);
    }];
    
    if (_subImageView.superview) {
        [self.subImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleContainer.mas_right);
            make.centerY.equalTo(self);
        }];
    }
    self.segmentLine.hidden = NO;
    self.titleLabel.text = title;
}

- (void)setSubTitle:(NSString *)subTitle
{
    _subTitle = subTitle;
    if (!_subContainerView.superview) {
        [self addSubview:self.subContainerView];
        [self.subContainerView mas_remakeConstraints:^(MASConstraintMaker *make) {
            __weak UIView *superView = self.subContainerView.superview;
            make.top.right.bottom.equalTo(superView);
            if (_countLabel.superview)
            {
                make.left.equalTo(self.countLabel.mas_right).offset(1);
            }else
            {
                make.left.equalTo(self.popBtn.mas_right).offset(1);
            }
        }];
    }
    if (!_titleContainer.superview) {
        [self.subContainerView addSubview:self.titleContainer];
    }
    
    if (!_subTitleLabel.superview) {
        [self.titleContainer addSubview:self.subTitleLabel];
        if (_titleLabel.superview) {
            [self.subTitleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.titleLabel);
                make.top.equalTo(self.titleLabel.mas_bottom);
            }];
            [self.titleContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
                __weak UIView *superView = self.titleContainer.superview;
                make.top.equalTo(self.titleLabel);
                make.right.greaterThanOrEqualTo(self.titleLabel);
                make.right.greaterThanOrEqualTo(self.subTitleLabel);
                make.bottom.equalTo(self.subTitleLabel);
                make.left.equalTo(superView);
                make.centerY.equalTo(superView);
            }];
        }else
        {
            [self.subTitleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                __weak UIView *superView = self.subTitleLabel.superview;
                make.left.equalTo(superView);
                make.top.equalTo(superView);
            }];
            [self.titleContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
                __weak UIView *superView = self.titleContainer.superview;
                make.top.bottom.equalTo(self.subTitleLabel);
                make.right.greaterThanOrEqualTo(self.subTitleLabel);
                make.left.equalTo(superView);
                make.centerY.equalTo(superView);
            }];
        }
    }
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.greaterThanOrEqualTo(self.titleContainer);
    }];
    
    if (_subImageView.superview) {
        [self.subImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleContainer.mas_right);
            make.centerY.equalTo(self);
        }];
    }
    self.segmentLine.hidden = NO;
    self.subTitleLabel.text = subTitle;
}

- (void)setSubImage:(UIImage *)subImage
{
    _subImage = subImage;
    if (!_subContainerView.superview) {
        [self addSubview:self.subContainerView];
        [self.subContainerView mas_remakeConstraints:^(MASConstraintMaker *make) {
            __weak UIView *superView = self.subContainerView.superview;
            make.top.right.bottom.equalTo(superView);
            if (_countLabel.superview)
            {
                make.left.equalTo(self.countLabel.mas_right).offset(1);
            }else
            {
                make.left.equalTo(self.popBtn.mas_right).offset(1);
            }
        }];
    }
    self.subImageView.image = subImage;
    if (!_subImageView.superview)
    {
        [self.subContainerView addSubview:self.subImageView];
        if (_titleContainer.superview) {
            [self.subImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                __weak UIView *superView = self.subImageView.superview;
                make.left.equalTo(self.titleContainer.mas_right);
                make.centerY.equalTo(superView);
            }];
        }
        else {
            [self.subImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                __weak UIView *superView = self.subImageView.superview;
                make.left.centerY.equalTo(superView);
            }];
        }
    }
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.greaterThanOrEqualTo(self.subImageView);
    }];
    self.segmentLine.hidden = NO;
}
#pragma mark - getter

- (UIButton *)popBtn
{
    if (!_popBtn)
    {
        _popBtn = [[UIButton alloc] init];
        [_popBtn setImage:[UIImage imageNamed:@"home_nav_bar_back_icon"] forState:UIControlStateNormal];
    }
    return _popBtn;
}

- (UILabel *)countLabel
{
    if (!_countLabel)
    {
        _countLabel = [[UILabel alloc]init];
    }
    return _countLabel;
}

- (UIView *)subContainerView
{
    if (!_subContainerView)
    {
        _subContainerView = [[UIView alloc]init];
    }
    return _subContainerView;
}


- (UILabel *)titleLabel
{
    if (!_titleLabel)
    {
        _titleLabel = [[UILabel alloc]init];
    }
    return _titleLabel;
}

- (UILabel *)subTitleLabel
{
    if (!_subTitleLabel)
    {
        _subTitleLabel = [[UILabel alloc]init];
    }
    return _subTitleLabel;
}

- (UIImageView *)subImageView
{
    if (!_subImageView)
    {
        _subImageView = [[UIImageView alloc]init];
    }
    return _subImageView;
}

- (UIView *)segmentLine
{
    if (!_segmentLine)
    {
        _segmentLine = [[UIView alloc]init];
        _segmentLine.backgroundColor = [UIColor blackColor];
        _segmentLine.hidden = YES;
    }
    return _segmentLine;
}

- (UIView *)titleContainer
{
    if (!_titleContainer)
    {
        _titleContainer = [[UIView alloc]init];
    }
    return _titleContainer;
}
@end
