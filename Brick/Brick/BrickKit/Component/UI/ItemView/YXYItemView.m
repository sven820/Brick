////  YXYItemView.m
//  YXY
//
//  Created by jinxiaofei on 16/9/18.
//  Copyright © 2016年 Guangzhou TalkHunt Information Technology Co., Ltd. All rights reserved.
//

#import "YXYItemView.h"
@import SDWebImage;

@interface YXYItemView ()

@property (nonatomic, strong) UIButton *actionView;
//
@property (nonatomic, strong) UIView *bottomLine;
@property (nonatomic, strong) UIView *topLine;
//
@property (nonatomic, strong) UIView *titleContainer;
@property (nonatomic, strong) UIImageView *leftIcon;//左边图标
@property (nonatomic, strong) UIButton *leftIconTagBtn;
@property (nonatomic, strong) UILabel *titleLabel;//标题
@property (nonatomic, strong) UIButton *titleTag;//标题上标(文字或图片, 选一)
@property (nonatomic, strong) UILabel *subTitleLabel;
//
@property (nonatomic, strong) UIView *detailView;

@property (nonatomic, strong) UILabel *detailLabel;//右边详细描述
@property (nonatomic, strong) UIImageView *detailIcon;//右边详细描述的icon
@property (nonatomic, assign) YXYItemViewDetailIconType detailIconLocation;
@property (nonatomic, strong) UIView *detailContentView;
@property (nonatomic, strong) UIView *imagesView;

@property (nonatomic, strong) UITextField *detailTextField;

@property (nonatomic, strong) UITextView *detailTextView;
@property (nonatomic, assign) CGFloat textViewHeight;
@property (nonatomic, strong) UILabel *detailTextViewPlaceholerLabel;
@property (nonatomic, strong) UILabel *detailEditViewLimitLabel;
//
@property (nonatomic, strong) UIButton *rightBtn;//右边图标(文字或图片, 选一)
@end
@implementation YXYItemView
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self drawViews];
        [self makeContraints];
        
        self.leftIconSize = CGSizeMake(39, 39);
        self.leftIconTagSize = CGSizeMake(15, 15);
        self.leftIconTagOffset = UIOffsetZero;
        
        _titleTagSize = CGSizeMake(6, 6);
        
        self.detailIconSize = CGSizeMake(20, 20);
        self.detailImageMargin = 10;
        self.detailIconTitleMargin = 5;
        self.subTitleTopMargin = 8;
        
        self.detailEditViewMinMinSize = CGSizeMake(0, 35);
        self.textViewHeight = self.detailEditViewMinMinSize.height;
        
        self.iconAreaInsets = UIEdgeInsetsMake(0, 12, 0, 0);
        self.titleAreaInsets = UIEdgeInsetsMake(0, 12, 0, 12);
        self.detailAreaInsets = UIEdgeInsetsMake(0, 12, 0, 12);
        self.rightAreaInsets = UIEdgeInsetsMake(0, 0, 0, 12);
        
        self.needRoundLeftIcon = YES;
        self.userInteractionEnabled = NO;
        self.editLimit = -1;
    }
    return self;
}

- (void)addTarget:(id)target sel:(SEL)sel
{
    self.actionView.userInteractionEnabled = YES;
    self.userInteractionEnabled = YES;
    if (!_actionView.superview) {
        [self insertSubview:self.actionView atIndex:0];
        [self.actionView mas_remakeConstraints:^(MASConstraintMaker *make) {
            __weak UIView *superView = self.actionView.superview;
            make.edges.equalTo(superView);
        }];
    }
    
    [self.actionView addTarget:target action:NSSelectorFromString(NSStringFromSelector(sel)) forControlEvents:UIControlEventTouchUpInside];
}

- (void)addTargetForRightBtn:(id)target sel:(SEL)sel events:(UIControlEvents)events
{
    self.rightBtn.userInteractionEnabled = YES;
    self.userInteractionEnabled = YES;
    [self.rightBtn addTarget:target action:sel forControlEvents:events];
}

- (void)setTopLineShow:(BOOL)isShow
{
    self.topLine.hidden = !isShow;
}

- (void)setTopLinePadding:(UIEdgeInsets)padding
{
    [self.topLine mas_updateConstraints:^(MASConstraintMaker *make) {
        __weak UIView *superView = self.topLine.superview;
        make.left.equalTo(superView).offset(padding.left);
        make.right.equalTo(superView).offset(-padding.right);
    }];
}

- (void)setBottomLineShow:(BOOL)isShow
{
    self.bottomLine.hidden = !isShow;
}

- (void)setBottomLinePadding:(UIEdgeInsets)padding
{
    [self.bottomLine mas_updateConstraints:^(MASConstraintMaker *make) {
        __weak UIView *superView = self.bottomLine.superview;
        make.left.equalTo(superView).offset(padding.left);
        make.right.equalTo(superView).offset(-padding.right);
    }];
}
#pragma mark - config item layout
- (void)updateConstraints
{
    [self makeConstraintsForSubGroupView];
    [self makeCOnstraintsForItemsView];
    [super updateConstraints];
}

- (void)makeConstraintsForSubGroupView
{
    if (_leftIcon.superview) {
        [self makeConstraintsForLeftIcon];
    }
    
    if (_titleContainer.superview) {
        [self makeTitleContainerConstraints];
    }

    if (_detailView.superview) {
        [self makeConstraintsForDetailView];
        [self makeConstraintsForDetailContentView];
    }
    if (_rightBtn.superview){
        [self makeConstraintsForRightBtn];
    }
}
- (void)makeCOnstraintsForItemsView
{
    [self p_makeConstraintsForDetailEditView];
    [self p_makeConstraintsForDetailPlaceholderLabel];
    
    if (_leftIconTagBtn.superview && _leftIcon.superview) {
        [self bringSubviewToFront:self.leftIconTagBtn];
        [self setConstraintsForLeftIconTag];
    }

    [self updateTitleContainerItemsConstraints];

    [self makeConstraintsForDetailLabel];
    [self p_makeConstraintsForDetailIconWithType];
    [self p_makeConstraintsForDetailIconSize];
    [self p_makeContraintsForDetailViewsWithType];
    
    if (_titleTag)
    {
        [self.titleContainer addSubview:self.titleTag];
        [self.titleTag mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.titleLabel.mas_top).offset(self.titleTagOffset.vertical);
            make.left.equalTo(self.titleLabel.mas_right).offset(self.titleTagOffset.horizontal);
            make.size.mas_equalTo(self.titleTagSize);
        }];
    }
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    if (self.needRoundLeftIcon && _leftIcon.superview) {
        self.leftIcon.layer.cornerRadius = self.leftIcon.bounds.size.width / 2;
    }
}
#pragma mark - configLeftIcon
- (void)addLeftIcon
{
    if (_leftIcon.superview) {
        return;
    }
    [self addSubview:self.leftIcon];
    
    [self setNeedsUpdateConstraints];
}
- (void)setConstraintsForLeftIconTag
{
    self.leftIconTagBtn.layer.cornerRadius = self.leftIconTagSize.width / 2;
    self.leftIconTagBtn.clipsToBounds = YES;
    [self.leftIconTagBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.leftIconTagSize);
        switch (self.leftIconTagType) {
            case YXYItemViewLeftIconTagTypeLeftTop:
            {
                make.left.top.equalTo(self.leftIcon);
            }
                break;
            case YXYItemViewLeftIconTagTypeLeftBottom:
            {
                make.left.bottom.equalTo(self.leftIcon);
            }
                break;
            case YXYItemViewLeftIconTagTypeRightTop:
            {
                make.right.top.equalTo(self.leftIcon);
            }
                break;
            case YXYItemViewLeftIconTagTypeRightBottom:
            {
                make.right.bottom.equalTo(self.leftIcon);
            }
                break;
            default:
                break;
        }

    }];
}
- (void)removeLeftIcon
{
    [_leftIcon removeFromSuperview];
    _leftIcon = nil;
    [self setNeedsUpdateConstraints];
}
- (void)makeConstraintsForLeftIcon
{
    [self.leftIcon mas_remakeConstraints:^(MASConstraintMaker *make) {
        __weak UIView *superView = self.leftIcon.superview;
        make.left.equalTo(superView).offset(self.iconAreaInsets.left).with.priorityHigh();
        make.centerY.equalTo(superView);
        if (self.leftIconSize.width) {
            make.width.mas_equalTo(self.leftIconSize.width);
            make.height.mas_equalTo(self.leftIconSize.height);
        }
        make.top.greaterThanOrEqualTo(superView).offset(self.iconAreaInsets.top).with.priorityLow();
        make.bottom.lessThanOrEqualTo(superView).offset(-self.iconAreaInsets.bottom).with.priorityLow();
    }];
}
#pragma mark - configRightBtn
- (void)addRightBtn
{
    if (_rightBtn.superview) {
        return;
    }
    [self addSubview:self.rightBtn];
    
    [self setNeedsUpdateConstraints];
}
- (void)removeRightBtn
{
    if (_rightBtn.superview) {
        
        [_rightBtn removeFromSuperview];
        _rightBtn = nil;
        
        [self setNeedsUpdateConstraints];
    }
}
- (void)makeConstraintsForRightBtn
{
    [self.rightBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        __weak UIView *superView = self.rightBtn.superview;
        make.centerY.equalTo(superView);
        make.right.equalTo(superView).offset(-self.rightAreaInsets.right);
        
        if (self.rightBtnSize.width) {
            make.size.mas_equalTo(self.rightBtnSize);
        }else{
            [self.rightBtn sizeToFit];
            make.size.mas_equalTo(self.rightBtn.bounds.size);
        }
        make.top.greaterThanOrEqualTo(superView).offset(self.rightAreaInsets.top).with.priorityLow();
        make.bottom.lessThanOrEqualTo(superView).offset(-self.rightAreaInsets.bottom).with.priorityLow();
    }];
}
#pragma mark - configTitleView
- (void)addTitleLabel
{
    if (_titleLabel.superview) {
        return;
    }
    if (!_titleContainer.superview) {
        [self addSubview:self.titleContainer];
    }
    [self.titleContainer addSubview:self.titleLabel];
    
    [self setNeedsUpdateConstraints];
}

- (void)updateTitleContainerItemsConstraints
{
    if (_titleLabel.superview) {
        [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            __weak UIView *superView = self.titleLabel.superview;
            make.left.top.equalTo(superView);
            make.right.lessThanOrEqualTo(superView);
            if (!_subTitleLabel.superview) {
                make.bottom.equalTo(superView);
            }
        }];
    }
    
    if (_subTitleLabel.superview) {
        [self.subTitleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            __weak UIView *superView = self.titleLabel.superview;
            if (_titleLabel.superview) {
                make.top.equalTo(self.titleLabel.mas_bottom);
            }else{
                make.top.equalTo(superView);
            }
            make.left.equalTo(superView);
            make.right.lessThanOrEqualTo(superView);
            make.bottom.equalTo(superView);
        }];
    }
}

- (void)removeTitleLabel
{
    [_titleLabel removeFromSuperview];

    [self setNeedsUpdateConstraints];
}

- (void)addSubTitleLabel
{
    if (_subTitleLabel.superview) {
        return;
    }
    if (!_titleContainer.superview) {
        [self addSubview:self.titleContainer];
    }
    [self.titleContainer addSubview:self.subTitleLabel];
    
    [self setNeedsUpdateConstraints];
}

- (void)removeSubTitleLabel
{
    [_subTitleLabel removeFromSuperview];
    
    [self setNeedsUpdateConstraints];
}

- (void)makeTitleContainerConstraints
{
    [self.titleContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
        __weak UIView *superView = self.titleContainer.superview;
        make.centerY.equalTo(superView);

        //top
        make.top.greaterThanOrEqualTo(superView).offset(self.titleAreaInsets.top);
        //bottom
        make.bottom.lessThanOrEqualTo(superView).offset(-self.titleAreaInsets.bottom);
        
        //right
//        if (!_detailView.superview && !_rightBtn.superview) {
//            make.right.lessThanOrEqualTo(superView).offset(-self.titleAreaInsets.right);
//        }else if (!_detailView.superview){
//            make.right.lessThanOrEqualTo(self.rightBtn.mas_left).offset(-self.titleAreaInsets.right-self.rightAreaInsets.left);
//        }
        //left
        if (_leftIcon.superview) {
            make.left.equalTo(_leftIcon.mas_right).offset(self.titleAreaInsets.left+self.iconAreaInsets.right);
        }else{
            make.left.equalTo(superView).offset(self.titleAreaInsets.left);
        }
        //width
        [_titleLabel sizeToFit];
        [_subTitleLabel sizeToFit];
        CGFloat lengthT;
        _titleLabel.bounds.size.width > _subTitleLabel.bounds.size.width ? (lengthT = _titleLabel.bounds.size.width) : (lengthT = _subTitleLabel.bounds.size.width);
        if (self.titleFixedLength) {
            lengthT = self.titleFixedLength;
        }
        make.width.mas_equalTo(lengthT).with.priorityHigh();
    }];
}

#pragma mark - configDetailView
- (void)addDetailTextField
{
    if (_detailTextField.superview) {
        return;
    }
    if (!_detailView.superview) {
        [self addSubview:self.detailView];
        self.detailView.userInteractionEnabled = YES;
    }
    
    [self p_removeDetailContent];
    [self p_removeTextView];
    self.userInteractionEnabled = YES;
    
    [self.detailView addSubview:self.detailContentView];
    [self.detailContentView addSubview:self.detailTextField];
    
    [self setNeedsUpdateConstraints];
}
- (void)addDetailTextView
{
    if (_detailTextView.superview) {
        return;
    }
    if (!_detailView.superview) {
        [self addSubview:self.detailView];
        self.detailView.userInteractionEnabled = YES;
    }
    
    [self p_removeDetailContent];
    [self p_removeTextField];
    self.userInteractionEnabled = YES;
    
    [self.detailView addSubview:self.detailContentView];
    [self.detailContentView addSubview:self.detailTextView];
    
    [self setNeedsUpdateConstraints];
}
- (void)addDetailLabel
{
    if (_detailLabel.superview) {
        return;
    }
    if (!_detailView.superview) {
        [self addSubview:self.detailView];
    }
    
    [self p_removeTextField];
    [self p_removeTextView];
    
    [self.detailView addSubview:self.detailContentView];
    [self.detailContentView addSubview:self.detailLabel];
}
- (void)makeConstraintsForDetailLabel
{
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        __weak UIView *superView = self.detailLabel.superview;
        if (self.detailIconLocation == YXYItemViewDetailIconTypeLeft) {
            make.right.equalTo(superView);
            if (_imagesView.superview) {
                [self.imagesView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(self.detailLabel.mas_left);
                }];
            }else if (_detailIcon.superview){
                [self.detailIcon mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(self.detailLabel.mas_left);
                }];
            }else{
                make.left.equalTo(superView);
            }
        }else if(self.detailIconLocation == YXYItemViewDetailIconTypeRight){
            make.left.equalTo(superView);
            if (_imagesView.superview) {
                make.right.equalTo(self.imagesView.mas_left);
            }else if (_detailIcon.superview){
                make.right.equalTo(self.imagesView.mas_left);
            }else{
                make.right.equalTo(superView);
            }
        }
        make.centerY.equalTo(superView);
        make.top.greaterThanOrEqualTo(superView);
        make.bottom.lessThanOrEqualTo(superView);
    }];
}
- (void)addDetailIcon:(UIImage *)image loaction:(YXYItemViewDetailIconType)loaction
{
    self.detailIconLocation = loaction;
    [self addDetailSingleImage:image url:nil];
    [self setNeedsUpdateConstraints];
}
- (void)addDetailWebIcon:(NSURL *)imageUrl loaction:(YXYItemViewDetailIconType)loaction
{
    self.detailIconLocation = loaction;
    [self addDetailSingleImage:nil url:imageUrl];
    [self setNeedsUpdateConstraints];
}
- (void)setDetailWebIcon:(NSURL *)imageUrl placeHolder:(UIImage *)placeHolder
{
    [self.detailIcon sd_setImageWithURL:imageUrl placeholderImage:placeHolder];
}
- (void)addDetailSingleImage:(UIImage *)image url:(NSURL *)url
{
    if (!_detailView.superview) {
        [self addSubview:self.detailView];
        [self.detailView addSubview:self.detailContentView];
    }
    if (_imagesView.superview) {
        [_imagesView removeFromSuperview];
    }
    [self.detailContentView addSubview:self.detailIcon];
    
    self.detailIcon.image = image;

    if (url) {
        [self.detailIcon sd_setImageWithURL:url placeholderImage:self.detailPlaceHolderIcon completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [self setNeedsUpdateConstraints];
        }];
    }
    [self setNeedsUpdateConstraints];
}

- (void)addDetailIcons:(NSArray<UIImage *> *)images loaction:(YXYItemViewDetailIconType)loaction;
{
    self.detailIconLocation = loaction;
    self.imagesView = [self getDetailImagesView:images];
    [self addImagesView];
    [self setNeedsUpdateConstraints];
}
- (void)addDetailWebIcons:(NSArray<NSURL *> *)images loaction:(YXYItemViewDetailIconType)loaction;
{
    self.detailIconLocation = loaction;
    self.imagesView = [self getDetailImagesViewFromWeb:images];
    [self addImagesView];
    [self setNeedsUpdateConstraints];
}
- (void)addImagesView
{
    if (_imagesView.superview) {
        return;
    }
    if (!_detailView.superview) {
        [self addSubview:self.detailView];
        [self.detailView addSubview:self.detailContentView];
    }
    if (_detailIcon.superview) {
        [_detailIcon removeFromSuperview];
    }
    [self.detailContentView addSubview:self.imagesView];
}

- (void)makeConstraintsForDetailContentView
{
    if (!_detailContentView.superview) {
        return;
    }
    [self.detailContentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        __weak UIView *superView = self.detailContentView.superview;

        make.centerY.equalTo(superView);
        make.top.greaterThanOrEqualTo(superView).offset(self.detailContentAreaInsets.top);
        make.bottom.lessThanOrEqualTo(superView).offset(-self.detailContentAreaInsets.bottom);
        
        switch (self.detailMode) {
            case YXYItemAttributeDetailModeRight:
                make.right.equalTo(superView).offset(-self.detailContentAreaInsets.right);
                make.left.greaterThanOrEqualTo(superView).offset(self.detailContentAreaInsets.left);
                break;
            case YXYItemAttributeDetailModeCenter:
                make.centerX.equalTo(superView).offset(self.detailContentAreaInsets.left - self.detailContentAreaInsets.right);
                make.right.lessThanOrEqualTo(superView).offset(-self.detailContentAreaInsets.right);
                make.left.greaterThanOrEqualTo(superView).offset(self.detailContentAreaInsets.left);
                break;
            case YXYItemAttributeDetailModeLeft:
                make.left.equalTo(superView).offset(self.detailContentAreaInsets.left);
                make.right.lessThanOrEqualTo(superView).offset(-self.detailContentAreaInsets.right);
                break;
            case YXYItemAttributeDetailModeLeftWrapContent:
                make.edges.equalTo(superView).insets(self.detailContentAreaInsets);
                break;
        }
    }];
}

- (void)makeConstraintsForDetailView
{
    [self.detailView mas_remakeConstraints:^(MASConstraintMaker *make) {
        __weak UIView *superView = self.detailView.superview;
        
        make.centerY.equalTo(superView);
        make.top.greaterThanOrEqualTo(superView).offset(self.detailAreaInsets.top);
        make.bottom.lessThanOrEqualTo(superView).offset(-self.detailAreaInsets.bottom);

        if (_titleContainer.superview) {
            make.left.equalTo(self.titleContainer.mas_right).offset(self.detailAreaInsets.left + self.titleAreaInsets.right);
        }else if(_leftIcon.superview){
            make.left.equalTo(self.leftIcon.mas_right).offset(self.detailAreaInsets.left+self.iconAreaInsets.right);
        }else{
            make.left.equalTo(superView).offset(self.detailAreaInsets.left);
        }
        
        if (!_rightBtn.superview){
            make.right.equalTo(superView).offset(-self.detailAreaInsets.right);
        }else{
            make.right.equalTo(self.rightBtn.mas_left).offset(-self.detailAreaInsets.right - self.rightAreaInsets.left);
        }
        
        /*
         CGFloat lengthD;
         [_detailLabel sizeToFit];
         lengthD = _detailLabel.bounds.size.width;
         if (_imagesView.superview) {
         lengthD += _imagesView.bounds.size.width;
         }
         if (self.detailFixedLength) {
         lengthD = self.detailFixedLength;
         }
         */
        if (self.detailFixedLength) {
            make.width.mas_equalTo(self.detailFixedLength).with.priorityHigh();
        }
    }];
}

- (void)p_removeTextField
{
    [_detailTextField removeFromSuperview];
    _detailTextField = nil;
    
    [self setNeedsUpdateConstraints];
}
- (void)p_removeTextView
{
    [_detailTextView removeFromSuperview];
    _detailTextView = nil;
    
    [self setNeedsUpdateConstraints];
}
- (void)p_removeDetailContent
{
    [_detailContentView removeFromSuperview];
    
    _detailIcon = nil;
    _detailLabel = nil;
    _detailContentView = nil;
    _imagesView = nil;
    
    [self setNeedsUpdateConstraints];
}
- (void)removeDetail
{
    [_detailView removeFromSuperview];
    _detailView = nil;
    _detailIcon = nil;
    _detailLabel = nil;
    _detailContentView = nil;
    _imagesView = nil;
    
    _detailTextField = nil;
    _detailTextView = nil;
    
    [self setNeedsUpdateConstraints];
}
#pragma mark - NSNotification
- (void)detailTextViewDidChange:(NSNotification *)note
{
    self.detailTextViewPlaceholerLabel.hidden = self.detailTextView.text.length;
    
    if (self.editLimit > 0) {
        if (self.detailTextView.text.length > self.editLimit) {
            self.detailTextView.text = [self.detailTextView.text substringToIndex:self.editLimit];
        }
        _detailEditViewLimitLabel.text = [NSString stringWithFormat:@"%zd/%zd", self.detailTextView.text.length, self.editLimit];
    }else{
        _detailEditViewLimitLabel.text = [NSString stringWithFormat:@"%zd", self.detailTextView.text.length];
    }
    
    [self adjustTextViewHeightIfNeed];
}
- (void)detailTextViewDidEndEdit:(NSNotification *)note
{
    if (self.adjustTextViewHeight && self.textViewHeight > self.detailEditViewMinMinSize.height) {
        CGPoint offset = self.detailTextView.contentOffset;
        offset.y -= self.detailTextView.textContainerInset.top + self.detailTextView.contentInset.top;
        [self.detailTextView setContentOffset:offset animated:YES];
    }
}
- (void)detailTextFieldDidChange:(NSNotification *)note
{
    if (self.editLimit > 0) {
        if (self.detailTextField.text.length > self.editLimit) {
            self.detailTextField.text = [self.detailTextView.text substringToIndex:self.editLimit];
        }
        _detailEditViewLimitLabel.text = [NSString stringWithFormat:@"%zd/%zd", self.detailTextField.text.length, self.editLimit];
    }else{
        _detailEditViewLimitLabel.text = [NSString stringWithFormat:@"%zd", self.detailTextField.text.length];
    }
}
#pragma mark - private
- (void)drawViews
{
    [self addSubview:self.topLine];
    [self addSubview:self.bottomLine];
}

- (void)makeContraints
{
    [self.topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        __weak UIView *superView = self.topLine.superview;
        make.left.top.right.equalTo(superView);
        make.height.mas_equalTo(kOnePixel);
    }];
    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        __weak UIView *superView = self.bottomLine.superview;
        make.left.bottom.right.equalTo(superView);
        make.height.mas_equalTo(kOnePixel);
    }];
}

- (UIView *)getDetailImagesView:(NSArray<UIImage *> *)images;
{
    if (!images.count)
    {
        return nil;
    }
    UIView *view = [[UIView alloc] init];
    CGFloat x = 0.0;
    CGFloat height = 0.0;
    for (UIImage *image in images)
    {
        if ([image isKindOfClass:[UIImage class]])
        {
            UIImageView *imageV = [[UIImageView alloc]initWithImage:image];
            
            [view addSubview:imageV];
            imageV.frame = CGRectMake(x, 0, imageV.bounds.size.width, imageV.bounds.size.height);
            x += imageV.bounds.size.width + self.detailImageMargin;
            if (height < imageV.bounds.size.height)
            {
                height = imageV.bounds.size.height;
            }
        }
    }
    view.bounds = CGRectMake(0, 0, x-self.detailImageMargin, height);
    return view;
}

- (UIView *)getDetailImagesViewFromWeb:(NSArray<NSURL *> *)images;
{
    if (!images.count)
    {
        return nil;
    }
    UIView *view = [[UIView alloc] init];
    CGFloat x = 0.0;
    CGFloat height = 0.0;
    for (NSURL *url in images)
    {
        UIImageView *imageV = [[UIImageView alloc]init];
        imageV.bounds = CGRectMake(0, 0, self.detailIconSize.width, self.detailIconSize.height);
        [imageV sd_setImageWithURL:url placeholderImage:self.detailPlaceHolderIcon];
        [view addSubview:imageV];
        imageV.frame = CGRectMake(x, 0, imageV.bounds.size.width, imageV.bounds.size.height);
        x += imageV.bounds.size.width + self.detailImageMargin;
        if (height < imageV.bounds.size.height)
        {
            height = imageV.bounds.size.height;
        }
    }
    view.bounds = CGRectMake(0, 0, x-self.detailImageMargin, height);
    return view;
}

- (void)p_makeConstraintsForDetailIconWithType
{
    if (!_detailIcon.superview) {
        return;
    }
    if (self.detailIconLocation == YXYItemViewDetailIconTypeLeft) {
        [self.detailIcon mas_remakeConstraints:^(MASConstraintMaker *make) {
            __weak UIView *superView = self.detailIcon.superview;
            make.left.equalTo(superView).with.priorityHigh();
            make.centerY.equalTo(superView);
            make.width.mas_equalTo(self.detailIconSize.width);
            make.height.mas_equalTo(self.detailIconSize.height);
            if (!_detailLabel.superview) {
                make.right.equalTo(superView);
            }
            make.top.greaterThanOrEqualTo(superView).with.priorityHigh();
            make.bottom.lessThanOrEqualTo(superView).with.priorityHigh();
        }];
        
        if (_detailLabel.superview) {
            [self.detailLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                __weak UIView *superView = self.detailLabel.superview;
                make.right.equalTo(superView);
                make.left.equalTo(self.detailIcon.mas_right).offset(self.detailIconTitleMargin);
                make.centerY.equalTo(superView);
                make.top.greaterThanOrEqualTo(superView);
                make.bottom.lessThanOrEqualTo(superView);
            }];
        }
    }
    else if (self.detailIconLocation == YXYItemViewDetailIconTypeRight) {
        [self.detailIcon mas_remakeConstraints:^(MASConstraintMaker *make) {
            __weak UIView *superView = self.detailIcon.superview;
            make.right.equalTo(superView).with.priorityHigh();
            make.centerY.equalTo(superView);
            make.width.mas_equalTo(self.detailIconSize.width);
            make.height.mas_equalTo(self.detailIconSize.height);
            if (!_detailLabel.superview) {
                make.left.equalTo(superView);
            }
            make.top.greaterThanOrEqualTo(superView).with.priorityHigh();
            make.bottom.lessThanOrEqualTo(superView).with.priorityHigh();
        }];
        
        if (_detailLabel.superview) {
            [self.detailLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                __weak UIView *superView = self.detailLabel.superview;
                make.left.equalTo(superView);
                make.right.equalTo(self.detailIcon.mas_left).offset(-self.detailIconTitleMargin);
                make.centerY.equalTo(superView);
                make.top.greaterThanOrEqualTo(superView);
                make.bottom.lessThanOrEqualTo(superView);
            }];
        }
    }
}

- (void)p_makeContraintsForDetailViewsWithType
{
    if (!_imagesView.superview) {
        return;
    }
    if (self.detailIconLocation == YXYItemViewDetailIconTypeLeft) {
        [self.imagesView mas_remakeConstraints:^(MASConstraintMaker *make) {
            __weak UIView *superView = self.imagesView.superview;
            make.left.equalTo(superView).with.priorityHigh();
            make.centerY.equalTo(superView);
            make.width.mas_equalTo(self.imagesView.bounds.size.width).with.priorityLow();
            make.height.mas_equalTo(self.imagesView.bounds.size.height).with.priorityLow();
            if (!_detailLabel.superview){
                make.right.equalTo(superView);
            }
            make.top.greaterThanOrEqualTo(superView).with.priorityHigh();
            make.bottom.lessThanOrEqualTo(superView).with.priorityHigh();
        }];
        
        if (_detailLabel.superview) {
            [self.detailLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                __weak UIView *superView = self.detailLabel.superview;
                make.right.equalTo(superView);
                make.left.equalTo(self.imagesView.mas_right).offset(self.detailIconTitleMargin);
                make.centerY.equalTo(superView);
                make.top.greaterThanOrEqualTo(superView);
                make.bottom.lessThanOrEqualTo(superView);
            }];
        }
    }
    else if(self.detailIconLocation == YXYItemViewDetailIconTypeRight) {
        [self.imagesView mas_remakeConstraints:^(MASConstraintMaker *make) {
            __weak UIView *superView = self.imagesView.superview;
            make.right.equalTo(superView).with.priorityHigh();
            make.centerY.equalTo(superView);
            make.width.mas_equalTo(self.imagesView.bounds.size.width).with.priorityLow();
            make.height.mas_equalTo(self.imagesView.bounds.size.height).with.priorityLow();
            if (!_detailLabel.superview){
                make.left.equalTo(superView);
            }
            make.top.greaterThanOrEqualTo(superView).with.priorityHigh();
            make.bottom.lessThanOrEqualTo(superView).with.priorityHigh();
        }];
        
        if (_detailLabel.superview) {
            [self.detailLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                __weak UIView *superView = self.detailLabel.superview;
                make.left.equalTo(superView);
                make.right.equalTo(self.imagesView.mas_left).offset(-self.detailIconTitleMargin);
                make.centerY.equalTo(superView);
                make.top.greaterThanOrEqualTo(superView);
                make.bottom.lessThanOrEqualTo(superView);
            }];
        }
    }
}
- (void)p_makeConstraintsForLeftlIconSize
{
    if (_leftIcon.superview) {
        if (!self.leftIconSize.width) {
            [self.leftIcon sizeToFit];
            self.leftIconSize = CGSizeMake(self.leftIcon.bounds.size.width, self.leftIcon.bounds.size.height);
        }
        if (self.leftIconSize.width) {
            [self.leftIcon mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(self.leftIconSize.width);
                make.height.mas_equalTo(self.leftIconSize.height);
            }];
        }
    }
    
    [self setNeedsUpdateConstraints];
}

- (void)p_makeConstraintsForDetailIconSize
{
    if (_detailIcon.superview) {
        if (!self.detailIconSize.width) {
            [self.detailIcon sizeToFit];
            self.detailIconSize = CGSizeMake(self.detailIcon.bounds.size.width, self.detailIcon.bounds.size.height);
        }
        if (self.detailIconSize.width) {
            [self.detailIcon mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(self.detailIconSize.width);
                make.height.mas_equalTo(self.detailIconSize.height);
            }];
        }
    }
    
    [self setNeedsUpdateConstraints];
}
- (void)p_makeConstraintsForDetailEditView
{
    if (self.editLimit >= 0) {
        [self.detailContentView addSubview:self.detailEditViewLimitLabel];
    }
    if (_detailTextView.superview) {
        [self updateDetailTextViewWhenHeightChange:self.textViewHeight];
    }else if (_detailTextField.superview){
        [self.detailTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
            __weak UIView *superView = self.detailTextField.superview;
            make.left.equalTo(superView);
            if (_detailEditViewLimitLabel.superview) {
                make.right.equalTo(self.detailEditViewLimitLabel.mas_left).offset(-4);
            }else{
                make.right.equalTo(superView);
            }
            make.top.greaterThanOrEqualTo(superView);
            make.bottom.lessThanOrEqualTo(superView);
            make.height.greaterThanOrEqualTo(@(self.detailEditViewMinMinSize.height));
            if (self.detailEditViewMinMinSize.width) {
                make.width.mas_equalTo(@(self.detailEditViewMinMinSize.width));
            }
        }];
        if (_detailEditViewLimitLabel.superview) {
            [self.detailEditViewLimitLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                __weak UIView *superView = self.detailEditViewLimitLabel.superview;
                make.right.equalTo(superView);
                make.centerY.equalTo(superView);
            }];
        }
    }
}
- (void)updateDetailTextViewWhenHeightChange:(CGFloat)height
{
    [self.detailTextView mas_remakeConstraints:^(MASConstraintMaker *make) {
        __weak UIView *superView = self.detailTextView.superview;
        make.left.top.bottom.equalTo(superView);
        if (_detailEditViewLimitLabel.superview) {
            make.right.equalTo(self.detailEditViewLimitLabel.mas_left).offset(-4);
        }else{
            make.right.equalTo(superView);
        }
        make.height.mas_equalTo(height);
        if (self.detailEditViewMinMinSize.width) {
            make.width.mas_equalTo(@(self.detailEditViewMinMinSize.width));
        }
    }];
    if (_detailEditViewLimitLabel.superview) {
        [self.detailEditViewLimitLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            __weak UIView *superView = self.detailEditViewLimitLabel.superview;
            make.right.equalTo(superView);
            make.centerY.equalTo(superView);
        }];
    }
}

- (void)p_makeConstraintsForDetailPlaceholderLabel
{
    if (!_detailTextViewPlaceholerLabel.superview) {
        return;
    }
    [self.detailTextViewPlaceholerLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        __weak UIView *superView = self.detailTextViewPlaceholerLabel.superview;
        make.left.equalTo(superView).offset(self.detailTextView.contentInset.left+self.detailTextView.textContainerInset.left+self.detailTextView.textContainer.lineFragmentPadding);
        make.top.equalTo(superView).offset(self.detailTextView.contentInset.top+self.detailTextView.textContainerInset.top);
        CGFloat wOffset = self.detailTextView.contentInset.right+self.detailTextView.textContainerInset.right+self.detailTextView.textContainer.lineFragmentPadding + self.detailTextView.contentInset.left+self.detailTextView.textContainerInset.left+self.detailTextView.textContainer.lineFragmentPadding;
        make.width.equalTo(self.detailTextView).offset(-wOffset);
        
        self.detailTextViewPlaceholerLabel.textAlignment = self.detailTextView.textAlignment;
    }];
}
- (void)adjustTextViewHeightIfNeed
{
    if (self.adjustTextViewHeight) {
        CGFloat insetH = self.detailTextView.textContainer.lineFragmentPadding * 2 + self.detailTextView.textContainerInset.left + self.detailTextView.textContainerInset.right + self.detailTextView.contentInset.left + self.detailTextView.contentInset.right;
        
        CGSize size = [self.detailTextView.text boundingRectWithSize:CGSizeMake(self.detailTextView.bounds.size.width - insetH, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{} context:nil].size;
        CGFloat insetV = self.detailTextView.textContainerInset.top + self.detailTextView.textContainerInset.bottom + self.detailTextView.contentInset.top + self.detailTextView.contentInset.bottom;
        CGFloat height = (size.height+insetV) > self.detailEditViewMinMinSize.height ? (size.height+insetV) : self.detailEditViewMinMinSize.height;
        
        if (height != self.detailTextView.bounds.size.height) {
            self.textViewHeight = height;
            [self setNeedsUpdateConstraints];
        }
    }
}
#pragma mark - setter
- (void)setDetailIconSize:(CGSize)detailIconSize
{
    _detailIconSize = detailIconSize;
    [self p_makeConstraintsForDetailIconSize];
}
- (void)setLeftIconSize:(CGSize)leftIconSize
{
    _leftIconSize = leftIconSize;
    [self p_makeConstraintsForLeftlIconSize];
}

- (void)setLeftIconTagType:(YXYItemViewLeftIconTagType)leftIconTagType
{
    _leftIconTagType = leftIconTagType;
    switch (leftIconTagType) {
        case YXYItemViewLeftIconTagTypeNone:
            [_leftIconTagBtn removeFromSuperview];
            break;
        default:
            [self addSubview:self.leftIconTagBtn];
            break;
    }
    [self setNeedsUpdateConstraints];
}

- (void)setLineColor:(UIColor *)lineColor
{
    _lineColor = lineColor;
    self.topLine.backgroundColor = lineColor;
    self.bottomLine.backgroundColor = lineColor;
}

- (void)setSubTitleTopMarginValue:(CGFloat)subTitleTopMargin
{
    self.subTitleTopMargin = subTitleTopMargin;
    [self setNeedsUpdateConstraints];
}

- (void)setDetailTextViewPlaceholder:(NSAttributedString *)detailTextViewPlaceholder
{
    _detailTextViewPlaceholder = detailTextViewPlaceholder;
    self.detailTextViewPlaceholerLabel.attributedText = detailTextViewPlaceholder;
    
    [self.detailTextView addSubview:self.detailTextViewPlaceholerLabel];
}
- (void)setTitleTagSize:(CGSize)titleTagSize
{
    _titleTagSize = titleTagSize;
    self.titleTag.layer.cornerRadius = titleTagSize.width/2;
}
#pragma mark - getter
- (UIView *)topLine
{
    if (!_topLine)
    {
        _topLine = [UIView new];
        _topLine.hidden = YES;
    }
    return _topLine;
}
- (UIView *)bottomLine
{
    if (!_bottomLine)
    {
        _bottomLine = [UIView new];
    }
    return _bottomLine;
}

//left icon
- (UIImageView *)leftIcon
{
    if (!_leftIcon)
    {
        _leftIcon = [[UIImageView alloc]init];
        _leftIcon.userInteractionEnabled = NO;
        [self addLeftIcon];
        _leftIcon.clipsToBounds = YES;
    }
    return _leftIcon;
}

- (UIButton *)leftIconTagBtn
{
    if (!_leftIconTagBtn)
    {
        _leftIconTagBtn = [[UIButton alloc]init];
        _leftIconTagBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        _leftIconTagBtn.userInteractionEnabled = NO;
    }
    return _leftIconTagBtn;
}

//titleContainer
- (UIView *)titleContainer
{
    if (!_titleContainer)
    {
        _titleContainer = [[UIView alloc]init];
//        _titleContainer.clipsToBounds = YES;
        _titleContainer.userInteractionEnabled = NO;
    }
    return _titleContainer;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel)
    {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.numberOfLines  = 0;
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.font = [UIFont systemFontOfSize:16];
        [self addTitleLabel];
    }
    return _titleLabel;
}
- (UIButton *)titleTag
{
    if (!_titleTag)
    {
        _titleTag = [[UIButton alloc]init];
        _titleTag.backgroundColor = [UIColor redColor];
        _titleTag.titleLabel.font = [UIFont systemFontOfSize:10];
        [_titleTag setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _titleTag.layer.cornerRadius = self.titleTagSize.width/2;
        _titleTag.clipsToBounds = YES;
    }
    return _titleTag;
}
- (UILabel *)subTitleLabel
{
    if (!_subTitleLabel)
    {
        _subTitleLabel = [[UILabel alloc]init];
        _subTitleLabel.numberOfLines  = 0;
        [self addSubTitleLabel];
    }
    return _subTitleLabel;
}

//right
- (UIButton *)rightBtn
{
    if (!_rightBtn)
    {
        _rightBtn = [[UIButton alloc] init];
        [_rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _rightBtn.userInteractionEnabled = NO;
        [self addRightBtn];
    }
    return _rightBtn;
}

//detail
- (UIView *)detailView
{
    if (!_detailView)
    {
        _detailView = [[UIView alloc]init];
        _detailView.clipsToBounds = YES;
        _detailView.userInteractionEnabled = NO;
    }
    return _detailView;
}
- (UITextField *)detailTextField
{
    if (!_detailTextField)
    {
        _detailTextField = [[UITextField alloc]init];
        _detailTextField.font = [UIFont systemFontOfSize:16];
        _detailTextField.textColor = [UIColor blackColor];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(detailTextFieldDidChange:) name:UITextFieldTextDidChangeNotification object:_detailTextField];
        self.detailMode = YXYItemAttributeDetailModeLeftWrapContent;
        [self addDetailTextField];
    }
    return _detailTextField;
}
- (UITextView *)detailTextView
{
    if (!_detailTextView)
    {
        _detailTextView = [[UITextView alloc]init];
        _detailTextView.font = [UIFont systemFontOfSize:16];
        _detailTextView.textColor = [UIColor blackColor];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(detailTextViewDidChange:) name:UITextViewTextDidChangeNotification object:_detailTextView];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(detailTextViewDidEndEdit:) name:UITextViewTextDidEndEditingNotification object:_detailTextView];

        self.detailMode = YXYItemAttributeDetailModeLeftWrapContent;
        [self addDetailTextView];
    }
    return _detailTextView;
}
- (UILabel *)detailTextViewPlaceholerLabel
{
    if (!_detailTextViewPlaceholerLabel)
    {
        _detailTextViewPlaceholerLabel = [[UILabel alloc]init];
        _detailTextViewPlaceholerLabel.font = [UIFont systemFontOfSize:16];
        _detailTextViewPlaceholerLabel.textColor = [UIColor blackColor];
        _detailTextViewPlaceholerLabel.userInteractionEnabled = NO;
        _detailTextViewPlaceholerLabel.numberOfLines = 0;
    }
    return _detailTextViewPlaceholerLabel;
}
- (UILabel *)detailEditViewLimitLabel
{
    if (!_detailEditViewLimitLabel)
    {
        _detailEditViewLimitLabel = [[UILabel alloc]init];
        if (self.editLimit > 0) {
            _detailEditViewLimitLabel.text = [NSString stringWithFormat:@"0/%zd", self.editLimit];
        }else{
            _detailEditViewLimitLabel.text = @"0";
        }
    }
    return _detailEditViewLimitLabel;
}
- (UILabel *)detailLabel
{
    if (!_detailLabel)
    {
        _detailLabel = [[UILabel alloc]init];
        _detailLabel.numberOfLines = 0;
        [self addDetailLabel];
    }
    return _detailLabel;
}
- (UIImageView *)detailIcon
{
    if (!_detailIcon)
    {
        _detailIcon = [[UIImageView alloc]init];
        _detailIcon.layer.cornerRadius = self.detailIconSize.width / 2;
        _detailIcon.clipsToBounds = YES;
    }
    return _detailIcon;
}
- (UIView *)detailContentView
{
    if (!_detailContentView)
    {
        _detailContentView = [[UIView alloc]init];
    }
    return _detailContentView;
}
- (UIButton *)actionView
{
    if (!_actionView)
    {
        _actionView = [[UIButton alloc]init];
        _actionView.userInteractionEnabled = NO;
    }
    return _actionView;
}
@end
