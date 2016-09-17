//
//  JJRefreshView.h
//  TableViewInfinite
//
//  Created by jxf on 16/3/22.
//  Copyright © 2016年 JJ.sevn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIScrollView+JJRefreshControl.h"

@interface JJRefreshView : UIView

+ (JJRefreshView *)loadDownPullViewWithBlock:(void(^)()) requestBlock;
+ (JJRefreshView *)loadUpPullViewWithBlock:(void(^)()) requestBlock;

@property(nonatomic, assign) BOOL downPullRefreshing;
@property(nonatomic, assign) BOOL upPullRefreshing;

- (void)appearHeaderAndRefreshing;
- (void)hideHeaderAndStopRefresh;
- (void)startFooterRefresh;
- (void)stopFooterRefresh;

- (void)endRefreshWithError: (NSString *)error;

@property(nonatomic, strong) NSString * refreshingText;
@property(nonatomic, strong) NSString * refreshingHoldingText;
@property(nonatomic, strong) NSString * refreshingDetailText;
@property(nonatomic, weak) UIView * indicateView;
@end
