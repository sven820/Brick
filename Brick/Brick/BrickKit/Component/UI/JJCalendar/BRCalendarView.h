//
//  YCFCalendarView.h
//  MyYaoChuFaApp
//
//  Created by zq chen on 3/23/15.
//  Copyright (c) 2015 要出发. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BRCalendarCell.h"
#import "BRCalendarSectionHeaderView.h"
#import "BRSmallCalendarView.h"

@class BRCalendarView;

typedef NS_ENUM(NSUInteger, BRCalendarViewContentType) {
    BRCalendarViewTypeNormal,
    BRCalendarViewTypeHistory,
    BRCalendarViewTypeFuture,
};

typedef NS_ENUM(NSUInteger, BRCalendarViewDisplayType) {
    BRCalendarViewDisplayTypeScreen,   //全屏
    BRCalendarViewDisplayTypeNav,     //一星期
    BRCalendarViewDisplayTypeMonth,  //一个月
};

@protocol BRCalendarViewDelegate <NSObject>
@required
@optional
//每个日期的数据模型
- (BRCalendarModel *)calendarView:(BRCalendarView*)aView model:(BRCalendarModel *)model;

- (CGFloat)calendarView:(BRCalendarView*)aView heightWithDateModel:(BRCalendarModel *)model;

- (CGFloat)calendarView:(BRCalendarView*)aView heightForHeaderInMonth:(NSDate *)month;
- (UIView *)calendarView:(BRCalendarView*)aView viewForHeaderInMonth:(NSDate *)month headerView:(BRCalendarSectionHeaderView *)headerView;

- (CGFloat)calendarView:(BRCalendarView*)aView heightForFooterInMonth:(NSDate *)month;
- (UIView *)calendarView:(BRCalendarView*)aView viewForFooterInMonth:(NSDate *)month footerView:(BRCalendarSectionFooterView *)headerView;

- (UIView *)calendarView:(BRCalendarView*)aView viewForExpandView:(NSIndexPath *)indexPath model:(BRCalendarModel *)model;
- (CGFloat)calendarView:(BRCalendarView*)aView heightForExpandView:(NSIndexPath *)indexPath model:(BRCalendarModel *)model;

#warning todo
- (CGSize)calendarView:(BRCalendarView*)aView sizeForCustomCell:(NSIndexPath *)indexPath model:(BRCalendarModel *)model;
- (UIView *)calendarView:(BRCalendarView*)aView viewForCustomCell:(NSIndexPath *)indexPath model:(BRCalendarModel *)model;

//点击上拉加载更多
- (CGFloat)calendarView:(BRCalendarView*)aView heightForLoadMoreWithEndDate:(NSDate *)endDate;
- (void)loadMoreOfCalendarView:(BRCalendarView*)aView fromDate:(NSDate *)fromDate endDate:(NSDate *)endDate loadMoreView:(BRCalendarSectionHeaderView *)loadMoreView;

//选中当前的日历
- (void)calendarView:(BRCalendarView*)aView didSelectedCell:(BRCalendarCell*)cell model:(BRCalendarModel *)model;
//编辑当前选择的日历
- (void)calendarView:(BRCalendarView*)aView editCellSelected:(BRCalendarCell*)cell model:(BRCalendarModel *)model;
//当前日历月份
- (void)calendarView:(BRCalendarView *)aView showCurrentMonth:(NSDate *)monthDate;

#warning todo
- (void)calendarView:(BRCalendarView*)aView doubleClickCell:(BRCalendarCell*)cell model:(BRCalendarModel *)model;
@end

@interface BRCalendarView : UIView

@property(nonatomic, weak) id <BRCalendarViewDelegate> delegate;

@property(nonatomic, assign) CGFloat calendarWidth;//默认为screenWidth
@property(nonatomic, assign) UIEdgeInsets titleEdgeInsets;
@property(nonatomic, assign) UIEdgeInsets detailEdgeInsets;
@property(nonatomic, assign) UIEdgeInsets contentEdgeInsets;

@property(nonatomic, assign) BOOL enableSelectedBeforToday;
#warning todo
@property(nonatomic, assign) BOOL allowsMultipleSelection;      // default is NO 暂时未生效
@property(nonatomic, assign) BOOL showSeparateLine;            //是否显示网格线
@property(nonatomic, assign) BOOL showLoadMoreBtn;             //是否显示加载更多的cell
@property(nonatomic, assign) BOOL showShink;               //是否显示底部展开/收缩按钮

@property(nonatomic, assign) BOOL showMonthSection;            //是否显示月份
@property(nonatomic, assign) BRCalendarSectionHeaderViewType monthSectionType;
@property(nonatomic, assign) CGFloat monthSectionLRMargin;     //支队left/right type有效

@property(nonatomic, assign) BOOL showExpandView;              //点击cell是否能展开

@property (nonatomic,strong) NSMutableArray *dateSelected;//已选日期 数据类型是nsdate
@property (nonatomic,assign) NSInteger limitOfMonthToShow;//显示月数限制默认是6，至少是1
@property (nonatomic,assign) NSInteger showNumOfMonthEachTime;//每次加载月数默认是3 ，至少是1
@property (nonatomic,strong) NSDate *startDate;
@property (nonatomic,strong) NSDate *endDate;
@property (nonatomic,strong) NSDate *loadFromDate;
@property (nonatomic,strong) NSDate *loadToDate;

- (instancetype)initWithDelegate:(id <BRCalendarViewDelegate>)delegate contentType:(BRCalendarViewContentType)contentType displayType:(BRCalendarViewDisplayType)displayType;

- (void)reloadData;//update canlendar if need
- (void)reloadDataWithContentType:(BRCalendarViewContentType)contentType displayType:(BRCalendarViewDisplayType)displayType;

- (BRCalendarCell*)cellForItemAtDate:(NSDate *)date;
- (NSDate*)dateForItemAtCell:(BRCalendarCell *)cell;

- (void)selectedDateInBigCalendar:(NSDate *)date;
- (void)selectedDateInSmallCalendar:(NSDate *)date;

- (void)expandWithAnimation:(BOOL)animation;
- (NSArray *)foldWithAnimation:(BOOL)animation;

- (void)setFoldViewHidden:(BOOL)hidden;
@end
