//
//  JJPictureInfiniteView.m
//  PictureInfinite
//
//  Created by jxf on 16/2/21.
//  Copyright © 2016年 JJ.sevn. All rights reserved.
//

#import "YCFInfiniteView.h"

#pragma mark - YCFReusableItemManager
@interface YCFReusableItemManager : NSObject
@property(nonatomic, strong) NSString *identify;
@property(nonatomic, assign) Class class;

@property(nonatomic, strong) NSMutableSet *reusableItems;
@end

@implementation YCFReusableItemManager
@end

#pragma mark - YCFInfiniteViewItem
@implementation YCFInfiniteViewItem

@end

#pragma mark - YCFInfiniteView
@interface YCFInfiniteView ()<UIScrollViewDelegate>
@property(nonatomic, strong) UIScrollView * scrollView;
@property(nonatomic, weak) NSTimer * timer;
@property(nonatomic, strong) UIPageControl *pageControl;
@property(nonatomic, assign, getter=getNumberOfItems) NSInteger numberOfItems;

@property(nonatomic, strong) NSMutableArray<YCFReusableItemManager *> *reusableItems;
@end

@implementation YCFInfiniteView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.pageControlSize = CGSizeMake(100, 30);
        [self p_drawViews];
    }
    return self;
}

- (void)p_drawViews
{
    [self addSubview:self.scrollView];
    [self addSubview:self.pageControl];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.scrollView.frame = self.bounds;
    CGFloat itemViewW = self.scrollView.frame.size.width;
    CGFloat itemViewH = self.scrollView.frame.size.height;
    switch (self.scrollType)
    {
        case YCFInfiniteViewScrollHorizontal:
        {
            self.scrollView.contentSize = CGSizeMake(itemViewW * 3, 0);
            int index = 0;
            for (UIView *itemView in self.scrollView.subviews)
            {
                itemView.frame = CGRectMake(itemViewW * index, 0, itemViewW, itemViewH);
                index ++;
            }

            break;
        }
        case YCFInfiniteViewScrollVertical:
        {
            self.scrollView.contentSize = CGSizeMake(0, itemViewH * 3);
            int index = 0;
            for (UIView *itemView in self.scrollView.subviews)
            {
                itemView.frame = CGRectMake(0, itemViewH * index, itemViewW, itemViewH);
                index ++;
            }
            break;
        }
    }
    self.pageControl.frame = CGRectMake(self.frame.size.width - (self.pageControlSize.width + self.pageControlRightPadding), self.frame.size.height - (self.pageControlSize.height + self.pageControlBottomPadding), self.pageControlSize.width, self.pageControlSize.height);
    self.pageControl.numberOfPages = self.numberOfItems;
    
    [self reload];
    [self startTimer];
}

#pragma mark - punlic methods
- (void)registerItemViewClass:(Class)itemClass forItemViewReuseIdentifier:(NSString *)identifier
{
    YCFReusableItemManager *manager = [[YCFReusableItemManager alloc] init];
    manager.class = itemClass;
    manager.identify = identifier;
    [self.reusableItems addObject:manager];
}

- (UIView *)dequeueReusableItemViewWithIdentifier:(NSString *)identifier
{
    __block YCFInfiniteViewItem *reusableView = nil;
    for (YCFReusableItemManager *manager in self.reusableItems)
    {
        if ([manager.identify isEqualToString:identifier])
        {
            [manager.reusableItems enumerateObjectsUsingBlock:^(YCFInfiniteViewItem *itemView, BOOL * _Nonnull stop) {
                reusableView = itemView;
                *stop = YES;
            }];
        }
        if (reusableView)
        {
            [manager.reusableItems removeObject:reusableView];
            break;
        }
        else
        {
            reusableView = [[manager.class alloc] init];
            reusableView.identify = identifier;
        }
    }
    return reusableView;
}

- (void)reloadData
{
    _scrollView = nil;
    self.pageControl.currentPage = 0;
    [self stopTimer];
    [self p_drawViews];
    [self layoutSubviews];
}

- (void)scrollToPage:(NSInteger)page
{
    self.pageControl.currentPage = page;
    [self reload];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    UIImageView *curView = nil;
    CGFloat curViewMargin = MAXFLOAT;
    for (UIImageView *itemView in self.scrollView.subviews)
    {
        CGFloat margin;
        switch (self.scrollType) {
            case YCFInfiniteViewScrollHorizontal: {
                margin = ABS(itemView.frame.origin.x - scrollView.contentOffset.x);
                break;
            }
            case YCFInfiniteViewScrollVertical: {
                margin = ABS(itemView.frame.origin.y - scrollView.contentOffset.y);
                break;
            }
        }
        if (margin < curViewMargin)
        {
            curViewMargin = margin;
            curView = itemView;
        }
    }
    self.pageControl.currentPage = curView.tag;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self reload];
    [self startTimer];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self stopTimer];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self reload];
}

#pragma mark - other
- (void)reload
{
    NSInteger curPage = self.pageControl.currentPage;
    for (int i = 0; i < self.scrollView.subviews.count; i++)
    {
        UIImageView *itemContainerView = self.scrollView.subviews[i];
        for (UIView *view in itemContainerView.subviews)
        {
            if ([view isKindOfClass:[YCFInfiniteViewItem class]])
            {
                YCFInfiniteViewItem *itemView = (YCFInfiniteViewItem *)view;
                for (YCFReusableItemManager *manager in self.reusableItems)
                {
                    if ([manager.identify isEqualToString:itemView.identify])
                    {
                        [manager.reusableItems addObject:itemView];
                        [itemView removeFromSuperview];
                    }
                }
            }
        }
        NSInteger itemIndex = 0;
        if (!self.isNeedInfinite && (self.pageControl.currentPage == 0 || self.pageControl.currentPage == self.numberOfItems - 1))
        {
            if (self.pageControl.currentPage == 0)
            {
                itemIndex = i;
            }
            if (self.pageControl.currentPage == self.numberOfItems - 1)
            {
                itemIndex = self.numberOfItems - 3 + i;
            }
        }
        else
        {
            if (i == 1)
            {
                itemIndex = curPage;
            }
            else if (i == 0)
            {
                itemIndex = curPage - 1;
            }
            else
            {
                itemIndex = curPage + 1;
            }
            
            if (itemIndex == -1)
            {
                if (self.isNeedInfinite)
                {
                    itemIndex = self.numberOfItems - 1;
                }
                else
                {
                    itemIndex = 0;
                }
            }
            else if (itemIndex == self.numberOfItems)
            {
                if (self.isNeedInfinite)
                {
                    itemIndex = 0;
                }
                else
                {
                    itemIndex = self.numberOfItems;
                }
            }
        }
        
        YCFInfiniteViewItem *itemView = [self.delegate infiniteView:self itemViewAtIndex:itemIndex];

        [itemContainerView addSubview:itemView];
        itemView.frame = itemContainerView.bounds;
        itemContainerView.tag = itemIndex;
    }
    
    if (!self.isNeedInfinite && (self.pageControl.currentPage == 0 || self.pageControl.currentPage == self.numberOfItems - 1))
    {
       
    }
    else
    {
        switch (self.scrollType)
        {
            case YCFInfiniteViewScrollHorizontal:
            {
                self.scrollView.contentOffset = CGPointMake(self.scrollView.frame.size.width, 0);
                break;
            }
            case YCFInfiniteViewScrollVertical: {
                self.scrollView.contentOffset = CGPointMake(0, self.scrollView.frame.size.height);
                
                break;
            }
        }
    }
}

- (void)startTimer
{
    if (!_timer && self.isNeedTimer)
    {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:self.infiniteTime target:self selector:@selector(nextPage) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    }
}

- (void)stopTimer
{
    [self.timer invalidate];
    self.timer = nil;
}

- (void)nextPage
{
    switch (self.scrollType) {
        case YCFInfiniteViewScrollHorizontal: {
            [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentOffset.x + self.scrollView.frame.size.width, 0) animated:YES];
            break;
        }
        case YCFInfiniteViewScrollVertical: {
            [self.scrollView setContentOffset:CGPointMake(0, self.scrollView.contentOffset.y + self.scrollView.frame.size.height) animated:YES];
            break;
        }
    }
}

- (void)didClickedItem:(UITapGestureRecognizer *)tap
{
    if ([self.delegate respondsToSelector:@selector(infiniteView:didClickedItemViewAtIndex:)])
    {
        [self.delegate infiniteView:self didClickedItemViewAtIndex:tap.view.tag];
    }
}

#pragma mark - private methods

- (UIView *)p_getContainer
{
    UIView *container = [[UIView alloc] init];
    [container addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickedItem:)]];
    return container;
}

#pragma mark - getter
- (UIScrollView *)scrollView
{
    if (!_scrollView)
    {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.bounces = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
        _scrollView.backgroundColor = [UIColor lightGrayColor];
        
        for (int i = 0; i < 3; i ++)
        {
            UIView *container = [self p_getContainer];
            [_scrollView addSubview:container];
        }
    }
    return _scrollView;
}

- (UIPageControl *)pageControl
{
    if (!_pageControl)
    {
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.pageIndicatorTintColor = [UIColor purpleColor];
        _pageControl.currentPageIndicatorTintColor = [UIColor redColor];
    }
    return _pageControl;
}

- (NSMutableArray *)reusableItems
{
    if (!_reusableItems)
    {
        _reusableItems = [NSMutableArray array];
    }
    return _reusableItems;
}

- (NSInteger)getNumberOfItems
{
    return [self.delegate numberOfItemAtInfiniteView:self];
}
@end
