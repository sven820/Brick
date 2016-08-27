//
//  BRCalendarSectionHeaderView.h
//  BrickKit
//
//  Created by jinxiaofei on 16/7/6.
//  Copyright © 2016年 JJ.sevn. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BRCalendarSectionHeaderView;
@class BRCalendarSectionFooterView;

static const CGFloat kDefaultMonthTitleLRMargin = 12;
static const int kCol = 7;

typedef NS_ENUM(NSUInteger, BRCalendarSectionHeaderViewType) {
    BRCalendarSectionHeaderViewTypeLeft,
    BRCalendarSectionHeaderViewTypeRight,
    BRCalendarSectionHeaderViewTypeCenter,
    BRCalendarSectionHeaderViewTypeFlowFirstDayOfMonth,
};

#pragma mark - BRCalendarSectionHeaderView

@protocol BRCalendarSectionHeaderViewDelegate <NSObject>

@optional
- (void)calendarSectionHeaderView:(BRCalendarSectionHeaderView *)headerView didSelectedWithMonth:(NSDate *)month;
@end


@interface BRCalendarSectionHeaderView : UICollectionReusableView

@property(nonatomic, strong, readonly) UILabel * label;

@property(nonatomic, assign) BOOL isLoadMore;
@property(nonatomic, assign) BOOL isLoadAll;

@property(nonatomic, weak) id<BRCalendarSectionHeaderViewDelegate> delegate;

- (void)defaultConfigWithMonth:(NSDate *)month;
- (void)configIfNeedCustom:(UIView *)customView;
- (void)configMonthLabelPosition:(CGFloat)positionX type:(BRCalendarSectionHeaderViewType)type monthDate:(NSDate *)monthDate; //positionX 支持left/right type有效
@end

#pragma mark - BRCalendarSectionFooterView

@protocol BRCalendarSectionFooterViewDelegate <NSObject>

@optional
- (void)calendarSectionFooterView:(BRCalendarSectionFooterView *)footerView didSelectedWithMonth:(NSDate *)month;

@end
@interface BRCalendarSectionFooterView : UICollectionReusableView

@property(nonatomic, weak) id<BRCalendarSectionFooterViewDelegate> delegate;

- (void)configWithMonth:(NSDate *)month isNeedCustom:(UIView *)customView;
@end
