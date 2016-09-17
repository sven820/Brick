//
//  YCFCalendarCell.m
//  MyYaoChuFaApp
//
//  Created by zq chen on 3/24/15.
//  Copyright (c) 2015 要出发. All rights reserved.
//

#import "BRCalendarCell.h"

static const CGFloat kDefaultCellTitleLabelTopMargin = 14;
static const CGFloat kDefaultCellDetailLabelBottomMargin = 5;
static const CGFloat kDefaultCellMonthSectionLRMargin = 12;

@interface BRCalendarCell ()

@property(nonatomic, strong) UIView * container;
@property(nonatomic, strong) BRCalendarModel * model;
@property(nonatomic, strong) UIView * bottomLine;
@property(nonatomic, strong) UIView * rightLine;

@property(nonatomic, assign) CGFloat titleTopMargin;
@property(nonatomic, assign) CGFloat detailBottomMargin;

@property(nonatomic, weak) UIView * customView;
@end


static NSString *const kWeekendTextColor = @"ff7800";
static NSString *const kDisableTextColor = @"cccccc";
@implementation BRCalendarCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.clipsToBounds = YES;
        self.showSeparateLine = YES;
        [self drawViews];
    }
    return self;
}

#pragma mark - drawViews
- (void)drawViews
{
    [self.contentView addSubview:self.rightLine];
    [self.contentView addSubview:self.bottomLine];
    
    [self.contentView addSubview:self.container];

    [self.container insertSubview:self.bgImageView atIndex:0];
    [self.container addSubview:self.titleLabel];
    [self.container addSubview:self.detailLabel];
    [self.container addSubview:self.leftCornerImgView];
    [self.container addSubview:self.rightCornerImgView];
   
    [self makeConstraints];
}

#pragma mark - make constraints
- (void)makeConstraints
{
    [self.rightLine mas_makeConstraints:^(MASConstraintMaker *make) {
        __weak UIView *superView = self.rightLine.superview;
        make.top.right.bottom.equalTo(superView);
        make.width.mas_equalTo(kOnePixel);
    }];
    
    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        __weak UIView *superView = self.bottomLine.superview;
        make.left.bottom.right.equalTo(superView);
        make.height.mas_equalTo(kOnePixel);
    }];
    
    [self.container mas_makeConstraints:^(MASConstraintMaker *make) {
        __weak UIView *superView = self.container.superview;
        make.edges.equalTo(superView);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        __weak UIView *superView = self.titleLabel.superview;
        make.centerX.equalTo(superView);
        make.top.equalTo(superView).offset(self.titleTopMargin);
    }];
    
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        __weak UIView *superView = self.detailLabel.superview;
        make.bottom.equalTo(superView).offset(-self.detailBottomMargin);
        make.centerX.equalTo(superView);
    }];
    
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        __weak UIView *superView = self.bgImageView.superview;
        make.edges.equalTo(superView);
    }];
    
    [self.leftCornerImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        __weak UIView *superView = self.leftCornerImgView.superview;
        make.width.height.mas_equalTo(kWidthOfCornerImgView);
        make.top.left.equalTo(superView);
    }];
    
    [self.rightCornerImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        __weak UIView *superView = self.rightCornerImgView.superview;
        make.width.height.mas_equalTo(kWidthOfCornerImgView);
        make.top.right.equalTo(superView);
    }];
}

- (void)updateConstrints
{
    if (self.customView)
    {
        [self.customView removeFromSuperview];
        self.customView = nil;
    }

    if (self.model.type == BRCalendarModelTypeDate)
    {
        if (self.detailLabel.hidden == YES)
        {
            [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                __weak UIView *superView = self.titleLabel.superview;
                make.center.equalTo(superView);
            }];
        }
        else
        {
            [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                __weak UIView *superView = self.titleLabel.superview;
                make.centerX.equalTo(superView);
                make.top.equalTo(superView).offset(self.titleTopMargin);
            }];
            
            [self.detailLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                __weak UIView *superView = self.detailLabel.superview;
                make.bottom.equalTo(superView).offset(-self.detailBottomMargin);
                make.centerX.equalTo(superView);
            }];
        }
    }
    else if(self.model.type == BRCalendarModelTypeCustom || self.model.type == BRCalendarModelTypeExpand)
    {
        if (self.model.customView)
        {
            [self.container addSubview:self.model.customView];
            self.container.backgroundColor = [UIColor darkGrayColor];
            [self.model.customView mas_remakeConstraints:^(MASConstraintMaker *make) {
                __weak UIView *superView = self.model.customView.superview;
                make.edges.equalTo(superView);
            }];
            self.customView = self.model.customView;
        }
    }
}

#pragma mark - configure cell by model
- (void)configureCellWithModel:(BRCalendarModel *)model
{
    self.model = model;
    
    [self configShowWhat:model];
    [self configContent:model];
    [self configFont:model];
    [self configColor:model];

    [self updateConstrints];
}

#pragma mark - private methods
- (void)configShowWhat:(BRCalendarModel *)model
{
    switch (self.model.type) {
        case BRCalendarModelTypeDate: {
            _titleLabel.hidden = NO;
            _detailLabel.hidden = NO;
            _leftCornerImgView.hidden = NO;
            _rightCornerImgView.hidden = NO;
            break;
        }
        case BRCalendarModelTypeExpand: {
            _titleLabel.hidden = YES;
            _detailLabel.hidden = YES;
            _leftCornerImgView.hidden = YES;
            _rightCornerImgView.hidden = YES;
            break;
        }
        case BRCalendarModelTypeCustom: {
            _titleLabel.hidden = YES;
            _detailLabel.hidden = YES;
            _leftCornerImgView.hidden = YES;
            _rightCornerImgView.hidden = YES;
            break;
        }
    }
    
    if (model.isDayOfOtherMonth)
    {
        self.container.hidden = YES;
    }
    else
    {
        self.container.hidden = NO;
    }
    
    if (!self.showSeparateLine)
    {
        self.bottomLine.hidden = YES;
        self.rightLine.hidden = YES;
    }
    else
    {
        self.bottomLine.hidden = NO;
        self.rightLine.hidden = NO;
    }
}

- (void)configContent:(BRCalendarModel *)model
{
    if (model.title)
    {
        self.titleLabel.text = model.title;
    }
    else
    {
        if (model.type == BRCalendarModelTypeDate)
        {
            if (model.isToday)
            {
                self.titleLabel.text = @"今天";
            }
            else
            {
                self.titleLabel.text = [NSString stringWithFormat:@"%02ld", (long)[model.date getDay]];
            }
            self.titleLabel.textAlignment = NSTextAlignmentCenter;
        }
    }
    
    if (model.detail)
    {
        self.detailLabel.text = model.detail;
    }
    
    if (model.hasSelected && model.enableSelected && model.selectedBgImage)
    {
        self.bgImageView.image = model.selectedBgImage;
    }
    else if(model.bgImage)
    {
        self.bgImageView.image = model.bgImage;
    }
    
    if (model.leftCornerImage)
    {
        self.leftCornerImgView.image = model.leftCornerImage;
    }
    
    if (model.rightCornerImage)
    {
        self.rightCornerImgView.image = model.rightCornerImage;
    }
}

- (void)configFont:(BRCalendarModel *)model
{
    if (model.titleFont)
    {
        self.titleLabel.font = [UIFont systemFontOfSize:model.titleFont];
    }
    else
    {
        _titleLabel.font = [UIFont systemFontOfSize:15];
    }
    
    if (model.detailFont)
    {
        _detailLabel.font = [UIFont systemFontOfSize:model.detailFont];
    }
    else
    {
        _detailLabel.font = [UIFont systemFontOfSize:10];

    }
}

- (void)configColor:(BRCalendarModel *)model
{
    //默认
    _titleLabel.textColor = [UIColor blackColor];
    _detailLabel.textColor = [UIColor darkGrayColor];
    self.container.backgroundColor = [UIColor clearColor];

    //配置model
    if (model.isWeekDay)
    {
        _titleLabel.textColor = [UIColor redColor];
    }
    
    if (model.isDayOfOtherMonth)
    {
        _titleLabel.textColor = [UIColor lightGrayColor];
    }
    
    if (model.isDayBeforToday)
    {
        _titleLabel.textColor = [UIColor lightGrayColor];
    }
    
    if (model.hasSelected && model.enableSelected)
    {
        _titleLabel.textColor = [UIColor whiteColor];
        self.detailLabel.textColor = [UIColor whiteColor];
        self.container.backgroundColor = [UIColor redColor];
    }
}
#pragma mark - setter


#pragma mark - getter

- (NSDate *)currentDate
{
    return self.model.date;
}

- (BRCalendarModel *)originalModel
{
    return self.model;
}

- (CGFloat)titleTopMargin
{
    CGFloat margin = self.titleEdgeInsets.top - self.titleEdgeInsets.bottom;
    if (!margin)
    {
        margin = kDefaultCellTitleLabelTopMargin;
    }
    return margin;
}

- (CGFloat)detailBottomMargin
{
    CGFloat margin = self.detailEdgeInsets.bottom - self.detailEdgeInsets.top;
    if (!margin)
    {
        margin = kDefaultCellDetailLabelBottomMargin;
    }
    return margin;
}

// subViews
- (UIView *)container
{
    if (!_container)
    {
        _container = [[UIView alloc] init];
    }
    return _container;
}
- (UIView *)bottomLine
{
    if (!_bottomLine)
    {
        _bottomLine = [UIView drawLineWithWidth:self.container.bounds.size.width color:[UIColor lightGrayColor]];
    }
    return _bottomLine;
}
- (UIView *)rightLine
{
    if (!_rightLine)
    {
        _rightLine = [UIView drawLineWithWidth:self.container.bounds.size.width color:[UIColor lightGrayColor]];
    }
    return _rightLine;
}

#pragma mark - lazy load
- (UIImageView *)bgImageView
{
    if (!_bgImageView)
    {
        _bgImageView = [[UIImageView alloc] init];
    }
    return _bgImageView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel)
    {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UILabel *)detailLabel
{
    
    if (!_detailLabel)
    {
        _detailLabel = [[UILabel alloc] init];
        _detailLabel.textColor = [UIColor blackColor];
        _detailLabel.backgroundColor = [UIColor clearColor];
        _detailLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _detailLabel;
}

- (UIImageView *)leftCornerImgView
{
    if (!_leftCornerImgView)
    {
        _leftCornerImgView = [[UIImageView alloc] init];
    }
    return _leftCornerImgView;
}

- (UIImageView *)rightCornerImgView
{
    if (!_rightCornerImgView)
    {
        _rightCornerImgView = [[UIImageView alloc] init];
    }
    return _rightCornerImgView;
}
@end
