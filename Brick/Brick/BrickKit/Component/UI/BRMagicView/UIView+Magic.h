//
//  UIView+Magic.h
//  Brick
//
//  Created by jinxiaofei on 16/9/5.
//  Copyright © 2016年 jinxiaofei. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MagicShadow;
// 布局 layout
// 数据 dataSource
// ..  delegate

// 结构: /item: /bg/gestureRecognizerView/container


/*to do
 2.按需加载attr
 3.reload, reload section, reload item
 5.优化, 增加attr休眠期, 优化通知
 6.高度缓存
 已完成: 
 
 4.sectionContainer 复用
 1.section 横向滚动效果
 */

typedef NS_ENUM(NSUInteger, BRMagicViewLayoutScrollDirection) {
    BRMagicViewLayoutScrollDirectionVertical,
    BRMagicViewLayoutScrollDirectionHorizontal,
};

typedef NS_ENUM(NSUInteger, BRMagicViewLayoutType) {
    BRMagicViewLayoutTypeHorizontal,
    BRMagicViewLayoutTypeVertical,
    BRMagicViewLayoutTypeReverseRank,//需要指定rank宽度(滚动方向长度)
    BRMagicViewLayoutTypeCustom,
};

typedef NS_ENUM(NSUInteger, MagicItemType) {
    MagicItemTypeItem = 0,
    MagicItemTypeHeader = -1000,
    MagicItemTypeFooter = -1001,
};


#pragma mark - BRMagicViewLayout
@protocol BRMagicViewLayout <NSObject>

@optional
@property(nonatomic, assign, readonly) NSInteger columnCount;   //相对值, 水平布局的纵向列数, 或垂直布局的横向行数
@property(nonatomic, assign, readonly) CGFloat itemHeight;       //相对值, item为布局方向的高度, 宽度通过columnCount自动计算

/** 行间距, 列间距为相对值, 布局方向同向为列, 垂直为行*/
@property(nonatomic, assign, readonly) CGFloat rowMargin;    //行间距, 相对值
@property(nonatomic, assign, readonly) CGFloat columnMargin; //列间距, 相对值

@property(nonatomic, assign, readonly) UIEdgeInsets sectionEdgeInsets;//绝对值, 不区分布局方向
@property(nonatomic, assign, readonly) BOOL edgeInsetsOnlyForItems; //设置后则只对item有效, header/footer无效

@property(nonatomic, assign, readonly) BOOL reloadWithoutClear; //设为YES, 不会clear之前的布局信息,只会布局新增的. NO, 会clear所有布局信息, 重新布局

@property(nonatomic, assign, readonly) BRMagicViewLayoutScrollDirection scrollDirection;
@property(nonatomic, assign, readonly) BRMagicViewLayoutType layoutType;
@property(nonatomic, strong, readonly) UICollectionViewLayout * customLayout; //for BRCollectionViewLayoutTypeCustom

@property(nonatomic, assign, readonly) CGFloat layoutLenght;//布局高度的阈值, 首次布局布局此长度布局, 否则超出再布局

/** item高度, 相对值, 为布局方向的高度, 宽度通过columnCount自动计算*/
- (CGFloat)magicView:(UIView *)magicView heightForItemAtIndexPath:(NSIndexPath *)indexPath;
/** header高度, 原则同上*/
- (CGFloat)magicView:(UIView *)magicView heightForHeaderAtSection:(NSInteger)section;
/** footer高度, 原则同上*/
- (CGFloat)magicView:(UIView *)magicView heightForFooterAtSection:(NSInteger)section;
/** section边距, 绝对值, 不区分布局方向*/
- (UIEdgeInsets)magicView:(UIView *)magicView insetsForSection:(NSInteger)section;

/** 自定义section布局的列数或行数, 当前section是水平布局, 则返回值是列数, 如果section布局是垂直布局, 则返回值是行数*/
- (NSInteger)magicView:(UIView *)magicView columnCountAtSection:(NSInteger)section;

/** 自定义section布局类型,如果当前布局的方向和滚动方向不相同或者是customsection, 则需要实现'collectionView:flowLayout:heightForSectionIfNeed:'协议方法, 返回section的高度值, */
- (BRMagicViewLayoutType)magicView:(UIView *)magicView layoutTypeAtSection:(NSInteger)section;
/**
 *  exp:垂直滚动, 水平布局, 如果想在某个section设置为垂直布局, 则此section必须返回高度值(滚动方向的长度), 否则section不显示
 *  exp:水平滚动, 垂直布局, 如果想在某个section设置为水平布局, 则此section必须返回高度值(滚动方向的长度), 否则section不显示
 *
 *  @param magicView magicView
 *  @param section        section
 *
 *  @return section 布局的高度(不包括header)
 */
- (CGFloat)magicView:(UIView *)magicView heightForSectionIfNeed:(NSInteger)section;
/**
 *  exp:垂直滚动, 水平布局, 如果想在某个section设置为垂直布局且水平排列, 则此section必须上面代理方法中返回高度值, 此代理方法中返回水平排列的宽度, 否则section不显示
 *  exp:水平滚动, 垂直布局, 如果想在某个section设置为水平布局且垂直排列, 则此section必须上面代理方法中返回高度值, 此代理方法中返回垂直排列的宽度, 否则section不显示
 *
 *  @param magicView magicView
 *  @param section        section
 *
 *  @return section 布局的高度(不包括header)
 */

- (CGFloat)magicView:(UIView *)magicView widthForSectionIfNeed:(NSInteger)section;
//当sectionContainer可以滚动时候是否需要分页功能
- (BOOL)magicView:(UIView *)magicView isNeedPageEnabledAtSectionIfNeed:(NSInteger)section;

/**
 *  自定义section布局, 实现此协议方法, 并布局
 *
 *  @param magicView magicView
 *  @param customRect     customRect : 预留的section区域, 不包括header和footer, 在此区域实现自定义布局
 *  @param section        section
 */
- (void)magicView:(UIView *)magicView customLayoutRect:(CGRect)customRect forSection:(NSInteger)section;

@end


#pragma mark - BRMagicViewDataSource
@protocol BRMagicViewDataSource <NSObject>

@optional
- (NSInteger)numberOfSections:(UIView *)magicView; //默认为1;
- (NSInteger)magicView:(UIView *)magicView numberOfItemsInSection:(NSInteger)section;

- (UIView *)magicView:(UIView *)magicView itemAtIndexPath:(NSIndexPath *)indexPath;
- (UIView *)magicView:(UIView *)magicView headerAtSection:(NSInteger)section;
- (UIView *)magicView:(UIView *)magicView footerAtSection:(NSInteger)section;
@end

#pragma mark - BRMagicViewDelegate
@protocol BRMagicViewDelegate <NSObject>

@optional
- (void)magicView:(UIView *)magicView item:(UIView *)item didSelectedItemAtIndexPath:(NSIndexPath *)indexPath;
- (void)magicView:(UIView *)magicView header:(UIView *)header didSelectedHeaderInSection:(NSInteger)section;
- (void)magicView:(UIView *)magicView footer:(UIView *)footer didSelectedFooterInSection:(NSInteger)section;
@end

#pragma mark - MagicSectionAttributes
@interface MagicSectionAttributes : NSObject
@property(nonatomic, assign) CGRect sectionFrame;
@property(nonatomic, assign) CGSize sectionContentSize;

@property(nonatomic, assign) BOOL pageEnabled;

@property(nonatomic, assign) NSInteger section;
@property(nonatomic, assign) BOOL isOnscreen;

@property(nonatomic, weak) UIView *father;
@property(nonatomic, weak) UIScrollView *son;//对应section的容器
@property(nonatomic, strong) NSMutableArray *grandSonAttrses;//包含的item

@property(nonatomic, assign) CGRect sectionContainerVisiableRect;
@property(nonatomic, assign) CGRect bigContainerVisiableRect;
@end
#pragma mark - MagicItemAttributes
@interface MagicItemAttributes : NSObject
@property(nonatomic, assign) CGRect frame;
@property(nonatomic, assign) CGRect sectionFrame;

@property(nonatomic, assign) CGPoint center;
@property(nonatomic, assign) CGSize size;
@property(nonatomic, assign) CATransform3D transform3D;
@property(nonatomic, assign) CGRect bounds;
@property(nonatomic, assign) CGAffineTransform transform ;
@property(nonatomic, assign) CGFloat alpha;
@property(nonatomic, assign) NSInteger zIndex;
@property(nonatomic, assign) BOOL hidden;

@property(nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, assign) MagicItemType kind;

@property(nonatomic, assign) BOOL isOnscreen;
#warning todo
@property(nonatomic, assign) BOOL isSleepy;
@property(nonatomic, weak) UIView *father;
@property(nonatomic, weak) UIView *son;//该attr对应的item
@property(nonatomic, weak) MagicSectionAttributes *sectionAttr;

@property(nonatomic, assign) CGRect bigContainerVisiableRect;
@property(nonatomic, assign) CGRect sectionContainerVisiableRect;
@end

#pragma mark - Magic
@interface UIView (Magic)
@property(nonatomic, weak, setter=setLayout:) id<BRMagicViewLayout> layout;
@property(nonatomic, weak, setter=setDataSource:) id<BRMagicViewDataSource> dataSource;
@property(nonatomic, weak, setter=setDelegate:) id<BRMagicViewDelegate> delegate;

//内部容器, 设置容器相关属性用这个, 比如滚动条, 分页...
@property(nonatomic, strong, readonly, getter=getContainerView) UIScrollView *containerView;
//bg view
@property(nonatomic, strong, setter=setBg:) UIView *bg;

//当前屏幕包含的item, 获取item/indexPath的话, MagicItemAttributes中有son/indexPath属性可以满足你的需求
@property(nonatomic, strong) NSMutableArray<MagicItemAttributes *> *screenItems;
@property(nonatomic, strong) NSMutableArray<MagicSectionAttributes *> *screenSections;

- (NSInteger)numberOfSections;
- (NSInteger)numberItemsInSection:(NSInteger)section;

#warning todo
@property(nonatomic, assign) MagicShadow *shadow; //描述一个magic view对象
- (NSArray *)filterItemWithShadow:(MagicShadow *)shadow;//信息越全, 找到的item越精确,越模糊, 找到的item越多

//注意这里只会返回屏幕里可见的item, 不可见的返回nil
- (UIView *)itemWithIndexPath:(NSIndexPath *)indexPath;
- (UIView *)headerWithSection:(NSInteger)section;
- (UIView *)footerWithSection:(NSInteger)section;

- (void)reloadData;

//注册和获取YCFInfiniteView view, 同UITableView
- (void)registerItemViewClass:(Class)itemClass forItemViewReuseIdentifier:(NSString *)identify;
- (UIView *)dequeueReusableItemViewWithIdentifier:(NSString *)identify;
@property(nonatomic, strong) NSString *identify;

@property(nonatomic, weak) MagicItemAttributes *attribute;

//注意处理循环引用
- (void)clickedWithHandleBlock:(void (^)(UIView *clickedView))clickHandle;
    //暂时不知怎么解决,双击必然触发单击, 且单击在前, 两个手势重叠, 超过两次也算是双击, 可以用到用户多次点击, alert提示
- (void)doubleClickedWithHandleBlock:(void (^)(UIView *clickedView))doubleClickHandle;
- (void)longPressWithHandleBlock:(void (^)(UIView *clickedView))longPressHandle;//长按多次移动会多次执行

@end

@interface MagicShadow : NSObject
@property(nonatomic, assign) NSInteger section;
@property(nonatomic, assign) NSInteger index;
@property(nonatomic, strong) NSString *identify;
@property(nonatomic, assign) NSInteger showId;
@end