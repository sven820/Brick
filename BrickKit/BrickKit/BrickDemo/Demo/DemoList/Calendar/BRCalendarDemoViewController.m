//
//  BRCalendarDemo.m
//  BrickKit
//
//  Created by jinxiaofei on 16/6/29.
//  Copyright © 2016年 JJ.sevn. All rights reserved.
//

#import "BRCalendarDemoViewController.h"
#import "BRCalendarView.h"

@interface BRCalendarDemoViewController ()<BRCalendarViewDelegate>

@property(nonatomic, strong) BRCalendarView * calendarView;
@end

@implementation BRCalendarDemoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self drawViews];
    [self makeContraints];
}

#pragma mark - draw views
- (void)drawViews
{
    [self.view addSubview:self.calendarView];
}

#pragma mark - make constraints
- (void)makeContraints
{
    [self.calendarView mas_makeConstraints:^(MASConstraintMaker *make) {
        __weak UIView *superView = self.calendarView.superview;
        make.left.right.equalTo(superView);
        make.top.equalTo(superView).offset(64);
        make.height.mas_equalTo(kSCREEN_HEIGHT - 64);
    }];
}

#pragma mark - getter
- (BRCalendarView *)calendarView
{
    if (!_calendarView)
    {
        _calendarView = [[BRCalendarView alloc] initWithDelegate:self contentType:BRCalendarViewTypeFuture displayType:BRCalendarViewDisplayTypeMonth];
        _calendarView.backgroundColor = [UIColor blueColor];
        _calendarView.startDate = [NSDate date];
        _calendarView.enableSelectedBeforToday = NO;
        _calendarView.showLoadMoreBtn = YES;
        _calendarView.showMonthSection = YES;
        _calendarView.showExpandView = YES;
        _calendarView.showSeparateLine = NO;
        _calendarView.monthSectionType = BRCalendarViewDisplayTypeScreen;
        _calendarView.showNumOfMonthEachTime = 3;
    }
    return _calendarView;
}

#pragma mark - BRCalendarViewDelegate
- (CGFloat)calendarView:(BRCalendarView*)aView heightWithDateModel:(BRCalendarModel *)model
{
    return 50;
}
- (CGFloat)calendarView:(BRCalendarView*)aView heightForLoadMoreItem:(NSIndexPath *)indexPath model:(BRCalendarModel *)model
{
    return 39;
}
- (CGFloat)calendarView:(BRCalendarView*)aView heightForMonthItem:(NSIndexPath *)indexPath model:(BRCalendarModel *)model
{
    return 39;
}
- (UIView *)calendarView:(BRCalendarView*)aView viewForExpandView:(NSIndexPath *)indexPath model:(BRCalendarModel *)model
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor blueColor];
    return view;
}
- (CGFloat)calendarView:(BRCalendarView*)aView heightForExpandView:(NSIndexPath *)indexPath model:(BRCalendarModel *)model
{
    return 78;
}

- (BRCalendarModel *)calendarView:(BRCalendarView *)aView model:(BRCalendarModel *)model
{
    model.detail = @"设置";
    return model;
}
@end
