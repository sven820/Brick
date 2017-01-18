//
//  TemplateCollectionController.m
//  Brick
//
//  Created by jinxiaofei on 16/9/22.
//  Copyright © 2016年 jinxiaofei. All rights reserved.
//

#import "TemplateCollectionController.h"

@interface TemplateCollectionController ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation TemplateCollectionController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self drawViews];
    [self makeContraints];
}

#pragma mark - draw views
- (void)drawViews
{
    [self.view addSubview:self.collectionView];
}

- (void)makeContraints
{
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        __weak UIView *superView = self.collectionView.superview;
        make.top.equalTo(superView).offset(64);
        make.left.right.bottom.equalTo(superView);
    }];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeZero;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - getter
- (UICollectionView *)collectionView
{
    if (!_collectionView)
    {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.minimumLineSpacing = 10;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
//        [_collectionView registerClass:[YXYChatKindCell class] forCellWithReuseIdentifier:NSStringFromClass([YXYChatKindCell class])];
        
    }
    return _collectionView;
}

@end
