//
//  BRMessageSessionDemoController.m
//  Brick
//
//  Created by jinxiaofei on 16/9/22.
//  Copyright © 2016年 jinxiaofei. All rights reserved.
//

#import "BRMessageSessionDemoController.h"
#import "YXYChatCell.h"
#import "TestView.h"

@interface BRMessageSessionDemoController ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) TestView *v;
@end

@implementation BRMessageSessionDemoController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    
//    [self drawViews];
//    [self makeContraints];
    
    self.v = [[TestView alloc]init];
    [self.view addSubview:self.v];
    self.v.frame = CGRectMake(0, 100, 350, 400);
}

//- (void)updateViewConstraints
//{
////    [self.v mas_makeConstraints:^(MASConstraintMaker *make) {
////        __weak UIView *superView = self.v.superview;
////        make.edges.equalTo(superView).width.insets(UIEdgeInsetsMake(50, 50, 50, 50));
////    }];
//    [super updateViewConstraints];
//}

- (void)dealloc
{
    NSLog(@"BRMessageSessionDemoController");
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
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    YXYChatCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([YXYChatCell class]) forIndexPath:indexPath];
    YXYChatCellAttributes *attr = [[YXYChatCellAttributes alloc] init];
    attr.cellType = arc4random_uniform(2);
    attr.name = @"xxxx";
    attr.avatarImageUrl = [NSURL URLWithString:@"http://e.hiphotos.baidu.com/image/h%3D200/sign=5f6ab3f5d00735fa8ef049b9ae500f9f/29381f30e924b8995d7368d66a061d950b7bf695.jpg"];
//    attr.text = @"sjfljskfdjlsjfl";
//    attr.contentType = YXYChatCellContentTypeText;
    [cell configWithCellAttributes:attr];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    YXYChatCellAttributes *attr = [[YXYChatCellAttributes alloc] init];
    attr.cellType = arc4random_uniform(2);
    attr.name = @"xxxx";
    attr.avatarImageUrl = [NSURL URLWithString:@"http://e.hiphotos.baidu.com/image/h%3D200/sign=5f6ab3f5d00735fa8ef049b9ae500f9f/29381f30e924b8995d7368d66a061d950b7bf695.jpg"];
//    attr.text = @"sjfljskfdjlsjfl";
    CGFloat height = [YXYChatCell caculateCellHeightWithAttributes:attr];
    
    return CGSizeMake(self.view.bounds.size.width, 66);
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
        [_collectionView registerClass:[YXYChatCell class] forCellWithReuseIdentifier:NSStringFromClass([YXYChatCell class])];
        
    }
    return _collectionView;
}
@end
