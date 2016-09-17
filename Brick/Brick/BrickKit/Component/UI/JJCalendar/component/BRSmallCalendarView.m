//
//  BRSmallCalendarView.m
//  BrickKit
//
//  Created by jinxiaofei on 16/7/7.
//  Copyright © 2016年 JJ.sevn. All rights reserved.
//

#import "BRSmallCalendarView.h"
#import "BRCalendarCell.h"

static NSString * const kSmallCollectionCellIdentify = @"kSmallCollectionCellIdentify";

@interface BRSmallCalendarView ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property(nonatomic, strong) UICollectionView * collectionView;
@property(nonatomic, strong) NSArray * models;
@end

@implementation BRSmallCalendarView

+ (instancetype)createSmallCallendarView
{
    BRSmallCalendarView *smallCalendar = [[BRSmallCalendarView alloc] init];
    return smallCalendar;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self drawViews];
        self.backgroundColor = [UIColor yellowColor];
    }
    return self;
}

- (void)reloadWithModels:(NSArray<BRCalendarModel *> *)models
{
    self.models = models;
    [self.collectionView reloadData];
}

#pragma mark - drawViews
- (void)drawViews
{
    [self addSubview:self.collectionView];
    
    [self makeContraints];
}

#pragma mark - make contraints
- (void)makeContraints
{
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        __weak UIView *superView = self.collectionView.superview;
        make.edges.equalTo(superView);
    }];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.models.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BRCalendarCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kSmallCollectionCellIdentify forIndexPath:indexPath];
    BRCalendarModel *model = self.models[indexPath.item];
    [cell configureCellWithModel:model];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BRCalendarModel *model = self.models[indexPath.item];
    return model.cellSize;
}

#pragma mark - getter
- (UICollectionView *)collectionView
{
    if (!_collectionView)
    {
        UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:[BRCalendarCell class] forCellWithReuseIdentifier:kSmallCollectionCellIdentify];
    }
    return _collectionView;
}

@end
