//
//  BRCollectionViewLayout.m
//  BrickKit
//
//  Created by jinxiaofei on 16/7/8.
//  Copyright © 2016年 JJ.sevn. All rights reserved.
//

/** 感谢:
 文／Flying_Einstein（简书作者）
 原文链接：http://www.jianshu.com/p/97e930658671
 著作权归作者所有，转载请联系作者获得授权，并标注“简书作者”。
 */

#import "BRCollectionViewLayoutExp.h"

@implementation BRCollectionViewLayoutExp

/** UICollectionViewCell结构
 首先是cell本身作为容器view
 然后是一个大小自动适应整个cell的backgroundView，用作cell平时的背景
 再其上是selectedBackgroundView，是cell被选中时的背景
 最后是一个contentView，自定义内容应被加在这个view上
 */

/** 调用顺序说明*/
/**
 1）-(void)prepareLayout  设置layout的结构和初始需要的参数等。
 
 2)  -(CGSize) collectionViewContentSize 确定collectionView的所有内容的尺寸。
 
 3）-(NSArray *)layoutAttributesForElementsInRect:(CGRect)rect初始的layout的外观将由该方法返回的UICollectionViewLayoutAttributes来决定。
 
 4)在需要更新layout时，需要给当前layout发送
     1)-invalidateLayout， 该消息会立即返回，并且预约在下一个loop的时候刷新当前layout(类似UIView的setNeedsLayout)
     2)-prepareLayout，
     3)依次再调用-collectionViewContentSize和-layoutAttributesForElementsInRect来生成更新后的布局。
 */

+ (Class)layoutAttributesClass
//返回创建布局信息时用到的类，如果你创建了继承自 UICollectionViewLayoutAttributes的子类，你也应该重载该方法，返回该子类。该方法主要是为了子类化，无需在代码中调用。
{
    return [super layoutAttributesClass];
}

-(void)prepareLayout
//准备方法,自动调用，以保证layout实例的正确, 设置layout的结构和初始需要的参数等。
{
    [super prepareLayout];
}

- (void)prepareForCollectionViewUpdates:(NSArray<UICollectionViewUpdateItem *> *)updateItems
//做一些和布局相关的准备工作
//当插入或者删除 item的时候，collection view将会通知布局对象它将调整布局，第一步就是调用该方法告知布局对象发生了什么改变。除此之外，该方法也可以用来获取插入、删除、移动item的布局信息
{
    
}

- (void)finalizeCollectionViewUpdates
//通过该方法添加一些动画到block，或者做一些和最终布局相关的工作
{
    
}

-(CGSize)collectionViewContentSize
//返回collectionView的内容的尺寸, 确定collectionView的所有内容的尺寸
{
    return [super collectionViewContentSize];
}

-(NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
//1.返回rect中的所有的元素的布局属性, rect初始的layout的外观将由该方法返回的UICollectionViewLayoutAttributes来决定。
//2.返回的是包含UICollectionViewLayoutAttributes的NSArray
//3.UICollectionViewLayoutAttributes可以是cell，追加视图或装饰视图的信息，通过不同的UICollectionViewLayoutAttributes初始化方法可以得到不同类型的UICollectionViewLayoutAttributes：
    //1)layoutAttributesForCellWithIndexPath:
    //2)layoutAttributesForSupplementaryViewOfKind:withIndexPath:
    //3)layoutAttributesForDecorationViewOfKind:withIndexPath:
{
    return [super layoutAttributesForElementsInRect:rect];
}

-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
//返回对应于indexPath的位置的cell的布局属性
{
    return [super layoutAttributesForItemAtIndexPath:indexPath];
}

-(UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
//返回对应于indexPath的位置的追加视图的布局属性，如果没有追加视图可不重载
{
    return [super layoutAttributesForSupplementaryViewOfKind:kind atIndexPath:indexPath];
}

-(UICollectionViewLayoutAttributes *)layoutAttributesForDecorationViewOfKind:(NSString *)decorationViewKind atIndexPath:(NSIndexPath *)indexPath
//返回对应于indexPath的位置的装饰视图的布局属性，如果没有装饰视图可不重载
{
    return [super layoutAttributesForDecorationViewOfKind:decorationViewKind atIndexPath:indexPath];
}

#pragma mark - 调整动态的变化, 做动画
//collection view在bounds动态改变或者插入、删除items之前，调用该方法。可以在该方法进行一些相关的计算，比如可以在该方法内部计算插入和删除的item初始和最终的位置。你也可用通过该方法添加动画，这些动画被用于处理item插入、删除和bounds改变
- (void)prepareForAnimatedBoundsChange:(CGRect)oldBounds
{
    [super prepareForAnimatedBoundsChange:oldBounds];
}
//该方法在item插入、删除和bounds改变动画完成之后，清空相关的操作
- (void)finalizeAnimatedBoundsChange
{
    [super finalizeAnimatedBoundsChange];
}
#pragma mark - 使布局失效, 更新布局
//在需要更新layout时，需要给当前layout发送 -invalidateLayout，该消息会立即返回，并且预约在下一个loop的时候刷新当前layout
//使当前的布局失效，同时触发布局更新,该方法会强制刷新全局布局
//一个更好的方式是只重新计算发生改变的布局信息，是用Invalidation Contexts去做, 你需要子类化 UICollectionViewLayoutInvalidationContext,为你的布局定义一个 自定义的 invalidation context.
- (void)invalidateLayout
{
    [super invalidateLayout];
}

- (void)invalidateLayoutWithContext:(UICollectionViewLayoutInvalidationContext *)context
    //在子类中定义一些属性，这些属性代表布局中可以单独重新计算的数据。当你需要 invalidate 你的布局时，创建一个 invalidation context 子类的实例，配置自定义的属性，并把该实例传给invalidateLayoutWithContext: 方法。你自定义的方法可以根据invalidation context 中的信息重新计算布局改变的部分。
    //如果你定义了一个自定义的 invalidation context 类，你也应该重载invalidationContextClass方法，返回自定义的类。 collection view 在需要invalidation context时，总是会创建一个指明的类实例。返回你自定义的子类，确保了自定义的对象拥有正确的 invalidation context.
{
    return [super invalidateLayoutWithContext:context];
}

//重载invalidationContextClass方法，返回自定义的类
+ (Class)invalidationContextClass
{
    return [super invalidationContextClass];
}

-(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
//当边界发生改变时，是否应该刷新布局。如果YES则在边界变化（一般是scroll到其他地方）时，将重新计算需要的布局信息。
//该方法决定了collection view是否能够进行布局更新，默认为NO。子类在重载该方法的时候，根据cell或者追加视图是否发生布局改变，返回正确的值。
{
    return [super shouldInvalidateLayoutForBoundsChange:newBounds];
}

/**
 collection view 的bounds发生改变的时候返回的无效上下文，该无效上下文描述了bounds变化后需要做出改变的部分。
 该方法默认实现是，通过invalidationContextClass方法返回的类创建一个实例，并作为返回值。如果你想获得一个自定义的无效上下文对象，就要重载invalidationContextClass方法。
 你可以通过重载该方法去创建和配置自定义的无效上下文。如果你重载该方法，第一步应该调用super类获取无效上下文,在获得该无效上下文后，为它设置自定义的属性，并返回。
 */
- (UICollectionViewLayoutInvalidationContext *)invalidationContextForBoundsChange:(CGRect)newBounds
{
    return [super invalidationContextForBoundsChange:newBounds];
}
/**
 在进行动画式布局的时候，该方法返回内容区的偏移量。在布局更新或者布局转场的时候，collection view 调用该方法改变内容区的偏移量，该偏移量作为动画的结束点。如果动画或者转场造成item位置的改变并不是以最优的方式进行，可以重载该方法进行优化。 collection view在调用prepareLayout 和 collectionViewContentSize 之后调用该方法.
 */
- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset
{
    return [super targetContentOffsetForProposedContentOffset:proposedContentOffset];
}

//该方法返回值为滑动停止的点。如果你希望内容区快速滑动到指定的区域，可以重载该方法。比如，你可以通过该方法让滑动停止在两个item中间的区域，而不是某个item的中间。
- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
{
    return [super targetContentOffsetForProposedContentOffset:proposedContentOffset withScrollingVelocity:velocity];
}

//当collection view包含self-sizing (自排列)的cell时，这些cell可以在布局attributes 应用到它之前更改这些attributes。一个自排列的cell指明一个不同于布局对象给出的size的时候，就会这么做。当cell设置一系列不同的attributes时，collection view将会调用该方法判断是否需要更新布局，默认返回为NO
- (BOOL)shouldInvalidateLayoutForPreferredLayoutAttributes:(UICollectionViewLayoutAttributes *)preferredAttributes withOriginalAttributes:(UICollectionViewLayoutAttributes *)originalAttributes
{
    return [super shouldInvalidateLayoutForPreferredLayoutAttributes:preferredAttributes withOriginalAttributes:originalAttributes];
}

//该方法返回值是一个上下文，上下文包含布局中需要改变的信息。默认的实现是，使用invalidationContextClass 方法返回的类创建一个实例，并返回。你可以通过重载该方法去创建和配置自定义的无效上下文。如果你重载该方法，第一步应该调用super类获取无效上下文,在获得该无效上下文后，为它设置自定义的属性，并返回
- (UICollectionViewLayoutInvalidationContext *)invalidationContextForPreferredLayoutAttributes:(UICollectionViewLayoutAttributes *)preferredAttributes withOriginalAttributes:(UICollectionViewLayoutAttributes *)originalAttributes
{
    return [super invalidationContextForPreferredLayoutAttributes:preferredAttributes withOriginalAttributes:originalAttributes];
}
- (UICollectionViewLayoutInvalidationContext *)invalidationContextForInteractivelyMovingItems:(NSArray<NSIndexPath *> *)targetIndexPaths withTargetPosition:(CGPoint)targetPosition previousIndexPaths:(NSArray<NSIndexPath *> *)previousIndexPaths previousPosition:(CGPoint)previousPosition
{
    return [super invalidationContextForInteractivelyMovingItems:targetIndexPaths withTargetPosition:targetPosition previousIndexPaths:previousIndexPaths previousPosition:previousPosition];
}
- (UICollectionViewLayoutInvalidationContext *)invalidationContextForEndingInteractiveMovementOfItemsToFinalIndexPaths:(NSArray<NSIndexPath *> *)indexPaths previousIndexPaths:(NSArray<NSIndexPath *> *)previousIndexPaths movementCancelled:(BOOL)movementCancelled
{
    return [super invalidationContextForEndingInteractiveMovementOfItemsToFinalIndexPaths:indexPaths previousIndexPaths:previousIndexPaths movementCancelled:movementCancelled];
}

#pragma mark - 在布局之间转换
//告知布局对象将会作为新的布局被导入到 collection view，该方法先于转场之前执行，可以在该方法做一些初始化的操作，生成布局attributes;
- (void)prepareForTransitionFromLayout:(UICollectionViewLayout *)oldLayout
{
    [super prepareForTransitionFromLayout:oldLayout];
}

//告知布局对象作为布局即将从collection view移除，该方法先于转场之前执行，可以在该方法做一些初始化的操作，生成布局attributes;
- (void)prepareForTransitionToLayout:(UICollectionViewLayout *)newLayout
{
    [super prepareForTransitionToLayout:newLayout];
}

//collection view在获取从一个布局向另一个布局转场的时候所有的布局attributes 后，调用该方法。你可以用该方法清空prepareForTransitionFromLayout: 和prepareForTransitionToLayout:生成的数据和缓存。
- (void)finalizeLayoutTransition
{
    [super finalizeLayoutTransition];
}
#pragma mark - 增加, 删除, 移动cell, 修改布局属性
/**下面是设置元素增加, 删除, 移动的布局属性*****************************************************************************/

/** 添加删除移动cell, 你需要重新布局相应的cell属性*/
    /**
     在一个 item被插入到collection view 的时候，返回开始的布局信息。这个方法在 prepareForCollectionViewUpdates:之后和finalizeCollectionViewUpdates 之前调用。collection view将会使用该布局信息作为动画的起点(结束点是该item在collection view 的最新的位置)。如果返回为nil，布局对象将用item的最终的attributes 作为动画的起点和终点.
     */
- (UICollectionViewLayoutAttributes *)initialLayoutAttributesForAppearingItemAtIndexPath:(NSIndexPath *)itemIndexPath
{
    return [super initialLayoutAttributesForAppearingItemAtIndexPath:itemIndexPath];
}

    //返回值是追加视图插入collection view时的布局信息。该方法使用同initialLayoutAttributesForAppearingItemAtIndexPath:
- (UICollectionViewLayoutAttributes *)initialLayoutAttributesForAppearingSupplementaryElementOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)elementIndexPath
{
    return [super initialLayoutAttributesForAppearingSupplementaryElementOfKind:elementKind atIndexPath:elementIndexPath];
}
    //返回值是装饰视图插入collection view时的布局信息。该方法使用同initialLayoutAttributesForAppearingItemAtIndexPath:
- (UICollectionViewLayoutAttributes *)initialLayoutAttributesForAppearingDecorationElementOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)decorationIndexPath
{
    return [super initialLayoutAttributesForAppearingDecorationElementOfKind:elementKind atIndexPath:decorationIndexPath];
}

/**
 返回值是item即将从collection view移除时候的布局信息，对即将删除的item来讲，该方法在 prepareForCollectionViewUpdates: 之后和finalizeCollectionViewUpdates 之前调用。在该方法中返回的布局信息描包含 item的状态信息和位置信息。 collection view将会把该信息作为动画的终点(起点是item当前的位置)。如果返回为nil的话，布局对象将会把当前的attribute，作为动画的起点和终点
 */
- (UICollectionViewLayoutAttributes *)finalLayoutAttributesForDisappearingItemAtIndexPath:(NSIndexPath *)itemIndexPath
{
    return [super finalLayoutAttributesForDisappearingItemAtIndexPath:itemIndexPath];
}

- (UICollectionViewLayoutAttributes *)finalLayoutAttributesForDisappearingSupplementaryElementOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)elementIndexPath
{
    return [super finalLayoutAttributesForDisappearingSupplementaryElementOfKind:elementKind atIndexPath:elementIndexPath];
}

- (UICollectionViewLayoutAttributes *)finalLayoutAttributesForDisappearingDecorationElementOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)decorationIndexPath
{
    return [super finalLayoutAttributesForDisappearingDecorationElementOfKind:elementKind atIndexPath:decorationIndexPath];
}

/**
 当item在手势交互下移动时，通过该方法返回这个item布局的attributes 。默认实现是，复制已存在的attributes，改变attributes两个值，一个是中心点center；另一个是z轴的坐标值，设置成最大值。所以该item在collection view的最上层。子类重载该方法，可以按照自己的需求更改attributes，首先需要调用super类获取attributes,然后自定义返回的数据结构。
 */
- (UICollectionViewLayoutAttributes *)layoutAttributesForInteractivelyMovingItemAtIndexPath:(NSIndexPath *)indexPath withTargetPosition:(CGPoint)position
{
    return [super layoutAttributesForInteractivelyMovingItemAtIndexPath:indexPath withTargetPosition:position];
}

/**
 根据item在collection view中的位置获取该item的index path。第一个参数该item原来的index path，第二个参数是item在collection view中的位置。在item移动的过程中，该方法将collection view中的location映射成相应 index paths。该方法的默认是现实，查找指定位置的已经存在的cell，返回该cell的 index path 。如果在相同的位置有多个cell，该方法默认返回最上层的cell。
 
 你可以通过重载该方法来改变 index path的决定方式。比如，你可以返回z坐标轴最底层cell的index path.当你重载该方法的时候，没有必要去调用super类该方法。
 */
- (NSIndexPath *)targetIndexPathForInteractivelyMovingItem:(NSIndexPath *)previousIndexPath withPosition:(CGPoint)position
{
    return [super targetIndexPathForInteractivelyMovingItem:previousIndexPath withPosition:position];
    
}

#pragma mark - 注册装饰视图, 装饰视图需通过布局注册创建
- (void)registerClass:(Class)viewClass forDecorationViewOfKind:(NSString *)decorationViewKind
{
    [super registerClass:viewClass forDecorationViewOfKind:decorationViewKind];
}
- (void)registerNib:(UINib *)nib forDecorationViewOfKind:(NSString *)decorationViewKind
{
    [super registerNib:nib forDecorationViewOfKind:decorationViewKind];
}

#pragma mark - 增加删除
/**
 返回一个NSIndexPath 类型的数组，该数组存放的是将要添加到collection view中的追加视图的 NSIndexPath 。往collection view添加cell或者section的时候，就会调用该方法。collection view将会在prepareForCollectionViewUpdates: 和finalizeCollectionViewUpdates之间调用该方法
 */
- (NSArray<NSIndexPath *> *)indexPathsToInsertForSupplementaryViewOfKind:(NSString *)elementKind
{
    return [super indexPathsToInsertForSupplementaryViewOfKind:elementKind];
}

- (NSArray<NSIndexPath *> *)indexPathsToInsertForDecorationViewOfKind:(NSString *)elementKind
{
    return [super indexPathsToInsertForDecorationViewOfKind:elementKind];
}

/**
 返回一个NSIndexPath 类型的数组，该数组存放的是将要从collection view中删除的追加视图的 NSIndexPath 。从collection view删除cell或者section的时候，就会调用该方法。collection view将会在prepareForCollectionViewUpdates: 和finalizeCollectionViewUpdates之间调用该方法
 */
- (NSArray<NSIndexPath *> *)indexPathsToDeleteForSupplementaryViewOfKind:(NSString *)elementKind
{
    return [super indexPathsToDeleteForSupplementaryViewOfKind:elementKind];
}

- (NSArray<NSIndexPath *> *)indexPathsToDeleteForDecorationViewOfKind:(NSString *)elementKind
{
    return [super indexPathsToDeleteForDecorationViewOfKind:elementKind];
}

@end
