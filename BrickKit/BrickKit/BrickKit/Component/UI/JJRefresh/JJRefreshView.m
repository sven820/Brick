//
//  JJRefreshView.m
//  TableViewInfinite
//
//  Created by jxf on 16/3/22.
//  Copyright © 2016年 JJ.sevn. All rights reserved.
//

#import "JJRefreshView.h"
#import "UIScrollView+JJExtension.h"
#import "UIView+AdjustFrame.h"

NSString *ScrollViewContentSizeKeyPath = @"contentSize";
NSString *ScrollViewContentOffsetKeyPath = @"contentOffset";
NSString *ScrollViewPanStateKeyPath = @"state";



@interface JJRefreshView ()<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *juhua;
@property(nonatomic, weak) UIScrollView * scrollView;

@property(nonatomic, strong) void(^downPullBlock)();

@property(nonatomic, strong) void(^upPullBlock)();

@property(nonatomic, strong) UIPanGestureRecognizer * pan;
@property(nonatomic, assign) UIEdgeInsets oriEdgeInsets;
@end

@implementation JJRefreshView
static JJRefreshView * header;
static JJRefreshView * footer;

+ (JJRefreshView *)loadDownPullViewWithBlock:(void (^)())requestBlock
{
    if (header == nil) {
        
        header = [[NSBundle mainBundle] loadNibNamed:@"JJRefreshView" owner:nil options:nil].firstObject;
        [header someInitSetting];
        header.downPullBlock = requestBlock;
    }
    return header;
}

+ (JJRefreshView *)loadUpPullViewWithBlock:(void (^)())requestBlock
{
    if (footer == nil) {
        
        footer = [[NSBundle mainBundle] loadNibNamed:@"JJRefreshView" owner:nil options:nil].lastObject;
        [footer someInitSetting];
        footer.upPullBlock = requestBlock;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:footer action:@selector(footerTaped:)];
        [footer addGestureRecognizer:tap];
    }
    
    return footer;
}

- (void)someInitSetting
{
    header.juhua.hidden = YES;
    header.hidden = YES;
    footer.juhua.hidden = YES;
    footer.statusLabel.text = @"下拉或点击加载更多";
    header.statusLabel.text = @"下拉刷新更多";
}

- (void)footerTaped:(UITapGestureRecognizer *)tap
{
    if (self.upPullRefreshing == YES) {
        return;
    }
    JJRefreshView *footer = (JJRefreshView *)tap.view;
    [footer startFooterRefresh];
}

#pragma mark ------------------------------------------
#pragma mark 设置KVO监听
- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    
    // 如果不是UIScrollView，不做任何事情
    if (newSuperview && ![newSuperview isKindOfClass:[UIScrollView class]]) return;
    
    // 旧的父控件移除监听
    [self removeObservers];
    
    if (newSuperview) { // 新的父控件
        // 记录UIScrollView
        _scrollView = (UIScrollView *)newSuperview;
        // 设置永远支持垂直弹簧效果
        self.scrollView.alwaysBounceVertical = YES;
        _oriEdgeInsets = _scrollView.contentInset;
        // 添加监听
        [self addObservers];
    }
}

- (void)addObservers
{
    NSKeyValueObservingOptions options = NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld;
    [self.scrollView addObserver:self forKeyPath:ScrollViewContentOffsetKeyPath options:options context:nil];
    [self.scrollView addObserver:self forKeyPath:ScrollViewContentSizeKeyPath options:options context:nil];
    self.pan = self.scrollView.panGestureRecognizer;
    [self.pan addObserver:self forKeyPath:ScrollViewPanStateKeyPath options:options context:nil];
}
- (void)removeObservers
{
    [self.superview removeObserver:self forKeyPath:ScrollViewContentOffsetKeyPath];
    [self.superview removeObserver:self forKeyPath:ScrollViewContentSizeKeyPath];;
    [self.pan removeObserver:self forKeyPath:ScrollViewPanStateKeyPath];
    self.pan = nil;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (keyPath == ScrollViewContentOffsetKeyPath) {
        [self jj_scrollViewDidScroll:self.scrollView];
    }
    if (keyPath == ScrollViewContentSizeKeyPath) {
        [self jj_scrollViewDidChangeContentSize:self.scrollView];
    }
    if (keyPath == ScrollViewPanStateKeyPath) {
        if (self.pan.state == UIGestureRecognizerStateEnded) {
            [self jj_scrollViewDidEndDragging:self.scrollView];
        }
    }
}



#pragma mark ------------------------------------------
#pragma mark 监听方法

- (void)jj_scrollViewDidScroll:(UIScrollView *)scrollView
{
    [scrollView.header dealHeaderRefreshView:scrollView];
    [scrollView.footer dealFooterRefreshView:scrollView];
}

- (void)jj_scrollViewDidEndDragging:(UIScrollView *)scrollView
{
    if (scrollView.header.downPullRefreshing) return;
    if (scrollView.contentOffset.y < -(scrollView.header.jj_height + scrollView.jj_insetT)) {
        
        [scrollView.header appearHeaderAndRefreshing];
    }
}

- (void)jj_scrollViewDidChangeContentSize:(UIScrollView *)scrollView
{
    footer.frame = CGRectMake(0, scrollView.contentSize.height, self.jj_width, 44);
    scrollView.jj_insetB = _oriEdgeInsets.bottom + footer.jj_height;

}
#pragma mark ------------------------------------------
#pragma mark other methods
- (void)dealFooterRefreshView:(UIScrollView *)scrollView
{
    if (scrollView.footer == nil) return;
    if (scrollView.footer.upPullRefreshing) return;
    scrollView.footer.scrollView = scrollView;
    if (scrollView.jj_offsetY > scrollView.jj_contentH - scrollView.jj_height) {
        
    }
    if (scrollView.contentOffset.y > scrollView.jj_contentH - scrollView.jj_height + scrollView.jj_insetB) {
        [scrollView.footer startFooterRefresh];
    }
}

- (void)dealHeaderRefreshView:(UIScrollView *)scrollView
{
    if (scrollView.header == nil) return;
    if (scrollView.header.downPullRefreshing) return;
    scrollView.header.scrollView = scrollView;
    if (scrollView.contentOffset.y < -(scrollView.header.jj_height + scrollView.jj_insetT)) {
        scrollView.header.statusLabel.text = @"松开立即刷新";
    }else{
        scrollView.header.statusLabel.text = @"下拉刷新更多";
    }
    if (scrollView.jj_offsetY < -scrollView.jj_insetT) {
        scrollView.header.hidden = NO;
    }
}

- (void)appearHeaderAndRefreshing
{
    if (self.downPullRefreshing) return;
    self.statusLabel.text = @"正在刷新...";
    self.downPullRefreshing = YES;
    self.juhua.hidden = NO;
    [self.juhua startAnimating];
    [UIView animateWithDuration:0.25 animations:^{
        
        self.scrollView.jj_insetT += self.scrollView.header.jj_height;
    }];
    header.downPullBlock();
    
}

- (void)hideHeaderAndStopRefresh
{
    self.statusLabel.text = @"下拉刷新更多";
    self.downPullRefreshing = NO;
    self.juhua.hidden = YES;
    [self.juhua stopAnimating];
    [UIView animateWithDuration:0.25 animations:^{
        
        self.scrollView.jj_insetT -= self.scrollView.header.jj_height;
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];
}

- (void)startFooterRefresh
{
    if (self.upPullRefreshing) return;
    self.statusLabel.text = @"正在加载...";
    self.upPullRefreshing = YES;
    self.juhua.hidden = NO;
    [self.juhua startAnimating];
    footer.upPullBlock();
}

- (void)stopFooterRefresh
{
    self.statusLabel.text = @"下拉或点击加载更多";
    self.upPullRefreshing = NO;
    self.juhua.hidden = YES;
    [self.juhua stopAnimating];
}

- (void)dealloc
{
    //    NSLog(@"refreshView销毁了");
}
@end
