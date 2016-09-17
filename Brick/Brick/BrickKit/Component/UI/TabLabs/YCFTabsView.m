//
//  YCFTabs.m
//  YCFComponentKit_OC
//
//  Created by jinxiaofei on 16/8/15.
//  Copyright © 2016年 yaochufa. All rights reserved.
//

#import "YCFTabsView.h"
#import "UIView+Magic.h"

#pragma mark - YCFTabButton
@interface YCFTabButton : UIButton
@property(nonatomic, assign) UIEdgeInsets contentInsets;
@property(nonatomic, assign) UIEdgeInsets iconInsets;
@property(nonatomic, assign) UIEdgeInsets titleInsets;
@property(nonatomic, assign) YCFTabsItemBtnType btnType;

- (void)configTabItemBtn:(YCFTabsItemBtnType)btnType contentInsets:(UIEdgeInsets)contentInsets titleInsets:(UIEdgeInsets)titleInsets iconInsets:(UIEdgeInsets)iconInsets;

@end

#pragma mark - YCFTabs
@interface YCFTabsView ()<UIGestureRecognizerDelegate>
@property(nonatomic, assign) BOOL isNeedEqualWidth;
@property(nonatomic, strong, setter=setTabs:) NSArray<UIView *> *tabs;
@property(nonatomic, strong, getter=getTabsContent) NSMutableArray<UIView *> *tabsContent;
@property (nonatomic, strong, getter=getSplitLines) NSMutableArray<UIView *> *splitLines;

@property(nonatomic, strong) UIView *bottomIndicator;

@property(nonatomic, weak) UIView *selectedItem;

@property(nonatomic, strong) NSMutableArray<NSNumber *> *itemXCaches;

@property(nonatomic, strong) UITouch *touch;
@end


#pragma mark - YCFTabs
@implementation YCFTabsView
@dynamic delegate;

#pragma mark - life
- (instancetype)initWithTabsViewWithTitles:(NSArray<NSString *> *)titles
                                 iconImage:(NSArray<NSString *> *)icons
                                iconImageH:(NSArray<NSString *> *)iconsH
                                iconImageS:(NSArray<NSString *> *)iconsS
                                   bgImage:(NSArray<NSString *> *)bgImages
                                  bgImageH:(NSArray<NSString *> *)bgImagesH
                                  bgImageS:(NSArray<NSString *> *)bgImagesS
                          isNeedEqualWidth:(BOOL)isNeedEqualWidth
{
    if (self = [super init])
    {
        self.isNeedEqualWidth = isNeedEqualWidth;
        [self p_createTabsWithTabsViewWithTitles:titles
                                       iconImage:icons
                                     iconImageH:iconsH
                                      iconImageS:iconsS
                                         bgImage:bgImages
                                        bgImageH:bgImagesH
                                        bgImageS:bgImagesS];
        self.selectedItem = self.tabs.firstObject;
        [self getTabsContent];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.bottomIndicatorColor = [UIColor redColor];
        self.selectedIndex = 0;
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
    }
    return self;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    [self p_getFixedContentSize];
    [self p_layoutTabs];
}

- (void)configTabItemBtn:(YCFTabsItemBtnType)btnType contentInsets:(UIEdgeInsets)contentInsets titleInsets:(UIEdgeInsets)titleInsets iconInsets:(UIEdgeInsets)iconInsets
{
    for (YCFTabButton *tabBtn in self.tabs)
    {
        if ([tabBtn isKindOfClass:[YCFTabButton class]])
        {
            [tabBtn configTabItemBtn:btnType contentInsets:contentInsets titleInsets:titleInsets iconInsets:iconInsets];
        }
    }
}

- (void)selectedTabItemAtIndex:(NSInteger)index
{
    if (index >= self.tabs.count)
    {
        return;
    }
    UIView *tabsContent = self.tabsContent[index];
    if ([self.delegate respondsToSelector:@selector(tabsView:didSelectedTabItemAtIndex:selectedItem:)])
    {
        [self.delegate tabsView:self didSelectedTabItemAtIndex:index selectedItem:[self objectAtIndex:index array:self.tabs]];
    }
    
    self.selectedIndex = index;
    [self p_setupTabItemSelectedStyle:tabsContent];
    [self p_setupTabItemCenter:tabsContent];
    
    [self p_setSelectedItem];
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    self.touch = touch;
    return YES;
}

#pragma mark - action

- (void)didSelectedTabItem:(UITapGestureRecognizer *)tap
{  
    if (self.touch.tapCount >= 2)
    {
        if ([self.delegate respondsToSelector:@selector(tabsView:didDoubleClickedTabItemAtIndex:selectedItem:)])
        {
            [self.delegate tabsView:self didDoubleClickedTabItemAtIndex:tap.view.tag selectedItem:[self objectAtIndex:tap.view.tag array:self.tabs]];
        }
    }
    else
    {
        if ([self.delegate respondsToSelector:@selector(tabsView:didSelectedTabItemAtIndex:selectedItem:)])
        {
            [self.delegate tabsView:self didSelectedTabItemAtIndex:tap.view.tag selectedItem:[self objectAtIndex:tap.view.tag array:self.tabs]];
        }
    }

    self.selectedIndex = tap.view.tag;
    [self p_setupTabItemSelectedStyle:tap.view];
    [self p_setupTabItemCenter:tap.view];
    
    [self p_setSelectedItem];
}

#pragma mark - private methods
- (void)p_setSelectedItem
{
    if ([self.selectedItem isKindOfClass:[YCFTabButton class]])
    {
        YCFTabButton *btn = (YCFTabButton *)self.selectedItem;
        btn.selected = NO;
    }
    
    UIView *selectedItem = self.tabs[self.selectedIndex];
    if ([selectedItem isKindOfClass:[YCFTabButton class]])
    {
        YCFTabButton *tabBtn = (YCFTabButton *)selectedItem;
        tabBtn.selected = YES;
        self.selectedItem = tabBtn;
    }
    {
        self.selectedItem = selectedItem;
    }
}

- (void)p_setupTabItemCenter:(UIView *)tab
{
    // 设置居中
    switch (self.layoutType) {
        case YCFTabsLayoutTypeHorizontal:
        {
            if (self.contentSize.width <= self.frame.size.width)
            {
                return;
            }
            CGFloat offsetX = tab.center.x - self.frame.size.width * 0.5;
            if (offsetX < 0)
            {
                offsetX = 0;
            }
            
            CGFloat maxOffsetX = self.contentSize.width - self.frame.size.width;
            if (offsetX > maxOffsetX)
            {
                offsetX = maxOffsetX;
            }
            
            [self setContentOffset:CGPointMake(offsetX, 0) animated:YES];

            break;
        }
        case YCFTabsLayoutTypeVertical:
        {
            if (self.contentSize.height <= self.frame.size.height)
            {
                return;
            }
            CGFloat offsetY = tab.center.y - self.frame.size.height * 0.5;
            if (offsetY < 0)
            {
                offsetY = 0;
            }
            
            CGFloat maxOffsetY = self.contentSize.height - self.frame.size.height;
            if (offsetY > maxOffsetY)
            {
                offsetY = maxOffsetY;
            }
            
            [self setContentOffset:CGPointMake(0, offsetY) animated:YES];
            break;
        }
    }
    
}

- (void)p_setupTabItemSelectedStyle:(UIView *)tab
{
    switch (self.tabsStyle) {
        case YCFTabsStyleNone: {
            
            break;
        }
        case YCFTabsStyleLine: {
            [self p_setupIndicatorView:tab];
            break;
        }
        case YCFTabsStyleCharFlow: {
            
            break;
        }
    }
}

- (void)p_setupIndicatorView:(UIView *)tab
{
    switch (self.layoutType) {
        case YCFTabsLayoutTypeHorizontal: {
            CGFloat height = self.bottomIndicatorSize.height > 0 ? self.bottomIndicatorSize.height : 3;

            CGFloat x = tab.frame.origin.x + tab.frame.size.width * 0.5 + self.bottomIndicatorInsets.left - self.bottomIndicatorInsets.right;
            CGFloat y = self.frame.size.height - height * 0.5 + self.bottomIndicatorInsets.top - self.bottomIndicatorInsets.bottom;
            self.bottomIndicator.center = CGPointMake(x,y);
            if (!self.isNeedEqualWidth)
            {
                CGRect bounds = self.bottomIndicator.bounds;
                bounds.size.width = tab.bounds.size.width;
                self.bottomIndicator.bounds = bounds;
            }
            break;
        }
        case YCFTabsLayoutTypeVertical: {
            CGFloat width = self.bottomIndicatorSize.width > 0 ? self.bottomIndicatorSize.width : 3;

            CGFloat x = self.frame.size.width - width * 0.5 + self.bottomIndicatorInsets.left - self.bottomIndicatorInsets.right;
            CGFloat y = tab.frame.origin.y + tab.frame.size.height * 0.5 + self.bottomIndicatorInsets.top - self.bottomIndicatorInsets.bottom;
            self.bottomIndicator.center = CGPointMake(x, y);
            if (!self.isNeedEqualWidth)
            {
                CGRect bounds = self.bottomIndicator.bounds;
                bounds.size.height = tab.bounds.size.height;
                self.bottomIndicator.bounds = bounds;
            }

            break;
        }
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        
    }];
}

- (void)p_layoutTabs
{
    NSInteger index = 0;
    for (UIView *tab in self.tabs)
    {
        UIView *content = self.tabsContent[index];
        UIView *line = self.splitLines[index];
        line.backgroundColor = self.splitLineColor;
        [content addSubview:tab];
        [content addSubview:line];
        [self addSubview:content];
        
        switch (self.layoutType) {
            case YCFTabsLayoutTypeHorizontal:
            {
                CGFloat X = [self.itemXCaches[index] floatValue];
                CGFloat Y = self.borderPadding.top;
                CGFloat w = self.isNeedEqualWidth ? self.equalWidth : tab.frame.size.width;
                content.frame = CGRectMake(X, Y, w, self.frame.size.height);
                tab.frame = content.bounds;
                CGFloat lineX = w - self.splitLineSize.width * 0.5 + self.columnMargin * 0.5 + self.splitLineInsets.left - self.splitLineInsets.right ;
                CGFloat lineY = self.splitLineInsets.top - self.splitLineInsets.bottom;
                line.frame = CGRectMake(lineX, lineY, self.splitLineSize.width, self.splitLineSize.height);
                if (index == self.selectedIndex && self.tabsStyle == YCFTabsStyleLine)
                {
                    [self addSubview:self.bottomIndicator];
                    CGFloat width = self.bottomIndicatorSize.width > 0 ? self.bottomIndicatorSize.width : tab.frame.size.width;
                    CGFloat height = self.bottomIndicatorSize.height > 0 ? self.bottomIndicatorSize.height : 3;
                    CGFloat x = content.frame.origin.x + content.frame.size.width * 0.5 + self.bottomIndicatorInsets.left - self.bottomIndicatorInsets.right;
                    CGFloat y = self.frame.size.height - height * 0.5 + self.bottomIndicatorInsets.top - self.bottomIndicatorInsets.bottom;
                    self.bottomIndicator.bounds = CGRectMake(0, 0, width, height);
                    self.bottomIndicator.center = CGPointMake(x,y);
                }
                break;
            }
            case YCFTabsLayoutTypeVertical:
            {
                CGFloat X = self.borderPadding.left;
                CGFloat Y = [self.itemXCaches[index] floatValue];
                CGFloat h = self.isNeedEqualWidth ? self.equalWidth : tab.bounds.size.height;
                content.frame = CGRectMake(X, Y, self.frame.size.width, h);
                tab.frame = content.bounds;
                CGFloat lineX = self.splitLineInsets.left - self.splitLineInsets.right;
                CGFloat lineY = h - self.splitLineSize.height * 0.5 + self.columnMargin * 0.5 + self.splitLineInsets.top - self.splitLineInsets.bottom;
                line.frame = CGRectMake(lineX, lineY, self.splitLineSize.width, self.splitLineSize.height);
                if (index == self.selectedIndex && self.tabsStyle == YCFTabsStyleLine)
                {
                    [self addSubview:self.bottomIndicator];
                    CGFloat width = self.bottomIndicatorSize.width > 0 ? self.bottomIndicatorSize.width : 3;
                    CGFloat height = self.bottomIndicatorSize.height > 0 ? self.bottomIndicatorSize.height : tab.frame.size.height;
                    CGFloat x = self.frame.size.width - width * 0.5 + self.bottomIndicatorInsets.left - self.bottomIndicatorInsets.right;
                    CGFloat y = content.frame.origin.y + content.frame.size.height * 0.5 + self.bottomIndicatorInsets.top - self.bottomIndicatorInsets.bottom;
                    self.bottomIndicator.bounds = CGRectMake(0, 0, width, height);
                    self.bottomIndicator.center = CGPointMake(x, y);
                }
                break;
            }
        }
        
        tab.center = CGPointMake(content.bounds.size.width * 0.5, content.bounds.size.height * 0.5);
        
        index ++;
    }
}

- (void)p_createTabsWithTabsViewWithTitles:(NSArray<NSString *> *)titles
                                 iconImage:(NSArray<NSString *> *)icons
                                iconImageH:(NSArray<NSString *> *)iconsH
                                iconImageS:(NSArray<NSString *> *)iconsS
                                   bgImage:(NSArray<NSString *> *)bgImages
                                  bgImageH:(NSArray<NSString *> *)bgImagesH
                                  bgImageS:(NSArray<NSString *> *)bgImagesS
{
    NSMutableArray *tabs = [NSMutableArray array];
    NSInteger count = titles.count > icons.count ? titles.count : icons.count;
    for (int i = 0; i < count; i++)
    {
        YCFTabButton *tabBtn = [[YCFTabButton alloc] init];

        NSString *title = [self objectAtIndex:i array:titles];
        if (titles && title.length > 0)
        {
            [tabBtn setTitle:title forState:UIControlStateNormal];
        }
        
        NSString *icon = [self objectAtIndex:i array:icons];
        if (icon && icon.length > 0)
        {
            [tabBtn setImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
        }
        
        NSString *iconH = [self objectAtIndex:i array:iconsH];
        if (iconH && iconH.length > 0)
        {
            [tabBtn setImage:[UIImage imageNamed:iconH] forState:UIControlStateHighlighted];
        }
        
        NSString *iconS = [self objectAtIndex:i array:iconsS];
        if (iconS && iconS.length > 0)
        {
            [tabBtn setImage:[UIImage imageNamed:iconS] forState:UIControlStateSelected];
        }
        
        NSString *bg = [self objectAtIndex:i array:bgImages];
        if (bg && bg.length > 0)
        {
            [tabBtn setBackgroundImage:[UIImage imageNamed:bg] forState:UIControlStateNormal];
        }
        
        NSString *bgH = [self objectAtIndex:i array:bgImagesH];
        if (bgH && bgH.length > 0)
        {
            [tabBtn setBackgroundImage:[UIImage imageNamed:bgH] forState:UIControlStateHighlighted];
        }
        
        NSString *bgS = [self objectAtIndex:i array:bgImagesS];
        if (bgS && bgS.length > 0)
        {
            [tabBtn setBackgroundImage:[UIImage imageNamed:bgS] forState:UIControlStateSelected];
        }
        [tabBtn setTitleColor:self.tabBtnTextColor forState:UIControlStateNormal];
        [tabBtn setTitleColor:self.tabBtnTextColorH forState:UIControlStateHighlighted];
        [tabBtn setTitleColor:self.tabBtnTextColorS forState:UIControlStateSelected];
        tabBtn.titleLabel.font = self.tabBtnFont;
        tabBtn.userInteractionEnabled = NO;
        tabBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        
        [tabs addObject:tabBtn];
        
        [tabBtn sizeToFit];
    }
    self.tabs = tabs;
}

- (void)p_getFixedContentSize
{
    switch (self.layoutType)
    {
        case YCFTabsLayoutTypeHorizontal:
        {
            if (self.isNeedEqualWidth && !self.equalWidth)
            {
                self.equalWidth = self.frame.size.width / self.tabs.count;
            }
            
            CGSize size = CGSizeZero;
            for (int i = 0; i < self.tabs.count; i++)
            {
                UIView *itemView = self.tabs[i];
                if (self.isNeedEqualWidth)
                {
                    size.width += self.equalWidth + self.columnMargin;
                }
                else
                {
                    size.width += itemView.bounds.size.width + self.columnMargin;
                }
                if (i == self.tabs.count - 1)
                {
                    size.width -= self.columnMargin;
                    size.width += self.borderPadding.right;
                }
                
                [self.itemXCaches addObject:@(size.width)];
            }
            self.contentSize = size;
            break;
        }
        case YCFTabsLayoutTypeVertical:
        {
            if (self.isNeedEqualWidth && !self.equalWidth)
            {
                self.equalWidth = self.frame.size.height / self.tabs.count;
            }
            
            CGSize size = CGSizeZero;
            for (int i = 0; i < self.tabs.count; i++)
            {
                UIView *itemView = self.tabs[i];
                if (self.isNeedEqualWidth)
                {
                    size.height += self.equalWidth + self.columnMargin;
                }
                else
                {
                    size.height += itemView.bounds.size.height + self.columnMargin;
                }
                if (i == self.tabs.count - 1)
                {
                    size.height -= self.columnMargin;
                    size.height += self.borderPadding.bottom;
                }
                
                [self.itemXCaches addObject:@(size.height)];
            }
            self.contentSize = size;
            break;
        }
    }
}

- (UIView *)createSplitLine
{
    UIView *line = [UIView new];
    line.backgroundColor = self.splitLineColor;
    return line;
}

- (id)objectAtIndex:(NSInteger)index array:(NSArray *)array
{
    if (!([array isKindOfClass:[NSArray class]])) {
        return nil;
    }
    if (array && array.count > index) {
        return array[index];
    } else {
        return nil;
    }
}
#pragma mark - public methods
+ (instancetype)quickCreateTabsViewWithTitles:(NSArray<NSString *> *)titles isNeedEqualWidth:(BOOL)isNeedEqualWidth
{
    return [[self  alloc] initWithTabsViewWithTitles:titles
                                           iconImage:nil
                                          iconImageH:nil
                                          iconImageS:nil
                                             bgImage:nil
                                            bgImageH:nil
                                            bgImageS:nil
                                    isNeedEqualWidth:isNeedEqualWidth];
}

+ (instancetype)quickCreateTabsViewWithTitles:(NSArray<NSString *> *)titles
                                    iconImage:(NSArray<NSString *> *)icons
                                   iconImageH:(NSArray<NSString *> *)iconsH
                                   iconImageS:(NSArray<NSString *> *)iconsS
                             isNeedEqualWidth:(BOOL)isNeedEqualWidth
{
    return [[self  alloc] initWithTabsViewWithTitles:titles
                                           iconImage:icons
                                          iconImageH:iconsH
                                          iconImageS:iconsS
                                             bgImage:nil
                                            bgImageH:nil
                                            bgImageS:nil
                                    isNeedEqualWidth:isNeedEqualWidth];
}

+ (instancetype)quickCreateTabsViewWithTitles:(NSArray<NSString *> *)titles
                                    iconImage:(NSArray<NSString *> *)icons
                                   iconImageH:(NSArray<NSString *> *)iconsH
                                   iconImageS:(NSArray<NSString *> *)iconsS
                                      bgImage:(NSArray<NSString *> *)bgImages
                                     bgImageH:(NSArray<NSString *> *)bgImagesH
                                     bgImageS:(NSArray<NSString *> *)bgImagesS
                             isNeedEqualWidth:(BOOL)isNeedEqualWidth
{
    return [[self  alloc] initWithTabsViewWithTitles:titles
                                           iconImage:icons
                                          iconImageH:iconsH
                                          iconImageS:iconsS
                                             bgImage:bgImages
                                            bgImageH:bgImagesH
                                            bgImageS:bgImagesS
                                    isNeedEqualWidth:isNeedEqualWidth];
}

+ (instancetype)layoutForCustomTabs:(NSArray<UIView *> *)tabs isNeedEqualWidth:(BOOL)isNeedEqualWidth
{
    YCFTabsView *tabsView = [[self alloc] init];
    tabsView.isNeedEqualWidth = isNeedEqualWidth;
    tabsView.tabs = tabs;
    tabsView.selectedItem = tabs.firstObject;
    return tabsView;
}

- (CGSize)sizeToFitWithMax:(CGFloat)max margin:(CGFloat)margin
{
    self.columnMargin = margin;
    CGSize size = CGSizeZero;
    switch (self.layoutType) {
        case YCFTabsLayoutTypeHorizontal: {
            for (UIView *itemView in self.tabs)
            {
                size.width += itemView.bounds.size.width;
                if (size.height < itemView.bounds.size.height)
                {
                    size.height = itemView.bounds.size.height;
                }
            }
            size.width += margin * (self.tabs.count - 1);
            if (size.width > max)
            {
                size.width = max;
            }
            break;
        }
        case YCFTabsLayoutTypeVertical: {
            for (UIView *itemView in self.tabs)
            {
                size.height += itemView.bounds.size.height;
                if (size.width < itemView.bounds.size.width)
                {
                    size.width = itemView.bounds.size.width;
                }
            }
            size.height += margin * (self.tabs.count - 1);
            if (size.height > max)
            {
                size.height = max;
            }
            break;
        }
    }
    return size;
}

#pragma mark - getter
- (UIView *)bottomIndicator
{
    if (!_bottomIndicator)
    {
        _bottomIndicator = [[UIView alloc] init];
        _bottomIndicator.backgroundColor = self.bottomIndicatorColor;
    }
    return _bottomIndicator;
}

- (NSMutableArray<UIView *> *)getTabsContent
{
    if (!_tabsContent)
    {
        _tabsContent = [NSMutableArray array];
        for (int i = 0; i < self.tabs.count; i++)
        {
            UIView *content = [[UIView alloc] init];
            content.tag = i;
            content.clipsToBounds = NO;
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didSelectedTabItem:)];
            tap.delegate = self;
            [content addGestureRecognizer:tap];
            [_tabsContent addObject:content];
        }
    }
    return _tabsContent;
}

- (NSMutableArray<NSNumber *> *)itemXCaches
{
    if (!_itemXCaches)
    {
        _itemXCaches = [NSMutableArray array];
        switch (self.layoutType) {
            case YCFTabsLayoutTypeHorizontal: {
                [_itemXCaches addObject:@(self.borderPadding.left)];
                break;
            }
            case YCFTabsLayoutTypeVertical: {
                [_itemXCaches addObject:@(self.borderPadding.top)];
                break;
            }
        }
    }
    return _itemXCaches;
}

- (NSMutableArray<UIView *> *)getSplitLines
{
    if (!self.isShowSplitLine)
    {
        return nil;
    }
    if (!_splitLines)
    {
        _splitLines = [NSMutableArray array];
        for (int i = 0; i < self.tabs.count; i++)
        {
            UIView *line = [[UIView alloc] init];
            [_splitLines addObject:line];
        }
    }
    return _splitLines;
}
@end

#pragma mark - YCFTabButton
@implementation YCFTabButton
- (void)configTabItemBtn:(YCFTabsItemBtnType)btnType contentInsets:(UIEdgeInsets)contentInsets titleInsets:(UIEdgeInsets)titleInsets iconInsets:(UIEdgeInsets)iconInsets
{
    self.btnType = btnType;
    self.contentInsets = contentInsets;
    self.iconInsets = iconInsets;
    self.titleInsets = titleInsets;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.titleLabel && !self.imageView.image)
    {
        CGFloat centerX = self.bounds.size.width * 0.5;
        CGFloat centerY = self.bounds.size.height * 0.5;
        self.titleLabel.center = CGPointMake(centerX, centerY);
        return;
    }
    else if(self.imageView.image && !(self.titleLabel.text && self.titleLabel.text.length > 0))
    {
        CGFloat centerX = self.bounds.size.width * 0.5;
        CGFloat centerY = self.bounds.size.height * 0.5;
        self.imageView.center = CGPointMake(centerX, centerY);
        return;
    }

    switch (self.btnType) {
        case YCFTabsItemBtnTypeHorizontaIconTitle:
        {
            CGFloat iconCenterX = self.imageView.bounds.size.width * 0.5 + self.contentInsets.left - self.contentInsets.right + self.iconInsets.left -self.iconInsets.right;
            CGFloat iconCenterY = self.bounds.size.height * 0.5;
            self.imageView.center = CGPointMake(iconCenterX, iconCenterY);

            CGFloat titleCenterX = CGRectGetMaxX(self.imageView.frame) +self.titleLabel.bounds.size.width * 0.5 + self.titleInsets.left -self.titleInsets.right;
            CGFloat titleCenterY = self.imageView.center.y + self.titleInsets.top - self.titleInsets.bottom;
            self.titleLabel.center = CGPointMake(titleCenterX, titleCenterY);
            break;
        }
        case YCFTabsItemBtnTypeHorizontaTitleIcon:
        {
            CGFloat titleCenterX = self.titleLabel.bounds.size.width * 0.5 + self.contentInsets.left - self.contentInsets.right + self.titleInsets.left -self.titleInsets.right;
            CGFloat titleCenterY = self.bounds.size.height * 0.5;
            self.titleLabel.center = CGPointMake(titleCenterX, titleCenterY);
            
            CGFloat iconCenterX = CGRectGetMaxX(self.titleLabel.frame) + self.imageView.bounds.size.width * 0.5 + self.iconInsets.left -self.iconInsets.right;
            CGFloat iconCenterY = self.titleLabel.center.y + self.iconInsets.left -self.iconInsets.right;
            self.imageView.center = CGPointMake(iconCenterX, iconCenterY);
            break;
        }
        case YCFTabsItemBtnTypeVerticalIconTitle:
        {
            CGFloat iconCenterX = self.bounds.size.width * 0.5 + self.contentInsets.left - self.contentInsets.right + self.iconInsets.left -self.iconInsets.right;
            CGFloat iconCenterY = self.imageView.bounds.size.height * 0.5 + self.contentInsets.top - self.contentInsets.bottom + self.iconInsets.top - self.iconInsets.bottom;
            self.imageView.center = CGPointMake(iconCenterX, iconCenterY);
            
            CGFloat titleCenterX = self.imageView.center.x;
            CGFloat titleCenterY = CGRectGetMaxY(self.imageView.frame) + self.titleLabel.bounds.size.height * 0.5 + self.titleInsets.top - self.titleInsets.bottom;
            self.titleLabel.center = CGPointMake(titleCenterX, titleCenterY);
            break;
        }
        case YCFTabsItemBtnTypeVerticalTitleIcon:
        {
            CGFloat titleCenterX = self.bounds.size.width * 0.5 + self.contentInsets.left - self.contentInsets.right + self.titleInsets.left -self.titleInsets.right;
            CGFloat titleCenterY = self.titleLabel.bounds.size.height * 0.5 + self.contentInsets.top - self.contentInsets.bottom + self.titleInsets.top - self.titleInsets.bottom;
            self.titleLabel.center = CGPointMake(titleCenterX, titleCenterY);

            CGFloat iconCenterX = self.titleLabel.center.x;
            CGFloat iconCenterY = CGRectGetMaxY(self.titleLabel.frame) + self.imageView.bounds.size.height * 0.5 + self.iconInsets.top - self.iconInsets.bottom;
            self.imageView.center = CGPointMake(iconCenterX, iconCenterY);
            break;
        }
    }
}
@end
