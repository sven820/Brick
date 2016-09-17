//
//  CBWHeader.m
//  CBWRefresh
//
//  Created by 陈博文 on 16/5/30.
//  Copyright © 2016年 陈博文. All rights reserved.
//

#import "CBWHeader.h"
#import "UIView+CBWFrame.h"
#import "UIScrollView+CBWFrame.h"
#import "CBWRefreshConst.h"

@interface CBWHeader ()


@end

@implementation CBWHeader

+ (instancetype)headerWithRefreshingTarget:(id)target refreshingAction:(SEL)action
{
    CBWHeader *cmp = [[self alloc] init];
    [cmp setRefreshingTarget:target refreshingAction:action];
    return cmp;
}

- (void)prepare{
    
    [super prepare];
    //header 的高度
    self.height = headerHeight;
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    //设置 header 的位置
    self.y = - headerHeight;
    

}

#pragma mark - 开始动画和结束动画
-(void)beginRefresh{
    
    [super beginRefresh];
    
    //设置状态为正在刷新
    self.state = CBWRefreshStateRefreshing;
    
    [UIView animateWithDuration:0.25f animations:^{
        self.scrollView.insetT += self.height;
    } completion:^(BOOL finished) {
        //调用刷新的方法
    
        [self executeRefreshingCallback];
    }];
}

- (void)endRefresh{
    
    [UIView animateWithDuration:0.25 animations:^{
        //将偏移量改回来
        self.scrollView.insetT -= self.height;
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        //在进行重新设置状态
        [super endRefresh];
    }];
}

#pragma mark - 处理偏移事件

/** 当scrollView的contentOffset发生改变的时候调用 */
- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change
{
    [super scrollViewContentOffsetDidChange:change];
    
    //发现正在刷新状态就直接返回
    if (self.state == CBWRefreshStateRefreshing) {return;}
    
    //不是的话在进行处理
    if (self.scrollView.contentOffset.y < -(self.height + self.scrollView.insetT)) {
        //距离超过了
        self.state = CBWRefreshStatePulling;
        
    }else{
        //距离没有超过
        self.state = CBWRefreshStateIdle;
    }
   
    self.pullingPercent = 1 - ((self.scrollView.contentOffset.y + (self.height + self.scrollView.insetT) ) / headerHeight);
//    NSLog(@"%f====",self.scrollView.contentOffset.y);
};
/** 当scrollView的contentSize发生改变的时候调用 */
- (void)scrollViewContentSizeDidChange:(NSDictionary *)change
{
    //这个是 footer 的现在不做处理
};
/** 当scrollView的拖拽状态发生改变的时候调用 */
- (void)scrollViewPanStateDidChange:(NSDictionary *)change
{

    //发现正在刷新状态就直接返回
    if (self.state == CBWRefreshStateRefreshing) {return;}
    
    //手势停止之后做的修改
    if (self.scrollView.contentOffset.y < -(self.height + self.scrollView.insetT)) {
        [UIView animateWithDuration:0.25f animations:^{
             self.scrollView.insetT += self.height;
        } completion:^(BOOL finished) {
            //调用刷新的方法
            
            [self executeRefreshingCallback];
        }];
        //设置状态为正在刷新
        self.state = CBWRefreshStateRefreshing;
        self.pullingPercent = 1.0;
    }
    
};

@end
