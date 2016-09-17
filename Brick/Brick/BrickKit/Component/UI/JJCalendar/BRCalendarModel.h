//
//  BRCalendarModel.h
//  BrickKit
//
//  Created by jinxiaofei on 16/6/29.
//  Copyright © 2016年 JJ.sevn. All rights reserved.
//

#import "BRModel.h"

typedef NS_ENUM(NSUInteger, BRCalendarModelType) {
    BRCalendarModelTypeDate,
    BRCalendarModelTypeExpand,
    BRCalendarModelTypeCustom,
};

@interface BRCalendarModel : BRModel

@property(nonatomic, assign) BRCalendarModelType type; //决定cell的类型

@property(nonatomic, strong) NSIndexPath * indexPath;
@property(nonatomic, assign) CGSize cellSize;

@property(nonatomic, strong) NSString * title;
@property(nonatomic, assign) CGFloat titleFont;
@property(nonatomic, strong) NSString * detail;
@property(nonatomic, assign) CGFloat detailFont;

@property(nonatomic, strong) UIImage * bgImage;
@property(nonatomic, strong) UIImage * selectedBgImage;
@property(nonatomic, strong) UIImage * leftCornerImage;
@property(nonatomic, strong) UIImage * rightCornerImage;

@property(nonatomic, strong) NSDate * date;
@property(nonatomic, strong) NSDate * monthDate;
@property(nonatomic, strong) NSString * dateStr;

@property(nonatomic, assign) BOOL isShowDetail;
@property(nonatomic, assign) BOOL isShowCornerMark;

@property(nonatomic, assign) BOOL enableSelected;         //是否可以点击
@property(nonatomic, assign) BOOL hasSelected;            //是否已选
@property(nonatomic, assign) BOOL enableLoadMore;         //是否可以加载更多
@property(nonatomic, assign) BOOL isLoadMore;

@property(nonatomic, assign) BOOL isDayOfOtherMonth;      //是否是当月
@property(nonatomic, assign) BOOL isDayBeforToday;        //是否是今天之前
@property(nonatomic, assign) BOOL isWeekDay;              //是否周六日
@property(nonatomic, assign) BOOL isToday;                //是否是今天

@property(nonatomic, assign) BOOL hasBeenInit;            //是否被初始化过了, 用于保存字典

@property(nonatomic, strong) UIView * customView;         //cell自定义的view


@end
