//
//  JJInfiniteTitleBar.m
//  TableViewInfinite
//
//  Created by jxf on 16/2/21.
//  Copyright © 2016年 JJ.sevn. All rights reserved.
//

#import "JJInfiniteTitleBar.h"
#import "JJTitleBtn.h"

NSString * const JJInfiniteTitleBarBtnDidClicked = @"JJInfiniteTitleBarBtnDidClicked";

@interface JJInfiniteTitleBar ()
@property(nonatomic, weak) JJTitleBtn * curPageTitleBtn;
//@property(nonatomic, weak) UIScrollView * scrollView;
@end

@implementation JJInfiniteTitleBar

#pragma mark ------------------------------------------
#pragma mark init methods
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.bounces = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat titleBtnH = self.frame.size.height;
    CGFloat titleBtnY = 0;
    NSInteger i = 0;
    for (JJTitleBtn *titleBtn in self.subviews) {
        titleBtn.frame = CGRectMake(self.titleWidth * i, titleBtnY, self.titleWidth, titleBtnH);
        i++;
    }
}

#pragma mark ------------------------------------------
#pragma mark other methods
- (void)titleBtnDidClicked:(UITapGestureRecognizer *)tap
{
    self.currentPage = tap.view.tag;
    // 添加点击通知
    [[NSNotificationCenter defaultCenter] postNotificationName:JJInfiniteTitleBarBtnDidClicked object:nil userInfo:nil];
    JJTitleBtn *clickedBtn = (JJTitleBtn *)tap.view;
    [self setupTitleBtnWithClickedBtn:clickedBtn];
}

- (void)setupTitleBtnWithClickedBtn:(JJTitleBtn *)curPageTitleBtn

{
    self.curPageTitleBtn.textColor = [UIColor blackColor];
    curPageTitleBtn.textColor = [UIColor redColor];
    // 设置居中
    CGFloat offsetX = curPageTitleBtn.center.x - self.frame.size.width * 0.5;
    if (offsetX < 0) {
        offsetX = 0;
    }
    CGFloat maxOffsetX = self.contentSize.width - self.frame.size.width;
    if (offsetX > maxOffsetX) {
        offsetX = maxOffsetX;
    }
    [self setContentOffset:CGPointMake(offsetX, 0) animated:YES];
    
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
        [self addSubview:titleBtn];
    }
    self.contentSize = CGSizeMake(self.titleWidth * _numberOfPages, 0);
}

- (void)setCurrentPage:(NSInteger)currentPage
{
    _currentPage = currentPage;
    JJTitleBtn *curPageTitleBtn = self.subviews[currentPage];
    [self setupTitleBtnWithClickedBtn:curPageTitleBtn];
}
@end
