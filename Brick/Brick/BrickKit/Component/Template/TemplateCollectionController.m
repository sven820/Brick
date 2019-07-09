//
//  TemplateCollectionController.m
//  YXY
//
//  Created by jinxiaofei on 16/11/13.
//  Copyright © 2016年 Guangzhou TalkHunt Information Technology Co., Ltd. All rights reserved.
//

#import "TemplateCollectionController.h"

@interface TemplateCollectionController ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@end

@implementation TemplateCollectionController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self drawViews];
    [self configActionForViews];
}
- (void)updateViewConstraints
{
    [self makeConstraints];
    [super updateViewConstraints];
}
- (void)configActionForViews
{
    
}
#pragma mark - draw views
- (void)drawViews
{
    [self.view addSubview:self.collectionView];
}

- (void)makeConstraints
{
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        __weak UIView *superView = self.collectionView.superview;
//        make.top.equalTo(self.navBar.mas_bottom);
        make.left.right.bottom.equalTo(superView);
    }];
}

#pragma mark - protocol
#pragma mark UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataSource.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([UICollectionViewCell class]) forIndexPath:indexPath];
    
    return cell;
}

#pragma mark UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark UICollectionViewDelegateFlowLayout
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath

#pragma mark - public

#pragma mark - action
//- (void)actionForRefrsh {}
//- (void)actionForLoadMore {}

#pragma mark - private

#pragma mark - setter

#pragma mark - getter

- (UICollectionView *)collectionView
{
    if (!_collectionView)
    {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.itemSize = CGSizeMake(120, 120);
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        flowLayout.minimumLineSpacing = 8;
        flowLayout.minimumInteritemSpacing = 8;
        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([UICollectionViewCell class])];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.contentInset = UIEdgeInsetsMake(0, 10, 0, 10);
        
        //refresh
//        [_collectionView addTargetForRefresh:self sel:@selector(actionForRefresh)];
//        [_collectionView addTargetForLoadMore:self sel:@selector(actionForLoadMore)];
        
    }
    return _collectionView;
}
- (NSMutableArray *)dataSource
{
    if (!_dataSource)
    {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
@end
