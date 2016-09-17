//
//  JJInfiniteTableView.m
//  TableViewInfinite
//
//  Created by jxf on 16/2/21.
//  Copyright © 2016年 JJ.sevn. All rights reserved.
//

#import "JJInfiniteTableView.h"
#import "UIView+AdjustFrame.h"
#import "UIScrollView+JJExtension.h"
#import "JJTitleBtn.h"
#import "UIScrollView+JJRefreshControl.h"
#import "JJRefreshView.h"

typedef NS_ENUM(NSInteger, ScrollDirection)
{
    ScrollDirectionUnknown,
    ScrollDirectionLeft,
    ScrollDirectionRight,
};

static const CGFloat navBarHeight = 64;

@interface JJInfiniteTableView ()<UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate>
@property(nonatomic, weak) UIScrollView * scrollView;
@property(nonatomic, weak) JJInfiniteTitleBar * titleBar;
@property(nonatomic, strong) NSMutableDictionary * tableViewMemoryContentOffset;
@property(nonatomic, strong) NSMutableDictionary * tableViewIsLoaded;
@property(nonatomic, weak) UIView * leftDrawerView;
@property(nonatomic, weak) UIView * rightDrawerView;
@property(nonatomic, weak) UIToolbar * darkView;

@property(nonatomic, strong) UIGestureRecognizer * pan;
@property(nonatomic, assign) ScrollDirection scrollDirection;
@property(nonatomic, assign) CGFloat rightScale;
@property(nonatomic, weak) JJTitleBtn * rightBtn;
@property(nonatomic, weak) JJTitleBtn * leftBtn;
@property(nonatomic, assign) NSInteger currentPage;
@property(nonatomic, assign) NSInteger pageCount;

@property(nonatomic, assign) BOOL markForNonLoadAndNonCurPage;
@property(nonatomic, assign) BOOL markInitFrame;
@end

@implementation JJInfiniteTableView
#pragma mark ------------------------------------------
#pragma mark init
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initView];
        _currentPage = -1;
    }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self setupSubviewsLayout];
    [self reloadSelf];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:JJInfiniteTitleBarBtnDidClicked object:nil];
}
#pragma mark ------------------------------------------
#pragma mark some init setting
- (void)initView
{
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.bounces = NO;
    scrollView.pagingEnabled = YES;
    scrollView.delegate = self;
    [self addSubview:scrollView];
    self.scrollView = scrollView;
    
    for (int i = 0; i < 3; i++) {
        UITableView *tableView = [[UITableView alloc] init];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.tag = i;
        [scrollView addSubview:tableView];
    }
    JJInfiniteTitleBar *titleBar = [[JJInfiniteTitleBar alloc] init];
    titleBar.titleWidth = 100;
    [self insertSubview:titleBar aboveSubview:self.scrollView];
    self.titleBar = titleBar;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(titleBtnDidClicked) name:JJInfiniteTitleBarBtnDidClicked object:nil];
    
}

- (void)setupSubviewsLayout
{
    if (self.markInitFrame) {
        return;
    }
    self.scrollView.frame = self.bounds;
    self.scrollView.contentSize = CGSizeMake(self.jj_width * self.scrollView.subviews.count, 0);
    //titleBar
    if (!self.titleBarHeight) {
        self.titleBarHeight = 35;
    }
    self.titleBar.frame = CGRectMake(0, 0, self.jj_width, self.titleBarHeight);
    if (self.adjustNavbar == YES) {
        self.titleBar.jj_y += navBarHeight;
    }
    // tableView
    NSInteger index = 0;
    for (UITableView *tableView in self.scrollView.subviews) {
        tableView.frame = CGRectMake(self.jj_width * index, 0, self.jj_width, self.jj_height);
        // 为什么我这里设置 contentInset, tableView并没有自动向下偏移(contentInset 打印结果显示已经设置了 contentInset 了), 这里我手动让他向下滚了一个 titleBar 的高度, 不是应该跟着滚得嘛?!
        tableView.jj_insetT += self.titleBar.jj_height;
        if (self.adjustNavbar == YES) {
            tableView.jj_insetT += navBarHeight;
        }
        tableView.scrollIndicatorInsets = tableView.contentInset;
        index ++;
    }
    // 初始化标题字体放大
    if (self.titleScrollStyle == JJInfiniteTitleBarScrollStyleSwell) {
        [self setupTitleBtnScrollModelWithBtnIndex:0 andOffsetWithFrameX:0 andTableViewIndex:0];
    }
    self.markInitFrame = YES;
}


#pragma mark ------------------------------------------
#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    if ([scrollView isKindOfClass:[UITableView class]]) return;
    if (self.currentPage < 0) return;
    UITableView *curTableView = nil;
    CGFloat curTableViewMargin = MAXFLOAT;
    for (UITableView *tableView in self.scrollView.subviews) {
        CGFloat margin = ABS(tableView.jj_x - scrollView.contentOffset.x);
        NSInteger i = tableView.jj_x / self.jj_width;
        [self setupTitleBtnScrollModelWithBtnIndex:tableView.tag andOffsetWithFrameX:margin andTableViewIndex:i];
        
        if (margin < curTableViewMargin) {
            curTableViewMargin = margin;
            curTableView = tableView;
        }
    }

    self.titleBar.currentPage = curTableView.tag;
    
    if (!self.isCloseInfiniteView) return;
    // 处理标题/leftDrawer跟随 scrollView
    if (self.scrollView.contentOffset.x < 0) {
        self.titleBar.jj_x = -self.scrollView.contentOffset.x;
        self.leftDrawerView.jj_x =self.titleBar.jj_x-self.leftDrawerView.jj_width;
        self.darkView.jj_x = self.titleBar.jj_x;
        self.darkView.alpha = self.darkView.jj_x / self.jj_width;
    }
    // 处理 rightDrawerView 进入跟随
    if (self.scrollView.contentOffset.x > self.jj_width * 2){
        CGFloat x = self.scrollView.contentSize.width - self.scrollView.contentOffset.x;
        self.rightDrawerView.jj_x = x;
        self.titleBar.jj_x = -(self.jj_width - x);
        self.darkView.jj_x = self.titleBar.jj_x;
        self.darkView.alpha = -self.darkView.jj_x / self.jj_width;
    }
    
    if (self.scrollView.contentOffset.x >= 0 && self.scrollView.contentOffset.x <= self.jj_width * 2) {
        if (_leftDrawerView) {
            
            [_leftDrawerView removeFromSuperview];
        }
        if (_rightDrawerView) {
            
            [_rightDrawerView removeFromSuperview];
        }
        if (_darkView) {
            
            [_darkView removeFromSuperview];
        }if (self.titleBar.jj_x != 0) {
            
            self.titleBar.jj_x = 0;
        }
        self.scrollView.contentInset = UIEdgeInsetsZero;
        self.scrollView.userInteractionEnabled = YES;
        self.scrollView.pagingEnabled = YES;
    }
    
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (decelerate) return;
    [self dealWhenScrollViewEndDraggingOrEndDecelerate:scrollView];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self dealWhenScrollViewEndDraggingOrEndDecelerate:scrollView];
}
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self dealWhenScrollViewEndDraggingOrEndDecelerate:scrollView];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    UIPanGestureRecognizer *pan = self.scrollView.panGestureRecognizer;
    CGPoint velocity = [pan velocityInView:pan.view];
    if (velocity.x > 0) {
        self.scrollDirection = ScrollDirectionRight;
    }else {
        self.scrollDirection = ScrollDirectionLeft;
    }
    if (!self.isCloseInfiniteView) return;
    if (![scrollView isKindOfClass:[UITableView class]]) {
        if (velocity.x > 0 && self.titleBar.currentPage == 0) {
            self.leftDrawerView = self.leftDrawerView;
            self.scrollView.pagingEnabled = NO;
            self.scrollView.userInteractionEnabled = NO;
        }
        if (velocity.x < 0 && self.titleBar.currentPage == self.titleBar.numberOfPages - 1) {
            self.rightDrawerView = self.rightDrawerView;
            self.scrollView.pagingEnabled = NO;
            self.scrollView.userInteractionEnabled = NO;
        }
    }
}

#pragma mark ------------------------------------------
#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.markForNonLoadAndNonCurPage) {
        return 0;
    }
    return [self.dataSource infiniteTableView:self numberOfCellsAtIndexPart:tableView.tag];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.dataSource infiniteTableView:self andTableView:tableView cellForRowAtIndexPath:indexPath andItemIndex:tableView.tag];
    return cell;
}

#pragma mark ------------------------------------------
#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(infiniteTableView:didSelectedRowAtIndexPath:)]) {
        [self.delegate infiniteTableView:self didSelectedRowAtIndexPath:indexPath];
    }
}

#pragma mark ------------------------------------------
#pragma mark other
- (void)dealWhenScrollViewEndDraggingOrEndDecelerate:(UIScrollView *)scrollView
{
    if ([scrollView isKindOfClass:[UITableView class]]) {
        // 记录 tableView 的偏移量
        NSString *key = [NSString stringWithFormat:@"%zd", self.titleBar.currentPage];
        self.tableViewMemoryContentOffset[key] =[NSValue valueWithCGPoint:scrollView.contentOffset];
        return;
    }else{
        if (!self.isCloseInfiniteView) {
            [self reloadSelf];
            return;
        }
        // 处理抽屉 view 的细节
        if (self.scrollView.contentOffset.x < 0) {
            [self locateLeftDrawerViewEndDecelerating];
            return;
        }
        if (self.scrollView.contentOffset.x > self.jj_width * 2) {
            [self locateRightDrawerViewEndDecelerating];
            return;
        }
        [self reloadSelf];
    }
}

- (void)reloadSelf
{
    NSInteger curPage = self.titleBar.currentPage;
    if (curPage == self.currentPage) {
        return;
    }
    // closeInfiniteView状态下, 处理特殊情况:第一个和最后一个 tableView
    if (self.isCloseInfiniteView)
    {
        if (self.titleBar.currentPage == 0)
        {
            [self setupLeftForFirst];
            return;
        }
        if (self.titleBar.currentPage == self.titleBar.numberOfPages - 1)
        {
            [self setupRightForLast];
            return;
        }
    }

    [self setupTransportForTableView:curPage];
    
    [self setupReloadForTableView:curPage];
    
    // 重置 scrollView 的 contentOffset
    self.scrollView.contentOffset = CGPointMake(self.jj_width, 0);
    self.currentPage = curPage;
}

- (void)setupTransportForTableView:(NSInteger)curPage
{
    if (self.scrollDirection == ScrollDirectionLeft) {
        for (UITableView *tableView in self.scrollView.subviews) {
            if (self.isCloseInfiniteView && (curPage >= self.pageCount - 2 || curPage <= 1)) {
                continue;
            }
            
            NSInteger index = tableView.jj_x / self.jj_width;
            if (index == 0) {
                tableView.jj_x = self.jj_width * 2;
            }else {
                tableView.jj_x -= self.jj_width;
            }
        }
        
    }else if(self.scrollDirection == ScrollDirectionRight) {
        for (UITableView *tableView in self.scrollView.subviews) {
            if (self.isCloseInfiniteView && (curPage >= self.pageCount - 2 || curPage <= 1)) {
                continue;
            }
            
            NSInteger index = tableView.jj_x / self.jj_width;
            if (index == 2) {
                tableView.jj_x = 0;
            }else {
                tableView.jj_x += self.jj_width;
            }
        }
    }
}

- (void)setupReloadForTableView:(NSInteger)curPage
{
    for (UITableView *tableView in self.scrollView.subviews) {
        NSInteger tableViewIndex;
        NSInteger index = tableView.jj_x / self.jj_width;
        if (index == 1) {
            tableViewIndex = curPage;
        }else if (index == 0){
            tableViewIndex = curPage - 1;
        }else{
            tableViewIndex = curPage + 1;
        }
        
        if (tableViewIndex == -1) {
            tableViewIndex = self.titleBar.numberOfPages - 1;
        }else if (tableViewIndex == self.titleBar.numberOfPages){
            tableViewIndex = 0;
        }
        tableView.tag = tableViewIndex;
        // 刷新tableView
        NSString *key = [NSString stringWithFormat:@"%zd", tableViewIndex];
        if (index == 1) {
            if ([self.tableViewIsLoaded[key] boolValue] == NO) {
//                [self.dataSource loadDataWithRequest:tableView andPageIndex:tableViewIndex];
                [self.dataSource loadDataWithRequest:tableView andPageIndex:curPage];
                
                [self requestWithUpDownRefresh:tableView];
                self.tableViewIsLoaded[key] = @(YES);
            }else {
                [tableView reloadData];
                [self requestWithUpDownRefresh:tableView];
            }
            
        }else {
            if ([self.tableViewIsLoaded[key] boolValue] == YES) {
                [tableView reloadData];
            }else if ([self.tableViewIsLoaded[key] boolValue] == NO) {
                self.markForNonLoadAndNonCurPage = YES;
                [tableView reloadData];
                self.markForNonLoadAndNonCurPage = NO;
            }
        }
        // 还原tableView原来的偏移量
        [self setupTableViewMemoryContentOffset:tableView];
    }
}

- (void)requestWithUpDownRefresh:(UITableView *)tableView
{
    // 上下拉刷新
    if ([self.dataSource respondsToSelector:@selector(downPullRefreshWithRequest:andPageIndex:)]) {
        tableView.header = [JJRefreshView loadDownPullViewWithBlock:^{
        [self.dataSource downPullRefreshWithRequest:tableView andPageIndex:tableView.tag];
        }];
    }
    if ([self.dataSource respondsToSelector:@selector(upPullRefreshWithRequest:andPageIndex:)]) {
        tableView.footer = [JJRefreshView loadUpPullViewWithBlock:^{
        [self.dataSource upPullRefreshWithRequest:tableView andPageIndex:tableView.tag];
        }];
    }
}

- (void)setupTitleBtnScrollModelWithBtnIndex:(NSInteger)index andOffsetWithFrameX:(CGFloat)margin andTableViewIndex:(NSInteger)i
{
    CGFloat scale = 1 - margin / self.jj_width;
    JJTitleBtn *titleBtn = self.titleBar.subviews[index];
    switch (self.titleScrollStyle) {
        case JJInfiniteTitleBarScrollStyleNone:
            break;
            
        case JJInfiniteTitleBarScrollStyleSwell:
            if (scale < 0) break;
            titleBtn.transform = CGAffineTransformMakeScale(scale * 0.3 + 1, scale * 0.3 + 1);
            titleBtn.textColor = [UIColor colorWithRed:scale green:0 blue:0 alpha:1];
            break;
            
        case JJInfiniteTitleBarScrollStyleCharFlow:

            if (self.scrollDirection == ScrollDirectionRight) {
                if (i == 2) {
                    titleBtn.progress = scale;
                    titleBtn.fillColor = [UIColor redColor];
                }
                if ( i == 1) {
                    titleBtn.progress = 1 - scale;
                    titleBtn.fillColor = [UIColor blackColor];
                }
                
            }else{
                
                if (i == 0) {
                    titleBtn.fillColor = [UIColor blackColor];
                    titleBtn.textColor = [UIColor redColor];
                    titleBtn.progress = 1 - scale;
                }else if (i == 1){
                    titleBtn.fillColor = [UIColor redColor];
                    titleBtn.textColor = [UIColor blackColor];
                    titleBtn.progress = scale;
                }
            }
            
            break;
            
        case JJInfiniteTitleBarScrollStyleShaowFlow:
            break;
            
        case JJInfiniteTitleBarScrollStyleHeadColorFlow:
            break;
            
        default:
            break;
    }

}

#pragma mark ------------------------------------------
#pragma mark 事件监听
- (void)titleBtnDidClicked
{
    [self reloadSelf];
}

#pragma mark ------------------------------------------
#pragma mark 关闭无限滚动情况下, 有抽屉效果配置
- (void)pan:(UIPanGestureRecognizer *)pan
{
    if (pan.state == UIGestureRecognizerStateEnded) {
        if (self.scrollView.contentOffset.x < 0) {
            [self locateLeftDrawerViewEndDecelerating];
        }
        if (self.scrollView.contentOffset.x > self.jj_width * 2) {
            [self locateRightDrawerViewEndDecelerating];
        }
    }
    
    CGPoint transP = [pan translationInView:pan.view];
    pan.view.transform = CGAffineTransformTranslate(pan.view.transform, transP.x, 0);
    
    if (self.titleBar.currentPage == 0) {
        
        if (pan.view.jj_x < 0) {
            pan.view.jj_x = 0;
        }
        if (pan.view.jj_x > self.scrollView.contentInset.left) {
            pan.view.jj_x = self.scrollView.contentInset.left;
        }
        self.scrollView.contentOffset = CGPointMake(-pan.view.jj_x, 0);
    }else{
        if (pan.view.jj_x > 0) {
            pan.view.jj_x = 0;
        }
        if (pan.view.jj_x < -self.scrollView.contentInset.right) {
            pan.view.jj_x = -self.scrollView.contentInset.right;
        }
        self.scrollView.contentOffset = CGPointMake(self.jj_width * 2 - pan.view.jj_x, 0);
    }
    
    [pan setTranslation:CGPointZero inView:pan.view];
}

// closeInfiniteView == YES
- (void)setupLeftForFirst
{
    // 刷新第0个tableView
    self.scrollView.contentOffset = CGPointZero;
    self.titleBar.currentPage = 0;
    
    for (UITableView *tableView in self.scrollView.subviews) {
        NSInteger index = tableView.jj_x / self.jj_width;
        tableView.tag = index;
        if (index == 0) {
            NSString *key = [NSString stringWithFormat:@"%zd", tableView.tag];
            if ([self.tableViewIsLoaded[key] boolValue] == NO) {
                [self.dataSource loadDataWithRequest:tableView andPageIndex:tableView.tag];
                    
                [self requestWithUpDownRefresh:tableView];
            
                self.tableViewIsLoaded[key] = @(YES);
            }else {
                [tableView reloadData];
                [self requestWithUpDownRefresh:tableView];
            }

            [self setupTableViewMemoryContentOffset:tableView];
            self.currentPage = tableView.tag;
        }
    }
}
// closeInfiniteView == YES
- (void)setupRightForLast
{
    // 刷新最后1个tableView
    self.scrollView.contentOffset = CGPointMake(self.jj_width * 2, 0);
    // 这里要设置下 currentPage, 和上面0的时候一样
    self.titleBar.currentPage = self.titleBar.numberOfPages - 1;
    
    for (UITableView *tableView in self.scrollView.subviews) {
        NSInteger index = tableView.jj_x / self.jj_width;
        tableView.tag = index + self.titleBar.numberOfPages - 3;
        if (index == 2) {
            NSString *key = [NSString stringWithFormat:@"%zd", tableView.tag];
            if ([self.tableViewIsLoaded[key] boolValue] == NO) {
                [self.dataSource loadDataWithRequest:tableView andPageIndex:tableView.tag];
                    
                [self requestWithUpDownRefresh:tableView];
                
                self.tableViewIsLoaded[key] = @(YES);
            }else {
                self.markForNonLoadAndNonCurPage = NO;
                [tableView reloadData];
                [self requestWithUpDownRefresh:tableView];
            }
            
            [self setupTableViewMemoryContentOffset:tableView];
            self.currentPage = tableView.tag;
        }
    }

}

- (void)setupTableViewMemoryContentOffset:(UITableView *)tableView
{
    // 还原tableView原来的偏移量
    NSString *key = [NSString stringWithFormat:@"%zd", tableView.tag];
    CGPoint oriPoint = [self.tableViewMemoryContentOffset[key] CGPointValue];
#warning 设置offset无效问题
    // 这一步是解决设置 contentInset 没效果的 bug, 我也不知道为什么...(看115行)
    if (oriPoint.y == 0) {
        oriPoint =  CGPointMake(0, -tableView.jj_insetT);
    }
    tableView.contentOffset = oriPoint;

}

- (void)locateLeftDrawerViewEndDecelerating
{
    if (self.scrollView.contentOffset.x <= -self.scrollView.contentInset.left * 0.5) {
        [self.scrollView setContentOffset:CGPointMake(-self.scrollView.contentInset.left, 0) animated:YES];
    }else{
        [self.scrollView setContentOffset:CGPointZero animated:YES];
        self.scrollView.userInteractionEnabled = YES;
    }
}

- (void)locateRightDrawerViewEndDecelerating
{
    if (self.scrollView.contentOffset.x >= self.scrollView.contentInset.right * 0.5 + self.jj_width * 2) {
        [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentInset.right + self.jj_width * 2, 0) animated:YES];
    }else{
        [self.scrollView setContentOffset:CGPointMake(self.jj_width * 2, 0) animated:YES];
        self.scrollView.userInteractionEnabled = YES;
    }
}
#pragma mark ------------------------------------------
#pragma mark lazy load
- (NSMutableDictionary *)tableViewMemoryContentOffset
{
    if (!_tableViewMemoryContentOffset) {
        _tableViewMemoryContentOffset = [NSMutableDictionary dictionary];
    }
    return _tableViewMemoryContentOffset;
}

- (NSMutableDictionary *)tableViewIsLoaded
{
    if (!_tableViewIsLoaded) {
        _tableViewIsLoaded = [NSMutableDictionary dictionary];
    }
    return _tableViewIsLoaded;
}

- (UIToolbar *)darkView
{
    if (!_darkView) {
        UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:self.bounds];
        toolBar.barStyle = UIBarStyleBlack;
        toolBar.alpha = 0;
        [self addSubview:toolBar];
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
        [toolBar addGestureRecognizer:pan];
        _darkView = toolBar;
        self.pan = pan;
    }
    return _darkView;
}
// left
- (UIView *)leftDrawerView
{
    if (!_leftDrawerView) {
        if ([self.delegate respondsToSelector:@selector(leftDrawerViewWithInfiniteTableView:)]){
            
            UIView *leftDrawerView = [self.delegate leftDrawerViewWithInfiniteTableView:self];
            [self insertSubview:leftDrawerView belowSubview:self.scrollView];
            leftDrawerView.frame = CGRectMake(-leftDrawerView.jj_width, 0, leftDrawerView.jj_width, leftDrawerView.jj_height);
            if (self.adjustNavbar == YES) {
                leftDrawerView.jj_y += navBarHeight;
            }
            CGFloat leftDrawerWidth = leftDrawerView.jj_width;
            if ([self.delegate respondsToSelector:@selector(widthForLeftDrawerViewWithInfiniteTableView:)]) {
                leftDrawerWidth = [self.delegate widthForLeftDrawerViewWithInfiniteTableView:self];
            }
            if (leftDrawerWidth <= 0) leftDrawerWidth = 0;
            if (leftDrawerWidth >self.jj_width) leftDrawerWidth = self.jj_width;
            self.scrollView.contentInset = UIEdgeInsetsMake(0, leftDrawerWidth, 0, 0);
            _leftDrawerView = leftDrawerView;
        }
    }
    return _leftDrawerView;
}
// right
- (UIView *)rightDrawerView
{
    if (!_rightDrawerView) {
        if ([self.delegate respondsToSelector:@selector(rightDrawerViewWithInfiniteTableView:)]){
            
            UIView *rightDrawerView = [self.delegate rightDrawerViewWithInfiniteTableView:self];
            [self insertSubview:rightDrawerView belowSubview:self.scrollView];
            rightDrawerView.frame = CGRectMake(self.jj_width, 0, rightDrawerView.jj_width, rightDrawerView.jj_height);
            if (self.adjustNavbar == YES) {
                rightDrawerView.jj_y += navBarHeight;
            }
            NSLog(@"%@", NSStringFromCGRect(rightDrawerView.frame));
            CGFloat rightDrawerWidth = rightDrawerView.jj_width;
            if ([self.delegate respondsToSelector:@selector(widthForRightDrawerViewWithInfiniteTableView:)]) {
                rightDrawerWidth = [self.delegate widthForRightDrawerViewWithInfiniteTableView:self];
            }
            if (rightDrawerWidth <= 0) rightDrawerWidth = 0;
            if (rightDrawerWidth >self.jj_width) rightDrawerWidth = self.jj_width;
            self.scrollView.contentInset = UIEdgeInsetsMake(0, self.scrollView.jj_insetL, 0, rightDrawerWidth);
            _rightDrawerView = rightDrawerView;
        }
    }
    return _rightDrawerView;
}

- (NSInteger)pageCount
{
    if (_pageCount == 0) {
        _pageCount = [self.dataSource numberOfItemsAtInfiniteTableView:self];
        self.titleBar.numberOfPages = _pageCount;
    }
    return _pageCount;
}
@end
