//
//  YCFCalendarView.m
//  MyYaoChuFaApp
//
//  Created by zq chen on 3/23/15.
//  Copyright (c) 2015 要出发. All rights reserved.
//

#import "BRCalendarView.h"
#import "BRCollectionViewLayout.h"

static NSString * const kCollectionCellIdentify = @"kCollectionCellIdentify";
static NSString * const kCollectionHeaderIdentify = @"kCollectionHeaderIdentify";
static NSString * const kCollectionFooterIdentify = @"kCollectionFooterIdentify";

static const CGFloat kDefaultCalendarWeekHeaderHeight = 35;

static const CGFloat kDefaultCalendarSectionHeaderHeight = 8;
static const CGFloat kDefaultCalendarSectionFooterHeight = 0;

static const CGFloat kDefaultCalendarSectionMonthHeight = 24;
static const CGFloat kDefaultCalendarFoldViewHeight = 44;


@interface BRCalendarView ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout, BRCalendarSectionHeaderViewDelegate, BRCalendarSectionFooterViewDelegate>


@property(nonatomic, assign) BRCalendarViewContentType contentType;
@property(nonatomic, assign) BRCalendarViewDisplayType displayType;

@property(nonatomic, strong) UICollectionView * bigCallendar;
@property(nonatomic, strong) UIView * weekHeadView;
@property(nonatomic, strong) UIView * weekViewBottomLine;
@property(nonatomic, strong) UIView * foldView;
@property(nonatomic, strong) BRSmallCalendarView * smallCalendar;

@property(nonatomic, strong) NSCache * calendarDateModels;
@property(nonatomic, strong) NSMutableArray * smallCalendarModels;

@property(nonatomic, strong) NSIndexPath *showStatusIndexPath;
@property(nonatomic, strong) NSIndexPath *selectedIndexPath;
@property(nonatomic, assign) BOOL isShowStatusView;

@property(nonatomic, strong) BRCalendarModel *selectedModel;
@property(nonatomic, weak)   BRCalendarCell * selectedCell;
@property(nonatomic, weak)   BRCalendarSectionHeaderView * loadMore;

@property(nonatomic, assign) CGFloat cellHeight;

@property(nonatomic, assign) BOOL isFold;
@property(nonatomic, strong) NSTimer * timer;

@property(nonatomic, strong) NSArray<NSDate *> * curScreenMonth;
@end
@implementation BRCalendarView
#pragma mark - API
- (instancetype)initWithDelegate:(id<BRCalendarViewDelegate>)delegate contentType:(BRCalendarViewContentType)contentType displayType:(BRCalendarViewDisplayType)displayType
{
    self = [super init];
    if (self)
    {
        self.contentType = contentType;
        self.displayType = displayType;
        
        self.showStatusIndexPath = [NSIndexPath indexPathForItem:NSIntegerMax inSection:NSIntegerMax];
        self.calendarWidth = kSCREEN_WIDTH;
        NSLog(@"%f", self.calendarWidth);
        self.delegate = delegate;
        self.dateSelected = [NSMutableArray array];
        self.allowsMultipleSelection = NO;
        self.enableSelectedBeforToday = NO;
        self.showLoadMoreBtn = YES;
        self.showShink = YES;
        self.limitOfMonthToShow = 6;
        self.showNumOfMonthEachTime = 3;
        self.startDate = [NSDate date];
        self.endDate = [self.startDate dateAfterMonth:self.showNumOfMonthEachTime - 1];
        
        [self drawViews];
        [self reloadData];
        [self selectedDateInSmallCalendar:[NSDate date]];
        
        self.smallCalendar.hidden = YES;
    }
    
    return self;
}

- (void)reloadData
{
    [self.bigCallendar reloadData];
}

- (void)reloadDataWithContentType:(BRCalendarViewContentType)contentType displayType:(BRCalendarViewDisplayType)displayType
{
    self.contentType = contentType;
    self.displayType = displayType;
    [self reloadData];
}

- (BRCalendarCell *)cellForItemAtDate:(NSDate *)date
{
    
    if (date == nil)
    {
        return nil;
    }
    
    NSInteger starYear = [self.startDate getYear];
    NSInteger starMonth = [self.startDate getMonth];
    
    
    NSInteger endYear = [date getYear];
    NSInteger endMonth = [date getMonth];
    
    NSInteger count = (endYear - starYear)*12 + endMonth - starMonth;
    
    NSDate *firstDateOfMonth = [date dateAfterDay:1-[date getDay]];
    NSDate *firstDayOfSection = [firstDateOfMonth dateAfterDay:1-[firstDateOfMonth weekday]];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    
    NSDateComponents *components = [calendar components:(NSCalendarUnitDay)
                                               fromDate:firstDayOfSection
                                                 toDate:date
                                                options:0];
    
    NSInteger index = [components day];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index+1 inSection:count];
    // 判断 indexPath 是否在 collectionView 已经加载的日历范围内。
    if (indexPath.section < [self.bigCallendar numberOfSections] &&
        indexPath.row < [self.bigCallendar numberOfItemsInSection:indexPath.section])
    {
        return (BRCalendarCell*)[self.bigCallendar cellForItemAtIndexPath:indexPath];
    }
    else
    {
        return nil;
    }
}

- (NSDate *)dateForItemAtCell:(BRCalendarCell *)cell{
    if([cell isKindOfClass:[BRCalendarCell class]]){
        return [cell currentDate];
    }
    return nil;
}

- (void)selectedDateInBigCalendar:(NSDate *)date
{
    
}

- (void)selectedDateInSmallCalendar:(NSDate *)date
{
    NSInteger week = [date weekday];
    NSDate *newDate = [date dateAfterDay:-(week - 1)];
    week = 0;
    do {
        BRCalendarModel *model = [[BRCalendarModel alloc] init];
        model.date = newDate;
        CGFloat cellHeight = kDefaultDateCellHeight;
        if ([self.delegate respondsToSelector:@selector(calendarView:heightWithDateModel:)])
        {
            cellHeight = [self.delegate calendarView:self heightWithDateModel:model];
        }
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:week inSection:0];
        model.cellSize = CGSizeMake([self calculateCellWidth:indexPath], cellHeight);
        [self setWithNormalModel:model date:newDate monthDate:date indexPath:nil];
        [self.smallCalendarModels addObject:model];
        newDate = [newDate dateAfterDay:1];
        week ++;
    } while (week <= kNumOfItemsInLine - 1);
    
    BRCalendarModel *model = self.smallCalendarModels.firstObject;
    self.cellHeight = model.cellSize.height;
    // 这里拿到cell高度后更新smallCalendar的高度
    [self.smallCalendar mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(model.cellSize.height);
    }];
    [self.smallCalendar reloadWithModels:self.smallCalendarModels];
}

- (void)onExpandTimer
{
    // 展开时，选中天所在行到一定位置，隐藏 _smallView.
    CALayer *presentationLayer = self.bigCallendar.layer.presentationLayer;
    CGFloat y = presentationLayer.frame.origin.y + self.cellHeight * [self.selectedModel.date getWeekOfMonth];
    if (y > self.smallCalendar.frame.origin.y || fabs(y - self.smallCalendar.frame.origin.y) < 0.000001) {
        self.smallCalendar.hidden = YES;
    }
}

- (void)onFoldTimer
{
    // 收起时，选中天所在行到一定位置，显示 _smallView.
    CALayer *presentationLayer = self.bigCallendar.layer.presentationLayer;
    CGFloat y = presentationLayer.frame.origin.y + self.cellHeight * [self.selectedModel.date getWeekOfMonth];
    if (y < self.smallCalendar.frame.origin.y || fabs(y - self.smallCalendar.frame.origin.y) < 0.000001) {
        self.smallCalendar.hidden = NO;
    }
}

- (void)expandWithAnimation:(BOOL)animation
{
    __weak typeof(self) weakSelf = self;
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo([weakSelf calculateHeight:self.displayType]);
    }];

    [_timer invalidate];
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.001 target:self selector:@selector(onExpandTimer) userInfo:nil repeats:YES];
    [UIView animateWithDuration:0.3 animations:^{
        [self.superview layoutIfNeeded];
    } completion:^(BOOL finished) {
        [_timer invalidate];
    }];
    self.isFold = NO;
}

- (NSArray *)foldWithAnimation:(BOOL)animation
{
    __weak typeof(self) weakSelf = self;
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo([weakSelf calculateHeight:BRCalendarViewDisplayTypeNav]);
    }];
    
    [_timer invalidate];
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.001 target:self selector:@selector(onFoldTimer) userInfo:nil repeats:YES];
    [UIView animateWithDuration:0.3 animations:^{
        [self.superview layoutIfNeeded];
    } completion:^(BOOL finished) {
        [_timer invalidate];
    }];
    
    return self.smallCalendarModels;
}

- (void)setFoldViewHidden:(BOOL)hidden
{
    if (hidden)
    {
        self.foldView.hidden = YES;
    }
    else
    {
        self.foldView.hidden = NO;
    }
}
#pragma mark - draw views
- (void)drawViews
{
    [self.weekHeadView addSubview:self.weekViewBottomLine];
    [self addSubview:self.weekHeadView];
    [self addSubview:self.bigCallendar];
    [self addSubview:self.smallCalendar];
    [self addSubview:self.foldView];
    
    [self makeContraints];
}

- (void)makeContraints
{
    __weak typeof(self) weakSelf = self;
    [self.weekViewBottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        __weak UIView *superView = weakSelf.weekViewBottomLine.superview;
        make.left.bottom.right.equalTo(superView);
        make.height.mas_equalTo(kOnePixel);
    }];
    
    [self.weekHeadView mas_makeConstraints:^(MASConstraintMaker *make) {
        __weak UIView *superView = weakSelf.weekHeadView.superview;
        make.left.top.right.equalTo(superView);
        make.height.mas_equalTo(kDefaultCalendarWeekHeaderHeight);
    }];
    
    [self.bigCallendar mas_updateConstraints:^(MASConstraintMaker *make) {
        __weak UIView *superView = weakSelf.bigCallendar.superview;
        make.top.equalTo(self.weekHeadView.mas_bottom);
        make.left.bottom.right.equalTo(superView);
    }];
    
    [self.smallCalendar mas_makeConstraints:^(MASConstraintMaker *make) {
        __weak UIView *superView = weakSelf.smallCalendar.superview;
        make.left.right.equalTo(superView);
        make.top.equalTo(self.weekHeadView.mas_bottom);
    }];

    [self.foldView mas_makeConstraints:^(MASConstraintMaker *make) {
        __weak UIView *superView = weakSelf.foldView.superview;
        make.left.bottom.right.equalTo(superView);
        make.height.mas_equalTo(kDefaultCalendarFoldViewHeight);
    }];

}

#pragma mark - UICollectionViewDataSource,UICollectionViewDelegate UICollectionViewDelegateFlowLayout
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    NSInteger count = [self calculateMonth];

    return  count + 1;//1 is load more
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == self.showStatusIndexPath.section && self.isShowStatusView)
    {
        return [self calculateNumOfItems:[self.startDate dateAfterMonth:section] section:section] + 1;
    }
    
    if (section == [self calculateMonth])
    {
        return 0;
    }

    return [self calculateNumOfItems:[self.startDate dateAfterMonth:section] section:section];
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPQ    ath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BRCalendarCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCollectionCellIdentify forIndexPath:indexPath];
    cell.backgroundColor = [UIColor yellowColor];
    cell.titleEdgeInsets = self.titleEdgeInsets;
    cell.detailEdgeInsets = self.detailEdgeInsets;
    cell.contentEdgeInsets = self.contentEdgeInsets;
    cell.showSeparateLine = self.showSeparateLine;
    NSDate *monthDate = [self.startDate dateAfterMonth:indexPath.section];
    NSDate *date = [self getDateWithIndexPath:indexPath monthDate:monthDate];
    NSString *key = [self getKeyStrFromDate:date monthDate:monthDate indexPath:indexPath];
    BRCalendarModel *model = [self.calendarDateModels objectForKey:key];
    
    if (!model || !model.hasBeenInit)
    {
        if (!model)
        {
            model = [[BRCalendarModel alloc] init];
        }
        model.hasBeenInit = YES;
        model.monthDate = monthDate;
        
        if (self.isShowStatusView && indexPath.item == self.showStatusIndexPath.item && indexPath.section == self.showStatusIndexPath.section)//配置expandCell
        {
            model.type = BRCalendarModelTypeExpand;
            if ([self.delegate respondsToSelector:@selector(calendarView:viewForExpandView:model:)])
            {
                UIView *expandView = [self.delegate calendarView:self viewForExpandView:indexPath model:model];
                model.customView = expandView;
            }
        }
        else
        {
            model.type = BRCalendarModelTypeDate;
            model.date = date;
            [self setWithNormalModel:model date:date monthDate:monthDate indexPath:indexPath];
            if ([self.delegate respondsToSelector:@selector(calendarView:viewForCustomCell:model:)])
            {
                model.type = BRCalendarModelTypeCustom;
                UIView *customView = [self.delegate calendarView:self viewForCustomCell:indexPath model:model];
                model.customView = customView;
            }
        }
        [self.calendarDateModels setObject:model forKey:key];
        
    }
    
    //选中状态
    model.hasSelected = NO;
    if (!model.isDayOfOtherMonth && model.enableSelected && self.isShowStatusView && indexPath.item == self.selectedIndexPath.item && indexPath.section == self.selectedIndexPath.section)
    {
        model.hasSelected = YES;
    }
    [cell configureCellWithModel:model];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDate *monthDate = [self.startDate dateAfterMonth:indexPath.section];
    NSDate *date = [self getDateWithIndexPath:indexPath monthDate:monthDate];
    NSString *key = [self getKeyStrFromDate:date monthDate:monthDate indexPath:indexPath];
    BRCalendarModel *model = [self.calendarDateModels objectForKey:key];
    if (model)
    {
        return model.cellSize;
    }
    else
    {
        model = [[BRCalendarModel alloc] init];
        [self.calendarDateModels setObject:model forKey:key];
        model.monthDate = monthDate;
        
        CGFloat cellHeight = 0;
        if (self.isShowStatusView && indexPath.item == self.showStatusIndexPath.item && indexPath.section == self.showStatusIndexPath.section)//配置expandCell
        {
            model.type = BRCalendarModelTypeExpand;
            if ([self.delegate respondsToSelector:@selector(calendarView:heightForExpandView:model:)])
            {
                cellHeight = [self.delegate calendarView:self heightForExpandView:indexPath model:model];
            }
            if (self.showExpandView)
            {
                model.cellSize = CGSizeMake(self.calendarWidth, cellHeight);
            }
            else
            {
                model.cellSize = CGSizeMake(0, 0);
            }
            return model.cellSize;
        }
        else
        {
            cellHeight = kDefaultDateCellHeight;
            if ([self.delegate respondsToSelector:@selector(calendarView:heightWithDateModel:)])
            {
                cellHeight = [self.delegate calendarView:self heightWithDateModel:model];
            }
            CGFloat width = [self calculateCellWidth:indexPath];
            
            model.cellSize = CGSizeMake(width, cellHeight);

            return model.cellSize;
        }
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (self.displayType == BRCalendarViewDisplayTypeMonth)
    {
        return CGSizeZero;
    }
    if (section == [self calculateMonth])
    {
        CGFloat height = 0;
        if (self.showLoadMoreBtn)
        {
            height = kDefaultLoadMoreHeight;
            if ([self.delegate respondsToSelector:@selector(calendarView:heightForLoadMoreWithEndDate:)])
            {
                height = [self.delegate calendarView:self heightForLoadMoreWithEndDate:self.endDate];
            }
            return CGSizeMake(self.bounds.size.width, height);
        }
        else
        {
            return CGSizeZero;
        }

    }
    
    CGFloat height = kDefaultCalendarSectionMonthHeight;
    NSDate *monthDate = [self.startDate dateAfterMonth:section];
    if ([self.delegate respondsToSelector:@selector(calendarView:heightForHeaderInMonth:)])
    {
        height = [self.delegate calendarView:self heightForHeaderInMonth:monthDate];
    }
    
    if (!self.showMonthSection)
    {
        height = kDefaultCalendarSectionHeaderHeight;
    }
    
    return CGSizeMake(self.bounds.size.width, height);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    if (self.displayType == BRCalendarViewDisplayTypeMonth)
    {
        return CGSizeZero;
    }
    CGFloat height = kDefaultCalendarSectionFooterHeight;
    NSDate *monthDate = [self.startDate dateAfterMonth:section];

    if ([self.delegate respondsToSelector:@selector(calendarView:heightForFooterInMonth:)])
    {
        height = [self.delegate calendarView:self heightForFooterInMonth:monthDate];
    }
    return CGSizeMake(self.bounds.size.width, height);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (self.displayType == BRCalendarViewDisplayTypeMonth)
    {
        return nil;
    }
    NSDate *monthDate =[self.startDate dateAfterMonth:indexPath.section];

    if ([kind isEqualToString:UICollectionElementKindSectionHeader])
    {
        BRCalendarSectionHeaderView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kCollectionHeaderIdentify forIndexPath:indexPath];
        header.delegate = self;
        if (indexPath.section == [self calculateMonth])
        {
            header.isLoadMore = YES;
            if (indexPath.section == self.limitOfMonthToShow)
            {
                header.isLoadAll = YES;
            }
            else
            {
                header.isLoadAll = NO;
            }
            self.loadMore = header;
        }
        else
        {
            header.isLoadMore = NO;
            header.isLoadAll = NO;
        }
        [header defaultConfigWithMonth:monthDate];
        [header configMonthLabelPosition:self.monthSectionLRMargin type:self.monthSectionType monthDate:monthDate];

        UIView *headerCustom = nil;
        if ([self.delegate respondsToSelector:@selector(calendarView:viewForHeaderInMonth:headerView:)])
        {
            headerCustom = [self.delegate calendarView:self viewForHeaderInMonth:monthDate headerView:header];
        }
        
        [header configIfNeedCustom:headerCustom];

        return header;
    }
    else if([kind isEqualToString:UICollectionElementKindSectionFooter])
    {
        BRCalendarSectionFooterView *footer = nil;
        if ([self.delegate respondsToSelector:@selector(calendarView:heightForFooterInMonth:)])
        {
            footer = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:kCollectionFooterIdentify forIndexPath:indexPath];
            footer.delegate = self;
        }
        UIView *footerCustom = nil;
        if ([self.delegate respondsToSelector:@selector(calendarView:viewForFooterInMonth:footerView:)])
        {
            footerCustom = [self.delegate calendarView:self viewForFooterInMonth:monthDate footerView:footer];
        }
        [footer configWithMonth:monthDate isNeedCustom:footerCustom];
        return footer;
    }
    return nil;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    if (section == [self calculateMonth])
    {
        return 0;
    }
    return kCellHorizontalPadding;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    if (section == [self calculateMonth])
    {
        return 0;
    }
    return kCellVerticalPadding;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    BRCalendarCell *cell = (BRCalendarCell*)[collectionView cellForItemAtIndexPath:indexPath];
    BRCalendarModel *model = [cell originalModel];

    if(model.type == BRCalendarModelTypeDate && model.enableSelected)
    {
        if (!self.allowsMultipleSelection)
        {
            BOOL isInsert = YES;

            if (indexPath.item == self.selectedIndexPath.item && indexPath.section == self.selectedIndexPath.section)
            {
                self.isShowStatusView = !self.isShowStatusView;
            }
            else
            {
                if (self.isShowStatusView)
                {
                    isInsert = NO;
                }
                if (self.isShowStatusView && indexPath.item > self.showStatusIndexPath.item && indexPath.section == self.showStatusIndexPath.section)
                {
                    // 当选中statusView后面的cell时, 由于statusView占一个cell, 所以后面的selectedCell为indexPath减去1的那个cell;
                    self.selectedIndexPath = [NSIndexPath indexPathForItem:indexPath.item - 1 inSection:indexPath.section];
                }else{
                    
                    self.selectedIndexPath = indexPath;
                }
                self.isShowStatusView = YES;
            }
            self.selectedModel = model;
            self.selectedCell = cell;
            NSInteger showStatusItem = (self.selectedIndexPath.row + 7) - (self.selectedIndexPath.row % 7);
            if (showStatusItem > [self.bigCallendar numberOfItemsInSection:indexPath.section])
            {
                showStatusItem = [self.bigCallendar numberOfItemsInSection:indexPath.section] - 1;
            }
            self.showStatusIndexPath = [NSIndexPath indexPathForItem:showStatusItem inSection:indexPath.section];
            
            if (self.isShowStatusView)
            {
                if (isInsert)
                {
                    [self.bigCallendar insertItemsAtIndexPaths:@[self.showStatusIndexPath]];
                    [self.bigCallendar reloadItemsAtIndexPaths:@[self.selectedIndexPath]];
                }
                else
                {
                    [self.bigCallendar reloadData];
                }
            }
            else
            {
                [self.bigCallendar deleteItemsAtIndexPaths:@[self.showStatusIndexPath]];
                [self.bigCallendar reloadItemsAtIndexPaths:@[self.selectedIndexPath]];
            }

            if([self.delegate respondsToSelector:@selector(calendarView:didSelectedCell:model:)])
            {
                [self.delegate calendarView:self didSelectedCell:cell model:self.selectedModel];
            }
        }
        
    }
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    //    YCFCalendarCell *cell = (YCFCalendarCell*)[collectionView cellForItemAtIndexPath:indexPath];
}

// 性能不好, 为了滚动时候动态显示月份
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSArray *visibleItems = [self.bigCallendar indexPathsForVisibleItems];
    if (visibleItems.count <= 0)
    {
        return;
    }
    NSIndexPath *indexp = [NSIndexPath indexPathForItem:NSIntegerMax inSection:NSIntegerMax];
    for (int i = 0; i<visibleItems.count; i++) {
        NSIndexPath *indexPath = visibleItems[i];
        if (indexPath.section < indexp.section) {
            indexp = indexPath;
        }
    }
    for (int j = 0; j<visibleItems.count; j++) {
        NSIndexPath *indexPath = visibleItems[j];
        if (indexPath.section > indexp.section) {
            continue;
        }
        if (indexPath.item < indexp.item) {
            indexp = indexPath;
        }
    }
    
    UICollectionViewCell *cell = [self.bigCallendar cellForItemAtIndexPath:indexp];
    if ([cell isKindOfClass:[BRCalendarCell class]])
    {
        BRCalendarCell *selCell = (BRCalendarCell *)cell;
        if ([self.delegate respondsToSelector:@selector(calendarView:showCurrentMonth:)])
        {
            [self.delegate calendarView:self showCurrentMonth:[selCell originalModel].monthDate];
        }
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if ((self.bigCallendar.contentOffset.y + self.bigCallendar.frame.size.height) > self.bigCallendar.contentSize.height) {
        self.loadFromDate = [self.endDate dateAfterDay:1];
        self.endDate = [self.endDate dateAfterMonth:self.showNumOfMonthEachTime];
        if ([self.delegate respondsToSelector:@selector(loadMoreOfCalendarView:fromDate:endDate:loadMoreView:)]) {
            [self.delegate loadMoreOfCalendarView:self fromDate:self.loadFromDate endDate:self.endDate loadMoreView:self.loadMore];
            [self reloadData];
        }
        else{
            [self reloadData];
        }
    }
}

#pragma mark - BRCalendarSectionHeaderViewDelegate, BRCalendarSectionFooterViewDelegate
- (void)calendarSectionHeaderView:(BRCalendarSectionHeaderView *)headerView didSelectedWithMonth:(NSDate *)month
{
    if (headerView.isLoadMore && self.showLoadMoreBtn)
    {
        [self loadMoreData:headerView];
    }
}

- (void)calendarSectionFooterView:(BRCalendarSectionFooterView *)footerView didSelectedWithMonth:(NSDate *)month
{
    
}

#pragma mark - if cell selected
- (BOOL)isCellSelected:(NSDate*)date{
    for (NSDate *tDate in self.dateSelected) {
        if ([[date getFormatYearMonthDay] doubleValue] == [[tDate getFormatYearMonthDay] doubleValue]) {
            return YES;
            break;
        }
    }
    return NO;
}

#pragma mark - draw weekday view
- (UIView*)drawWeekDayView
{
    UIView *weekView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kDefaultCalendarWeekHeaderHeight)];
    weekView.backgroundColor = [UIColor whiteColor];

    UIView *bottomLineView = [UIView drawLineWithWidth:kSCREEN_WIDTH color:[UIColor lightGrayColor]];
    
    int width = (kSCREEN_WIDTH - (kNumOfItemsInLine -1) * kCellHorizontalPadding)/kNumOfItemsInLine;
    float fOfferSet = kSCREEN_WIDTH - width*kNumOfItemsInLine - (kNumOfItemsInLine -1) * kCellHorizontalPadding;
    int iOfferSet = (int)fOfferSet;

    for (int i = 0; i < kNumOfItemsInLine; i++) {
        CGRect frame = CGRectMake(width*i + kCellHorizontalPadding*i, 0, width, weekView.frame.size.height);

        if (iOfferSet > i) {
            frame.origin.x += i;
            frame.size.width = width + 1;
        }
        else if(fOfferSet > i){
            frame.origin.x += fOfferSet;
            frame.size.width = width + fOfferSet - iOfferSet;
        }
        else{
            frame.origin.x += fOfferSet;
        }

        UILabel *label = [[UILabel alloc] initWithFrame:frame];
        label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        label.text = [self p_intToChinese:i];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:11];
        label.textColor = [UIColor colorWithHexString:@"000000"];
        [weekView addSubview:label];
    }

    [weekView addSubview:bottomLineView];
    return weekView;
}

//数字转中文
-(NSString *)p_intToChinese:(NSInteger)intNum{
    NSString *numStr = @"";
    switch (intNum) {
        case 0:
            return NSLocalizedString(@"日", @"");
            break;
        case 1:
            return NSLocalizedString(@"一", @"");
            break;
        case 2:
            return NSLocalizedString(@"二", @"");
            break;
        case 3:
            return NSLocalizedString(@"三", @"");
            break;
        case 4:
            return NSLocalizedString(@"四", @"");
            break;
        case 5:
            return NSLocalizedString(@"五", @"");
            break;
        case 6:
            return  NSLocalizedString(@"六", @"");
            break;
        default:
            break;
    }
    return numStr;
}

- (NSArray *)dateForSelected{
    return [self.dateSelected copy];
}

#pragma mark - IBAction
- (void)p_editRoomStatus:(UIButton *)editBtn
{
    if([self.delegate respondsToSelector:@selector(calendarView:editCellSelected:model:)]) {
        [self.delegate calendarView:self editCellSelected:self.selectedCell model:self.selectedModel];
    }
}

- (void)tapFoldView
{
    self.isFold = !self.isFold;
    if (self.isFold)
    {
        [self foldWithAnimation:YES];
    }
    else
    {
        [self expandWithAnimation:YES];
    }
}
#pragma mark - private methods

- (void)setWithNormalModel:(BRCalendarModel *)model date:(NSDate *)date monthDate:(NSDate *)monthDate indexPath:(NSIndexPath *)indexPath
{
    model.type = BRCalendarModelTypeDate;
    
    if (([date getYear] != [monthDate getYear] || [date getMonth] != [monthDate getMonth]))
    {
        model.isDayOfOtherMonth = YES;
    }
    
    if (model.isDayOfOtherMonth || (model.isDayBeforToday && !self.enableSelectedBeforToday))
    {
        model.enableSelected = NO;
    }
    else
    {
        model.enableSelected = YES;
    }
    
    model.hasSelected = NO;
    if (!model.isDayOfOtherMonth && model.enableSelected && self.isShowStatusView && indexPath.item == self.selectedIndexPath.item && indexPath.section == self.selectedIndexPath.section)
    {
        model.hasSelected = YES;
    }
    
    if ([self.delegate respondsToSelector:@selector(calendarView:model:)])
    {
        model = [self.delegate calendarView:self model:model];
    }
}

- (NSDate *)getDateWithIndexPath:(NSIndexPath *)indexPath monthDate:(NSDate *)monthDate
{
    NSDate *firstDateOfMonth = [monthDate dateAfterDay:1-[monthDate getDay]];
    NSDate *firstDateOfSection = [firstDateOfMonth dateAfterDay:1-[firstDateOfMonth weekday]];
    if (indexPath.section == 0)
    {
        firstDateOfSection = [self.startDate dateAfterDay:1 - [self.startDate weekday]];
    }
    NSDate *date = nil;
    if (self.isShowStatusView && indexPath.item > self.showStatusIndexPath.item && indexPath.section == self.showStatusIndexPath.section)
    {
        date = [firstDateOfSection dateAfterDay:indexPath.row - 1];
    }
    else
    {
        date = [firstDateOfSection dateAfterDay:indexPath.row];
    }
    return date;
}

- (void)loadMoreData:(BRCalendarSectionHeaderView *)loadMoreView
{
    self.loadFromDate = [self.endDate dateAfterDay:1];
    self.endDate = [self.endDate dateAfterMonth:self.showNumOfMonthEachTime];
    if ([self.delegate respondsToSelector:@selector(loadMoreOfCalendarView:fromDate:endDate:loadMoreView:)])
    {
        [self.delegate loadMoreOfCalendarView:self fromDate:self.loadFromDate endDate:self.endDate loadMoreView:loadMoreView];
    }
    else
    {
        [self reloadData];
    }
}

- (CGFloat)calculateCellWidth:(NSIndexPath *)indexPath
{
    int width = (kSCREEN_WIDTH - (kNumOfItemsInLine -1) * kCellHorizontalPadding)/kNumOfItemsInLine;
    float fOfferSet = kSCREEN_WIDTH - width*kNumOfItemsInLine - (kNumOfItemsInLine -1) * kCellHorizontalPadding;
    int iOfferSet = (int)fOfferSet;
    
    int tmp = indexPath.row % kNumOfItemsInLine;
    if (iOfferSet >= tmp && tmp != 0) {
        width = width + 1;
    }
    else if(fOfferSet > tmp){
        width = width + fOfferSet - iOfferSet;
    }
    return width;
}

- (NSString *)getKeyStrFromDate:(NSDate *)date monthDate:(NSDate *)monthDate indexPath:(NSIndexPath *)indexPath
{
    NSString *dateStr = [NSDate stringFromDate:date];
    NSString *key = nil;
    if (dateStr.length >= 10)
    {
        key = [NSString stringWithFormat:@"%zd-%@", [monthDate getMonth], [[NSDate stringFromDate:date] substringToIndex:10]];
    }
    else
    {
        key = [NSString stringWithFormat:@"%zd%zd", indexPath.item, indexPath.section];
    }
    if (self.isShowStatusView && indexPath.item == self.showStatusIndexPath.item && indexPath.section == self.showStatusIndexPath.section)//配置expandCell
    {
        key = [NSString stringWithFormat:@"%@-showStatus", [[NSDate stringFromDate:self.selectedModel.date]substringToIndex:10]];
    }
    return key;
}

- (NSInteger)calculateMonth
{
    NSInteger starYear = [self.startDate getYear];
    NSInteger starMonth = [self.startDate getMonth];
    
    NSInteger endYear = [self.endDate getYear];
    NSInteger endMonth = [self.endDate getMonth];
    
    NSInteger count = (endYear - starYear)*12 + endMonth - starMonth + 1;
    
    
    return count;
}

- (NSInteger)calculateNumOfItems:(NSDate*)date section:(NSInteger)section
{
    NSInteger count = 0;
    if (section == 0)
    {
        count = ([date getWeekNumOfMonth] - [date getWeekOfMonth] + 1) * 7;
    }
    else
    {
        count = [date getWeekNumOfMonth] * kNumOfItemsInLine;
    }
    return count;
}

- (CGFloat)calculateHeight:(BRCalendarViewDisplayType)displayType
{
    CGFloat height = 0;
    
    //    int width = (kSCREEN_WIDTH - (kNumOfItemsInLine -1) * kCellHorizontalPadding)/kNumOfItemsInLine;
    //    height += width * ([self.startDate getWeekNumOfMonth]);
    switch (displayType) {
        case BRCalendarViewDisplayTypeScreen: {
            height = kSCREEN_HEIGHT - CGRectGetMinY(self.frame);
            break;
        }
        case BRCalendarViewDisplayTypeNav: {
            height = kDefaultCalendarWeekHeaderHeight + self.cellHeight + kDefaultCalendarFoldViewHeight;
            break;
        }
        case BRCalendarViewDisplayTypeMonth: {
            NSDate *monthDate = self.curScreenMonth.firstObject;
            height = kDefaultCalendarWeekHeaderHeight + [monthDate getWeekNumOfMonth] * self.cellHeight + kDefaultCalendarFoldViewHeight;
            break;
        }
    }
    return height;
}
#pragma mark - setter
- (void)setStartDate:(NSDate *)startDate
{
    _startDate = startDate;
    self.loadFromDate = _startDate;
}

- (void)setEndDate:(NSDate *)endDate
{
    _endDate = [endDate endOfMonth];
    NSInteger count = ([_endDate getYear] - [self.startDate getYear])*12 + [_endDate getMonth] - [self.startDate getMonth] + 1;
    if (count >= self.limitOfMonthToShow)
    {
        _endDate = [[self.startDate dateAfterMonth:self.limitOfMonthToShow - 1] endOfMonth];
    }
    self.loadToDate = _endDate;
}

- (void)setLimitOfMonthToShow:(NSInteger)limitOfMonthToShow
{
    _limitOfMonthToShow = limitOfMonthToShow;
    if (_limitOfMonthToShow < 1) {
        _limitOfMonthToShow = 1;
    }
    self.endDate = _endDate;//重新设置limitOfMonthToShow后需要，重新判断endDate
}

- (void)setShowNumOfMonthEachTime:(NSInteger)showNumOfMonthEachTime
{
    _showNumOfMonthEachTime = showNumOfMonthEachTime;
    if (_showNumOfMonthEachTime < 1) {
        _showNumOfMonthEachTime = 1;
    }
}

#pragma mark - getter

- (UIView *)weekHeadView
{
    if (!_weekHeadView)
    {
        _weekHeadView = [[UIView alloc] init];
        _weekHeadView.bounds = CGRectMake(0, 0, self.calendarWidth, kDefaultCalendarWeekHeaderHeight);
        _weekHeadView.backgroundColor = [UIColor whiteColor];
        
        int width = (kSCREEN_WIDTH - (kNumOfItemsInLine -1) * kCellHorizontalPadding)/kNumOfItemsInLine;
        float fOfferSet = kSCREEN_WIDTH - width*kNumOfItemsInLine - (kNumOfItemsInLine -1) * kCellHorizontalPadding;
        int iOfferSet = (int)fOfferSet;
        
        for (int i = 0; i < kNumOfItemsInLine; i++) {
            CGRect frame = CGRectMake(width*i + kCellHorizontalPadding*i, 0, width, _weekHeadView.frame.size.height);
            
            if (iOfferSet > i) {
                frame.origin.x += i;
                frame.size.width = width + 1;
            }
            else if(fOfferSet > i){
                frame.origin.x += fOfferSet;
                frame.size.width = width + fOfferSet - iOfferSet;
            }
            else{
                frame.origin.x += fOfferSet;
            }
            
            UILabel *label = [[UILabel alloc] initWithFrame:frame];
            label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
            label.text = [self p_intToChinese:i];
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont systemFontOfSize:11];
            label.textColor = [UIColor colorWithHexString:@"000000"];
            [_weekHeadView addSubview:label];
        }
    }
    return _weekHeadView;
}

- (UIView *)weekViewBottomLine
{
    if (!_weekViewBottomLine)
    {
        _weekViewBottomLine = [UIView drawLineWithWidth:self.calendarWidth];
    }
    return _weekViewBottomLine;
}

- (UICollectionView *)bigCallendar
{
    if (!_bigCallendar)
    {
        BRCollectionViewLayout *flowLayout=[[BRCollectionViewLayout alloc] init];
        flowLayout.itemHeight = 49;
        flowLayout.columnCount = kNumOfItemsInLine;
        flowLayout.rowMargin = 0;
        flowLayout.columnMargin =0;
        flowLayout.scrollDirection = BRCollectionViewLayoutScrollDirectionVertical;
        flowLayout.layoutType = BRCollectionViewLayoutTypeHorizontal;
        
        _bigCallendar = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _bigCallendar.delegate = self;
        _bigCallendar.dataSource = self;
        _bigCallendar.backgroundColor = [UIColor whiteColor];
        [_bigCallendar registerClass:[BRCalendarCell class] forCellWithReuseIdentifier:kCollectionCellIdentify];
        [_bigCallendar registerClass:[BRCalendarSectionHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kCollectionHeaderIdentify];
        [_bigCallendar registerClass:[BRCalendarSectionFooterView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:kCollectionFooterIdentify];
        
        if (self.displayType == BRCalendarViewDisplayTypeMonth)
        {
            flowLayout.scrollDirection = BRCollectionViewLayoutScrollDirectionHorizontal;
            _bigCallendar.pagingEnabled = YES;
        }
        else if(self.displayType == BRCalendarViewDisplayTypeScreen)
        {
            flowLayout.scrollDirection = BRCollectionViewLayoutScrollDirectionVertical;
            _bigCallendar.pagingEnabled = NO;
        }

    }
    return _bigCallendar;
}

- (UIView *)foldView
{
    if (!_foldView)
    {
        _foldView = [[UIView alloc] init];
        _foldView.backgroundColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:0.5];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapFoldView)];
        [_foldView addGestureRecognizer:tap];
    }
    return _foldView;
}

- (BRSmallCalendarView *)smallCalendar
{
    if (!_smallCalendar)
    {
        _smallCalendar = [BRSmallCalendarView createSmallCallendarView];
    }
    return _smallCalendar;
}

- (NSCache *)calendarDateModels
{
    if (!_calendarDateModels)
    {
        _calendarDateModels = [[NSCache alloc] init];
    }
    return _calendarDateModels;
}

- (NSMutableArray *)smallCalendarModels
{
    if (!_smallCalendarModels)
    {
        _smallCalendarModels = [NSMutableArray array];
    }
    return _smallCalendarModels;
}
@end
