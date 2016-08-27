//
//  CBWrefreshComponet.h
//  CBWRefresh
//
//  Created by 陈博文 on 16/5/30.
//  Copyright © 2016年 陈博文. All rights reserved.
//

#import <UIKit/UIKit.h>

/** 刷新控件的状态 */
typedef NS_ENUM(NSInteger,CBWRefreshState) {
    /** 普通闲置状态 */
    CBWRefreshStateIdle = 1,
    /** 松开就可以进行刷新的状态 */
    CBWRefreshStatePulling,
    /** 正在刷新中的状态 */
    CBWRefreshStateRefreshing,
    /** 即将刷新的状态 */
    CBWRefreshStateWillRefresh,
    /** 所有数据加载完毕，没有更多的数据了 */
    CBWRefreshStateNoMoreData
};

@interface CBWrefreshComponet : UIView

/** 处于刷新的状态*/
@property (nonatomic ,assign) CBWRefreshState state;
/** 获取正在滚动的 scrolView*/
@property (nonatomic ,weak) UIScrollView *scrollView;
/** 回调对象 */
@property (weak, nonatomic) id refreshingTarget;
/** 回调方法 */
@property (assign, nonatomic) SEL refreshingAction;
/** 下拉比例*/
@property (nonatomic ,assign) float pullingPercent;

/**
 *  初始化控件
 */
- (void)prepare;

/**
 *  开始刷新
 */
- (void)beginRefresh;

/**
 *  结束刷新
 */
- (void)endRefresh;

//设置事件
- (void)setRefreshingTarget:(id)target refreshingAction:(SEL)action;

//调用刷新方法
- (void)executeRefreshingCallback;

/** 当scrollView的contentOffset发生改变的时候调用 */
- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change;
/** 当scrollView的contentSize发生改变的时候调用 */
- (void)scrollViewContentSizeDidChange:(NSDictionary *)change;
/** 当scrollView的拖拽状态发生改变的时候调用 */
- (void)scrollViewPanStateDidChange:(NSDictionary *)change;
@end
