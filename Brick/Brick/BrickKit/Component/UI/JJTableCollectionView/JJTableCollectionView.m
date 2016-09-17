//
//  JJTableCollectionView.m
//  JJTableCollectionView
//
//  Created by jxf on 16/2/18.
//  Copyright © 2016年 JJ.sevn. All rights reserved.
//

#import "JJTableCollectionView.h"
#import "JJTableCollectionCell.h"

@interface JJTableCollectionView ()<UICollectionViewDataSource, UICollectionViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, weak) UICollectionView * collectionView;
@property(nonatomic, weak) UICollectionViewFlowLayout * flowLayout;
@property(nonatomic, weak) UITableView * curPageTableView;
@property(nonatomic, weak) JJTitleBar * titleBar;
@property(nonatomic, strong) NSMutableDictionary * tableViewMemoryContentOffset;

@end

@implementation JJTableCollectionView

+ (instancetype)tableCollectionView
{
    return [[self alloc] init];
}

static NSString * const tableCollectionViewId = @"tableCollectionViewId";
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initTableCollectionView];
    }
    return self;
}

- (void)awakeFromNib
{
    [self initTableCollectionView];
}

- (void)initTableCollectionView
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 0;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.pagingEnabled = YES;
    collectionView.bounces = NO;
    
    [collectionView registerClass:[JJTableCollectionCell class] forCellWithReuseIdentifier:tableCollectionViewId];
    [self addSubview:collectionView];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    self.collectionView = collectionView;
    self.flowLayout = flowLayout;
    
    JJTitleBar *titleBar = [[JJTitleBar alloc] init];
    [self addSubview:titleBar];
    self.titleBar = titleBar;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(titleBtnDidClicked) name:JJTitleBarBtnDidClicked object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:JJTitleBarBtnDidClicked object:nil];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.collectionView.frame = self.bounds;
    self.flowLayout.itemSize = self.collectionView.frame.size;
    
    //titleBar
    if (self.titleBarHeight == 0) {
        self.titleBarHeight = 35;
    }
    self.titleBar.frame = CGRectMake(0, 0, self.frame.size.width, self.titleBarHeight);

}


#pragma mark ------------------------------------------
#pragma mark UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.dataSource tableCollectionView:self numberOfItemsInSection:0];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JJTableCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:tableCollectionViewId forIndexPath:indexPath];
    cell.tableView.delegate = self;
    cell.tableView.dataSource = self;
    cell.tableView.contentInset = UIEdgeInsetsMake(self.titleBar.frame.size.height, 0, 0, 0);
    return cell;
}

#pragma mark ------------------------------------------
#pragma mark UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.titleBar.currentPage = indexPath.item;
    JJTableCollectionCell * currentShowItem = (JJTableCollectionCell *)cell;
    self.curPageTableView = currentShowItem.tableView;
    // 还原 tableView 的之前的偏移量
    NSString *key = [NSString stringWithFormat:@"%zd", self.titleBar.currentPage];
    CGPoint oriPoint = [self.tableViewMemoryContentOffset[key] CGPointValue];
    if (oriPoint.y == 0) {
        oriPoint =  CGPointMake(0, -self.titleBar.frame.size.height);
    }
    self.curPageTableView.contentOffset = oriPoint;
    [currentShowItem.tableView reloadData];
}

#pragma mark ------------------------------------------
#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSource tableCollectionView:self numberOfCellsInCollectionItem:self.titleBar.currentPage];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.dataSource tableCollectionView:self andTableView:self.curPageTableView cellForRowAtIndexPath:indexPath andItemIndex:self.titleBar.currentPage];
}

#pragma mark ------------------------------------------
#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"selected----%zd", indexPath.row);
}

#pragma mark ------------------------------------------
#pragma mark UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self dealWhenScrollViewEndDraggingOrEndDecelerate:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate) {
        [self dealWhenScrollViewEndDraggingOrEndDecelerate:scrollView];
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
    }
}

- (void)titleBtnDidClicked
{
    
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.titleBar.currentPage inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
}

#pragma mark ------------------------------------------
#pragma mark set/get

- (NSMutableDictionary *)tableViewMemoryContentOffset
{
    if (!_tableViewMemoryContentOffset) {
        _tableViewMemoryContentOffset = [NSMutableDictionary dictionary];
    }
    return _tableViewMemoryContentOffset;
}
@end
