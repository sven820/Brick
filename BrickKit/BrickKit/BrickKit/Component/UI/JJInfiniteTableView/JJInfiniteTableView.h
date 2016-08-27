//
//  JJInfiniteTableView.h
//  TableViewInfinite
//
//  Created by jxf on 16/2/21.
//  Copyright © 2016年 JJ.sevn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JJInfiniteTitleBar.h"
@class JJInfiniteTableView;
typedef NS_ENUM(NSInteger, JJInfiniteTitleBarScrollStyle)
{
    JJInfiniteTitleBarScrollStyleNone,
    JJInfiniteTitleBarScrollStyleSwell,
    JJInfiniteTitleBarScrollStyleCharFlow,
    JJInfiniteTitleBarScrollStyleShaowFlow,
    JJInfiniteTitleBarScrollStyleHeadColorFlow,
};


@protocol JJInfiniteTableViewDataSource <NSObject>

@required
// 有多少内容view
- (NSInteger)numberOfItemsAtInfiniteTableView:(JJInfiniteTableView *)infiniteTableView;
// 内容view的cell个数
- (NSInteger)infiniteTableView:(JJInfiniteTableView *)infiniteTableView numberOfCellsAtIndexPart:(NSInteger)index;
// 内容view的cell
- (UITableViewCell *)infiniteTableView:(JJInfiniteTableView *)infiniteTableView andTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath andItemIndex:(NSInteger)index;
@optional
// 外界网络请求数据
// 加载当前页tableView被显示出来时的请求
- (void)loadDataWithRequest:(UITableView *)tableView andPageIndex:(NSInteger)index;
- (void)loadDataWithRequest:(UITableView *)tableView andPageIndex:(NSInteger)index andRefreshBlock:(void(^)()) refreshBlock;
// 下拉刷新请求
- (void)downPullRefreshWithRequest:(UITableView *)tableView andPageIndex:(NSInteger)index;
// 下拉刷新请求
- (void)upPullRefreshWithRequest:(UITableView *)tableView andPageIndex:(NSInteger)index;
@end

@protocol JJInfiniteTableViewDelegate <NSObject>

@optional
// 选中某页的某行
- (void)infiniteTableView:(JJInfiniteTableView *)infiniteTableView didSelectedRowAtIndexPath:(NSIndexPath *)indexPath;
// closeInfiniteView = YES, 抽屉效果, 选择性实现
- (UIView *)leftDrawerViewWithInfiniteTableView:(JJInfiniteTableView *)infiniteTableView;
- (CGFloat)widthForLeftDrawerViewWithInfiniteTableView:(JJInfiniteTableView *)infiniteTableView;
- (UIView *)rightDrawerViewWithInfiniteTableView:(JJInfiniteTableView *)infiniteTableView;
- (CGFloat)widthForRightDrawerViewWithInfiniteTableView:(JJInfiniteTableView *)infiniteTableView;
// 外界自定义的上下拉刷新控件, 选择性实现, 不实现, 为默认效果
    // 下拉刷新
- (UIView *)upPullRefreshView:(JJInfiniteTableView *)infiniteTableView;
    // 上拉加载
- (UIView *)downPullRefreshView:(JJInfiniteTableView *)infiniteTableView;
@end


@interface JJInfiniteTableView : UIView
@property(nonatomic, weak) id<JJInfiniteTableViewDelegate> delegate;
@property(nonatomic, weak) id<JJInfiniteTableViewDataSource> dataSource;
@property(nonatomic, weak, readonly) JJInfiniteTitleBar * titleBar;
@property(nonatomic, assign) CGFloat titleBarHeight;
@property(nonatomic, assign, getter=isCloseInfiniteView ) BOOL closeInfiniteView;
@property(nonatomic, assign) JJInfiniteTitleBarScrollStyle titleScrollStyle;
@property(nonatomic, assign) BOOL adjustNavbar;

@end
