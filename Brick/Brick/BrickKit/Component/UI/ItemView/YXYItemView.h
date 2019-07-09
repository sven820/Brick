//
//  YXYItemView.h
//  YXY
//
//  Created by jinxiaofei on 16/9/18.
//  Copyright © 2016年 Guangzhou TalkHunt Information Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YXYItemView;

typedef NS_ENUM(NSUInteger, YXYItemAttributeDetailMode) {
    YXYItemAttributeDetailModeRight,
    YXYItemAttributeDetailModeCenter,
    YXYItemAttributeDetailModeLeft,
    YXYItemAttributeDetailModeLeftWrapContent,
};

typedef NS_ENUM(NSUInteger, YXYItemViewDetailIconType) {
    YXYItemViewDetailIconTypeLeft,//如果有文本, 位于文本左边
    YXYItemViewDetailIconTypeRight,//如果有文本, 位于文本右边
    YXYItemViewDetailIconTypeTop,//如果有文本, 位于文本上边
    YXYItemViewDetailIconTypeBottom,//如果有文本, 位于文本下边
};

typedef NS_ENUM(NSUInteger, YXYItemViewLeftIconTagType) {
    YXYItemViewLeftIconTagTypeNone,
    YXYItemViewLeftIconTagTypeLeftTop,
    YXYItemViewLeftIconTagTypeLeftBottom,
    YXYItemViewLeftIconTagTypeRightTop,
    YXYItemViewLeftIconTagTypeRightBottom,
};

@interface YXYItemView : UIView
#pragma mark - action
- (void)addTarget:(id)target sel:(SEL)sel;
- (void)addTargetForRightBtn:(id)target sel:(SEL)sel events:(UIControlEvents)events;

#pragma mark - leftArea
@property (nonatomic, readonly) UIImageView *leftIcon;//左边图标, 默认贴边
@property (nonatomic, assign) CGSize leftIconSize; //默认39 * 39
@property (nonatomic, assign) BOOL needRoundLeftIcon; //默认yes
@property (nonatomic, assign) YXYItemViewLeftIconTagType leftIconTagType;
@property (nonatomic, readonly) UIButton *leftIconTagBtn;
@property (nonatomic, assign) CGSize leftIconTagSize; // 15 * 15
@property (nonatomic, assign) UIOffset leftIconTagOffset; //zero
//- (void)locateLeftIconToCenter;
- (void)removeLeftIcon;

#pragma mark - titleArea
//注意, 当同时存在detailLabel , titlelabel时候, 且文本长度之和超过一行宽度时候, 必须确定其中一个的宽度 titleFixedLength | detailFixedLength, 根据UI具体调整, 一般最好指定一项, 以防文本超出或压缩
@property (nonatomic, assign) CGFloat titleFixedLength;//固定titleview宽度, 默认跟文字对齐
@property (nonatomic, readonly) UILabel *titleLabel;//标题
- (void)removeTitleLabel;
@property (nonatomic, readonly) UILabel *subTitleLabel;
- (void)removeSubTitleLabel;
@property (nonatomic, assign) CGFloat titleViewMargin;//8
//tag
@property (nonatomic, readonly) UIButton *titleTag;//标题上标(文字或图片, 选一)
@property (nonatomic, assign) CGSize titleTagSize;//default 6 * 6
@property (nonatomic, assign) UIOffset titleTagOffset;//default zero

#pragma mark - detailArea
@property (nonatomic, assign) CGFloat detailFixedLength;//固定detailView宽度, 默认跟文字对齐,

@property (nonatomic, readonly) UILabel *detailLabel;//中间详细描述
@property (nonatomic, assign) CGSize detailIconSize;
@property (nonatomic, assign) BOOL detailIconRound;//NO;
@property (nonatomic, assign) YXYItemAttributeDetailMode detailMode;
@property (nonatomic, assign) CGFloat detailImageMargin;
@property (nonatomic, assign) CGFloat detailIconTitleMargin;//5
@property (nonatomic, strong) UIImage *detailPlaceHolderIcon;
//图片需要确定size, 默认20 * 20
- (void)addDetailIcon:(UIImage *)image loaction:(YXYItemViewDetailIconType)loaction;
- (void)addDetailWebIcon:(NSURL *)imageUrl loaction:(YXYItemViewDetailIconType)loaction;
- (void)setDetailWebIcon:(NSURL *)imageUrl placeHolder:(UIImage *)placeHolder;
- (void)addDetailIcons:(NSArray<UIImage *> *)images loaction:(YXYItemViewDetailIconType)loaction;
- (void)addDetailWebIcons:(NSArray<NSURL *> *)images loaction:(YXYItemViewDetailIconType)loaction;

@property (nonatomic, readonly) UITextField *detailTextField; //可以编辑的中间描述

@property (nonatomic, readonly) UITextView *detailTextView; //可以编辑的中间描述
@property (nonatomic, assign) BOOL adjustTextViewHeight;
- (void)updateDetailTextViewWhenHeightChange:(CGFloat)height;
@property (nonatomic, strong) NSAttributedString *detailTextViewPlaceholder;
@property (nonatomic, assign) NSInteger editLimit;//default:-1, 不显示
@property (nonatomic, readonly) UILabel *detailEditViewLimitLabel;//editLimit >= 0时候显示, =0时候只显示字数

@property (nonatomic, assign) CGSize detailEditViewMinMinSize;//default: (0, 35), default:YXYItemAttributeDetailModeLeftWrapContent

- (void)removeDetail;

#pragma mark - rightArea
@property (nonatomic, readonly) UIButton *rightBtn;//右边图标(文字或图片, 选一)
@property (nonatomic, assign) CGSize rightBtnSize; //默认为sizeTofit
- (void)removeRightBtn;

#pragma mark - configuration
@property (nonatomic, assign) UIEdgeInsets iconAreaInsets;//default: UIEdgeInsetsMake(0, 12, 0, 0)
@property (nonatomic, assign) UIEdgeInsets titleAreaInsets;//default: UIEdgeInsetsMake(0, 12, 0, 12)
@property (nonatomic, assign) UIEdgeInsets detailAreaInsets;//default: UIEdgeInsetsMake(0, 12, 0, 12)
@property (nonatomic, assign) UIEdgeInsets detailContentAreaInsets;//default: UIEdgeInsetsMake(0, 0, 0, 0)
@property (nonatomic, assign) UIEdgeInsets rightAreaInsets;//default: UIEdgeInsetsMake(0, 0, 0, 12)
@property (nonatomic,assign) CGFloat subTitleTopMargin;//8

@property (nonatomic, strong, setter=setLineColor:) UIColor *lineColor;
- (void)setTopLineShow:(BOOL)isShow;//默认隐藏
- (void)setBottomLineShow:(BOOL)isShow;//默认显示
- (void)setTopLinePadding:(UIEdgeInsets)padding; // padding左右有效
- (void)setBottomLinePadding:(UIEdgeInsets)padding; // padding左右有效
- (void)setSubTitleTopMarginValue:(CGFloat)subTitleTopMargin;
@end
