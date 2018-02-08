//
//  UIView+Magic.m
//  Brick
//
//  Created by jinxiaofei on 16/9/5.
//  Copyright © 2016年 jinxiaofei. All rights reserved.
//

#import "UIView+Magic.h"
#import <objc/runtime.h>

struct StndardLoc {
    NSInteger index;
    CGFloat value;
};
typedef struct StndardLoc StndardLoc;


static NSString * const kSectionContainerIdentify = @"kSectionContainerIdentify";


static NSString * const kFatherItemNotificaation = @"kFatherItemNotificaation";
static NSString * const kFatherSectionNotificaation = @"kFatherSectionNotificaation";

static NSString * const kFatherNoteInfoFatherBigScrollViewKey = @"kFatherNoteInfoFatherBigScrollViewKey";
static NSString * const kFatherNoteInfoSectionScrollViewTagKey = @"kFatherNoteInfoSectionScrollViewTagKey";

static NSInteger const kcontainerViewTag = -100;

#pragma mark - YCFReusableItemManager
@interface ReusableItemManager : NSObject
@property(nonatomic, strong) NSString *identify;
@property(nonatomic, assign) Class class;
@property(nonatomic, strong) NSMutableSet *reusableItems;
@end
@implementation ReusableItemManager
- (NSMutableSet *)reusableItems
{
    if (!_reusableItems)
    {
        _reusableItems = [NSMutableSet set];
    }
    return _reusableItems;
}
@end

#pragma mark - Magic view Storage
@interface MagicStorage : NSObject
//纵向记录
@property(nonatomic, assign) CGFloat heightStandardVertical;
@property(nonatomic, strong) NSMutableArray * standardArrVertical;
//横向记录
@property(nonatomic, assign) CGFloat heightStandardHorizontal;
@property(nonatomic, strong) NSMutableArray * standardArrHorizontal;
@property(nonatomic, strong) NSMutableDictionary<NSString *, MagicItemAttributes *> * attrses;
@property(atomic, strong) NSMutableDictionary<NSString *, MagicSectionAttributes *> *sectionAttrses;

#warning todo
@property(nonatomic, assign) NSInteger page;

@property(nonatomic, assign) NSInteger numberOfSection;
@property(nonatomic, assign) CGFloat width;
@property(nonatomic, assign) CGFloat height;

@property(nonatomic, assign) CGFloat sectionWidth;
@property(nonatomic, assign) CGFloat sectionItemWidth;
@property(nonatomic, assign) CGFloat sectionX;
@property(nonatomic, assign) CGFloat sectionY;
@property(nonatomic, assign) NSInteger sectionColumnCount;
@property(nonatomic, assign) BRMagicViewLayoutType sectionLayoutType;

@property(nonatomic, assign) CGFloat contentWidth;


//layout property default
@property(nonatomic, weak) id<BRMagicViewLayout> layout;
@property(nonatomic, assign) NSInteger columnCount;   //相对值, 水平布局的纵向列数, 或垂直布局的横向行数
@property(nonatomic, assign) CGFloat itemHeight;       //相对值, item为布局方向的高度, 宽度通过columnCount自动计算

/** 行间距, 列间距为相对值, 布局方向同向为列, 垂直为行*/
@property(nonatomic, assign) CGFloat rowMargin;    //行间距, 相对值
@property(nonatomic, assign) CGFloat columnMargin; //列间距, 相对值

@property(nonatomic, assign) UIEdgeInsets sectionEdgeInsets;//绝对值, 不区分布局方向
@property(nonatomic, assign) BOOL edgeInsetsOnlyForItems; //设置后则只对item有效, header/footer无效

@property(nonatomic, assign) BOOL reloadWithoutClear; //设为YES, 不会clear之前的布局信息,只会布局新增的. NO, 会clear所有布局信息, 重新布局

@property(nonatomic, assign) BRMagicViewLayoutScrollDirection scrollDirection;
@property(nonatomic, assign) BRMagicViewLayoutType layoutType;
@property(nonatomic, strong) UICollectionViewLayout * customLayout; //for BRCollectionViewLayoutTypeCustom

@property(nonatomic, assign) CGFloat layoutLenght;//布局高度的阈值, 首次布局布局此长度布局, 否则超出再布局
@end

#pragma mark - Magic view
@interface UIView ()<UIScrollViewDelegate, UIGestureRecognizerDelegate>

@property(nonatomic, strong, getter=getContainerView) UIScrollView *containerView;
@property(nonatomic, strong, getter=getGestureView) UIView *gestureView;

@property(nonatomic, strong) MagicStorage *storage;
@property(nonatomic, strong) NSMutableDictionary<NSString *,ReusableItemManager *> *reusableManagers;

@property(nonatomic, strong) UITouch *touch;
@property(nonatomic, strong) void (^clickedHandle)(UIView *view);
@property(nonatomic, strong) void (^longPressHandle)(UIView *view);
@property(nonatomic, strong) void (^doubleClickHandle)(UIView *view);

@property(nonatomic, strong) NSValue *visiableRect;
@end

@implementation UIView (Magic)

+ (void)load
{
    //initWithFrame
    Method method1 = class_getInstanceMethod(self, @selector(initWithFrame:));
    Method method2 = class_getInstanceMethod(self, @selector(br_initWithFrame:));
    method_exchangeImplementations(method1, method2);
    
    //layoutSubViews
    Method method3 = class_getInstanceMethod(self, @selector(layoutSubviews));
    Method method4 = class_getInstanceMethod(self, @selector(br_layoutSubviews));
    method_exchangeImplementations(method3, method4);
}

#pragma mark - life cycle
- (instancetype)br_initWithFrame:(CGRect)frame
{
    UIView *instance = [self br_initWithFrame:frame];
    [self registerItemViewClass:[UIScrollView class] forItemViewReuseIdentifier:kSectionContainerIdentify];
    return instance;
}

- (void)br_layoutSubviews
{
    [self br_layoutSubviews];
    
    [self layoutSubs];
}

- (void)dealloc
{
//    NSLog(@"被释放了%@", self.identify);
}

#pragma mark - delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    BOOL isBig;
    if (scrollView.tag == kcontainerViewTag)
    {
        isBig = YES;
        self.visiableRect = [NSValue valueWithCGRect:[self currentLayoutRect:scrollView]];
    }
    else
    {
        MagicSectionAttributes *attr = [self.storage.sectionAttrses objectForKey:[NSString stringWithFormat:@"%zd", scrollView.tag]];
        attr.sectionContainerVisiableRect = [self currentLayoutRect:scrollView];
    }
    NSMutableDictionary *noteInfo = [NSMutableDictionary dictionary];
    [noteInfo setObject:[NSNumber numberWithBool:isBig] forKey:kFatherNoteInfoFatherBigScrollViewKey];
    [noteInfo setObject:[NSNumber numberWithInteger:scrollView.tag] forKey:kFatherNoteInfoSectionScrollViewTagKey];

    if (scrollView.tag == kcontainerViewTag)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:kFatherSectionNotificaation object:self userInfo:noteInfo];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kFatherItemNotificaation object:self userInfo:noteInfo];
}
#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    self.touch = touch;
    return YES;
}
#pragma mark - public
- (NSInteger)numberOfSections
{
    return self.numberOfSections;
}
- (NSInteger)numberItemsInSection:(NSInteger)section
{
    if ([self.dataSource respondsToSelector:@selector(magicView:numberOfItemsInSection:)])
    {
        return [self.dataSource magicView:self numberOfItemsInSection:section];
    }
    return 0;
}
- (void)reloadData
{
    [self layoutSubs];
}

- (void)registerItemViewClass:(Class)itemClass forItemViewReuseIdentifier:(NSString *)identify
{
    ReusableItemManager *manager = [self.reusableManagers objectForKey:identify];
    if (!manager)
    {
        manager = [[ReusableItemManager alloc] init];
        manager.class = itemClass;
        manager.identify = identify;
        [self.reusableManagers setValue:manager forKey:identify];
    }
   
}
- (UIView *)dequeueReusableItemViewWithIdentifier:(NSString *)identify
{
    __block UIView *reusableView = nil;
    ReusableItemManager *manager = [self.reusableManagers objectForKey:identify];
    if (!manager) return nil;
    
    [manager.reusableItems enumerateObjectsUsingBlock:^(UIView *itemView, BOOL * _Nonnull stop) {
        reusableView = itemView;
        *stop = YES;
    }];
    if (reusableView)
    {
        [manager.reusableItems removeObject:reusableView];
    }
    else
    {
        reusableView = [[manager.class alloc] init];
        reusableView.identify = identify;
    }
    return reusableView;
}

- (UIView *)itemWithIndexPath:(NSIndexPath *)indexPath
{
    for (MagicItemAttributes *item in self.screenItems) {
        if (item.kind == MagicItemTypeItem && [indexPath isEqual:item.indexPath])
        {
            return item.son;
        }
    }
    return nil;
}
- (UIView *)headerWithSection:(NSInteger)section
{
    for (MagicItemAttributes *item in self.screenItems) {
        if (item.kind == MagicItemTypeHeader && section == item.indexPath.section)
        {
            return item.son;
        }
    }
    return nil;
}
- (UIView *)footerWithSection:(NSInteger)section
{
    for (MagicItemAttributes *item in self.screenItems) {
        if (item.kind == MagicItemTypeFooter && section == item.indexPath.section)
        {
            return item.son;
        }
    }
    return nil;
}

- (void)clickedWithHandleBlock:(void (^)(UIView *))clickHandle
{
    [self getGestureView];
    self.clickedHandle = clickHandle;
}
- (void)longPressWithHandleBlock:(void (^)(UIView *clickedView))longPressHandle
{
    [self getGestureView];
    self.longPressHandle = longPressHandle;
}
- (void)doubleClickedWithHandleBlock:(void (^)(UIView *))doubleClickHandle
{
    [self getGestureView];
    self.doubleClickHandle = doubleClickHandle;
}
#pragma mark - private
- (CGRect)currentLayoutRect:(UIScrollView *)scrollView
{
    CGFloat x = scrollView.contentOffset.x;
    CGFloat y = scrollView.contentOffset.y;
    CGFloat width = scrollView.frame.size.width;
    CGFloat height = scrollView.frame.size.height;
    CGRect rect = CGRectMake(x, y, width, height);
    return rect;
}
- (void)layoutSubs
{
    if (objc_getAssociatedObject(self, @selector(getGestureView)))
    {
        self.gestureView.frame = self.bounds;
    }
    if (objc_getAssociatedObject(self, @selector(getContainerView)))
    {
        self.containerView.frame = self.gestureView.bounds;
    }
    
    if (!self.layout || !self.dataSource)
    {
        return;
    }
#warning todo
//    if (!self.storage.reloadWithoutClear)
//    {
//        [self clear];
//    }
    
    if ([self.dataSource respondsToSelector:@selector(numberOfSections:)])
    {
        NSInteger sections = [self.dataSource numberOfSections:self];
        if (sections) self.storage.numberOfSection = sections;
    }
    
    self.storage.layout = self.layout;
    
    self.storage.width = self.containerView.frame.size.width;
    self.storage.height = self.containerView.frame.size.height;
    self.storage.sectionWidth = self.storage.width - self.storage.sectionEdgeInsets.left - self.storage.sectionEdgeInsets.right;
    self.storage.sectionX = self.storage.sectionEdgeInsets.left;
    self.storage.sectionY = self.storage.sectionEdgeInsets.top;
    self.storage.sectionLayoutType = self.storage.layoutType;
    
    dispatch_async(dispatch_get_global_queue(0, DISPATCH_QUEUE_PRIORITY_DEFAULT), ^{
        [self estimateContentSize];
    });
    [self prepareForItemAttributes];
}

-(void)prepareForItemAttributes
{
    MagicItemAttributes *attrs = [self.storage.attrses.allValues lastObject];
    NSInteger fromSection = attrs.indexPath.section;
    NSInteger fromItem = attrs.indexPath.item + 1;
    if (attrs == nil)
    {
        fromSection = 0;
        fromItem = 0;
    }
    
    if (fromItem >= [self numberItemsInSection:fromSection])
    {
        fromSection += 1;
        fromItem = 0;
    }
    
    if (fromSection >= self.storage.numberOfSection) return;
    for (NSInteger i = fromSection; i < self.storage.numberOfSection; i++)
    {
        MagicSectionAttributes *sectionAttr = [self getSectionAttributes:i];
        
        CGFloat sectionContainerX = 0.0;
        CGFloat sectionContainerY = 0.0;
        CGFloat sectionContainerW = 0.0;
        CGFloat sectionContainerH = 0.0;
        CGFloat sectionContainerContentWidth = 0.0;
        CGFloat sectionContainerContentHeight = self.storage.heightStandardVertical;
        
        UIEdgeInsets edgeInsets = self.storage.sectionEdgeInsets;
        if ([self.layout respondsToSelector:@selector(magicView:insetsForSection:)])
        {
            edgeInsets = [self.layout magicView:self insetsForSection:i];
        }
        
        switch (self.storage.scrollDirection){
            case BRMagicViewLayoutScrollDirectionVertical: {
                self.storage.sectionWidth = self.containerView.bounds.size.width - edgeInsets.left - edgeInsets.right;
                self.storage.sectionX = edgeInsets.left;
                self.storage.heightStandardVertical += edgeInsets.top;
                self.storage.heightStandardHorizontal = edgeInsets.left;
                break;
            }
            case BRMagicViewLayoutScrollDirectionHorizontal: {
                self.storage.sectionWidth = self.containerView.bounds.size.height - edgeInsets.top - edgeInsets.bottom;
                self.storage.sectionY = edgeInsets.top;
                self.storage.heightStandardHorizontal += edgeInsets.left;
                self.storage.heightStandardVertical = edgeInsets.top;
                break;
            }
        }
        
        //header
        NSIndexPath *sectionHeaderIndexPath = [NSIndexPath indexPathForItem:MagicItemTypeHeader inSection:i];
        NSString *sectionHeaderKey = [NSString stringWithFormat:@"%zd?%zd", MagicItemTypeHeader, i];
        MagicItemAttributes *headerAttr = [self.storage.attrses objectForKey:sectionHeaderKey];
        if (!headerAttr)
        {
            headerAttr = [self layoutForHeaderAtIndexPath:sectionHeaderIndexPath kind:MagicItemTypeHeader];
            if (headerAttr)
            {
                headerAttr.father = self;
                headerAttr.sectionAttr = sectionAttr;
                [self.storage.attrses setObject:headerAttr forKey:sectionHeaderKey];
            }
        }
        
        switch (self.storage.scrollDirection){
            case BRMagicViewLayoutScrollDirectionVertical: {
                sectionContainerX = self.storage.sectionX;
                sectionContainerY = self.storage.heightStandardVertical;
                sectionContainerW = self.storage.sectionWidth;
                break;
            }
            case BRMagicViewLayoutScrollDirectionHorizontal: {
                sectionContainerX = self.storage.heightStandardHorizontal;
                sectionContainerY = self.storage.sectionY;
                sectionContainerH = self.storage.sectionWidth;
                break;
            }
        }


        //items
        self.storage.sectionColumnCount = self.storage.columnCount;
        self.storage.sectionLayoutType = self.storage.layoutType;
        if ([self.layout respondsToSelector:@selector(magicView:columnCountAtSection:)]) {
            self.storage.sectionColumnCount = [self.layout magicView:self columnCountAtSection:i];
        }
        if ([self.layout respondsToSelector:@selector(magicView:layoutTypeAtSection:)]) {
            self.storage.sectionLayoutType = [self.layout magicView:self layoutTypeAtSection:i];
        }
        NSInteger items  = [self numberItemsInSection:i];
        
        switch (self.storage.scrollDirection){
            case BRMagicViewLayoutScrollDirectionVertical:
            {
                switch (self.storage.sectionLayoutType) {
                    case BRMagicViewLayoutTypeHorizontal:
                    {
                        self.storage.sectionItemWidth = (self.storage.sectionWidth - (self.storage.sectionColumnCount - 1)*self.storage.columnMargin)/self.storage.sectionColumnCount;
                        
                        for (NSInteger j = fromItem; j < items; j++)
                        {
                            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:j inSection:i];
                            NSString *key = [NSString stringWithFormat:@"%zd?%zd", j, i];
                            MagicItemAttributes *attrs = [self.storage.attrses objectForKey:key];
                            if (!attrs)
                            {
                                attrs = [self layoutItemForVerticalScrollAndHorizontalLayout:indexPath];
                                
                                attrs.father = self;
                                attrs.sectionAttr = sectionAttr;
                                [self.storage.attrses setObject:attrs forKey:key];
                                [sectionAttr.grandSonAttrses addObject:attrs];
                            }
                        }
                        break;
                    }
                    case BRMagicViewLayoutTypeVertical:
                    {
                        CGFloat sectionHeight = 0;
                        if ([self.layout respondsToSelector:@selector(magicView:heightForSectionIfNeed:)])
                        {
                            sectionHeight = [self.layout magicView:self heightForSectionIfNeed:i];
                            self.storage.sectionItemWidth = (sectionHeight - (self.storage.sectionColumnCount - 1)*self.storage.columnMargin)/self.storage.sectionColumnCount;
                            [self standardAllSetValue:self.storage.heightStandardVertical + sectionHeight standardArr:self.storage.standardArrVertical];
                            for (NSInteger j = fromItem; j < items; j++)
                            {
                                NSIndexPath *indexPath = [NSIndexPath indexPathForItem:j inSection:i];
                                NSString *key = [NSString stringWithFormat:@"%zd?%zd", j, i];
                                MagicItemAttributes *attrs = [self.storage.attrses objectForKey:key];
                                if (!attrs)
                                {
                                    attrs = [self layoutItemForVerticalScrollAndVerticalLayout:indexPath];
                                    
                                    attrs.father = self;
                                    [self.storage.attrses setObject:attrs forKey:key];
                                    [sectionAttr.grandSonAttrses addObject:attrs];
                                    attrs.sectionAttr = sectionAttr;
                                }
                            }
                        }
                        else
                        {
                            NSLog(@"需要section height, 请在'collectionView:flowLayout:heightForSectionIfNeed:'中返回section高度");
                        }
                        break;
                    }
                    case BRMagicViewLayoutTypeReverseRank:
                    {
                        CGFloat sectionHeight = 0;
                        CGFloat rankWidth = 0;
                        if ([self.layout respondsToSelector:@selector(magicView:heightForSectionIfNeed:)] &&
                            [self.layout respondsToSelector:@selector(magicView:widthForSectionIfNeed:)])
                        {
                            sectionHeight = [self.layout magicView:self heightForSectionIfNeed:i];
                            rankWidth = [self.layout magicView:self widthForSectionIfNeed:i];
                            
                            self.storage.sectionItemWidth = (rankWidth - (self.storage.sectionColumnCount - 1)*self.storage.columnMargin)/self.storage.sectionColumnCount;
                            for (NSInteger j = fromItem; j < items; j++)
                            {
                                NSIndexPath *indexPath = [NSIndexPath indexPathForItem:j inSection:i];
                                NSString *key = [NSString stringWithFormat:@"%zd?%zd", j, i];
                                MagicItemAttributes *attrs = [self.storage.attrses objectForKey:key];
                                if (!attrs)
                                {
                                    attrs = [self layoutItemForVerticalScrollAndVerticalLayoutAndHorizontalRank:indexPath rankWidth:rankWidth sectionHeight:sectionHeight leftMargin:edgeInsets.left];
                                    
                                    
                                    attrs.father = self;
                                    [self.storage.attrses setObject:attrs forKey:key];
                                    [sectionAttr.grandSonAttrses addObject:attrs];
                                    attrs.sectionAttr = sectionAttr;
                                }
                            }
                            self.storage.heightStandardHorizontal += rankWidth;
                            [self standardAllSetValue:self.storage.heightStandardVertical + sectionHeight standardArr:self.storage.standardArrVertical];
                        }
                        else
                        {
                            NSLog(@"需要section height 或rankWidth, 请在'collectionView:flowLayout:height(width)ForSectionIfNeed:'中返回");
                        }
                        break;
                    }
                    case BRMagicViewLayoutTypeCustom:
                    {
#warning todo 现为大bigcontainer的rect, 优化为sectionContainer rect
                        CGFloat sectionHeight = 0;
                        if ([self.layout respondsToSelector:@selector(magicView:heightForSectionIfNeed:)])
                        {
                            sectionHeight = [self.layout magicView:self heightForSectionIfNeed:i];
                            [self standardAllSetValue:self.storage.heightStandardVertical + sectionHeight standardArr:self.storage.standardArrVertical];
                        }
                        if ([self.layout respondsToSelector:@selector(magicView:customLayoutRect:forSection:)])
                        {
                            CGRect rect = CGRectMake(self.storage.sectionX, self.storage.heightStandardVertical, self.storage.sectionWidth, sectionHeight);
                            [self.layout magicView:self customLayoutRect:rect forSection:i];
                        }
                        break;
                    }
                }
                break;
            }
            case BRMagicViewLayoutScrollDirectionHorizontal:
            {
                switch (self.storage.sectionLayoutType) {
                    case BRMagicViewLayoutTypeVertical:
                    {
                        self.storage.sectionItemWidth = (self.storage.sectionWidth - (self.storage.sectionColumnCount - 1)*self.storage.columnMargin)/self.storage.sectionColumnCount;
                        for (NSInteger j = fromItem; j < items; j++)
                        {
                            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:j inSection:i];
                            NSString *key = [NSString stringWithFormat:@"%zd?%zd", j, i];
                            MagicItemAttributes *attrs = [self.storage.attrses objectForKey:key];
                            if (!attrs)
                            {
                                attrs = [self layoutItemForHorizontalScrollAndVerticalLayout:indexPath];
                                
                                attrs.father = self;
                                [self.storage.attrses setObject:attrs forKey:key];
                                [sectionAttr.grandSonAttrses addObject:attrs];
                                attrs.sectionAttr = sectionAttr;
                            }
                        }
                        break;
                    }
                    case BRMagicViewLayoutTypeHorizontal:
                    {
                        CGFloat sectionHeight = 0;
                        if ([self.layout respondsToSelector:@selector(magicView:heightForSectionIfNeed:)])
                        {
                            sectionHeight = [self.layout magicView:self heightForSectionIfNeed:i];
                            self.storage.sectionItemWidth = (sectionHeight - (self.storage.sectionColumnCount - 1)*self.storage.columnMargin)/self.storage.sectionColumnCount;
                            [self standardAllSetValue:self.storage.heightStandardHorizontal + sectionHeight standardArr:self.storage.standardArrHorizontal];
                            for (NSInteger j = fromItem; j < items; j++)
                            {
                                NSIndexPath *indexPath = [NSIndexPath indexPathForItem:j inSection:i];
                                NSString *key = [NSString stringWithFormat:@"%zd?%zd", j, i];
                                MagicItemAttributes *attrs = [self.storage.attrses objectForKey:key];
                                if (!attrs)
                                {
                                    attrs = [self layoutItemForHorizontalScrollAndHorizontalLayout:indexPath];
                                    
                                    attrs.father = self;
                                    [self.storage.attrses setObject:attrs forKey:key];
                                    [sectionAttr.grandSonAttrses addObject:attrs];
                                    attrs.sectionAttr = sectionAttr;
                                }
                            }
                        }
                        else
                        {
                            NSLog(@"需要section height, 请在'collectionView:flowLayout:heightForSectionIfNeed:'中返回section高度");
                        }
                        break;
                    }
                    case BRMagicViewLayoutTypeReverseRank:
                    {
                        CGFloat sectionHeight = 0;
                        CGFloat rankWidth = 0;
                        if ([self.layout respondsToSelector:@selector(magicView:heightForSectionIfNeed:)] &&
                            [self.layout respondsToSelector:@selector(magicView:widthForSectionIfNeed:)])
                        {
                            sectionHeight = [self.layout magicView:self heightForSectionIfNeed:i];
                            rankWidth = [self.layout magicView:self widthForSectionIfNeed:i];
                            
                            self.storage.sectionItemWidth = (rankWidth - (self.storage.sectionColumnCount - 1)*self.storage.columnMargin)/self.storage.sectionColumnCount;
                            for (NSInteger j = fromItem; j < items; j++)
                            {
                                NSIndexPath *indexPath = [NSIndexPath indexPathForItem:j inSection:i];
                                NSString *key = [NSString stringWithFormat:@"%zd?%zd", j, i];
                                MagicItemAttributes *attrs = [self.storage.attrses objectForKey:key];
                                if (!attrs)
                                {
                                    attrs = [self layoutItemForHorizontalScrollAndHorizontalLayoutAndVerticalRank:indexPath rankWidth:rankWidth sectionHeight:sectionHeight topMargin:edgeInsets.top];
                                    
                                    attrs.father = self;
                                    [self.storage.attrses setObject:attrs forKey:key];
                                    [sectionAttr.grandSonAttrses addObject:attrs];
                                    attrs.sectionAttr = sectionAttr;
                                }
                            }
                            
                            self.storage.heightStandardVertical += rankWidth;
                            [self standardAllSetValue:self.storage.heightStandardHorizontal + sectionHeight standardArr:self.storage.standardArrHorizontal];
                        }
                        else
                        {
                            NSLog(@"需要section height 或rankWidth, 请在'collectionView:flowLayout:height(width)ForSectionIfNeed:'中返回");
                        }
                        break;
                    }
                    case BRMagicViewLayoutTypeCustom:
                    {
#warning todo 现为大bigcontainer的rect, 优化为sectionContainer rect
                        CGFloat sectionHeight = 0;
                        if ([self.delegate respondsToSelector:@selector(magicView:heightForSectionIfNeed:)])
                        {
                            sectionHeight = [self.layout magicView:self heightForSectionIfNeed:i];
                            [self standardAllSetValue:self.storage.heightStandardHorizontal + sectionHeight standardArr:self.storage.standardArrHorizontal];
                        }
                        if ([self.delegate respondsToSelector:@selector(magicView:customLayoutRect:forSection:)])
                        {
                            CGRect rect = CGRectMake(self.storage.heightStandardHorizontal, self.storage.sectionY, sectionHeight, self.storage.sectionWidth);
                            [self.layout magicView:self customLayoutRect:rect forSection:i];
                        }
                        
                        break;
                    }
                }
                break;
            }
        }
        
        //布局位置记录
        StndardLoc standardMaxVertical = [self getStandardMax:self.storage.standardArrVertical];
        
        StndardLoc standardMaxHorizontal = [self getStandardMax:self.storage.standardArrHorizontal];
        
        self.storage.standardArrVertical = nil;//致空, 下个section根据heightStandard的值重新初始化
        self.storage.standardArrHorizontal = nil;//致空, 下个section根据heightStandard的值重新初始化
        switch (self.storage.scrollDirection){
            case BRMagicViewLayoutScrollDirectionVertical: {
                if (self.storage.contentWidth < standardMaxHorizontal.value)
                {
                    self.storage.contentWidth = standardMaxHorizontal.value-edgeInsets.left;
                }
                sectionContainerContentWidth = self.storage.contentWidth;
                sectionContainerContentHeight = standardMaxVertical.value - self.storage.heightStandardVertical;
                sectionContainerH = sectionContainerContentHeight;
                
                self.storage.heightStandardVertical = standardMaxVertical.value;
                self.storage.heightStandardHorizontal = 0;//致0, 下个section重新获取
                self.storage.contentWidth = 0;
                break;
            }
            case BRMagicViewLayoutScrollDirectionHorizontal: {
                if (self.storage.contentWidth < standardMaxVertical.value)
                {
                    self.storage.contentWidth = standardMaxVertical.value-edgeInsets.top;
                }
                sectionContainerContentHeight = self.storage.contentWidth;
                sectionContainerContentWidth = standardMaxHorizontal.value - self.storage.heightStandardHorizontal;
                sectionContainerW = sectionContainerContentWidth;
                
                self.storage.heightStandardHorizontal = standardMaxHorizontal.value;
                self.storage.heightStandardVertical = 0;//致0, 下个section重新获取
                self.storage.contentWidth = 0;
                break;
            }
        }
        
        sectionAttr.sectionFrame = CGRectMake(sectionContainerX, sectionContainerY, sectionContainerW, sectionContainerH);
        sectionAttr.sectionContentSize = CGSizeMake(sectionContainerContentWidth, sectionContainerContentHeight);
        
        //footer
        NSIndexPath *sectionFooterIndexPath = [NSIndexPath indexPathForItem:MagicItemTypeFooter inSection:i];
        NSString *sectionFooterKey = [NSString stringWithFormat:@"%zd?%zd", MagicItemTypeFooter, i];
        MagicItemAttributes *footerAttr = [self.storage.attrses objectForKey:sectionFooterKey];
        if (!footerAttr)
        {
            footerAttr = [self layoutForFooterAtIndexPath:sectionFooterIndexPath kind:MagicItemTypeFooter];
            if (footerAttr)
            {
                footerAttr.father = self;
                footerAttr.sectionAttr = sectionAttr;
                [self.storage.attrses setObject:footerAttr forKey:sectionFooterKey];
            }
        }
        
        //section 底部间距
        switch (self.storage.scrollDirection){
            case BRMagicViewLayoutScrollDirectionVertical: {
                self.storage.heightStandardVertical += edgeInsets.bottom;
                break;
            }
            case BRMagicViewLayoutScrollDirectionHorizontal: {
                self.storage.heightStandardHorizontal += edgeInsets.right;
                break;
            }
        }
    }
    //设置contentsize
    
    switch (self.storage.scrollDirection){
        case BRMagicViewLayoutScrollDirectionVertical: {
            self.containerView.contentSize = CGSizeMake(0, self.storage.heightStandardVertical);
            break;
        }
        case BRMagicViewLayoutScrollDirectionHorizontal: {
            self.containerView.contentSize = CGSizeMake(self.storage.heightStandardHorizontal, 0);
            break;
        }
    }
    
    //绘制屏幕内的item
    [self scrollViewDidScroll:self.containerView];
}

- (void)estimateContentSize
{
    CGFloat contentSizeWidth = 0.0;
    CGFloat contentSizeHeight = 0.0;
    for (NSInteger i = 0; i < self.storage.numberOfSection; i++)
    {
        MagicSectionAttributes *sectionAttr = [self getSectionAttributes:i];
        CGFloat sectionContainerContentWidth = 0.0;
        CGFloat sectionContainerContentHeight = self.storage.heightStandardVertical;
        
        UIEdgeInsets edgeInsets = self.storage.sectionEdgeInsets;
        if ([self.layout respondsToSelector:@selector(magicView:insetsForSection:)])
        {
            edgeInsets = [self.layout magicView:self insetsForSection:i];
        }
        
        //header
        CGFloat headerHeight = 0.0;
        if ([self.layout respondsToSelector:@selector(magicView:heightForHeaderAtSection:)])
        {
            headerHeight = [self.layout magicView:self heightForHeaderAtSection:i];
        }
        
        switch (self.storage.scrollDirection){
            case BRMagicViewLayoutScrollDirectionVertical: {
                contentSizeHeight = edgeInsets.top + headerHeight;
                break;
            }
            case BRMagicViewLayoutScrollDirectionHorizontal: {
                contentSizeWidth += edgeInsets.left + headerHeight;
                break;
            }
        }
        
        //items
        NSInteger sectionColumnCount = self.storage.columnCount;
        BRMagicViewLayoutType sectionLayoutType = self.storage.layoutType;
        if ([self.layout respondsToSelector:@selector(magicView:columnCountAtSection:)]) {
            sectionColumnCount = [self.layout magicView:self columnCountAtSection:i];
        }
        if ([self.layout respondsToSelector:@selector(magicView:layoutTypeAtSection:)]) {
            sectionLayoutType = [self.layout magicView:self layoutTypeAtSection:i];
        }
        NSInteger items  = [self numberItemsInSection:i];
        
        switch (self.storage.scrollDirection){
            case BRMagicViewLayoutScrollDirectionVertical:
            {
                switch (sectionLayoutType) {
                    case BRMagicViewLayoutTypeHorizontal:
                    {
                        CGFloat sectionItemsHeight = 0.0;
                        
                        for (NSInteger j = 0; j < items; j++)
                        {
                            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:j inSection:i];
                            CGFloat itemHeight = self.storage.itemHeight;
                            if ([self.layout respondsToSelector:@selector(magicView:heightForItemAtIndexPath:)])
                            {
                                itemHeight = [self.layout magicView:self heightForItemAtIndexPath:indexPath];
                            }
                            sectionItemsHeight += itemHeight;
                        }
                        contentSizeHeight += sectionItemsHeight / sectionColumnCount;
                        sectionContainerContentHeight = sectionItemsHeight / sectionColumnCount;
#warning 优化, 异步计算contentsize时候, 计算期时间很长话, 会出现无contentsize而不能滚动的情况, 考虑计算中不断给contentsize赋值
                        self.containerView.contentSize = CGSizeMake(contentSizeWidth, contentSizeHeight);
                        sectionAttr.sectionContentSize = CGSizeMake(sectionContainerContentWidth, sectionContainerContentHeight);
                        break;
                    }
                    case BRMagicViewLayoutTypeVertical:
                    {
                        CGFloat sectionHeight = 0;
                        if ([self.layout respondsToSelector:@selector(magicView:heightForSectionIfNeed:)])
                        {
                            sectionHeight = [self.layout magicView:self heightForSectionIfNeed:i];
                            contentSizeHeight += sectionHeight;
                            
                            CGFloat sectionItemsHeight = 0.0;
                            for (NSInteger j = 0; j < items; j++)
                            {
                                NSIndexPath *indexPath = [NSIndexPath indexPathForItem:j inSection:i];
                                CGFloat itemHeight = self.storage.itemHeight;
                                if ([self.layout respondsToSelector:@selector(magicView:heightForItemAtIndexPath:)])
                                {
                                    itemHeight = [self.layout magicView:self heightForItemAtIndexPath:indexPath];
                                }
                                sectionItemsHeight += itemHeight;
                            }
                            sectionContainerContentWidth += sectionItemsHeight / sectionColumnCount;
                            self.containerView.contentSize = CGSizeMake(contentSizeWidth, contentSizeHeight);
                            sectionAttr.sectionContentSize = CGSizeMake(sectionContainerContentWidth, sectionContainerContentHeight);
                        }
                        else
                        {
                            NSLog(@"需要section height, 请在'collectionView:flowLayout:heightForSectionIfNeed:'中返回section高度");
                        }
                        break;
                    }
                    case BRMagicViewLayoutTypeReverseRank:
                    {
                        CGFloat sectionHeight = 0;
                        CGFloat rankWidth = 0;
                        if ([self.layout respondsToSelector:@selector(magicView:heightForSectionIfNeed:)] &&
                            [self.layout respondsToSelector:@selector(magicView:widthForSectionIfNeed:)])
                        {
                            sectionHeight = [self.layout magicView:self heightForSectionIfNeed:i];
                            contentSizeHeight += sectionHeight;

                            rankWidth = [self.layout magicView:self widthForSectionIfNeed:i];
                            sectionContainerContentWidth = (items/sectionColumnCount + 1) * rankWidth;
                            sectionAttr.sectionContentSize = CGSizeMake(sectionContainerContentWidth, sectionContainerContentHeight);
                        }
                        else
                        {
                            NSLog(@"需要section height 或rankWidth, 请在'collectionView:flowLayout:height(width)ForSectionIfNeed:'中返回");
                        }
                        self.containerView.contentSize = CGSizeMake(contentSizeWidth, contentSizeHeight);
                        break;
                    }
                    case BRMagicViewLayoutTypeCustom:
                    {
#warning todo 现为大bigcontainer的rect, 优化为sectionContainer rect
                        CGFloat sectionHeight = 0;
                        if ([self.layout respondsToSelector:@selector(magicView:heightForSectionIfNeed:)])
                        {
                            sectionHeight = [self.layout magicView:self heightForSectionIfNeed:i];
                            contentSizeHeight += sectionHeight;
                        }
                        sectionAttr.sectionContentSize = CGSizeMake(self.storage.sectionWidth, sectionHeight);
                        self.containerView.contentSize = CGSizeMake(contentSizeWidth, contentSizeHeight);
                        break;
                    }
                }
                break;
            }
            case BRMagicViewLayoutScrollDirectionHorizontal:
            {
                switch (self.storage.sectionLayoutType) {
                    case BRMagicViewLayoutTypeVertical:
                    {
                        self.storage.sectionItemWidth = (self.storage.sectionWidth - (self.storage.sectionColumnCount - 1)*self.storage.columnMargin)/self.storage.sectionColumnCount;
                        CGFloat sectionItemsHeight = 0.0;
                        for (NSInteger j = 0; j < items; j++)
                        {
                            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:j inSection:i];
                            CGFloat itemHeight = self.storage.itemHeight;
                            if ([self.layout respondsToSelector:@selector(magicView:heightForItemAtIndexPath:)])
                            {
                                itemHeight = [self.layout magicView:self heightForItemAtIndexPath:indexPath];
                            }
                            sectionItemsHeight += itemHeight;
                        }
                        contentSizeWidth += sectionItemsHeight / sectionColumnCount;
                        sectionContainerContentWidth = sectionItemsHeight / sectionColumnCount;
                        self.containerView.contentSize = CGSizeMake(contentSizeWidth, contentSizeHeight);
                        sectionAttr.sectionContentSize = CGSizeMake(sectionContainerContentWidth, sectionContainerContentHeight);
                        break;
                    }
                    case BRMagicViewLayoutTypeHorizontal:
                    {
                        CGFloat sectionHeight = 0;
                        if ([self.layout respondsToSelector:@selector(magicView:heightForSectionIfNeed:)])
                        {
                            sectionHeight = [self.layout magicView:self heightForSectionIfNeed:i];
                            contentSizeWidth += sectionHeight;
                        
                            CGFloat sectionItemsHeight = 0.0;
                            for (NSInteger j = 0; j < items; j++)
                            {
                                NSIndexPath *indexPath = [NSIndexPath indexPathForItem:j inSection:i];
                                CGFloat itemHeight = self.storage.itemHeight;
                                if ([self.layout respondsToSelector:@selector(magicView:heightForItemAtIndexPath:)])
                                {
                                    itemHeight = [self.layout magicView:self heightForItemAtIndexPath:indexPath];
                                }
                                sectionItemsHeight += itemHeight;
                            }
                            sectionContainerContentHeight = sectionItemsHeight / sectionColumnCount;
                            self.containerView.contentSize = CGSizeMake(contentSizeWidth, contentSizeHeight);
                            sectionAttr.sectionContentSize = CGSizeMake(sectionContainerContentWidth, sectionContainerContentHeight);
                        }
                        else
                        {
                            NSLog(@"需要section height, 请在'collectionView:flowLayout:heightForSectionIfNeed:'中返回section高度");
                        }
                        break;
                    }
                    case BRMagicViewLayoutTypeReverseRank:
                    {
                        CGFloat sectionHeight = 0;
                        CGFloat rankWidth = 0;
                        if ([self.layout respondsToSelector:@selector(magicView:heightForSectionIfNeed:)] &&
                            [self.layout respondsToSelector:@selector(magicView:widthForSectionIfNeed:)])
                        {
                            sectionHeight = [self.layout magicView:self heightForSectionIfNeed:i];
                            contentSizeWidth += sectionHeight;
                            
                            rankWidth = [self.layout magicView:self widthForSectionIfNeed:i];
                            sectionContainerContentHeight = (items/sectionColumnCount + 1) * rankWidth;
                            sectionAttr.sectionContentSize = CGSizeMake(sectionContainerContentWidth, sectionContainerContentHeight);
                        }
                        else
                        {
                            NSLog(@"需要section height 或rankWidth, 请在'collectionView:flowLayout:height(width)ForSectionIfNeed:'中返回");
                        }
                        self.containerView.contentSize = CGSizeMake(contentSizeWidth, contentSizeHeight);
                        break;
                    }
                    case BRMagicViewLayoutTypeCustom:
                    {
#warning todo 现为大bigcontainer的rect, 优化为sectionContainer rect
                        CGFloat sectionHeight = 0;
                        if ([self.delegate respondsToSelector:@selector(magicView:heightForSectionIfNeed:)])
                        {
                            sectionHeight = [self.layout magicView:self heightForSectionIfNeed:i];
                            contentSizeWidth += sectionHeight;
                        }
                        sectionAttr.sectionContentSize = CGSizeMake(sectionHeight, self.storage.sectionWidth);
                        self.containerView.contentSize = CGSizeMake(contentSizeWidth, contentSizeHeight);
                        break;
                    }
                }
                break;
            }
        }
        
        //footer
        CGFloat footerHeight = 0.0;
        if ([self.layout respondsToSelector:@selector(magicView:heightForFooterAtSection:)])
        {
            footerHeight = [self.layout magicView:self heightForFooterAtSection:i];
        }
        //section 底部间距
        switch (self.storage.scrollDirection){
            case BRMagicViewLayoutScrollDirectionVertical: {
                contentSizeHeight = footerHeight + edgeInsets.bottom;
                break;
            }
            case BRMagicViewLayoutScrollDirectionHorizontal: {
                contentSizeWidth = footerHeight + edgeInsets.right;
                break;
            }
        }
    }
    //设置contentsize
    self.containerView.contentSize = CGSizeMake(contentSizeWidth, contentSizeHeight);
}

- (void)tapGestureView:(UITapGestureRecognizer *)tap
{
    if (self.touch.tapCount >= 2)
    {
        if (self.doubleClickHandle)
        {
            self.doubleClickHandle(self);
        }
    }
    else
    {
        if (self.clickedHandle)
        {
            self.clickedHandle(self);
        }
        
        if (self.attribute)
        {
            switch (self.attribute.kind) {
                case MagicItemTypeItem: {
                    if ([self.attribute.father.delegate respondsToSelector:@selector(magicView:item:didSelectedItemAtIndexPath:)])
                    {
                        [self.attribute.father.delegate magicView:self.attribute.father item:self didSelectedItemAtIndexPath:self.attribute.indexPath];
                    }
                    break;
                }
                case MagicItemTypeHeader: {
                    if ([self.attribute.father.delegate respondsToSelector:@selector(magicView:header:didSelectedHeaderInSection:)])
                    {
                        [self.attribute.father.delegate magicView:self.attribute.father header:self didSelectedHeaderInSection:self.attribute.indexPath.section];
                    }
                    break;
                }
                case MagicItemTypeFooter: {
                    if ([self.attribute.father.delegate respondsToSelector:@selector(magicView:footer:didSelectedFooterInSection:)])
                    {
                        [self.attribute.father.delegate magicView:self.attribute.father footer:self didSelectedFooterInSection:self.attribute.indexPath.section];
                    }
                    break;
                }
            }
            
        }
    }
    
}

- (void)longPress:(UILongPressGestureRecognizer *)longPress
{
    if (self.longPressHandle)
    {
        self.longPressHandle(self);
    }
}

- (MagicSectionAttributes *)getSectionAttributes:(NSInteger)section
{
    @synchronized (self) {
        NSString *sectionKey = [NSString stringWithFormat:@"%zd", section];
        MagicSectionAttributes *sectionAttr = [self.storage.sectionAttrses objectForKey:sectionKey];
        if (!sectionAttr) {
            sectionAttr = [[MagicSectionAttributes alloc] init];
            sectionAttr.section = section;
            sectionAttr.father = self;
            sectionAttr.bigContainerVisiableRect = [self.visiableRect CGRectValue];
            if ([self.layout respondsToSelector:@selector(magicView:isNeedPageEnabledAtSectionIfNeed:)])
            {
                sectionAttr.pageEnabled = [self.layout magicView:self isNeedPageEnabledAtSectionIfNeed:section];
            }
            [self.storage.sectionAttrses setObject:sectionAttr forKey:sectionKey];
        }
        return sectionAttr;
    }
}

#pragma mark - private - layout header
- (MagicItemAttributes *)layoutForHeaderAtIndexPath:(NSIndexPath *)indexPath kind:(NSInteger)kind
{
    MagicItemAttributes *attrs;
    switch (self.storage.scrollDirection){
        case BRMagicViewLayoutScrollDirectionVertical: {
            attrs = [self layoutForHeaderWithScrollVerticalAtIndexPath:indexPath kind:kind];
            break;
        }
        case BRMagicViewLayoutScrollDirectionHorizontal: {
            attrs = [self layoutForHeaderWithScrollHorizontalAtIndexPath:indexPath kind:kind];
            break;
        }
    }
    return attrs;
}
- (MagicItemAttributes *)layoutForHeaderWithScrollVerticalAtIndexPath:(NSIndexPath *)indexPath kind:(NSInteger)kind
{
    if ([self.layout respondsToSelector:@selector(magicView:heightForHeaderAtSection:)])
    {
        //header
        CGFloat height = [self.layout magicView:self heightForHeaderAtSection:indexPath.section];
        MagicItemAttributes *sectionHeaderAttr = [[MagicItemAttributes alloc]init];
        sectionHeaderAttr.indexPath = indexPath;
        sectionHeaderAttr.kind = kind;
        if (self.storage.edgeInsetsOnlyForItems) {
            sectionHeaderAttr.size = CGSizeMake(self.storage.width, height);
            sectionHeaderAttr.frame = CGRectMake(0, self.storage.heightStandardVertical, self.storage.width, height);
        }else
        {
            sectionHeaderAttr.size = CGSizeMake(self.storage.sectionWidth, height);
            sectionHeaderAttr.frame = CGRectMake(self.storage.sectionX, self.storage.heightStandardVertical,self.storage.sectionWidth, height);
        }
        self.storage.heightStandardVertical = CGRectGetMaxY(sectionHeaderAttr.frame);
        return sectionHeaderAttr;
    }
    return nil;
    
}
- (MagicItemAttributes *)layoutForHeaderWithScrollHorizontalAtIndexPath:(NSIndexPath *)indexPath kind:(NSInteger)kind
{
    if ([self.layout respondsToSelector:@selector(magicView:heightForHeaderAtSection:)])
    {
        //header
        CGFloat height = [self.layout magicView:self heightForHeaderAtSection:indexPath.section];
        MagicItemAttributes *sectionHeaderAttr = [[MagicItemAttributes alloc ]init];
        sectionHeaderAttr.indexPath = indexPath;
        sectionHeaderAttr.kind = kind;
        if (self.storage.edgeInsetsOnlyForItems) {
            sectionHeaderAttr.size = CGSizeMake(height, self.storage.height);
            sectionHeaderAttr.frame = CGRectMake(self.storage.heightStandardHorizontal, 0, height, self.storage.height);
        }else
        {
            sectionHeaderAttr.size = CGSizeMake(height, self.storage.sectionWidth);
            sectionHeaderAttr.frame = CGRectMake(self.storage.heightStandardHorizontal, self.storage.sectionY, height, self.storage.sectionWidth);
        }
        self.storage.heightStandardHorizontal = CGRectGetMaxX(sectionHeaderAttr.frame);
        return sectionHeaderAttr;
    }
    return nil;
}

#pragma mark - private - layout footer

- (MagicItemAttributes *)layoutForFooterAtIndexPath:(NSIndexPath *)indexPath kind:(NSInteger)kind
{
    MagicItemAttributes *attrs;
    switch (self.storage.scrollDirection){
        case BRMagicViewLayoutScrollDirectionVertical: {
            attrs = [self layoutForFooterWithScrollVerticalAtIndexPath:indexPath kind:kind];
            break;
        }
        case BRMagicViewLayoutScrollDirectionHorizontal: {
            attrs = [self layoutForFooterWithScrollHorizontalAtIndexPath:indexPath kind:kind];
            break;
        }
    }
    return attrs;
}

- (MagicItemAttributes *)layoutForFooterWithScrollVerticalAtIndexPath:(NSIndexPath *)indexPath kind:(NSInteger)kind
{
    if ([self.layout respondsToSelector:@selector(magicView:heightForFooterAtSection:)])
    {
        //footer
        CGFloat height = [self.layout magicView:self heightForFooterAtSection:indexPath.section];
        MagicItemAttributes *sectionFooterAttr = [[MagicItemAttributes alloc ]init];
        sectionFooterAttr.indexPath = indexPath;
        sectionFooterAttr.kind = kind;
        if (self.storage.edgeInsetsOnlyForItems) {
            sectionFooterAttr.size = CGSizeMake(self.storage.width, height);
            sectionFooterAttr.frame = CGRectMake(0, self.storage.heightStandardVertical, self.storage.width, height);
        }else
        {
            sectionFooterAttr.size = CGSizeMake(self.storage.sectionWidth, height);
            sectionFooterAttr.frame = CGRectMake(self.storage.sectionX, self.storage.heightStandardVertical,self.storage.sectionWidth, height);
        }
        self.storage.heightStandardVertical = CGRectGetMaxY(sectionFooterAttr.frame);
        return sectionFooterAttr;
    }
    return nil;
}
- (MagicItemAttributes *)layoutForFooterWithScrollHorizontalAtIndexPath:(NSIndexPath *)indexPath kind:(NSInteger)kind
{
    if ([self.layout respondsToSelector:@selector(magicView:heightForFooterAtSection:)])
    {
        //footer
        CGFloat height = [self.layout magicView:self heightForFooterAtSection:indexPath.section];
        MagicItemAttributes *sectionFooterAttr = [[MagicItemAttributes alloc ]init];
        sectionFooterAttr.indexPath = indexPath;
        sectionFooterAttr.kind = kind;
        if (self.storage.edgeInsetsOnlyForItems) {
            sectionFooterAttr.size = CGSizeMake(height, self.storage.height);
            sectionFooterAttr.frame = CGRectMake(self.storage.heightStandardHorizontal, 0, height, self.storage.height);
        }else
        {
            sectionFooterAttr.size = CGSizeMake(height, self.storage.sectionWidth);
            sectionFooterAttr.frame = CGRectMake(self.storage.heightStandardHorizontal, self.storage.sectionY, height, self.storage.sectionWidth);
        }
        self.storage.heightStandardHorizontal = CGRectGetMaxX(sectionFooterAttr.frame);
        return sectionFooterAttr;
    }
    return nil;
}

#pragma mark - private - layout item
- (MagicItemAttributes *)layoutItemForVerticalScrollAndHorizontalLayout:(NSIndexPath *)indexPath
{
    MagicItemAttributes *attr = [[MagicItemAttributes alloc ]init];
    attr.indexPath = indexPath;
    attr.kind = MagicItemTypeItem;
    attr.size = CGSizeMake(self.storage.sectionItemWidth, self.storage.itemHeight);
    if ([self.layout respondsToSelector:@selector(magicView:heightForItemAtIndexPath:)])
    {
        CGFloat height = [self.layout magicView:self heightForItemAtIndexPath:indexPath];
        attr.size = CGSizeMake(self.storage.sectionItemWidth, height);
    }
    
    StndardLoc standardMin = [self getStandardMin:self.storage.standardArrVertical];
    CGFloat X = self.storage.sectionX + standardMin.index * (self.storage.sectionItemWidth+self.storage.columnMargin);
    CGFloat Y = standardMin.value + self.storage.rowMargin;
    if (indexPath.item < self.storage.sectionColumnCount) {
        Y -= self.storage.rowMargin;//第一行不用加行距
    }
    attr.frame = CGRectMake(X, Y, attr.size.width, attr.size.height);
    attr.sectionFrame = CGRectMake(X-self.storage.sectionX, Y - self.storage.heightStandardVertical, attr.size.width, attr.size.height);

    [self standardSetValue:CGRectGetMaxY(attr.frame) index:standardMin.index standardArr:self.storage.standardArrVertical];
    
    return attr;
}
- (MagicItemAttributes *)layoutItemForVerticalScrollAndVerticalLayout:(NSIndexPath *)indexPath
{
    MagicItemAttributes *attr = [[MagicItemAttributes alloc ]init];
    attr.indexPath = indexPath;
    attr.kind = MagicItemTypeItem;
    attr.size = CGSizeMake(self.storage.itemHeight, self.storage.sectionItemWidth);
    if ([self.layout respondsToSelector:@selector(magicView:heightForItemAtIndexPath:)])
    {
        CGFloat height = [self.layout magicView:self heightForItemAtIndexPath:indexPath];
        attr.size = CGSizeMake(height, self.storage.sectionItemWidth);
    }
    StndardLoc standardMin = [self getStandardMin:self.storage.standardArrHorizontal];
    CGFloat X = standardMin.value + self.storage.rowMargin;
    CGFloat Y = standardMin.index * (self.storage.sectionItemWidth+self.storage.columnMargin) + self.storage.heightStandardVertical;
    if (indexPath.item < self.storage.sectionColumnCount) {
        X -= self.storage.rowMargin;//第一行不用加行距
    }
    attr.frame = CGRectMake(X, Y, attr.size.width, attr.size.height);
    attr.sectionFrame = CGRectMake(X-self.storage.heightStandardHorizontal, Y-self.storage.heightStandardVertical, attr.size.width, attr.size.height);

    [self standardSetValue:CGRectGetMaxX(attr.frame) index:standardMin.index standardArr:self.storage.standardArrHorizontal];
    return attr;
}

static  NSInteger sectionReverseRankTempCount;//记录换页时候的item数量
- (MagicItemAttributes *)layoutItemForVerticalScrollAndVerticalLayoutAndHorizontalRank:(NSIndexPath *)indexPath rankWidth:(CGFloat)rankWidth sectionHeight:(CGFloat)sectionHeight leftMargin:(CGFloat)leftMargin;
{
    MagicItemAttributes *attr = [[MagicItemAttributes alloc ]init];
    attr.indexPath = indexPath;
    attr.kind = MagicItemTypeItem;
    attr.size = CGSizeMake(self.storage.sectionItemWidth, self.storage.itemHeight);
    if ([self.layout respondsToSelector:@selector(magicView:heightForItemAtIndexPath:)])
    {
        CGFloat height = [self.layout magicView:self heightForItemAtIndexPath:indexPath];
        attr.size = CGSizeMake(self.storage.sectionItemWidth, height);
    }
    StndardLoc standardMin = [self getStandardMin:self.storage.standardArrVertical];
    CGFloat X = standardMin.index * (self.storage.sectionItemWidth+self.storage.columnMargin) + self.storage.heightStandardHorizontal;
    CGFloat Y = standardMin.value + self.storage.rowMargin;
    if (indexPath.item < self.storage.sectionColumnCount || (indexPath.item - sectionReverseRankTempCount)<self.storage.sectionColumnCount) {
        Y -= self.storage.rowMargin;//第一行不用加行距
    }
    if (Y-self.storage.heightStandardVertical + attr.size.height > sectionHeight) {
        self.storage.standardArrVertical = nil;
        self.storage.heightStandardHorizontal += rankWidth;
        standardMin = [self getStandardMin:self.storage.standardArrVertical];
        X = standardMin.index * (self.storage.sectionItemWidth+self.storage.columnMargin) + self.storage.heightStandardHorizontal;
        Y = standardMin.value;
        sectionReverseRankTempCount = indexPath.item;
    }
    attr.frame = CGRectMake(X, Y, attr.size.width, attr.size.height);
    attr.sectionFrame = CGRectMake(X-leftMargin, Y-self.storage.heightStandardVertical, attr.size.width, attr.size.height);
    
    [self standardSetValue:CGRectGetMaxY(attr.frame) index:standardMin.index standardArr:self.storage.standardArrVertical];
    return attr;
}

- (MagicItemAttributes *)layoutItemForVerticalScrollAndCustomLayout:(NSIndexPath *)indexPath
{
    return nil;
}
- (MagicItemAttributes *)layoutItemForHorizontalScrollAndVerticalLayout:(NSIndexPath *)indexPath
{
    MagicItemAttributes *attr = [[MagicItemAttributes alloc ]init];
    attr.indexPath = indexPath;
    attr.kind = MagicItemTypeItem;
    attr.size = CGSizeMake(self.storage.itemHeight, self.storage.sectionItemWidth);
    if ([self.layout respondsToSelector:@selector(magicView:heightForItemAtIndexPath:)])
    {
        CGFloat height = [self.layout magicView:self heightForItemAtIndexPath:indexPath];
        attr.size = CGSizeMake(height, self.storage.sectionItemWidth);
    }
    
    StndardLoc standardMin = [self getStandardMin:self.storage.standardArrHorizontal];
    CGFloat X = standardMin.value + self.storage.rowMargin;
    CGFloat Y = standardMin.index * (self.storage.sectionItemWidth+self.storage.columnMargin) + self.storage.sectionY;
    if (indexPath.item < self.storage.sectionColumnCount) {
        X -= self.storage.rowMargin;//第一行不用加行距
    }
    attr.frame = CGRectMake(X, Y, attr.size.width, attr.size.height);
    attr.sectionFrame = CGRectMake(X-self.storage.heightStandardHorizontal, Y-self.storage.sectionY, attr.size.width, attr.size.height);

    [self standardSetValue:CGRectGetMaxX(attr.frame) index:standardMin.index standardArr:self.storage.standardArrHorizontal];
    return attr;
}
- (MagicItemAttributes *)layoutItemForHorizontalScrollAndHorizontalLayout:(NSIndexPath *)indexPath
{
    MagicItemAttributes *attr = [[MagicItemAttributes alloc ]init];
    attr.indexPath = indexPath;
    attr.kind = MagicItemTypeItem;
    attr.size = CGSizeMake(self.storage.sectionItemWidth, self.storage.itemHeight);
    if ([self.layout respondsToSelector:@selector(magicView:heightForItemAtIndexPath:)])
    {
        CGFloat height = [self.layout magicView:self heightForItemAtIndexPath:indexPath];
        attr.size = CGSizeMake(self.storage.sectionItemWidth, height);
    }
    
    StndardLoc standardMin = [self getStandardMin:self.storage.standardArrVertical];
    CGFloat X = self.storage.heightStandardHorizontal + standardMin.index * (self.storage.sectionItemWidth+self.storage.columnMargin);
    CGFloat Y = standardMin.value + self.storage.rowMargin;
    if (indexPath.item < self.storage.sectionColumnCount) {
        Y -= self.storage.rowMargin;//第一行不用加行距
    }
    attr.frame = CGRectMake(X, Y, attr.size.width, attr.size.height);
    attr.sectionFrame = CGRectMake(X-self.storage.heightStandardHorizontal, Y-self.storage.heightStandardVertical, attr.size.width, attr.size.height);

    [self standardSetValue:CGRectGetMaxY(attr.frame) index:standardMin.index standardArr:self.storage.standardArrVertical];
    return attr;
}
- (MagicItemAttributes *)layoutItemForHorizontalScrollAndHorizontalLayoutAndVerticalRank:(NSIndexPath *)indexPath rankWidth:(CGFloat)rankWidth sectionHeight:(CGFloat)sectionHeight topMargin:(CGFloat)topMargin
{
    MagicItemAttributes *attr = [[MagicItemAttributes alloc ]init];
    attr.indexPath = indexPath;
    attr.kind = MagicItemTypeItem;
    attr.size = CGSizeMake(self.storage.itemHeight, self.storage.sectionItemWidth);
    if ([self.layout respondsToSelector:@selector(magicView:heightForItemAtIndexPath:)])
    {
        CGFloat height = [self.layout magicView:self heightForItemAtIndexPath:indexPath];
        attr.size = CGSizeMake(height, self.storage.sectionItemWidth);
    }
    StndardLoc standardMin = [self getStandardMin:self.storage.standardArrHorizontal];
    CGFloat X = standardMin.value + self.storage.rowMargin;
    CGFloat Y = standardMin.index * (self.storage.sectionItemWidth+self.storage.columnMargin) + self.storage.heightStandardVertical;
    if (indexPath.item < self.storage.sectionColumnCount || (indexPath.item - sectionReverseRankTempCount)<self.storage.sectionColumnCount) {
        X -= self.storage.rowMargin;//第一行不用加行距
    }
    if (X-self.storage.heightStandardHorizontal + attr.size.width > sectionHeight) {
        self.storage.standardArrHorizontal = nil;
        self.storage.heightStandardVertical += rankWidth;
        standardMin = [self getStandardMin:self.storage.standardArrHorizontal];
        X = standardMin.value;
        Y = standardMin.index * (self.storage.sectionItemWidth+self.storage.columnMargin) + self.storage.heightStandardVertical;
        sectionReverseRankTempCount = indexPath.item;
    }
    attr.frame = CGRectMake(X, Y, attr.size.width, attr.size.height);
    attr.sectionFrame = CGRectMake(X-self.storage.heightStandardHorizontal, Y-topMargin, attr.size.width, attr.size.height);
    
    [self standardSetValue:CGRectGetMaxX(attr.frame) index:standardMin.index standardArr:self.storage.standardArrHorizontal];
    return attr;
}
- (MagicItemAttributes *)layoutItemForHorizontalScrollAndCustomLayout:(NSIndexPath *)indexPath
{
    return nil;
}
#pragma mark - private - other
- (StndardLoc)getStandardMin:(NSMutableArray *)standardArr
{
    CGFloat minY = [[standardArr firstObject] floatValue];
    NSInteger location = 0;
    for (int i = 0; i<self.storage.sectionColumnCount; i++)
    {
        if (minY > [standardArr[i] floatValue])
        {
            minY = [standardArr[i] floatValue];
            location = i;
        }
    }
    StndardLoc min = {location, minY};
    return min;
}

- (StndardLoc)getStandardMax:(NSMutableArray *)standardArr
{
    CGFloat maxY = [[standardArr firstObject] floatValue];
    NSInteger location = 0;
    for (int i = 0; i<self.storage.sectionColumnCount; i++)
    {
        if (maxY < [standardArr[i] floatValue])
        {
            maxY = [standardArr[i] floatValue];
            location = i;
        }
    }
    
    StndardLoc max = {location, maxY};
    return max;
}

- (void)standardSetValue:(CGFloat)value index:(NSInteger)index standardArr:(NSMutableArray *)standardArr
{
    standardArr[index] = [NSNumber numberWithFloat:value];
}

- (void)standardAllSetValue:(CGFloat)value standardArr:(NSMutableArray *)standardArr
{
    for (int i = 0; i<self.storage.sectionColumnCount; i++)
    {
        standardArr[i] = [NSNumber numberWithFloat:value];
    }
}

- (void)clear
{
    self.storage.standardArrVertical = nil;
    self.storage.standardArrHorizontal = nil;
    self.storage.attrses = nil;
    self.storage.numberOfSection = 1;
    self.storage.width = 0;
    self.storage.height = 0;
    self.storage.sectionWidth = 0;
    self.storage.sectionItemWidth = 0;
    self.storage.sectionX= 0;
    self.storage.sectionColumnCount =0;
    self.storage.heightStandardVertical = 0;
    self.storage.heightStandardHorizontal = 0;
    self.storage.contentWidth = 0;
}

#pragma mark - setter/getter
//gestureView
- (UIView *)getGestureView
{
    UIView *gestureV = objc_getAssociatedObject(self, @selector(getGestureView));
    if (!gestureV) {
        gestureV = [[UIView alloc] init];
        self.bg ? [self insertSubview:gestureV aboveSubview:self.bg] : [self addSubview:gestureV];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureView:)];
        tap.delegate = self;
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
        
        [gestureV addGestureRecognizer:tap];
        [gestureV addGestureRecognizer:longPress];
        self.gestureView = gestureV;
    }
    gestureV.frame = self.bounds;
    gestureV.backgroundColor = self.backgroundColor;//优化图层混合的性能问题

    return gestureV;
}
- (void)setGestureView:(UIView *)gestureView
{
    objc_setAssociatedObject(self, @selector(getGestureView), gestureView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
//containerView
- (UIScrollView *)getContainerView
{
    UIScrollView *content = objc_getAssociatedObject(self, @selector(getContainerView));
    if (!content)
    {
        content = [[UIScrollView alloc] init];
        content.delegate = self;
        content.tag = kcontainerViewTag;
        [self.gestureView addSubview:content];
        self.containerView = content;
    }
    content.frame = self.gestureView.bounds;
    content.backgroundColor = self.backgroundColor;//优化图层混合的性能问题
    return content;
}
- (void)setContainerView:(UIScrollView *)containerView
{
    objc_setAssociatedObject(self, @selector(getContainerView), containerView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

}//layout
- (id<BRMagicViewLayout>)layout
{
    return objc_getAssociatedObject(self, @selector(layout));
}
- (void)setLayout:(id<BRMagicViewLayout>)layout
{
    objc_setAssociatedObject(self, @selector(layout), layout, OBJC_ASSOCIATION_ASSIGN);
}
//dataSource
- (id<BRMagicViewDataSource>)dataSource
{
    return objc_getAssociatedObject(self, @selector(dataSource));
}
- (void)setDataSource:(id<BRMagicViewDataSource>)dataSource
{
    objc_setAssociatedObject(self, @selector(dataSource), dataSource, OBJC_ASSOCIATION_ASSIGN);
}
//delegate
- (id<BRMagicViewDelegate>)delegate
{
    return objc_getAssociatedObject(self, @selector(delegate));
}
- (void)setDelegate:(id<BRMagicViewDelegate>)delegate
{
    objc_setAssociatedObject(self, @selector(delegate), delegate, OBJC_ASSOCIATION_ASSIGN);
}
//identify
- (NSString *)identify
{
    return objc_getAssociatedObject(self, @selector(identify));
}
- (void)setIdentify:(NSString *)identify
{
    objc_setAssociatedObject(self, @selector(identify), identify, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
//bg
- (UIView *)bg
{
    return objc_getAssociatedObject(self, @selector(bg));
}
- (void)setBg:(UIView *)bg
{
    objc_setAssociatedObject(self, @selector(bg), bg, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self insertSubview:bg atIndex:0];
    bg.frame = self.bounds;
}
//storage
- (MagicStorage *)storage
{
    MagicStorage *storage = objc_getAssociatedObject(self, @selector(storage));
    if (!storage)
    {
        storage = [[MagicStorage alloc] init];
        self.storage = storage;
    }
    return storage;
}
- (void)setStorage:(MagicStorage *)storage
{
    objc_setAssociatedObject(self, @selector(storage), storage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
//reusableItems
- (NSMutableDictionary *)reusableManagers
{
    NSMutableDictionary *arr = objc_getAssociatedObject(self, @selector(reusableManagers));
    if (!arr)
    {
        arr = [NSMutableDictionary dictionary];
        self.reusableManagers = arr;
    }
    return arr;
}
- (void)setReusableManagers:(NSMutableDictionary *)reusableManagers
{
    objc_setAssociatedObject(self, @selector(reusableManagers), reusableManagers, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
//screenItems
- (NSMutableArray *)screenItems
{
    NSMutableArray *arr = objc_getAssociatedObject(self, @selector(screenItems));
    if (!arr)
    {
        arr = [NSMutableArray array];
        self.screenItems = arr;
    }
    return arr;
}
- (void)setScreenItems:(NSMutableArray *)screenItems
{
    objc_setAssociatedObject(self, @selector(screenItems), screenItems, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
//screenSections
- (NSMutableArray<MagicSectionAttributes *> *)screenSections
{
    NSMutableArray *arr = objc_getAssociatedObject(self, @selector(screenSections));
    if (!arr)
    {
        arr = [NSMutableArray array];
        self.screenSections = arr;
    }
    return arr;
}
- (void)setScreenSections:(NSMutableArray<MagicSectionAttributes *> *)screenSections
{
    objc_setAssociatedObject(self, @selector(screenSections), screenSections, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
//attribute
- (MagicItemAttributes *)attribute
{
    return objc_getAssociatedObject(self, @selector(attribute));
}
- (void)setAttribute:(MagicItemAttributes *)attribute
{
    objc_setAssociatedObject(self, @selector(attribute), attribute, OBJC_ASSOCIATION_ASSIGN);
}
//touch
- (UITouch *)touch
{
    return objc_getAssociatedObject(self, @selector(touch));
}
- (void)setTouch:(UITouch *)touch
{
    objc_setAssociatedObject(self, @selector(touch), touch, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
//clickedHandle
- (void (^)(UIView *))clickedHandle
{
    return objc_getAssociatedObject(self, @selector(clickedHandle));
}
- (void)setClickedHandle:(void (^)(UIView *))clickedHandle
{
    objc_setAssociatedObject(self, @selector(clickedHandle), clickedHandle, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
//long press handle
- (void (^)(UIView *))longPressHandle
{
    return objc_getAssociatedObject(self, @selector(longPressHandle));
}
- (void)setLongPressHandle:(void (^)(UIView *))longPressHandle
{
    objc_setAssociatedObject(self, @selector(longPressHandle), longPressHandle, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
//doubleClickHandle
- (void (^)(UIView *))doubleClickHandle
{
    return objc_getAssociatedObject(self, @selector(doubleClickHandle));
}
- (void)setDoubleClickHandle:(void (^)(UIView *))doubleClickHandle
{
    objc_setAssociatedObject(self, @selector(doubleClickHandle), doubleClickHandle, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
//sectionContainers
- (NSMutableArray *)sectionContainers
{
    NSMutableArray *arr = objc_getAssociatedObject(self, @selector(sectionContainers));
    if (!arr)
    {
        arr = [NSMutableArray array];
        self.sectionContainers = arr;
    }
    return arr;
}
- (void)setSectionContainers:(NSMutableArray *)sectionContainers
{
    objc_setAssociatedObject(self, @selector(sectionContainers), sectionContainers, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
//visiableRect
- (NSValue *)visiableRect
{
    NSValue *rect = objc_getAssociatedObject(self, @selector(visiableRect));
    if (!rect)
    {
        rect = [NSValue valueWithCGRect:CGRectMake(0, 0, self.containerView.frame.size.width, self.containerView.frame.size.height)];
        self.visiableRect = rect;
    }
    return rect;
}
- (void)setVisiableRect:(NSValue *)visiableRect
{
    objc_setAssociatedObject(self, @selector(visiableRect), visiableRect, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
@end


#pragma mark - MagicStorage
@implementation MagicStorage
- (instancetype)init
{
    if (self = [super init])
    {
        self.numberOfSection = 1;
        self.edgeInsetsOnlyForItems = YES;
        self.sectionAttrses = [NSMutableDictionary dictionary];
    }
    return self;
}
- (void)setLayout:(id<BRMagicViewLayout>)layout
{
    _layout = layout;
    
    self.columnCount = 1;
    self.layoutLenght = MAXFLOAT;
    
    if ([layout respondsToSelector:@selector(columnCount)])
    {
        self.columnCount = layout.columnCount;
    }
    if ([layout respondsToSelector:@selector(itemHeight)])
    {
        self.itemHeight = layout.itemHeight;
    }
    if ([layout respondsToSelector:@selector(rowMargin)])
    {
        self.rowMargin = layout.rowMargin;
    }
    if ([layout respondsToSelector:@selector(rowMargin)])
    {
        self.rowMargin = layout.rowMargin;
    }
    if ([layout respondsToSelector:@selector(columnMargin)])
    {
        self.columnMargin = layout.columnMargin;
    }
    if ([layout respondsToSelector:@selector(sectionEdgeInsets)])
    {
        self.sectionEdgeInsets = layout.sectionEdgeInsets;
    }
    if ([layout respondsToSelector:@selector(edgeInsetsOnlyForItems)])
    {
        self.edgeInsetsOnlyForItems = layout.edgeInsetsOnlyForItems;
    }
    if ([layout respondsToSelector:@selector(reloadWithoutClear)])
    {
        self.reloadWithoutClear = layout.reloadWithoutClear;
    }
    if ([layout respondsToSelector:@selector(scrollDirection)])
    {
        self.scrollDirection = layout.scrollDirection;
    }
    if ([layout respondsToSelector:@selector(layoutType)])
    {
        self.layoutType = layout.layoutType;
    }
    if ([layout respondsToSelector:@selector(customLayout)])
    {
        self.customLayout = layout.customLayout;
    }
    if ([layout respondsToSelector:@selector(layoutLenght)])
    {
        self.layoutLenght = layout.layoutLenght;
    }
    
}
- (NSMutableArray *)standardArrVertical
{
    if (!_standardArrVertical)
    {
        _standardArrVertical = [NSMutableArray array];
        for (int i = 0; i<self.sectionColumnCount; i++)
        {
            _standardArrVertical[i] = @(self.heightStandardVertical);
        }
    }
    return _standardArrVertical;
}

- (NSMutableArray *)standardArrHorizontal
{
    if (!_standardArrHorizontal)
    {
        _standardArrHorizontal = [NSMutableArray array];
        for (int i = 0; i<self.sectionColumnCount; i++)
        {
            _standardArrHorizontal[i] = @(self.heightStandardHorizontal);
        }
    }
    return _standardArrHorizontal;
}

- (NSMutableDictionary<NSString *,MagicItemAttributes *> *)attrses
{
    if (!_attrses)
    {
        _attrses = [NSMutableDictionary dictionary];
    }
    return _attrses;
}
@end

#pragma mark - MagicItemAttributes
@implementation MagicItemAttributes
- (void)setFather:(UIView *)father
{
    _father = father;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dealWithReusableItem:) name:kFatherItemNotificaation object:father];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)dealWithReusableItem:(NSNotification *)note
{
    NSDictionary *noteInfo = note.userInfo;
    CGRect rect = [self.father.visiableRect CGRectValue];
    BOOL isBigContainer = [[noteInfo valueForKey:kFatherNoteInfoFatherBigScrollViewKey] boolValue];
    NSInteger sectionTag = [[noteInfo valueForKey:kFatherNoteInfoSectionScrollViewTagKey] integerValue];
    //移出不在屏幕内的item
    if (self.isOnscreen)
    {
        BOOL dealBig = isBigContainer && self.kind != MagicItemTypeItem && !CGRectIntersectsRect(rect, self.frame);
        BOOL dealBigInSection = isBigContainer && self.kind == MagicItemTypeItem &&
        !CGRectIntersectsRect(rect, CGRectMake(self.frame.origin.x - self.sectionAttr.son.contentOffset.x, self.frame.origin.y - self.sectionAttr.son.contentOffset.y, self.frame.size.width, self.frame.size.height));
        BOOL dealSection = !isBigContainer && self.sectionAttr.section == sectionTag && !CGRectIntersectsRect(rect, self.sectionFrame) && self.kind == MagicItemTypeItem;
        if (dealBig || dealBigInSection || dealSection )
        {
            [self.son removeFromSuperview];
            [self.father.screenItems removeObject:self];
            self.isOnscreen = NO;
            ReusableItemManager *manager = [self.father.reusableManagers objectForKey:self.son.identify];
            [manager.reusableItems addObject:self.son];
        }
    }
    else
    {
        //添加将要显示到屏幕的item
        switch (self.kind) {
            case MagicItemTypeItem: {
                if ([self.father.dataSource respondsToSelector:@selector(magicView:itemAtIndexPath:)])
                {
                    BOOL dealBig = isBigContainer && CGRectIntersectsRect(rect, CGRectMake(self.frame.origin.x - self.sectionAttr.son.contentOffset.x, self.frame.origin.y - self.sectionAttr.son.contentOffset.y, self.frame.size.width, self.frame.size.height));
                    BOOL dealSection = !isBigContainer && self.sectionAttr.section == sectionTag && CGRectIntersectsRect(rect, self.sectionFrame);
                    
                    if (dealBig || dealSection)
                    {
                        [self.father.screenItems addObject:self];
                        self.isOnscreen = YES;
                        UIView *item = [self.father.dataSource magicView:self.father itemAtIndexPath:self.indexPath];
                        item.frame = self.sectionFrame;
                        item.attribute = self;
                        self.son = item;
                        [self.sectionAttr.son insertSubview:item atIndex:0];//解决滚动条被挡住了, 不知道为什么
                        
                        if (dealBig) {
                            self.bigContainerVisiableRect = rect;
                        }
                        if (dealSection) {
                            self.sectionAttr.sectionContainerVisiableRect = rect;
                            self.sectionContainerVisiableRect = rect;
                        }
                    }
                }
                break;
            }
            case MagicItemTypeHeader: {
                if ([self.father.dataSource respondsToSelector:@selector(magicView:headerAtSection:)] && isBigContainer)
                {
                    if (CGRectIntersectsRect(rect, self.frame))
                    {
                        [self.father.screenItems addObject:self];
                        self.isOnscreen = YES;
                        UIView *header = [self.father.dataSource magicView:self.father headerAtSection:self.indexPath.section];
                        header.frame = self.frame;
                        header.attribute = self;
                        self.son = header;
                        [self.father.containerView insertSubview:header atIndex:self.indexPath.section];
                        self.bigContainerVisiableRect = rect;
                    }
                }
                break;
            }
            case MagicItemTypeFooter: {
                if ([self.father.dataSource respondsToSelector:@selector(magicView:footerAtSection:)] && isBigContainer)
                {
                    if (CGRectIntersectsRect(rect, self.frame))
                    {
                        [self.father.screenItems addObject:self];
                        self.isOnscreen = YES;
                        UIView *footer = [self.father.dataSource magicView:self.father footerAtSection:self.indexPath.section];
                        footer.frame = self.frame;
                        footer.attribute = self;
                        self.son = footer;
                        [self.father.containerView insertSubview:footer atIndex:self.indexPath.section];
                        self.bigContainerVisiableRect = rect;
                    }
                }
                break;
            }
        }

    }
}

- (CGRect)sectionContainerVisiableRect
{
    if (_sectionContainerVisiableRect.size.width == 0 || _sectionContainerVisiableRect.size.height == 0)
    {
        _sectionContainerVisiableRect = self.sectionAttr.son.bounds;
    }
    return _sectionContainerVisiableRect;
}

- (CGRect)bigContainerVisiableRect
{
    if (_bigContainerVisiableRect.size.width == 0 || _bigContainerVisiableRect.size.height == 0)
    {
        _bigContainerVisiableRect = self.father.bounds;
    }
    return _bigContainerVisiableRect;
}
@end

#pragma mark - MagicSectionAttributes
@implementation MagicSectionAttributes
- (void)setFather:(UIView *)father
{
    _father = father;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dealWithReusableSection:) name:kFatherSectionNotificaation object:father];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)dealWithReusableSection:(NSNotification *)note
{
    if (self.isOnscreen)
    {
        if (!CGRectIntersectsRect([self.father.visiableRect CGRectValue], self.sectionFrame))
        {
            [self.son removeFromSuperview];
            [self.father.screenSections removeObject:self];0x7fc441580bb0 /0x7fc4414b8980;
            self.isOnscreen = NO;
            ReusableItemManager *manager = [self.father.reusableManagers objectForKey:kSectionContainerIdentify];
            [manager.reusableItems addObject:self.son];
        }
    }
    else
    {
        NSLog(@"ddd-%zd-%p----%@----%@", self.section, self, NSStringFromCGRect(self.sectionFrame), NSStringFromCGRect([self.father.visiableRect CGRectValue]));

        if (CGRectIntersectsRect([self.father.visiableRect CGRectValue], self.sectionFrame))
        {
            [self.father.screenSections addObject:self];
            self.isOnscreen = YES;
            UIScrollView *sectionContainer = (UIScrollView *)[self.father dequeueReusableItemViewWithIdentifier:kSectionContainerIdentify];
            sectionContainer.backgroundColor = self.father.backgroundColor;
            sectionContainer.delegate = self.father;
            sectionContainer.frame = self.sectionFrame;
            sectionContainer.contentSize = self.sectionContentSize;
            sectionContainer.tag = self.section;
            sectionContainer.pagingEnabled = self.pageEnabled;
            self.son = sectionContainer;
            [self.father.containerView insertSubview:sectionContainer atIndex:0];//解决滚动条被挡住了, 不知道为什么
        }
    }
}

- (CGRect)sectionContainerVisiableRect
{
    if (_sectionContainerVisiableRect.size.width == 0 || _sectionContainerVisiableRect.size.height ==0)
    {
        _sectionContainerVisiableRect = CGRectMake(0, 0, self.sectionFrame.size.width, self.sectionFrame.size.height);
    }
    return _sectionContainerVisiableRect;
}

- (NSMutableArray *)grandSonAttrses
{
    if (!_grandSonAttrses)
    {
        _grandSonAttrses = [NSMutableArray array];
    }
    return _grandSonAttrses;
}
@end
