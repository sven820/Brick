//
//  BRCalendarSectionHeaderView.m
//  BrickKit
//
//  Created by jinxiaofei on 16/7/6.
//  Copyright © 2016年 JJ.sevn. All rights reserved.
//

#import "BRCalendarSectionHeaderView.h"

@interface BRCalendarSectionHeaderView ()
@property(nonatomic, strong) UILabel * label;
@property(nonatomic, strong) UIView * bottomLine;

@property(nonatomic, assign) BRCalendarSectionHeaderViewType showType;
@property(nonatomic, strong) NSDate * monthDate;
@end

@interface BRCalendarSectionFooterView ()
@property(nonatomic, strong) NSDate * monthDate;
@end

#pragma mark - BRCalendarSectionHeaderView

@implementation BRCalendarSectionHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self drawViews];
    }
    return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if ([self.delegate respondsToSelector:@selector(calendarSectionHeaderView:didSelectedWithMonth:)])
    {
        [self.delegate calendarSectionHeaderView:self didSelectedWithMonth:self.monthDate];
    }
}

- (void)defaultConfigWithMonth:(NSDate *)month
{
    self.monthDate = month;
    
    if (self.isLoadMore)
    {
        if (self.isLoadAll)
        {
            self.label.text = @"已全部加载完毕";
            
            self.label.font = [UIFont systemFontOfSize:12];
        }else
        {
            self.label.text = @"点击上拉加载更多..";
            
            self.label.font = [UIFont systemFontOfSize:12];
        }
    }
    else
    {
        if ([month getMonth] == 1)
        {
            self.label.text = [NSString stringWithFormat:@"%zd年-%02zd月", [month getYear], [month getMonth]];
        }
        else
        {
            self.label.text = [NSString stringWithFormat:@"%02zd月", [month getMonth]];
        }
        self.label.font = [UIFont systemFontOfSize:14];
    }
}

- (void)configIfNeedCustom:(UIView *)customView
{
    if (customView)
    {
        [self layoutWithCustom:customView];
    }
}

- (void)configMonthLabelPosition:(CGFloat)positionX type:(BRCalendarSectionHeaderViewType)type monthDate:(NSDate *)monthDate
{
    
    self.showType = type;
    self.monthDate = monthDate;
    CGFloat margin = positionX ? positionX : kDefaultMonthTitleLRMargin;

    if (self.isLoadMore)
    {
        [self.label mas_remakeConstraints:^(MASConstraintMaker *make) {
            __weak UIView *superView = self.label.superview;
            make.center.equalTo(superView);
        }];
        return;
    }

    switch (type) {
        case BRCalendarSectionHeaderViewTypeLeft: {
            [self.label mas_remakeConstraints:^(MASConstraintMaker *make) {
                __weak UIView *superView = self.label.superview;
                make.centerY.equalTo(superView);
                make.left.equalTo(superView).offset(margin);
            }];
            break;
        }
        case BRCalendarSectionHeaderViewTypeRight: {
            [self.label mas_remakeConstraints:^(MASConstraintMaker *make) {
                __weak UIView *superView = self.label.superview;
                make.centerY.equalTo(superView);
                make.left.equalTo(superView).offset(-margin);
            }];
            break;
        }
        case BRCalendarSectionHeaderViewTypeCenter: {
            [self.label mas_remakeConstraints:^(MASConstraintMaker *make) {
                __weak UIView *superView = self.label.superview;
                make.center.equalTo(superView);
            }];
            break;
        }
        case BRCalendarSectionHeaderViewTypeFlowFirstDayOfMonth: {
            NSDate *firstDateOfMonth = [monthDate dateAfterDay:1-[monthDate getDay]];
            CGFloat margin = ([firstDateOfMonth weekday] - 0.5) * (self.bounds.size.width / kCol) - self.bounds.size.width * 0.5 ;
            [self.label mas_remakeConstraints:^(MASConstraintMaker *make) {
                __weak UIView *superView = self.label.superview;
                make.centerY.equalTo(superView);
                make.centerX.equalTo(superView).offset(margin);
            }];
            break;
        }
    }
}

#pragma mark - draw views
- (void)drawViews
{
    [self addSubview:self.label];
    [self addSubview:self.bottomLine];
    [self makeContraints];
}

#pragma mark - make constraints
- (void)makeContraints
{
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        __weak UIView *superView = self.label.superview;
        make.centerY.equalTo(superView);
        make.left.equalTo(superView).offset(kDefaultMonthTitleLRMargin);
    }];
    
    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        __weak UIView *superView = self.bottomLine.superview;
        make.left.bottom.right.equalTo(superView);
        make.height.mas_equalTo(kOnePixel);
    }];
}

#pragma mark - pravite methods
- (void)layoutWithCustom:(UIView *)custom
{
    if (!custom)
    {
        return;
    }
    [self addSubview:custom];
    self.label.hidden = YES;
    [custom mas_makeConstraints:^(MASConstraintMaker *make) {
        __weak UIView *superView = custom.superview;
        make.edges.equalTo(superView);
    }];
}

#pragma mark - getter
- (UILabel *)label
{
    if (!_label)
    {
        _label = [[UILabel alloc] init];
    }
    return _label;
}

- (UIView *)bottomLine
{
    if (!_bottomLine)
    {
        _bottomLine = [UIView drawLineWithWidth:self.bounds.size.width color:[UIColor lightGrayColor]];
    }
    return _bottomLine;
}
@end

#pragma mark - BRCalendarSectionFooterView


@implementation BRCalendarSectionFooterView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        
    }
    return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if ([self.delegate respondsToSelector:@selector(calendarSectionFooterView:didSelectedWithMonth:)])
    {
        [self.delegate calendarSectionFooterView:self didSelectedWithMonth:self.monthDate];
    }
}

- (void)configWithMonth:(NSDate *)month isNeedCustom:(UIView *)customView
{
    self.monthDate = month;
    if (customView)
    {
        [self layoutWithCustom:customView];
    }
}

#pragma mark - pravite methods
- (void)layoutWithCustom:(UIView *)custom
{
    [self addSubview:custom];
    [custom mas_makeConstraints:^(MASConstraintMaker *make) {
        __weak UIView *superView = custom.superview;
        make.edges.equalTo(superView);
    }];
}
@end

