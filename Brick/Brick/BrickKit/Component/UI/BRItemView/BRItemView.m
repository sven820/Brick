//
//  YXYItemView.m
//  YXY
//
//  Created by jinxiaofei on 16/9/18.
//  Copyright © 2016年 Guangzhou TalkHunt Information Technology Co., Ltd. All rights reserved.
//

#import "BRItemView.h"

@interface BRItemView ()
@property (nonatomic, assign) YXYItemViewStatus status;
@property (nonatomic, strong) BRItemAttributeModel *itemModel;

@property (nonatomic, strong) UIView *bottomLine;
@property (nonatomic, strong) UIView *topLine;

@property (nonatomic, strong) UIImageView *leftIcon;//左边图标
@property (nonatomic, strong) UILabel *titlelabel;//标题
@property (nonatomic, strong) UIButton *titleTag;//标题上标(文字或图片, 选一)
@property (nonatomic, strong) UIButton *rightBtn;//右边图标(文字或图片, 选一)

@property (nonatomic, strong) UIView *detailView;
@property (nonatomic, strong) UILabel *detailLabel;//右边详细描述
@property (nonatomic, strong) UIImageView *detailIcon;//右边详细描述的icon
@property (nonatomic, strong) UIView *detailContentView;
@property (nonatomic, strong) UIView *imagesView;

@end
@implementation BRItemView

- (instancetype)initWithTarget:(id)target sel:(SEL)sel
{
    if (self = [super init]) {
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:target action:sel];
        [self addGestureRecognizer:tap];
        
        [self drawViews];
        [self makeContraints];
    }
    return self;

}


- (void)configWithItemModel:(BRItemAttributeModel *)itemModel
{
    self.itemModel = itemModel;
    
    [self configLeftIcon:itemModel];
    [self configRightBtn:itemModel];
    [self configTitleLabel:itemModel];
    [self configDetailView:itemModel];
}

- (void)configLeftIcon:(BRItemAttributeModel *)itemModel
{
    if (itemModel.leftIcon)
    {
        if (_leftIcon.superview) {
            self.leftIcon.image = itemModel.leftIcon;
            [self.leftIcon sizeToFit];
        }
        else
        {
            [self addSubview:self.leftIcon];
            self.leftIcon.image = itemModel.leftIcon;
            [self.leftIcon sizeToFit];
            [self.leftIcon mas_makeConstraints:^(MASConstraintMaker *make) {
                __weak UIView *superView = self.leftIcon.superview;
                make.centerY.equalTo(superView);
                make.left.equalTo(superView).offset(8);
                make.width.height.mas_equalTo(39);
            }];
        }
    }
    else
    {
        [_leftIcon removeFromSuperview];
        if (_titlelabel.superview)
        {
            [self.titlelabel mas_updateConstraints:^(MASConstraintMaker *make) {
                __weak UIView *superView = self.titlelabel.superview;
                make.left.equalTo(superView).offset(8);
            }];
        }
    }
}
- (void)configRightBtn:(BRItemAttributeModel *)itemModel
{
    if (itemModel.rightIcon)
    {
        if (_rightBtn.superview) {
            [_rightBtn setBackgroundImage:itemModel.rightIcon forState:UIControlStateNormal];
            [self.rightBtn sizeToFit];
        }
        else
        {
            [self addSubview:self.rightBtn];
            [self.rightBtn setImage:itemModel.rightIcon forState:UIControlStateNormal];
            [self.rightBtn sizeToFit];
            [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                __weak UIView *superView = self.rightBtn.superview;
                make.centerY.equalTo(superView);
                make.right.equalTo(superView).offset(-8);
            }];
        }
    }
    else
    {
        if (![NSString checkIsEmptyOrNull:itemModel.rightTitle])
        {
            if (_rightBtn.superview) {
                [_rightBtn setTitle:itemModel.rightTitle forState:UIControlStateNormal];
                [self.rightBtn sizeToFit];
            }
            else
            {
                [self addSubview:self.rightBtn];
                [_rightBtn setTitle:itemModel.rightTitle forState:UIControlStateNormal];
                [self.rightBtn sizeToFit];
                [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    __weak UIView *superView = self.rightBtn.superview;
                    make.centerY.equalTo(superView);
                    make.right.equalTo(superView).offset(-8);
                }];
            }
        }
        else
        {
            [_rightBtn removeFromSuperview];
            if (_detailView.superview) {
                [self.detailView mas_updateConstraints:^(MASConstraintMaker *make) {
                    __weak UIView *superView = self.detailView.superview;
                    make.right.equalTo(superView).offset(8);
                }];
            }
        }
    }
}
- (void)configTitleLabel:(BRItemAttributeModel *)itemModel
{
    if (![NSString checkIsEmptyOrNull:itemModel.title])
    {
        if (_titlelabel.superview)
        {
            _titlelabel.text = itemModel.title;
            [self.titlelabel sizeToFit];
        }
        else
        {
            if (_leftIcon.superview)
            {
                [self addSubview:self.titlelabel];
                self.titlelabel.text = itemModel.title;
                [self.titlelabel sizeToFit];
                [self.titlelabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    __weak UIView *superView = self.titlelabel.superview;
                    make.left.equalTo(self.leftIcon.mas_right).offset(4);
                    make.centerY.equalTo(superView);
                }];
            }
            else
            {
                [self addSubview:self.titlelabel];
                self.titlelabel.text = itemModel.title;
                [self.titlelabel sizeToFit];
                [self.titlelabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    __weak UIView *superView = self.titlelabel.superview;
                    make.left.equalTo(superView).offset(8);
                    make.centerY.equalTo(superView);
                }];
            }
        }
    }
    else
    {
        [_titlelabel removeFromSuperview];
        [_titleTag removeFromSuperview];
    }
    
    if (!_titlelabel.superview)
    {
        return;
    }
    if (itemModel.titleTagImage)
    {
        if (_titleTag.superview)
        {
            [self.titleTag setBackgroundImage:itemModel.titleTagImage forState:UIControlStateNormal];
            [self.titleTag sizeToFit];
        }
        else
        {
            [self addSubview:self.titleTag];
            [self.titleTag setBackgroundImage:itemModel.titleTagImage forState:UIControlStateNormal];
            [self.titleTag sizeToFit];
            [self.titleTag mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.titlelabel.mas_right);
                make.bottom.equalTo(self.titlelabel.mas_top);
            }];
        }
    }
    else
    {
        if (![NSString checkIsEmptyOrNull:itemModel.titleTagNum])
        {
            if (_titleTag.superview)
            {
                [self.titleTag setTitle:itemModel.titleTagNum forState:UIControlStateNormal];
                [self.titleTag sizeToFit];
            }
            else
            {
                [self addSubview:self.titleTag];
                [self.titleTag setTitle:itemModel.titleTagNum forState:UIControlStateNormal];
                [self.titleTag sizeToFit];
                [self.titleTag mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self.titlelabel.mas_right);
                    make.bottom.equalTo(self.titlelabel.mas_top);
                }];
            }
        }
        else
        {
            [_titleTag removeFromSuperview];
        }
    }

}
- (void)configDetailView:(BRItemAttributeModel *)itemModel
{
    if ([NSString checkIsEmptyOrNull:itemModel.detail] && !itemModel.detailImage && !itemModel.detailImages.count) return;
    [self addSubview:self.detailView];
    [self.detailView addSubview:self.detailContentView];
    [self.detailView mas_makeConstraints:^(MASConstraintMaker *make) {
        __weak UIView *superView = self.detailView.superview;
        make.centerY.equalTo(superView);
        make.top.bottom.equalTo(superView);
        if (_titleTag)
        {
            make.left.equalTo(self.titleTag.mas_right).offset(4);
        }
        else if (_titlelabel)
        {
            make.left.equalTo(self.titlelabel.mas_right).offset(4);
        }
        else if (_leftIcon)
        {
            make.left.equalTo(self.leftIcon.mas_right).offset(4);
        }
        else
        {
            make.left.equalTo(superView).offset(8);
        }
        if (_rightBtn)
        {
            make.right.equalTo(self.rightBtn.mas_left).offset(-4);
        }else
        {
            make.right.equalTo(superView).offset(-8);
        }
    }];
    
    if (![NSString checkIsEmptyOrNull:itemModel.detail])
    {
        if (_detailLabel.superview)
        {
            self.detailLabel.text = itemModel.detail;
            [self.detailLabel sizeToFit];
        }
        else
        {
            [self.detailContentView addSubview:self.detailLabel];
            self.detailLabel.text = itemModel.detail;
            [self.detailLabel sizeToFit];
            [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                __weak UIView *superView = self.detailLabel.superview;
                make.right.equalTo(superView);
                make.centerY.equalTo(superView);
            }];
        }
    }
    else
    {
        [_detailLabel removeFromSuperview];
        if (_imagesView.superview)
        {
            [self.imagesView mas_updateConstraints:^(MASConstraintMaker *make) {
                __weak UIView *superView = self.imagesView.superview;
                make.right.equalTo(superView);
            }];
        }
        else if (_detailIcon.superview)
        {
            [self.detailIcon mas_updateConstraints:^(MASConstraintMaker *make) {
                __weak UIView *superView = self.detailIcon.superview;
                make.right.equalTo(superView);
            }];
        }
    }
    
    if (itemModel.detailImages.count)
    {
        if (_imagesView.subviews.count != itemModel.detailImages.count)
        {
            _imagesView = nil;
            [self.detailContentView addSubview:self.imagesView];
            if (_detailLabel.superview)
            {
                [self.imagesView mas_makeConstraints:^(MASConstraintMaker *make) {
                    __weak UIView *superView = self.imagesView.superview;
                    make.right.equalTo(self.detailLabel.mas_left);
                    make.centerY.equalTo(superView);
                    make.width.mas_equalTo(self.imagesView.bounds.size.width);
                    make.height.mas_equalTo(self.imagesView.bounds.size.height);
                }];
            }
            else
            {
                [self.imagesView mas_makeConstraints:^(MASConstraintMaker *make) {
                    __weak UIView *superView = self.imagesView.superview;
                    make.right.equalTo(superView);
                    make.centerY.equalTo(superView);
                    make.width.mas_equalTo(self.imagesView.bounds.size.width);
                    make.height.mas_equalTo(self.imagesView.bounds.size.height);
                }];
            }
        }
    }
    else if (itemModel.detailImage)
    {
        if (_detailIcon.superview)
        {
            self.detailIcon.image = itemModel.detailImage;
            [self.detailIcon sizeToFit];
        }
        else
        {
            [self.detailContentView addSubview:self.detailIcon];
            self.detailIcon.image = itemModel.detailImage;
            [self.detailIcon sizeToFit];
            if (_detailLabel.superview)
            {
                [self.detailIcon mas_makeConstraints:^(MASConstraintMaker *make) {
                    __weak UIView *superView = self.detailIcon.superview;
                    make.right.equalTo(self.detailLabel.mas_left);
                    make.centerY.equalTo(superView);
                }];
            }
            else
            {
                [self.detailIcon mas_makeConstraints:^(MASConstraintMaker *make) {
                    __weak UIView *superView = self.detailIcon.superview;
                    make.right.equalTo(superView);
                    make.centerY.equalTo(superView);
                }];
            }
        }
    }
    else
    {
        [_detailIcon removeFromSuperview];
        [self.imagesView removeFromSuperview];
    }
    
    [self.detailContentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        __weak UIView *superView = self.detailContentView.superview;
        make.top.bottom.equalTo(superView);
        if (_imagesView.superview)
        {
            make.width.mas_equalTo(_imagesView.bounds.size.width + _detailLabel.bounds.size.width);
        }
        else if (_detailIcon.superview)
        {
            make.width.mas_equalTo(_detailIcon.bounds.size.width + _detailLabel.bounds.size.width);
        }
        switch (itemModel.mode) {
            case YXYItemAttributeDetailModeRight:
                make.right.equalTo(superView).offset(-(itemModel.detailInsets.right - itemModel.detailInsets.left));
                break;
            case YXYItemAttributeDetailModeCenter:
                make.centerX.equalTo(superView).offset(itemModel.detailInsets.left - itemModel.detailInsets.right);
                break;
            case YXYItemAttributeDetailModeLeft:
                make.left.equalTo(superView).offset(itemModel.detailInsets.left - itemModel.detailInsets.right);
                break;
        }
    }];
}

- (void)setTopLineShow:(BOOL)isShow
{
    self.topLine.hidden = !isShow;
}

- (void)setBottomLineShow:(BOOL)isShow
{
    self.bottomLine.hidden = !isShow;
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

- (UIView *)getDetailImagesView
{
    if (!self.itemModel.detailImages.count)
    {
        return nil;
    }
    UIView *view = [[UIView alloc] init];
    CGFloat x = 0.0;
    CGFloat height = 0.0;
    if (!self.itemModel.detailImagesMargin)
    {
        self.itemModel.detailImagesMargin = 2;
    }
    for (UIImage *image in self.itemModel.detailImages)
    {
        if ([image isKindOfClass:[UIImage class]])
        {
            UIImageView *imageV = [[UIImageView alloc]initWithImage:image];
            [imageV sizeToFit];
            [view addSubview:imageV];
            imageV.frame = CGRectMake(x, 0, imageV.bounds.size.width, imageV.bounds.size.height);
            x += imageV.bounds.size.width + self.itemModel.detailImagesMargin;
            if (height < imageV.bounds.size.height)
            {
                height = imageV.bounds.size.height;
            }
        }
    }
    view.bounds = CGRectMake(0, 0, x-self.itemModel.detailImagesMargin, height);
    return view;
}
#pragma mark - setter & getter
- (UIView *)topLine
{
    if (!_topLine)
    {
        _topLine = [UIView new];
        _topLine.backgroundColor = [UIColor lightGrayColor];
        _topLine.hidden = YES;
    }
    return _topLine;
}
- (UIView *)bottomLine
{
    if (!_bottomLine)
    {
        _bottomLine = [UIView new];
        _bottomLine.backgroundColor = [UIColor lightGrayColor];
    }
    return _bottomLine;
}

- (UIImageView *)leftIcon
{
    if (!_leftIcon)
    {
        _leftIcon = [[UIImageView alloc]init];
    }
    return _leftIcon;
}
- (UILabel *)titlelabel
{
    if (!_titlelabel)
    {
        _titlelabel = [[UILabel alloc] init];
    }
    return _titlelabel;
}
- (UIButton *)titleTag
{
    if (!_titleTag)
    {
        _titleTag = [[UIButton alloc] init];
        _titleTag.userInteractionEnabled = NO;
        _titleTag.titleLabel.font = [UIFont systemFontOfSize:10];
    }
    return _titleTag;
}
- (UIButton *)rightBtn
{
    if (!_rightBtn)
    {
        _rightBtn = [[UIButton alloc] init];
    }
    return _rightBtn;
}
- (UIView *)detailView
{
    if (!_detailView)
    {
        _detailView = [[UIView alloc]init];
    }
    return _detailView;
}
- (UILabel *)detailLabel
{
    if (!_detailLabel)
    {
        _detailLabel = [[UILabel alloc]init];
    }
    return _detailLabel;
}
- (UIImageView *)detailIcon
{
    if (!_detailIcon)
    {
        _detailIcon = [[UIImageView alloc]init];
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
- (UIView *)imagesView
{
    if (!_imagesView)
    {
        _imagesView = [self getDetailImagesView];
    }
    return _imagesView;
}
@end


@implementation BRItemAttributeModel

@end
