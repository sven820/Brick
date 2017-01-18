//
//  MagicDemoViewController.m
//  Brick
//
//  Created by jinxiaofei on 16/9/6.
//  Copyright © 2016年 jinxiaofei. All rights reserved.
//

#import "MagicDemoViewController.h"
#import "UIView+Magic.h"

@interface MagicDemoViewController ()<BRMagicViewDataSource, BRMagicViewDelegate, BRMagicViewLayout>
@property(nonatomic, strong) UIView *magicView;


@property(nonatomic, assign) NSInteger columnCount;   //相对值, 水平布局的纵向列数, 或垂直布局的横向行数
@property(nonatomic, assign) CGFloat itemHeight;       //相对值, item为布局方向的高度, 宽度通过columnCount自动计算
@property(nonatomic, assign) UIEdgeInsets sectionEdgeInsets;//绝对值, 不区分布局方向
@property(nonatomic, assign) BRMagicViewLayoutScrollDirection scrollDirection;
@end

@implementation MagicDemoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.magicView = [[UIView alloc] init];
    [self.view addSubview:self.magicView];
    self.magicView.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64);
    self.magicView.backgroundColor = [UIColor lightGrayColor];
    [self.magicView registerItemViewClass:[UILabel class] forItemViewReuseIdentifier:@"header"];
    [self.magicView registerItemViewClass:[UILabel class] forItemViewReuseIdentifier:@"footer"];
    
    self.magicView.dataSource = self;
    self.magicView.delegate = self;
    self.magicView.layout = self;
    self.columnCount = 3;
    self.itemHeight = 49;
    self.sectionEdgeInsets = UIEdgeInsetsMake(0, 0, 10, 0);
//    self.scrollDirection = BRMagicViewLayoutScrollDirectionHorizontal;
    
    [self.magicView clickedWithHandleBlock:^(UIView *clickedView) {
        NSLog(@"click self");
    }];
    
    //测试手势触发API
    UIScrollView *gesV = [[UIScrollView alloc] init];
    [self.view addSubview:gesV];

    gesV.backgroundColor = [UIColor blueColor];
    
    [gesV clickedWithHandleBlock:^(UIView *clickedView) {
        NSLog(@"click handle");
    }];
    [gesV doubleClickedWithHandleBlock:^(UIView *clickedView) {
        NSLog(@"doubleClick handle");
    }];
    [gesV longPressWithHandleBlock:^(UIView *clickedView) {
        NSLog(@"longPress handle");
    }];
    gesV.frame = CGRectMake(0, 567, self.view.frame.size.width, 0);
    
}

#pragma mark - BRMagicViewDataSource
- (NSInteger)numberOfSections:(UIView *)magicView
{
    return 5;
}
- (NSInteger)magicView:(UIView *)magicView numberOfItemsInSection:(NSInteger)section
{
    return 30;
}

- (UIView *)magicView:(UIView *)magicView headerAtSection:(NSInteger)section
{
    UILabel *header = (UILabel *)[magicView dequeueReusableItemViewWithIdentifier:@"header"];
    header.text = [NSString stringWithFormat:@"第%zd组-header", section];
    header.backgroundColor = [UIColor darkGrayColor];
    return header;
}

- (UIView *)magicView:(UIView *)magicView footerAtSection:(NSInteger)section
{
    UILabel *footer = (UILabel *)[magicView dequeueReusableItemViewWithIdentifier:@"footer"];
    footer.text = [NSString stringWithFormat:@"第%zd组-footer", section];
    footer.backgroundColor = [UIColor darkGrayColor];
    footer.textAlignment = NSTextAlignmentRight;
    return footer;
}

- (UIView *)magicView:(UIView *)magicView itemAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}
#pragma mark - BRMagicViewLayout
- (CGFloat)magicView:(UIView *)magicView heightForHeaderAtSection:(NSInteger)section
{
    return 30;
}
- (CGFloat)magicView:(UIView *)magicView heightForFooterAtSection:(NSInteger)section
{
    return 30;
}
- (CGFloat)magicView:(UIView *)magicView heightForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return arc4random_uniform(88) + 44;
}
- (NSInteger)magicView:(UIView *)magicView columnCountAtSection:(NSInteger)section
{
    return 4;
}
- (BRMagicViewLayoutType)magicView:(UIView *)magicView layoutTypeAtSection:(NSInteger)section
{
    if (section % 3 == 0)
    {
        return BRMagicViewLayoutTypeHorizontal;
    }
    else if(section % 3 == 1)
    {
        return BRMagicViewLayoutTypeVertical;
    }
    else
    {
        return BRMagicViewLayoutTypeReverseRank;
    }
}
- (CGFloat)magicView:(UIView *)magicView heightForSectionIfNeed:(NSInteger)section
{
    return 300;
}
- (CGFloat)magicView:(UIView *)magicView widthForSectionIfNeed:(NSInteger)section
{
    return self.magicView.frame.size.width;
    
//    return self.magicView.frame.size.height - 10;
}

- (BOOL)magicView:(UIView *)magicView isNeedPageEnabledAtSectionIfNeed:(NSInteger)section
{
    return NO;
}
#pragma mark - BRMagicViewDelegate
- (void)magicView:(UIView *)magicView item:(UIView *)item didSelectedItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%zd---%zd", indexPath.section, indexPath.item);
}
- (void)magicView:(UIView *)magicView header:(UIView *)header didSelectedHeaderInSection:(NSInteger)section
{
    NSLog(@"header--%zd", section);
}
- (void)magicView:(UIView *)magicView footer:(UIView *)footer didSelectedFooterInSection:(NSInteger)section
{
    NSLog(@"footer--%zd", section);
}
@end
