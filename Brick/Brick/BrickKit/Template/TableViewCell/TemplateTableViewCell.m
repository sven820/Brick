//
//  TemplateTableViewCell.m
//  Brick
//
//  Created by jinxiaofei on 16/9/21.
//  Copyright © 2016年 jinxiaofei. All rights reserved.
//

#import "TemplateTableViewCell.h"

@interface TemplateTableViewCell ()

@property (nonatomic, strong) UIView *container;
@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UILabel *nickNameLabel;
@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIView *line;
@end

@implementation TemplateTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self drawViews];
        [self makeContraints];
    }
    return self;
}

+ (CGFloat)calculateCellHeightWithModel:(id)model
{
    return 44;
}
- (void)configCellWithModel:(id)model
{
    
}

#pragma mark - draw views
- (void)drawViews
{
    [self.contentView addSubview:self.container];
    
    [self.container addSubview:self.avatarImageView];
    [self.container addSubview:self.nickNameLabel];
    [self.container addSubview:self.messageLabel];
    [self.container addSubview:self.timeLabel];
    
    [self.contentView addSubview:self.line];
    
}

- (void)makeContraints
{
    [self.container mas_makeConstraints:^(MASConstraintMaker *make) {
        __weak UIView *superView = self.container.superview;
        make.left.top.right.equalTo(superView);
        make.bottom.greaterThanOrEqualTo(self.messageLabel).offset(8);
        make.bottom.greaterThanOrEqualTo(self.avatarImageView).offset(8);
    }];
    
    [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        __weak UIView *superView = self.avatarImageView.superview;
        make.left.top.equalTo(superView).offset(8);
        make.width.height.equalTo(@40);
    }];
    
    [self.nickNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        __weak UIView *superView = self.nickNameLabel.superview;
        make.top.equalTo(self.avatarImageView);
        make.left.equalTo(self.avatarImageView.mas_right).offset(4);
        make.right.lessThanOrEqualTo(superView).offset(-8);
    }];
    
    [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        __weak UIView *superView = self.messageLabel.superview;
        make.left.equalTo(self.nickNameLabel);
        make.top.equalTo(self.nickNameLabel.mas_bottom).offset(8);
        make.right.lessThanOrEqualTo(superView).offset(-8);
    }];
    
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        __weak UIView *superView = self.line.superview;
        make.left.bottom.right.equalTo(superView);
        make.height.mas_equalTo(kOnePixel);
    }];
}

#pragma mark - private

#pragma mark - getter & setter
- (UIView *)container
{
    if (!_container)
    {
        _container = [[UIView alloc]init];
    }
    return _container;
}
- (UIImageView *)avatarImageView
{
    if (!_avatarImageView) {
        _avatarImageView = [[UIImageView alloc] init];
        _avatarImageView.backgroundColor = [UIColor blueColor];
    }
    return _avatarImageView;
}

- (UILabel *)nickNameLabel {
    if (!_nickNameLabel) {
        _nickNameLabel = [[UILabel alloc] init];
    }
    return _nickNameLabel;
}

- (UILabel *)messageLabel {
    if (!_messageLabel) {
        _messageLabel = [[UILabel alloc] init];
    }
    return _messageLabel;
}

- (UILabel *)timeLabel
{
    if (!_timeLabel)
    {
        _timeLabel = [[UILabel alloc]init];
    }
    return _timeLabel;
}

- (UIView *)line
{
    if (!_line)
    {
        _line = [[UIView alloc]init];
        _line.backgroundColor = [UIColor lightGrayColor];
    }
    return _line;
}
@end
