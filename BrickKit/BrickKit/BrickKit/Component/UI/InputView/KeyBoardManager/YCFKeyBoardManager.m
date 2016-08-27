//
//  YCFKeyBoardManager.m
//  keyboar
//
//  Created by jinxiaofei on 16/8/3.
//  Copyright © 2016年 JJ.sevn. All rights reserved.
//

#import "YCFKeyBoardManager.h"

static NSString * const kToolBarItemCellIdentify = @"kToolBarItemCellIdentify";

/**YCFKeyBoardMaskView*****************************************************************************/
@interface YCFKeyBoardMaskView : UIView
@property(nonatomic, weak) UIView * maskedView;
@property(nonatomic, strong) NSMutableArray * editViews;

+ (instancetype) maskView;
@end
/**YCFKeyBoardToolItemCell*****************************************************************************/
@interface YCFKeyBoardToolItemCell : UICollectionViewCell
@property(nonatomic, strong) UIImageView *icon;
@property(nonatomic, strong) UILabel *title;

- (void)configItem:(YCFKeyBoardMaskToolItemType)itemType icon:(NSString *)icon title:(NSString *)title;
@end
/**YCFKeyBoardManager*****************************************************************************/
@interface YCFKeyBoardManager ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property(nonatomic, strong, setter=setKeyBoardNote:) NSNotification *keyBoardNote;
@property(nonatomic, strong) YCFKeyBoardMaskView *keyBoardMaskView;

@property(nonatomic, assign) CGFloat keyBoardDuration;
@property(nonatomic, assign) CGRect keyBoardFrame;
@property(nonatomic, assign) UIViewAnimationOptions keyBoardAnimationOptions;

@property(nonatomic, strong) UICollectionView *keyBoardToolBar;
@property(nonatomic, weak) id<YCFKeyBoardToolBarDelegate> delegate;

@property(nonatomic, strong) NSMutableArray *toolItems;
@end
#pragma mark - YCFKeyBoardManager
@implementation YCFKeyBoardManager
+ (YCFKeyBoardManager *) shareInstance
{
    
    static YCFKeyBoardManager *shareInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        shareInstance = [[YCFKeyBoardManager alloc] init];
        shareInstance.isNeedManageKeyBoardResign = YES;
        shareInstance.isNeedKeyBoardToolBar = YES;
        shareInstance.keyBoardToolBarHeight = 30;
        
        [shareInstance p_addKeyBoardToolBar];
        
        [[NSNotificationCenter defaultCenter] addObserver:shareInstance selector:@selector(dealWithKeyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:shareInstance selector:@selector(dealWithKeyBoardDidShow:) name:UIKeyboardDidShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:shareInstance selector:@selector(dealWithKeyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:shareInstance selector:@selector(dealWithKeyBoardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    });
    
    return shareInstance;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)dealWithKeyBoardWillShow:(NSNotification *)note
{
    self.keyBoardNote = note;
    self.status = YCFKeyBoardStatusWillShow;
    [self p_addMaskedView];
    [self showKeyBoardToolBar];
}
- (void)dealWithKeyBoardDidShow:(NSNotification *)note
{
    self.keyBoardNote = note;
    self.status = YCFKeyBoardStatusDidShow;

}
- (void)dealWithKeyBoardWillHide:(NSNotification *)note
{
    self.keyBoardNote = note;
    self.status = YCFKeyBoardStatusWillHide;
    [self dismissKeyBoardToolBar];
}
- (void)dealWithKeyBoardDidHide:(NSNotification *)note
{
    self.keyBoardNote = note;
    self.status = YCFKeyBoardStatusDidHide;
    [self p_removeMaskView];
}

#pragma mark - public methods
- (void)resetKeyBoard
{
    [_keyBoardMaskView removeFromSuperview];
    _keyBoardMaskView = nil;
    _keyBoardToolBar = nil;
    self.curEditView = nil;
    
    self.isNeedManageKeyBoardResign = YES;
    self.isNeedKeyBoardToolBar = YES;
    [self p_addKeyBoardToolBar];
}

- (void)showToolBarWithAnimation:(BOOL)animation
{
    if (!self.isNeedKeyBoardToolBar)
    {
        return;
    }
    self.keyBoardToolBar.hidden = NO;
    [self.keyBoardToolBar mas_updateConstraints:^(MASConstraintMaker *make) {
        __weak UIView *superView = self.keyBoardToolBar.superview;
        make.top.equalTo(superView.mas_bottom).offset(-self.keyBoardFrame.size.height);
    }];
    if (animation)
    {
        [UIView animateWithDuration:self.keyBoardDuration delay:0.0 options:self.keyBoardAnimationOptions animations:^{
            [[UIApplication sharedApplication].keyWindow layoutIfNeeded];
        } completion:^(BOOL finished) {
        }];
    }
}

- (void)hideToolBarWithAnimation:(BOOL)animation
{
    if (!self.isNeedKeyBoardToolBar)
    {
        return;
    }
    [self.keyBoardToolBar mas_updateConstraints:^(MASConstraintMaker *make) {
        __weak UIView *superView = self.keyBoardToolBar.superview;
        make.top.equalTo(superView.mas_bottom);
    }];
    if (animation)
    {
        [UIView animateWithDuration:self.keyBoardDuration delay:0.0 options:self.keyBoardAnimationOptions animations:^{
            [[UIApplication sharedApplication].keyWindow layoutIfNeeded];
        } completion:^(BOOL finished) {
            self.keyBoardToolBar.hidden = YES;
        }];
    }
}

- (void)bottomToolBarWithAnimation:(BOOL)animation
{
    if (!self.isNeedKeyBoardToolBar)
    {
        return;
    }
    self.keyBoardToolBar.hidden = NO;
    [self.keyBoardToolBar mas_updateConstraints:^(MASConstraintMaker *make) {
        __weak UIView *superView = self.keyBoardToolBar.superview;
        make.top.equalTo(superView.mas_bottom).offset(-self.keyBoardToolBarHeight);
    }];
    if (animation)
    {
        [UIView animateWithDuration:self.keyBoardDuration delay:0.0 options:self.keyBoardAnimationOptions animations:^{
            [[UIApplication sharedApplication].keyWindow layoutIfNeeded];
        } completion:^(BOOL finished) {
            
        }];
    }
}
#pragma mark - private methods
- (void)p_addMaskedView
{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;

    [keyWindow addSubview:self.keyBoardMaskView];
    [self.keyBoardMaskView mas_makeConstraints:^(MASConstraintMaker *make) {
        __weak UIView *superView = self.keyBoardMaskView.superview;
        make.left.top.right.equalTo(superView);
        make.height.mas_equalTo(keyWindow.frame.size.height - self.keyBoardFrame.size.height);
    }];
}

- (void)p_addKeyBoardToolBar
{
    if (!self.isNeedKeyBoardToolBar)
    {
        return;
    }
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    
    [keyWindow addSubview:self.keyBoardToolBar];
    [self.keyBoardToolBar mas_makeConstraints:^(MASConstraintMaker *make) {
        __weak UIView *superView = self.keyBoardToolBar.superview;
        make.left.right.equalTo(superView);
        make.top.equalTo(superView.mas_bottom);
        make.height.mas_equalTo(self.keyBoardToolBarHeight);
    }];}

- (void)p_removeMaskView
{
    [self.keyBoardMaskView removeFromSuperview];
    self.keyBoardMaskView.editViews = nil;
}

- (void)showKeyBoardToolBar
{
    [self showToolBarWithAnimation:YES];
}

- (void)dismissKeyBoardToolBar
{
    BOOL isNeedHide = YES;
    if ([self.delegate respondsToSelector:@selector(isNeedToolBarHideWhenResignKeyboard:)])
    {
        isNeedHide = [self.delegate isNeedToolBarHideWhenResignKeyboard:self.keyBoardToolBar];
    }
    if (isNeedHide)
    {
        [self hideToolBarWithAnimation:YES];
    }
    else
    {
        [self bottomToolBarWithAnimation:YES];
    }
}

#pragma mark - UICollectionDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if ([self.delegate respondsToSelector:@selector(configDefaultKeyBoardToolBarItemsForAddOrDelete:toolBar:)])
    {
        [self.delegate configDefaultKeyBoardToolBarItemsForAddOrDelete:self.toolItems toolBar:self.keyBoardToolBar];
    }
    return self.toolItems.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(itemCellAtIndex:toolBar:)])
    {
        return [self.delegate itemCellAtIndex:indexPath.item toolBar:self.keyBoardToolBar];
    }
    NSString *icon;
    NSString *title;
    if ([self.delegate respondsToSelector:@selector(iconForItemCellIfNeedAtIndex:toolBar:)])
    {
        icon = [self.delegate iconForItemCellIfNeedAtIndex:indexPath.item toolBar:self.keyBoardToolBar];
    }
    if ([self.delegate respondsToSelector:@selector(titleForItemCellIfNeedAtIndex:toolBar:)])
    {
        title = [self.delegate titleForItemCellIfNeedAtIndex:indexPath.item toolBar:self.keyBoardToolBar];
    }
    YCFKeyBoardToolItemCell *cell = [self.keyBoardToolBar dequeueReusableCellWithReuseIdentifier:kToolBarItemCellIdentify forIndexPath:indexPath];
    [cell configItem:[self.toolItems[indexPath.item] integerValue] icon:icon title:title];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(itemSizeAtIndex:toolBar:)])
    {
        return [self.delegate itemSizeAtIndex:indexPath.item toolBar:self.keyBoardToolBar];
    }
    CGFloat width = [UIScreen mainScreen].bounds.size.width / self.toolItems.count;
    return CGSizeMake(width, self.keyBoardToolBarHeight);
}
#pragma mark - UICollectionDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    YCFKeyBoardMaskToolItemType type = [self.toolItems[indexPath.item] integerValue];
    switch (type) {
        case YCFKeyBoardMaskToolItemTypeCustom: {
            if ([self.delegate respondsToSelector:@selector(didSelectedToolBarItemAtIndex:toolBar:itemType:)])
            {
                [self.delegate didSelectedToolBarItemAtIndex:indexPath.item toolBar:self.keyBoardToolBar itemType:[self.toolItems[indexPath.item] integerValue]];
            }
            break;
        }
        case YCFKeyBoardMaskToolItemTypePhotos: {
            [self openPhotos];
            break;
        }
        case YCFKeyBoardMaskToolItemTypeAlt: {
            [self openAlt];
            break;
        }
        case YCFKeyBoardMaskToolItemTypeTopic: {
            [self openTopic];
            break;
        }
        case YCFKeyBoardMaskToolItemTypeEmoji: {
            [self openEmoji];
            break;
        }
        case YCFKeyBoardMaskToolItemTypeMore: {
            [self openMore];
            break;
        }
        case YCFKeyBoardMaskToolItemTypeResignKeyBoard: {
            [self resetKeyBoard];
            break;
        }
    }
}

#pragma mark - IBAction
- (void)openPhotos
{
    
}

- (void)openAlt
{
    
}

- (void)openTopic
{
    
}

- (void)openEmoji
{
    
}

- (void)openMore
{
    
}

#pragma mark - getter
- (YCFKeyBoardMaskView *)keyBoardMaskView
{
    if (!_keyBoardMaskView)
    {
        _keyBoardMaskView = [YCFKeyBoardMaskView maskView];
        _keyBoardMaskView.backgroundColor = [UIColor clearColor];
        _keyBoardMaskView.maskedView = self.curEditView;
    }
    return _keyBoardMaskView;
}

- (UICollectionView *)keyBoardToolBar
{
    if (!_keyBoardToolBar)
    {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _keyBoardToolBar = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        [_keyBoardToolBar registerClass:[YCFKeyBoardToolItemCell class] forCellWithReuseIdentifier:kToolBarItemCellIdentify];
        _keyBoardToolBar.backgroundColor = [UIColor greenColor];
        _keyBoardToolBar.delegate = self;
        _keyBoardToolBar.dataSource = self;
    }
    return _keyBoardToolBar;
}

- (NSMutableArray *)toolItems
{
    if (!_toolItems)
    {
        _toolItems = [NSMutableArray arrayWithArray:@[
                                                      @(YCFKeyBoardMaskToolItemTypePhotos),
                                                      @(YCFKeyBoardMaskToolItemTypeAlt),
                                                      @(YCFKeyBoardMaskToolItemTypeTopic),
                                                      @(YCFKeyBoardMaskToolItemTypeEmoji),
                                                      @(YCFKeyBoardMaskToolItemTypeMore),
                                                      @(YCFKeyBoardMaskToolItemTypeResignKeyBoard),
                                                      ]];
    }
    return _toolItems;
}

#pragma mark - setter
- (void)setKeyBoardNote:(NSNotification *)keyBoardNote
{
    _keyBoardNote = keyBoardNote;
    self.keyBoardDuration = [keyBoardNote.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    self.keyBoardFrame = [keyBoardNote.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    if (self.isNeedKeyBoardToolBar)
    {
        CGRect rect = self.keyBoardFrame;
        rect.origin.y -= self.keyBoardToolBarHeight;
        rect.size.height += self.keyBoardToolBarHeight;
        self.keyBoardFrame = rect;
    }
    self.keyBoardAnimationOptions = [keyBoardNote.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
}

- (void)setCurEditView:(UIView *)curEditView
{
    _curEditView = curEditView;
    if ([curEditView isKindOfClass:[UITextView class]])
    {
        UITextView *textView = (UITextView *)curEditView;
        self.delegate = (id<YCFKeyBoardToolBarDelegate>)textView.delegate;
    }
    else if ([curEditView isKindOfClass:[UITextField class]])
    {
        UITextField *textField = (UITextField *)curEditView;
        self.delegate = (id<YCFKeyBoardToolBarDelegate>)textField.delegate;
    }

}
@end


#pragma mark - YCFKeyBoardMaskView
@implementation YCFKeyBoardMaskView

+ (YCFKeyBoardMaskView *) maskView
{
    return [[YCFKeyBoardMaskView alloc] init];;
}

- (void)dealloc
{
    [self p_resignFirstResponder];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    if (![YCFKeyBoardManager shareInstance].isNeedManageKeyBoardResign || point.y <= 64)
    {
        return nil;
    }
    
    [self checkCanEditViewInsideView:[UIApplication sharedApplication].keyWindow];
    
    for (UIView *view in self.editViews)
    {
        CGPoint p = [self convertPoint:point toView:view];
        if ([view pointInside:p withEvent:event])
        {
            return [view hitTest:p withEvent:event];
        }
    }

    return [super hitTest:point withEvent:event];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self p_resignFirstResponder];
}

#pragma mark - private methods

- (void)p_resignFirstResponder
{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    [self.maskedView endEditing:YES];
    [self.maskedView resignFirstResponder];
    
}

- (void)checkCanEditViewInsideView:(UIView *)view
{
    CGRect viewRect = [view convertRect:view.bounds toView:nil];
    if (!CGRectIntersectsRect([UIApplication sharedApplication].keyWindow.frame, viewRect))
    {
        return;
    }
    
    if ([view isKindOfClass:[UITableView class]])//UITableView/UICollectionView单独处理, 因为递归不到subviews
    {
        UITableView *tabView = (UITableView *)view;
        NSInteger sections = [tabView numberOfSections];
        for (NSInteger i = 0; i < sections; i++)
        {
            NSInteger rows = [tabView numberOfRowsInSection:i];
            for (NSInteger j = 0; j < rows; j++)
            {
                UITableViewCell *cell = [tabView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:j inSection:i]];
                
                for (UIView *subview in cell.subviews)
                {
                    [self checkCanEditViewInsideView:subview];
                }
            }
        }
    }
    else if ([view isKindOfClass:[UICollectionView class]])
    {
        UICollectionView *collectionView = (UICollectionView *)view;
        NSInteger sections = [collectionView numberOfSections];
        for (NSInteger i = 0; i < sections; i++)
        {
            NSInteger items = [collectionView numberOfItemsInSection:i];
            for (NSInteger j = 0; j < items; j++)
            {
                UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:j inSection:i]];
                for (UIView *subview in cell.subviews)
                {
                    [self checkCanEditViewInsideView:subview];
                }
            }
        }
    }
    else
    {
        for (UIView *subview in view.subviews)
        {
            [self checkCanEditViewInsideView:subview];
        }
    }
    
    if ([view isKindOfClass:[UITextField class]] || [view isKindOfClass:[UITextView class]] || [view isKindOfClass:[UIControl class]])
    {
        [self.editViews insertObject:view atIndex:0];//始终保持最上层的view在前面
    }
}
#pragma mark - getter
- (NSMutableArray *)editViews
{
    if (!_editViews)
    {
        NSArray *ignoreViews;
        if ([[YCFKeyBoardManager shareInstance].delegate respondsToSelector:@selector(hitTextIgnoreViewsWhenClickMaskView:)])
        {
            ignoreViews = [[YCFKeyBoardManager shareInstance].delegate hitTextIgnoreViewsWhenClickMaskView:self.maskedView];
        }
        _editViews = [NSMutableArray arrayWithArray:ignoreViews];
    }
    return _editViews;
}

@end

#pragma mark - YCFKeyBoardToolItemCell
@implementation YCFKeyBoardToolItemCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self p_drawViews];
        [self p_constraints];
    }
    return self;
}

- (void)p_drawViews
{
    [self.contentView addSubview:self.icon];
    [self.contentView addSubview:self.title];
}

- (void)p_constraints
{
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        __weak UIView *superView = self.icon.superview;
        make.edges.equalTo(superView);
    }];
    
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        __weak UIView *superView = self.title.superview;
        make.center.equalTo(superView);
    }];
}

- (void)configItem:(YCFKeyBoardMaskToolItemType)itemType icon:(NSString *)icon title:(NSString *)title
{
    NSString *itemIcon;
    NSString *itemTitle;
    switch (itemType) {
        case YCFKeyBoardMaskToolItemTypePhotos: {
            itemIcon = @"";
            itemTitle = @"相册";
            break;
        }
        case YCFKeyBoardMaskToolItemTypeAlt: {
            itemIcon = @"";
            itemTitle = @"@";
            break;
        }
        case YCFKeyBoardMaskToolItemTypeTopic: {
            itemIcon = @"";
            itemTitle = @"#";
            break;
        }
        case YCFKeyBoardMaskToolItemTypeEmoji: {
            itemIcon = @"";
            itemTitle = @"表情";
            break;
        }
        case YCFKeyBoardMaskToolItemTypeMore: {
            itemIcon = @"";
            itemTitle = @"more";
            break;
        }
        case YCFKeyBoardMaskToolItemTypeCustom: {
            itemIcon = @"";
            itemTitle = @"custom";
            break;
        }
        case YCFKeyBoardMaskToolItemTypeResignKeyBoard: {
            itemIcon = @"";
            itemTitle = @"退键盘";
            break;
        }
    }
    if (icon)
    {
        itemIcon = icon;
    }
    if (title)
    {
        itemTitle = title;
    }
    self.icon.image = [UIImage imageNamed:itemIcon];
    self.title.text = itemTitle;
}

#pragma mark - getter
- (UIImageView *)icon
{
    if (!_icon)
    {
        _icon = [[UIImageView alloc] init];;
    }
    return _icon;
}

- (UILabel *)title
{
    if (!_title)
    {
        _title = [[UILabel alloc] init];
    }
    return _title;
}
@end
