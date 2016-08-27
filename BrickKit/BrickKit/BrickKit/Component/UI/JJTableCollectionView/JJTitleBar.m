//
//  JJTitleBar.m
//  JJTableCollectionView
//
//  Created by jxf on 16/2/24.
//  Copyright © 2016年 JJ.sevn. All rights reserved.
//

#import "JJTitleBar.h"
#import "JJTitleBtn.h"

NSString * const JJTitleBarBtnDidClicked = @"JJTitleBarBtnDidClicked";

@interface JJTitleBar ()
@property(nonatomic, weak) UIScrollView * scrollView;
@property(nonatomic, weak) JJTitleBtn * curPageTitleBtn;
@end

@implementation JJTitleBar
#pragma mark ------------------------------------------
#pragma mark init
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        UIScrollView *scrollView = [[UIScrollView alloc] init];
        scrollView.bounces = NO;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        [self addSubview:scrollView];
        self.scrollView = scrollView;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.scrollView.frame = self.bounds;
    CGFloat titleBtnW = 100;
    self.scrollView.contentSize = CGSizeMake(titleBtnW * self.numberOfPages, 0);
    
    CGFloat titleBtnH = self.scrollView.frame.size.height;
    CGFloat titleBtnY = 0;
    NSInteger i = 0;
    for (JJTitleBtn *titleBtn in self.scrollView.subviews) {
        titleBtn.frame = CGRectMake(titleBtnW * i, titleBtnY, titleBtnW, titleBtnH);
        i++;
    }
}

#pragma mark ------------------------------------------
#pragma mark other methods
- (void)titleBtnDidClicked:(UITapGestureRecognizer *)tap
{
    self.currentPage = tap.view.tag;
    [[NSNotificationCenter defaultCenter] postNotificationName:JJTitleBarBtnDidClicked object:nil userInfo:nil];
    JJTitleBtn *curPageTitleBtn = (JJTitleBtn *)tap.view;
    [self setupTitleBtnWithClickedBtn:curPageTitleBtn];
}

- (void)setupTitleBtnWithClickedBtn:(JJTitleBtn *)curPageTitleBtn

{
    self.curPageTitleBtn.textColor = [UIColor blackColor];
    curPageTitleBtn.textColor = [UIColor redColor];
    // 设置居中
    CGFloat offsetX = curPageTitleBtn.center.x - self.scrollView.frame.size.width * 0.5;
    if (offsetX < 0) {
        offsetX = 0;
    }
    CGFloat maxOffsetX = self.scrollView.contentSize.width - self.scrollView.frame.size.width;
    if (offsetX > maxOffsetX) {
        offsetX = maxOffsetX;
    }
    [self.scrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
    
    self.curPageTitleBtn = curPageTitleBtn;
}


#pragma mark ------------------------------------------
#pragma mark set/get
- (void)setTitles:(NSArray *)titles
{
    _titles = titles;
    self.numberOfPages = titles.count;
    for (int i = 0; i < self.numberOfPages; i++) {
        JJTitleBtn  *titleBtn = [[JJTitleBtn alloc] init];
        titleBtn.tag = i;
        titleBtn.text = self.titles[i];
        titleBtn.textColor = [UIColor blackColor];
        titleBtn.backgroundColor = [UIColor yellowColor];
        [titleBtn addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(titleBtnDidClicked:)]];
        [self.scrollView addSubview:titleBtn];
    }
}

- (void)setCurrentPage:(NSInteger)currentPage
{
    _currentPage = currentPage;
    JJTitleBtn *curPageTitleBtn = self.scrollView.subviews[currentPage];
    [self setupTitleBtnWithClickedBtn:curPageTitleBtn];
}
@end
