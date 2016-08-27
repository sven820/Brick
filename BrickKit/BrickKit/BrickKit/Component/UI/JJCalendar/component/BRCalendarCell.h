//
//  YCFCalendarCell.h
//  MyYaoChuFaApp
//
//  Created by zq chen on 3/24/15.
//  Copyright (c) 2015 要出发. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BRCalendarModel.h"

static const int kWidthOfCornerImgView = 12;

typedef NS_ENUM(NSUInteger, BRCalendarViewMonthSectionType) {
    BRCalendarViewMonthSectionTypeLeft,
    BRCalendarViewMonthSectionTypeRight,
    BRCalendarViewMonthSectionTypeCenter,
    BRCalendarViewMonthSectionTypeFlowFirstDayOfMonth,
};

static const int kDefaultMonthCellHeight = 24;
static const int kDefaultLoadMoreHeight = 24;
static const int kDefaultDateCellHeight = 49;

static const int kNumOfItemsInLine = 7;
static const float kCellHorizontalPadding = 0;
static const float kCellVerticalPadding = 0;

@class BRCalendarCell;

@interface BRCalendarCell : UICollectionViewCell
@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UILabel *detailLabel;
@property(nonatomic, strong) UIImageView *leftCornerImgView;        //角标
@property(nonatomic, strong) UIImageView *rightCornerImgView;        //角标
@property(nonatomic, strong) UIImageView *bgImageView;

@property(nonatomic, assign) UIEdgeInsets titleEdgeInsets;
@property(nonatomic, assign) UIEdgeInsets detailEdgeInsets;
@property(nonatomic, assign) UIEdgeInsets contentEdgeInsets;

@property(nonatomic, assign) BOOL showSeparateLine;            //是否显示网格线

@property(nonatomic, assign) BRCalendarViewMonthSectionType monthSectionType;
@property(nonatomic, assign) CGFloat monthSectionLRMargin;     //支队left/right type有效

- (void)configureCellWithModel:(BRCalendarModel *)model;
- (NSDate *)currentDate;
- (BRCalendarModel *)originalModel;
@end
