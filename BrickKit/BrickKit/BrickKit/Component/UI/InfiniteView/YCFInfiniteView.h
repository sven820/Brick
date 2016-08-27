//
//  JJPictureInfiniteView.h
//  PictureInfinite
//
//  Created by jxf on 16/2/21.
//  Copyright © 2016年 JJ.sevn. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YCFInfiniteView;

typedef NS_ENUM(NSUInteger, YCFInfiniteViewScrollType) {
    YCFInfiniteViewScrollHorizontal,
    YCFInfiniteViewScrollVertical,
};

@interface YCFInfiniteViewItem : UIView
@property(nonatomic, strong) NSString *identify;
@end

@protocol YCFInfiniteViewDelegate <NSObject>

@required
/**
 *  轮播器
 *
 *  @param infiniteView YCFInfiniteView
 *
 *  @return 轮播器内容的个数
 */
- (NSInteger)numberOfItemAtInfiniteView:(YCFInfiniteView *)infiniteView;
/**
 *  轮播器
 *
 *  @param infiniteView YCFInfiniteView
 *  @param index        第几个item
 *
 *  @return 返回第几个item的view, 类型为YCFInfiniteViewItem
 */
- (YCFInfiniteViewItem *)infiniteView:(YCFInfiniteView *)infiniteView itemViewAtIndex:(NSInteger)index;

@optional
/**
 *  轮播器
 *
 *  @param infiniteView YCFInfiniteView
 *  @param index        点击的第几个item
 */
- (void)infiniteView:(YCFInfiniteView *)infiniteView didClickedItemViewAtIndex:(NSInteger)index;

@end

@interface YCFInfiniteView : UIView

@property(nonatomic, weak) id<YCFInfiniteViewDelegate> delegate;

@property(nonatomic, assign) YCFInfiniteViewScrollType scrollType;

//定义pageControl的位置
@property(nonatomic, assign) CGSize  pageControlSize;
@property(nonatomic, assign) CGFloat pageControlRightPadding;
@property(nonatomic, assign) CGFloat pageControlBottomPadding;

@property(nonatomic, strong, readonly) UIPageControl *pageControl;

//是否需要定时器
@property(nonatomic, assign) BOOL isNeedTimer;
//是否支持无限循环
@property(nonatomic, assign) BOOL isNeedInfinite;
//轮播时间间隔
@property(nonatomic, assign) CGFloat infiniteTime;

//刷新轮播器, 会回到第0页
- (void)reloadData;
//滚动到第几页
- (void)scrollToPage:(NSInteger)page;

//注册和获取YCFInfiniteView view, 同UITableView
- (void)registerItemViewClass:(Class)itemClass forItemViewReuseIdentifier:(NSString *)identifier;
- (YCFInfiniteViewItem *)dequeueReusableItemViewWithIdentifier:(NSString *)identifier;
@end
