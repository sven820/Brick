//
//  BRCollectionViewLayout.m
//  BrickKit
//
//  Created by jinxiaofei on 16/7/10.
//  Copyright © 2016年 JJ.sevn. All rights reserved.
//

#import "BRCollectionViewLayout.h"

struct StndardLoc {
    NSInteger index;
    CGFloat value;
};
typedef struct StndardLoc StndardLoc;

@interface BRCollectionViewLayout ()
@property(nonatomic, assign) id<BRCollectionViewLayoutDalegate> delegate;

//纵向记录
@property(nonatomic, assign) CGFloat heightStandardVertical;
@property(nonatomic, strong) NSMutableArray * standardArrVertical;
//横向记录
@property(nonatomic, assign) CGFloat heightStandardHorizontal;
@property(nonatomic, strong) NSMutableArray * standardArrHorizontal;
@property(nonatomic, strong) NSMutableArray * attrses;

@property(nonatomic, assign) CGSize contentSize;

@property(nonatomic, assign) NSInteger page;

@property(nonatomic, assign) NSInteger numberOfSection;
@property(nonatomic, assign) CGFloat width;
@property(nonatomic, assign) CGFloat height;

@property(nonatomic, assign) CGFloat sectionWidth;
@property(nonatomic, assign) CGFloat sectionItemWidth;
@property(nonatomic, assign) CGFloat sectionX;
@property(nonatomic, assign) CGFloat sectionY;
@property(nonatomic, assign) NSInteger sectionColumnCount;
@property(nonatomic, assign) BRCollectionViewLayoutType sectionLayoutType;

@property(nonatomic, assign) CGFloat contentWidth;
@end

@implementation BRCollectionViewLayout

- (instancetype)init
{
    if (self = [super init])
    {
    }
    return self;
}

- (void)invalidateLayout
{
    [super invalidateLayout];
}

- (void)prepareLayout
{
    [super prepareLayout];
    self.delegate = (id<BRCollectionViewLayoutDalegate>)self.collectionView.delegate;
    if (!self.reloadWithoutClear)
    {
        [self clear];
    }

    self.numberOfSection = [self.collectionView numberOfSections];
    if (self.numberOfSection == 0)return;
    self.width = self.collectionView.frame.size.width;
    self.height = self.collectionView.frame.size.height;
    self.sectionWidth = self.width - self.sectionEdgeInsets.left - self.sectionEdgeInsets.right;
    self.sectionX = self.sectionEdgeInsets.left;
    self.sectionY = self.sectionEdgeInsets.top;
    self.sectionLayoutType = self.layoutType;
    [self startLayout];
}

//- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
//{
//    return NO;
//}

//- (void)prepareForCollectionViewUpdates:(NSArray<UICollectionViewUpdateItem *> *)updateItems
//{
//    [super prepareForCollectionViewUpdates:updateItems];
//}

-(CGSize)collectionViewContentSize
//返回collectionView的内容的尺寸, 确定collectionView的所有内容的尺寸
{
    return self.contentSize;
}

-(NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    return self.attrses;
}

-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
//返回对应于indexPath的位置的cell的布局属性
{
    UICollectionViewLayoutAttributes *attrs;
    if (self.sectionItemWidth == 0)
    {
        return nil;
    }
    switch (self.scrollDirection){
        case BRCollectionViewLayoutScrollDirectionVertical:
        {
            switch (self.sectionLayoutType) {
                case BRCollectionViewLayoutTypeHorizontal:
                {
                    attrs = [self layoutItemForVerticalScrollAndHorizontalLayout:indexPath];
                    break;
                }
                case BRCollectionViewLayoutTypeVertical:
                {
                    attrs = [self layoutItemForVerticalScrollAndVerticalLayout:indexPath];
                    break;
                }
                case BRCollectionViewLayoutTypeCustom:
                {
                    attrs = [self layoutItemForVerticalScrollAndCustomLayout:indexPath];
                    break;
                }
            }
            break;
        }
        case BRCollectionViewLayoutScrollDirectionHorizontal:
        {
            switch (self.sectionLayoutType) {
                case BRCollectionViewLayoutTypeVertical:
                {
                    attrs = [self layoutItemForHorizontalScrollAndHorizontalLayout:indexPath];
                    break;
                }
                case BRCollectionViewLayoutTypeHorizontal:
                {
                    attrs = [self layoutItemForHorizontalScrollAndVerticalLayout:indexPath];
                    break;
                }
                case BRCollectionViewLayoutTypeCustom:
                {
                    attrs = [self layoutItemForHorizontalScrollAndCustomLayout:indexPath];
                    break;
                }
            }
            break;
        }
    }
    if (attrs)
    {
        [self.attrses addObject:attrs];
    }
    return attrs;
}

-(UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
//返回对应于indexPath的位置的追加视图的布局属性，如果没有追加视图可不重载
{
    UICollectionViewLayoutAttributes *attrs;
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader])
    {
        attrs = [self layoutForHeaderAtIndexPath:indexPath kind:kind];
    }
    else if([kind isEqualToString:UICollectionElementKindSectionFooter])
    {
        attrs = [self layoutForFooterAtIndexPath:indexPath kind:kind];
    }
    
    if (attrs)
    {
        [self.attrses addObject:attrs];
    }
    return attrs;
}

//-(UICollectionViewLayoutAttributes *)layoutAttributesForDecorationViewOfKind:(NSString *)decorationViewKind atIndexPath:(NSIndexPath *)indexPath
////返回对应于indexPath的位置的装饰视图的布局属性，如果没有装饰视图可不重载
//{
//    return [super layoutAttributesForDecorationViewOfKind:decorationViewKind atIndexPath:indexPath];
//}
//
//- (UICollectionViewLayoutAttributes *)initialLayoutAttributesForAppearingItemAtIndexPath:(NSIndexPath *)itemIndexPath
//{
//    return [super initialLayoutAttributesForAppearingItemAtIndexPath:itemIndexPath];
//}
//
//- (UICollectionViewLayoutAttributes *)finalLayoutAttributesForDisappearingItemAtIndexPath:(NSIndexPath *)itemIndexPath
//{
//    return [super finalLayoutAttributesForDisappearingItemAtIndexPath:itemIndexPath];
//}
//
//- (void)finalizeAnimatedBoundsChange
//{
//    [super finalizeAnimatedBoundsChange];
//}

#pragma mark - private methods
-(void)startLayout
{
    UICollectionViewLayoutAttributes *attrs = self.attrses.lastObject;
    NSInteger fromSection = attrs.indexPath.section;
    NSInteger fromItem = attrs.indexPath.item + 1;
    if (attrs == nil)
    {
        fromSection = 0;
        fromItem = 0;
    }
    if (fromItem >= [self.collectionView numberOfItemsInSection:fromSection])
    {
        fromSection += 1;
        fromItem = 0;
    }
    if (fromSection >= self.numberOfSection) return;
    
    for (NSInteger i = fromSection; i < self.numberOfSection; i++)
    {
        UIEdgeInsets edgeInsets = self.sectionEdgeInsets;
        if ([self.delegate respondsToSelector:@selector(collectionView:flowLayout:insetsForSection:)])
        {
            edgeInsets = [self.delegate collectionView:self.collectionView flowLayout:self insetsForSection:i];
        }

        switch (self.scrollDirection){
            case BRCollectionViewLayoutScrollDirectionVertical: {
                self.sectionWidth = self.collectionView.bounds.size.width - edgeInsets.left - edgeInsets.right;
                self.sectionX = edgeInsets.left;
                self.heightStandardVertical += edgeInsets.top;
                self.heightStandardHorizontal = edgeInsets.left;
                break;
            }
            case BRCollectionViewLayoutScrollDirectionHorizontal: {
                self.sectionWidth = self.collectionView.bounds.size.height - edgeInsets.top - edgeInsets.bottom;
                self.sectionY = edgeInsets.top;
                self.heightStandardHorizontal += edgeInsets.left;
                self.heightStandardVertical = edgeInsets.top;
                break;
            }
        }

        //header
        NSIndexPath *sectionHeaderIndexPath = [NSIndexPath indexPathForItem:0 inSection:i];
        [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:sectionHeaderIndexPath];
        
        //items
        self.sectionColumnCount = self.columnCount;
        self.sectionLayoutType = self.layoutType;
        if ([self.delegate respondsToSelector:@selector(collectionView:flowLayout:columnCountAtSection:)]) {
            self.sectionColumnCount = [self.delegate collectionView:self.collectionView flowLayout:self columnCountAtSection:i];
        }
        if ([self.delegate respondsToSelector:@selector(collectionView:flowLayout:layoutTypeAtSection:)]) {
            self.sectionLayoutType = [self.delegate collectionView:self.collectionView flowLayout:self layoutTypeAtSection:i];
        }
        NSInteger items  = [self.collectionView numberOfItemsInSection:i];

        switch (self.scrollDirection){
            case BRCollectionViewLayoutScrollDirectionVertical:
            {
                switch (self.sectionLayoutType) {
                    case BRCollectionViewLayoutTypeHorizontal:
                    {
                        self.sectionItemWidth = (self.sectionWidth - (self.sectionColumnCount - 1)*self.columnMargin)/self.sectionColumnCount;
                        
                        for (NSInteger j = fromItem; j < items; j++)
                        {
                            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:j inSection:i];
                            [self layoutAttributesForItemAtIndexPath:indexPath];
                        }
                        break;
                    }
#warning todo 如果width超了, 能否自动加个scrollview到section位置
                    case BRCollectionViewLayoutTypeVertical:
                    {
                        CGFloat sectionHeight = 0;
                        if ([self.delegate respondsToSelector:@selector(collectionView:flowLayout:heightForSectionIfNeed:)])
                        {
                            sectionHeight = [self.delegate collectionView:self.collectionView flowLayout:self heightForSectionIfNeed:i];
                            self.sectionItemWidth = (sectionHeight - (self.sectionColumnCount - 1)*self.columnMargin)/self.sectionColumnCount;
                            [self standardAllSetValue:self.heightStandardVertical + sectionHeight standardArr:self.standardArrVertical];
                            for (NSInteger j = fromItem; j < items; j++)
                            {
                                NSIndexPath *indexPath = [NSIndexPath indexPathForItem:j inSection:i];
                                [self layoutAttributesForItemAtIndexPath:indexPath];
                            }
                        }
                        else
                        {
                            NSLog(@"需要section height, 请在'collectionView:flowLayout:heightForSectionIfNeed:'中返回section高度");
                        }
                        break;
                    }
                    case BRCollectionViewLayoutTypeCustom:
                    {
                        CGFloat sectionHeight = 0;
                        if ([self.delegate respondsToSelector:@selector(collectionView:flowLayout:heightForSectionIfNeed:)])
                        {
                            sectionHeight = [self.delegate collectionView:self.collectionView flowLayout:self heightForSectionIfNeed:i];
                            [self standardAllSetValue:self.heightStandardVertical + sectionHeight standardArr:self.standardArrVertical];
                        }
                        if ([self.delegate respondsToSelector:@selector(collectionView:flowLayout:customLayoutRect:forSection:)])
                        {
                            CGRect rect = CGRectMake(self.sectionX, self.heightStandardVertical, self.sectionWidth, sectionHeight);
                            [self.delegate collectionView:self.collectionView flowLayout:self customLayoutRect:rect forSection:i];
                        }
                        break;
                    }
                }
                break;
            }
            case BRCollectionViewLayoutScrollDirectionHorizontal:
            {
                switch (self.sectionLayoutType) {
                    case BRCollectionViewLayoutTypeVertical:
                    {
                        self.sectionItemWidth = (self.sectionWidth - (self.sectionColumnCount - 1)*self.columnMargin)/self.sectionColumnCount;
                        for (NSInteger j = fromItem; j < items; j++)
                        {
                            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:j inSection:i];
                            [self layoutAttributesForItemAtIndexPath:indexPath];
                        }
                        break;
                    }
                    case BRCollectionViewLayoutTypeHorizontal:
                    {
                        CGFloat sectionHeight = 0;
                        if ([self.delegate respondsToSelector:@selector(collectionView:flowLayout:heightForSectionIfNeed:)])
                        {
                            sectionHeight = [self.delegate collectionView:self.collectionView flowLayout:self heightForSectionIfNeed:i];
                            self.sectionItemWidth = (sectionHeight - (self.sectionColumnCount - 1)*self.columnMargin)/self.sectionColumnCount;
                            [self standardAllSetValue:self.heightStandardHorizontal + sectionHeight standardArr:self.standardArrHorizontal];
                            for (NSInteger j = fromItem; j < items; j++)
                            {
                                NSIndexPath *indexPath = [NSIndexPath indexPathForItem:j inSection:i];
                                [self layoutAttributesForItemAtIndexPath:indexPath];
                            }
                        }
                        else
                        {
                            NSLog(@"需要section height, 请在'collectionView:flowLayout:heightForSectionIfNeed:'中返回section高度");
                        }
                        break;
                    }
                    case BRCollectionViewLayoutTypeCustom:
                    {
                        CGFloat sectionHeight = 0;
                        if ([self.delegate respondsToSelector:@selector(collectionView:flowLayout:heightForSectionIfNeed:)])
                        {
                            sectionHeight = [self.delegate collectionView:self.collectionView flowLayout:self heightForSectionIfNeed:i];
                            [self standardAllSetValue:self.heightStandardHorizontal + sectionHeight standardArr:self.standardArrHorizontal];
                        }
                        if ([self.delegate respondsToSelector:@selector(collectionView:flowLayout:customLayoutRect:forSection:)])
                        {
                            CGRect rect = CGRectMake(self.heightStandardHorizontal, self.sectionY, sectionHeight, self.sectionWidth);
                            [self.delegate collectionView:self.collectionView flowLayout:self customLayoutRect:rect forSection:i];
                        }

                        break;
                    }
                }
                break;
            }
        }

            //布局位置记录
        StndardLoc standardMaxVertical = [self getStandardMax:self.standardArrVertical];
        self.heightStandardVertical = standardMaxVertical.value;
        
        StndardLoc standardMaxHorizontal = [self getStandardMax:self.standardArrHorizontal];
        self.heightStandardHorizontal = standardMaxHorizontal.value;
        
        self.standardArrVertical = nil;//致空, 下个section根据heightStandard的值重新初始化
        self.standardArrHorizontal = nil;//致空, 下个section根据heightStandard的值重新初始化
        switch (self.scrollDirection){
            case BRCollectionViewLayoutScrollDirectionVertical: {
                if (self.contentWidth < self.heightStandardHorizontal)
                {
                    self.contentWidth = self.heightStandardHorizontal;
                }
                self.heightStandardHorizontal = 0;//致0, 下个section重新获取
                break;
            }
            case BRCollectionViewLayoutScrollDirectionHorizontal: {
                if (self.contentWidth < self.heightStandardVertical)
                {
                    self.contentWidth = self.heightStandardVertical;
                }
                self.heightStandardVertical = 0;//致0, 下个section重新获取
                break;
            }
        }

        //footer
        NSIndexPath *sectionFooterIndexPath = [NSIndexPath indexPathForItem:items-1 inSection:i];
        [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter atIndexPath:sectionFooterIndexPath];
        //section 底部间距
        switch (self.scrollDirection){
            case BRCollectionViewLayoutScrollDirectionVertical: {
                self.heightStandardVertical += edgeInsets.bottom;
                break;
            }
            case BRCollectionViewLayoutScrollDirectionHorizontal: {
                self.heightStandardHorizontal += edgeInsets.right;
                break;
            }
        }
    }
    //设置contentsize
    
    switch (self.scrollDirection){
        case BRCollectionViewLayoutScrollDirectionVertical: {
            self.contentSize = CGSizeMake(self.contentWidth, self.heightStandardVertical);
            break;
        }
        case BRCollectionViewLayoutScrollDirectionHorizontal: {
            self.contentSize = CGSizeMake(self.heightStandardHorizontal, self.contentWidth);
            break;
        }
    }

}
#pragma mark - private - layout header
- (UICollectionViewLayoutAttributes *)layoutForHeaderAtIndexPath:(NSIndexPath *)indexPath kind:(NSString *)kind
{
    UICollectionViewLayoutAttributes *attrs;
    switch (self.scrollDirection){
        case BRCollectionViewLayoutScrollDirectionVertical: {
            attrs = [self layoutForHeaderWithScrollVerticalAtIndexPath:indexPath kind:kind];
            break;
        }
        case BRCollectionViewLayoutScrollDirectionHorizontal: {
            attrs = [self layoutForHeaderWithScrollHorizontalAtIndexPath:indexPath kind:kind];
            break;
        }
    }
    return attrs;
}
- (UICollectionViewLayoutAttributes *)layoutForHeaderWithScrollVerticalAtIndexPath:(NSIndexPath *)indexPath kind:(NSString *)kind
{
    if ([self.delegate respondsToSelector:@selector(collectionView:flowLayout:heightForHeaderAtSection:)])
    {
        //header
        CGFloat height = [self.delegate collectionView:self.collectionView flowLayout:self heightForHeaderAtSection:indexPath.section];
        UICollectionViewLayoutAttributes *sectionHeaderAttr = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:kind withIndexPath:indexPath];
        sectionHeaderAttr.indexPath = indexPath;
        if (self.edgeInsetsOnlyForItems) {
            sectionHeaderAttr.size = CGSizeMake(self.width, height);
            sectionHeaderAttr.frame = CGRectMake(0, self.heightStandardVertical, self.width, height);
        }else
        {
            sectionHeaderAttr.size = CGSizeMake(self.sectionWidth, height);
            sectionHeaderAttr.frame = CGRectMake(self.sectionX, self.heightStandardVertical,self.sectionWidth, height);
        }
        self.heightStandardVertical = CGRectGetMaxY(sectionHeaderAttr.frame);
        return sectionHeaderAttr;
    }
    return nil;

}
- (UICollectionViewLayoutAttributes *)layoutForHeaderWithScrollHorizontalAtIndexPath:(NSIndexPath *)indexPath kind:(NSString *)kind
{
    if ([self.delegate respondsToSelector:@selector(collectionView:flowLayout:heightForHeaderAtSection:)])
    {
        //header
        CGFloat height = [self.delegate collectionView:self.collectionView flowLayout:self heightForHeaderAtSection:indexPath.section];
        UICollectionViewLayoutAttributes *sectionHeaderAttr = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:kind withIndexPath:indexPath];
        sectionHeaderAttr.indexPath = indexPath;
        if (self.edgeInsetsOnlyForItems) {
            sectionHeaderAttr.size = CGSizeMake(height, self.height);
            sectionHeaderAttr.frame = CGRectMake(self.heightStandardHorizontal, 0, height, self.height);
        }else
        {
            sectionHeaderAttr.size = CGSizeMake(height, self.sectionWidth);
            sectionHeaderAttr.frame = CGRectMake(self.heightStandardHorizontal, self.sectionY, height, self.sectionWidth);
        }
        self.heightStandardHorizontal = CGRectGetMaxX(sectionHeaderAttr.frame);
        return sectionHeaderAttr;
    }
    return nil;
}

#pragma mark - private - layout footer

- (UICollectionViewLayoutAttributes *)layoutForFooterAtIndexPath:(NSIndexPath *)indexPath kind:(NSString *)kind
{
    UICollectionViewLayoutAttributes *attrs;
    switch (self.scrollDirection){
        case BRCollectionViewLayoutScrollDirectionVertical: {
            attrs = [self layoutForFooterWithScrollVerticalAtIndexPath:indexPath kind:kind];
            break;
        }
        case BRCollectionViewLayoutScrollDirectionHorizontal: {
            attrs = [self layoutForFooterWithScrollHorizontalAtIndexPath:indexPath kind:kind];
            break;
        }
    }
    return attrs;
}

- (UICollectionViewLayoutAttributes *)layoutForFooterWithScrollVerticalAtIndexPath:(NSIndexPath *)indexPath kind:(NSString *)kind
{
    if ([self.delegate respondsToSelector:@selector(collectionView:flowLayout:heightForFooterAtSection:)])
    {
        //footer
        CGFloat height = [self.delegate collectionView:self.collectionView flowLayout:self heightForFooterAtSection:indexPath.section];
        UICollectionViewLayoutAttributes *sectionFooterAttr = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:kind withIndexPath:indexPath];
        sectionFooterAttr.indexPath = indexPath;
        if (self.edgeInsetsOnlyForItems) {
            sectionFooterAttr.size = CGSizeMake(self.width, height);
            sectionFooterAttr.frame = CGRectMake(0, self.heightStandardVertical, self.width, height);
        }else
        {
            sectionFooterAttr.size = CGSizeMake(self.sectionWidth, height);
            sectionFooterAttr.frame = CGRectMake(self.sectionX, self.heightStandardVertical,self.sectionWidth, height);
        }
        self.heightStandardVertical = CGRectGetMaxY(sectionFooterAttr.frame);
        return sectionFooterAttr;
    }
    return nil;
}
- (UICollectionViewLayoutAttributes *)layoutForFooterWithScrollHorizontalAtIndexPath:(NSIndexPath *)indexPath kind:(NSString *)kind
{
    if ([self.delegate respondsToSelector:@selector(collectionView:flowLayout:heightForFooterAtSection:)])
    {
        //footer
        CGFloat height = [self.delegate collectionView:self.collectionView flowLayout:self heightForFooterAtSection:indexPath.section];
        UICollectionViewLayoutAttributes *sectionFooterAttr = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:kind withIndexPath:indexPath];
        sectionFooterAttr.indexPath = indexPath;
        if (self.edgeInsetsOnlyForItems) {
            sectionFooterAttr.size = CGSizeMake(height, self.height);
            sectionFooterAttr.frame = CGRectMake(self.heightStandardHorizontal, 0, height, self.height);
        }else
        {
            sectionFooterAttr.size = CGSizeMake(height, self.sectionWidth);
            sectionFooterAttr.frame = CGRectMake(self.heightStandardHorizontal, self.sectionY, height, self.sectionWidth);
        }
        self.heightStandardHorizontal = CGRectGetMaxX(sectionFooterAttr.frame);
        return sectionFooterAttr;
    }
    return nil;
}

#pragma mark - private - layout item
- (UICollectionViewLayoutAttributes *)layoutItemForVerticalScrollAndHorizontalLayout:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    attr.indexPath = indexPath;
    attr.size = CGSizeMake(self.sectionItemWidth, self.itemHeight);
    if ([self.delegate respondsToSelector:@selector(collectionView:flowLayout:heightForItemAtIndexPath:)])
    {
        CGFloat height = [self.delegate collectionView:self.collectionView flowLayout:self heightForItemAtIndexPath:indexPath];
        attr.size = CGSizeMake(self.sectionItemWidth, height);
    }
    
    StndardLoc standardMin = [self getStandardMin:self.standardArrVertical];
    CGFloat X = self.sectionX + standardMin.index * (self.sectionItemWidth+self.columnMargin);
    CGFloat Y = standardMin.value + self.rowMargin;
    if (indexPath.item < self.sectionColumnCount) {
        Y -= self.rowMargin;//第一行不用加行距
    }
    attr.frame = CGRectMake(X, Y, attr.size.width, attr.size.height);
    [self standardSetValue:CGRectGetMaxY(attr.frame) index:standardMin.index standardArr:self.standardArrVertical];
    
    return attr;
}
- (UICollectionViewLayoutAttributes *)layoutItemForVerticalScrollAndVerticalLayout:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    attr.indexPath = indexPath;
    attr.size = CGSizeMake(self.itemHeight, self.sectionItemWidth);
    if ([self.delegate respondsToSelector:@selector(collectionView:flowLayout:heightForItemAtIndexPath:)])
    {
        CGFloat height = [self.delegate collectionView:self.collectionView flowLayout:self heightForItemAtIndexPath:indexPath];
        attr.size = CGSizeMake(height, self.sectionItemWidth);
    }
    StndardLoc standardMin = [self getStandardMin:self.standardArrHorizontal];
    CGFloat X = standardMin.value + self.rowMargin;
    CGFloat Y = standardMin.index * (self.sectionItemWidth+self.columnMargin) + self.heightStandardVertical;
    if (indexPath.item < self.sectionColumnCount) {
        X -= self.rowMargin;//第一行不用加行距
    }
    attr.frame = CGRectMake(X, Y, attr.size.width, attr.size.height);
    [self standardSetValue:CGRectGetMaxX(attr.frame) index:standardMin.index standardArr:self.standardArrHorizontal];
    return attr;
}
- (UICollectionViewLayoutAttributes *)layoutItemForVerticalScrollAndCustomLayout:(NSIndexPath *)indexPath
{
    return nil;
}
- (UICollectionViewLayoutAttributes *)layoutItemForHorizontalScrollAndHorizontalLayout:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    attr.indexPath = indexPath;
    attr.size = CGSizeMake(self.itemHeight, self.sectionItemWidth);
    if ([self.delegate respondsToSelector:@selector(collectionView:flowLayout:heightForItemAtIndexPath:)])
    {
        CGFloat height = [self.delegate collectionView:self.collectionView flowLayout:self heightForItemAtIndexPath:indexPath];
        attr.size = CGSizeMake(height, self.sectionItemWidth);
    }
    
    StndardLoc standardMin = [self getStandardMin:self.standardArrHorizontal];
    CGFloat X = standardMin.value + self.rowMargin;
    CGFloat Y = standardMin.index * (self.sectionItemWidth+self.columnMargin) + self.sectionY;
    if (indexPath.item < self.sectionColumnCount) {
        X -= self.rowMargin;//第一行不用加行距
    }
    attr.frame = CGRectMake(X, Y, attr.size.width, attr.size.height);
    [self standardSetValue:CGRectGetMaxX(attr.frame) index:standardMin.index standardArr:self.standardArrHorizontal];
    return attr;
}
- (UICollectionViewLayoutAttributes *)layoutItemForHorizontalScrollAndVerticalLayout:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    attr.indexPath = indexPath;
    attr.size = CGSizeMake(self.sectionItemWidth, self.itemHeight);
    if ([self.delegate respondsToSelector:@selector(collectionView:flowLayout:heightForItemAtIndexPath:)])
    {
        CGFloat height = [self.delegate collectionView:self.collectionView flowLayout:self heightForItemAtIndexPath:indexPath];
        attr.size = CGSizeMake(self.sectionItemWidth, height);
    }
    
    StndardLoc standardMin = [self getStandardMin:self.standardArrVertical];
    CGFloat X = self.heightStandardHorizontal + standardMin.index * (self.sectionItemWidth+self.columnMargin);
    CGFloat Y = standardMin.value + self.rowMargin;
    if (indexPath.item < self.sectionColumnCount) {
        Y -= self.rowMargin;//第一行不用加行距
    }
    attr.frame = CGRectMake(X, Y, attr.size.width, attr.size.height);
    [self standardSetValue:CGRectGetMaxY(attr.frame) index:standardMin.index standardArr:self.standardArrVertical];
    return attr;
}
- (UICollectionViewLayoutAttributes *)layoutItemForHorizontalScrollAndCustomLayout:(NSIndexPath *)indexPath
{
    return nil;
}
#pragma mark - private - other
- (StndardLoc)getStandardMin:(NSMutableArray *)standardArr
{
    CGFloat minY = [[standardArr firstObject] floatValue];
    NSInteger location = 0;
    for (int i = 0; i<self.sectionColumnCount; i++)
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
    for (int i = 0; i<self.sectionColumnCount; i++)
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
    for (int i = 0; i<self.sectionColumnCount; i++)
    {
        standardArr[i] = [NSNumber numberWithFloat:value];
    }
}

- (void)clear
{
    self.standardArrVertical = nil;
    self.standardArrHorizontal = nil;
    self.attrses = nil;
    self.numberOfSection = 0;
    self.width = 0;
    self.height = 0;
    self.sectionWidth = 0;
    self.sectionItemWidth = 0;
    self.sectionX= 0;
    self.sectionColumnCount =0;
    self.heightStandardVertical = 0;
    self.heightStandardHorizontal = 0;
    self.contentWidth = 0;
}
#pragma mark - getter

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

- (NSMutableArray *)attrses
{
    if (!_attrses)
    {
        _attrses = [NSMutableArray array];
    }
    return _attrses;
}
@end
