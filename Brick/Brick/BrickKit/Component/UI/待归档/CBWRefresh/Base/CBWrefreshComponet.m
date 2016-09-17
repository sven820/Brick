//
//  CBWrefreshComponet.m
//  CBWRefresh
//
//  Created by 陈博文 on 16/5/30.
//  Copyright © 2016年 陈博文. All rights reserved.
//

#import "CBWrefreshComponet.h"
#import "UIView+CBWFrame.h"
#import "CBWRefreshConst.h"
#import <objc/message.h>

@interface CBWrefreshComponet ()


/** 获取正在移动的手势*/
@property(nonatomic, strong) UIPanGestureRecognizer *pan;
/** 记录一开始的insert*/
@property(nonatomic, assign) UIEdgeInsets scrollViewOriginalInset;

@end

@implementation CBWrefreshComponet
#pragma mark - 初始化

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.state = CBWRefreshStateIdle;
//        self.backgroundColor = [UIColor greenColor];
        [self prepare];
    }
    return self;
}

- (void)prepare{
    //这个是自动适应 scrollView 的width
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth;

}

#pragma mark - 设置事件
- (void)setRefreshingTarget:(id)target refreshingAction:(SEL)action
{
    self.refreshingTarget = target;
    self.refreshingAction = action;
    
}

#pragma mark - 开始动画和隐藏动画

- (void)beginRefresh{
    
    self.state = CBWRefreshStateIdle;
    
}

-(void)endRefresh{
    
    self.state = CBWRefreshStateIdle;
}

#pragma mark 设置KVO监听
- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    
    // 如果不是UIScrollView，不做任何事情
    if (newSuperview && ![newSuperview isKindOfClass:[UIScrollView class]]) return;
    
    // 旧的父控件移除监听
    [self removeObservers];
    
    if (newSuperview) { // 新的父控件
        
        self.width = newSuperview.width;
        // 设置位置
        self.x = 0;
        
        
        // 记录UIScrollView
        _scrollView = (UIScrollView *)newSuperview;
        // 设置永远支持垂直弹簧效果
        self.scrollView.alwaysBounceVertical = YES;
        _scrollViewOriginalInset = _scrollView.contentInset;
        // 添加监听
        [self addObservers];
    }
}

- (void)addObservers
{
    NSKeyValueObservingOptions options = NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld;
    [self.scrollView addObserver:self forKeyPath:scrollViewContentOffsetKeyPath options:options context:nil];
    [self.scrollView addObserver:self forKeyPath:scrollViewContentSizeKeyPath options:options context:nil];
    self.pan = self.scrollView.panGestureRecognizer;
    [self.pan addObserver:self forKeyPath:scrollViewPanStateKeyPath options:options context:nil];
}
- (void)removeObservers
{
    [self.superview removeObserver:self forKeyPath:scrollViewContentOffsetKeyPath];
    [self.superview removeObserver:self forKeyPath:scrollViewContentSizeKeyPath];;
    [self.pan removeObserver:self forKeyPath:scrollViewPanStateKeyPath];
    self.pan = nil;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (keyPath == scrollViewContentOffsetKeyPath) {
//        NSLog(@"=scrollViewContentOffsetKeyPath=%f",self.scrollView.contentOffset.y);

        [self scrollViewContentOffsetDidChange:change];
    }
    if (keyPath == scrollViewContentSizeKeyPath) {
        [self scrollViewContentSizeDidChange:change];
    }
    if (keyPath == scrollViewPanStateKeyPath) {
        if (self.pan.state == UIGestureRecognizerStateEnded) {

            [self scrollViewPanStateDidChange:change];
        }
    }
}

/** 当scrollView的contentOffset发生改变的时候调用 */
- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change{};
/** 当scrollView的contentSize发生改变的时候调用 */
- (void)scrollViewContentSizeDidChange:(NSDictionary *)change{};
/** 当scrollView的拖拽状态发生改变的时候调用 */
- (void)scrollViewPanStateDidChange:(NSDictionary *)change{};

#pragma mark - 回到主线程调用方法
- (void)executeRefreshingCallback
{
    dispatch_async(dispatch_get_main_queue(), ^{

        if ([self.refreshingTarget respondsToSelector:self.refreshingAction]) {
             CBWRefreshMsgSend(CBWRefreshMsgTarget(self.refreshingTarget), self.refreshingAction, self);
        }
    });
}

#pragma mark - setter && getter 

-(void)setPullingPercent:(float)pullingPercent{
    
//    NSLog(@"%f",pullingPercent);
    _pullingPercent = pullingPercent;
 
    if (pullingPercent < 0.0) {return;}
    
    if (self.state == CBWRefreshStateRefreshing) {
        self.alpha = 1.0;
    }else{
        if (pullingPercent > 1.0) {
            pullingPercent = 1.0;
        }
        self.alpha = pullingPercent;
    }
}

@end
