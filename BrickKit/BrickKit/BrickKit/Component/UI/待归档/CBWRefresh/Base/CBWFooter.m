//
//  CBWFooter.m
//  CBWRefresh
//
//  Created by 陈博文 on 16/5/30.
//  Copyright © 2016年 陈博文. All rights reserved.
//

#import "CBWFooter.h"
#import "UIScrollView+CBWFrame.h"
#import "UIView+CBWFrame.h"
#import "CBWRefreshConst.h"


@interface CBWFooter ()

@end

@implementation CBWFooter

+ (instancetype)footerWithRefreshingTarget:(id)target refreshingAction:(SEL)action{
    
    CBWFooter *cmp = [[self alloc] init];
    [cmp setRefreshingTarget:target refreshingAction:action];
    return cmp;
    
}

- (void)prepare{

    [super prepare];
    self.height = footerHeight;
    
}
#pragma mark - 开始和结束刷新
//TODO:上拉刷新没有开始刷新的命令

- (void)endRefresh{
    
    [UIView animateWithDuration:0.25 animations:^{
        //将偏移量改回来
        self.scrollView.insetB -= self.height;
    } completion:^(BOOL finished) {
        //在进行重新设置状态
        [super endRefresh];
    }];
}

/** 提示没有更多的数据 */
- (void)endRefreshingWithNoMoreData{
    self.state = CBWRefreshStateNoMoreData;
}
-(void)resetNoMoreData{
    
    if (self.state == CBWRefreshStateNoMoreData) {
        //将状态变成空的状态
        self.state = CBWRefreshStateIdle;
        //将偏移量改回来
        self.scrollView.insetB -= self.height;
        
    }
}
#pragma mark - 处理偏移事件

/** 当scrollView的contentOffset发生改变的时候调用 */
- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change
{
    [super scrollViewContentOffsetDidChange:change];
    
    //发现正在刷新状态就直接返回
    if (self.state == CBWRefreshStateRefreshing) {return;}
    if (self.state == CBWRefreshStateNoMoreData) {return;}
   
    //这里要考虑 contentsize小于 scrollView 的frame情款的时候的情况,
    //就不能使用 height
    if (self.scrollView.contentH < self.scrollView.height) {

        if (self.scrollView.contentOffset.y > - self.scrollView.insetT + self.height) {
            //距离超过了
           
            self.state = CBWRefreshStatePulling;
        }else{
            //距离超过了
            self.state = CBWRefreshStateIdle;
        }
        return;
        
        }
    
    if (self.scrollView.contentOffset.y > self.scrollView.contentH - self.scrollView.height + self.height + self.scrollView.insetB) {
        //距离超过了
        NSLog(@"%f,%f",self.scrollView.contentOffset.y,self.scrollView.contentH - self.scrollView.height + self.height + self.scrollView.insetB);
        self.state = CBWRefreshStatePulling;
    }else{
        //距离超过了
        self.state = CBWRefreshStateIdle;
    }
};
/** 当scrollView的contentSize发生改变的时候调用 */
- (void)scrollViewContentSizeDidChange:(NSDictionary *)change
{
 
    [super scrollViewContentSizeDidChange:change];
//     self.hidden = self.y > 0 ? NO:YES;
    // 设置 footer位置
//    NSLog(@"self.scrollView.contentH%f====self.scrollView.height%f",self.scrollView.contentH, self.scrollView.height);
    self.y = MAX(self.scrollView.contentH, self.scrollView.height - self.scrollView.contentInset.top - self.scrollView.contentInset.bottom);
//    self.y = self.scrollView.contentH;
//    NSLog(@"scrollViewContentSizeDidChange%f",self.y);
   
};
/** 当scrollView的拖拽状态发生改变的时候调用 */
- (void)scrollViewPanStateDidChange:(NSDictionary *)change
{
    
    //发现正在刷新状态就直接返回
    if (self.state == CBWRefreshStateRefreshing) {return;}
    //发现没有更多数据直接返回
    if (self.state == CBWRefreshStateNoMoreData) {return;}
    
    //这里要考虑 contentsize小于 scrollView 的frame情款的时候的情况,
    //就不能使用 height
    if (self.scrollView.contentH < self.scrollView.height) {
        
        
        if (self.scrollView.contentH < self.scrollView.height) {
            
            if (self.scrollView.contentOffset.y > - self.scrollView.insetT + self.height) {
                //距离超过了
                [UIView animateWithDuration:0.25f animations:^{
                    self.scrollView.insetB += self.height;
                } completion:^(BOOL finished) {
                    //调用刷新的方法
                    
                    [self executeRefreshingCallback];
                }];
                
                //设置状态为正在刷新
                self.state = CBWRefreshStateRefreshing;
                
            }
            
        }
          return;
    }

    
    //手势停止之后做的修改
    if (self.scrollView.contentOffset.y > self.scrollView.contentH - self.scrollView.height+ self.height + self.scrollView.insetB) {
       
        [UIView animateWithDuration:0.25f animations:^{
            self.scrollView.insetB += self.height;
        } completion:^(BOOL finished) {
            //调用刷新的方法
            
            [self executeRefreshingCallback];
        }];
        
        //设置状态为正在刷新
        self.state = CBWRefreshStateRefreshing;
    }
    
};


@end
