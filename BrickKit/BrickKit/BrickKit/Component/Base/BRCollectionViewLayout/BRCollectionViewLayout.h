//
//  BRCollectionViewLayout.h
//  BrickKit
//
//  Created by jinxiaofei on 16/7/10.
//  Copyright © 2016年 JJ.sevn. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BRCollectionViewLayout;

typedef NS_ENUM(NSUInteger, BRCollectionViewLayoutScrollDirection) {
    BRCollectionViewLayoutScrollDirectionVertical,
    BRCollectionViewLayoutScrollDirectionHorizontal,
};

typedef NS_ENUM(NSUInteger, BRCollectionViewLayoutType) {
    BRCollectionViewLayoutTypeHorizontal,
    BRCollectionViewLayoutTypeVertical,
    BRCollectionViewLayoutTypeCustom,
};

@protocol BRCollectionViewLayoutDalegate <UICollectionViewDelegateFlowLayout>

@optional
/** item高度, 相对值, 为布局方向的高度, 宽度通过columnCount自动计算*/
- (CGFloat)collectionView:(UICollectionView *)collectionView flowLayout:(BRCollectionViewLayout *)layout heightForItemAtIndexPath:(NSIndexPath *)indexPath;
/** header高度, 原则同上*/
- (CGFloat)collectionView:(UICollectionView *)collectionView flowLayout:(BRCollectionViewLayout *)layout heightForHeaderAtSection:(NSInteger)section;
/** footer高度, 原则同上*/
- (CGFloat)collectionView:(UICollectionView *)collectionView flowLayout:(BRCollectionViewLayout *)layout heightForFooterAtSection:(NSInteger)section;
/** section边距, 绝对值, 不区分布局方向*/
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView flowLayout:(BRCollectionViewLayout *)layout insetsForSection:(NSInteger)section;

/** 自定义section布局的列数或行数, 当前section是水平布局, 则返回值是列数, 如果section布局是垂直布局, 则返回值是行数*/
- (NSInteger)collectionView:(UICollectionView *)collectionView flowLayout:(BRCollectionViewLayout *)layout columnCountAtSection:(NSInteger)section;

/** 自定义section布局类型,如果当前布局的方向和滚动方向不相同或者是customsection, 则需要实现'collectionView:flowLayout:heightForSectionIfNeed:'协议方法, 返回section的高度值, */
- (BRCollectionViewLayoutType)collectionView:(UICollectionView *)collectionView flowLayout:(BRCollectionViewLayout *)layout layoutTypeAtSection:(NSInteger)section;
/**
 *  如果当前布局的方向和滚动方向不相同或者是customsection, 则需要实现此协议方法, 返回section的高度值
 *  exp:垂直滚动, 水平布局, 如果想在某个section设置为垂直布局, 则此section必须返回高度值, 否则section不显示
 *
 *  @param collectionView collectionView
 *  @param layout         layout
 *  @param section        section
 *
 *  @return section 布局的高度(不包括header)
 */
- (CGFloat)collectionView:(UICollectionView *)collectionView flowLayout:(BRCollectionViewLayout *)layout heightForSectionIfNeed:(NSInteger)section;
/**
 *  自定义section布局, 实现此协议方法, 并布局
 *
 *  @param collectionView collectionView
 *  @param layout         layout
 *  @param customRect     customRect : 预留的section区域, 不包括header和footer, 在此区域实现自定义布局
 *  @param section        section
 */
- (void)collectionView:(UICollectionView *)collectionView flowLayout:(BRCollectionViewLayout *)layout customLayoutRect:(CGRect)customRect forSection:(NSInteger)section;
@end
  
@interface BRCollectionViewLayout : UICollectionViewLayout

@property(nonatomic, assign) NSInteger columnCount;   //相对值, 水平布局的纵向列数, 或垂直布局的横向行数

@property(nonatomic, assign) CGFloat itemHeight;       //相对值, item为布局方向的高度, 宽度通过columnCount自动计算

/** 行间距, 列间距为相对值, 布局方向同向为列, 垂直为行*/
@property(nonatomic, assign) CGFloat rowMargin;    //行间距, 相对值
@property(nonatomic, assign) CGFloat columnMargin; //列间距, 相对值

@property(nonatomic, assign) UIEdgeInsets sectionEdgeInsets;//绝对值, 不区分布局方向
@property(nonatomic, assign) BOOL edgeInsetsOnlyForItems; //设置后则只对item有效, header/footer无效

@property(nonatomic, assign) BOOL reloadWithoutClear; //设为YES, 不会clear之前的布局信息,只会布局新增的. NO, 会clear所有布局信息, 重新布局

@property(nonatomic, assign) BRCollectionViewLayoutScrollDirection scrollDirection;
@property(nonatomic, assign) BRCollectionViewLayoutType layoutType;
@property(nonatomic, strong) UICollectionViewLayout * customLayout; //for BRCollectionViewLayoutTypeCustom

@property(nonatomic, assign) CGFloat layoutLenght;//布局高度的阈值, 首次布局布局此长度布局, 否则超出再布局
@end
