//
//  YCFTabs.h
//  YCFComponentKit_OC
//
//  Created by jinxiaofei on 16/8/15.
//  Copyright © 2016年 yaochufa. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YCFTabsView;
//这个组件的作用, 用来快速布局一些tabs, 并且提供一些生成快速样式方法

typedef NS_ENUM(NSUInteger, YCFTabsLayoutType) {
    YCFTabsLayoutTypeHorizontal,
    YCFTabsLayoutTypeVertical,
};

typedef NS_ENUM(NSUInteger, YCFTabsStyle) {
    YCFTabsStyleNone,
    YCFTabsStyleLine,
    YCFTabsStyleCharFlow,
};

typedef NS_ENUM(NSUInteger, YCFTabsItemBtnType) {
    YCFTabsItemBtnTypeHorizontaIconTitle,
    YCFTabsItemBtnTypeHorizontaTitleIcon,
    YCFTabsItemBtnTypeVerticalIconTitle,
    YCFTabsItemBtnTypeVerticalTitleIcon,
};

@protocol YCFTabsDelegate <UIScrollViewDelegate>

@optional
//如果子item有手势, 则item范围内会覆盖内部的手势范围, 则请自行管理
- (void)tabsView:(YCFTabsView *)tabsView didSelectedTabItemAtIndex:(NSInteger)index selectedItem:(UIView *)item;

- (void)tabsView:(YCFTabsView *)tabsView didDoubleClickedTabItemAtIndex:(NSInteger)index selectedItem:(UIView *)item;
@end

@interface YCFTabsView : UIScrollView

@property(nonatomic, weak) id<YCFTabsDelegate> delegate;

@property(nonatomic, assign) NSInteger selectedIndex;

@property(nonatomic, strong) UIFont  *tabBtnFont;
@property(nonatomic, strong) UIColor *tabBtnTextColor;
@property(nonatomic, strong) UIColor *tabBtnTextColorH;
@property(nonatomic, strong) UIColor *tabBtnTextColorS;

@property(nonatomic, assign) CGFloat equalWidth;//isNeedEqualWidth == YES, 默认为平均宽度/高度
@property(nonatomic, assign) CGFloat columnMargin; //列间距
@property(nonatomic, assign) UIEdgeInsets borderPadding;//四周边距

@property(nonatomic, assign) YCFTabsLayoutType layoutType;
@property(nonatomic, assign) YCFTabsStyle tabsStyle;


@property(nonatomic, strong) UIColor *bottomIndicatorColor;
@property(nonatomic, assign) CGSize bottomIndicatorSize;
@property(nonatomic, assign) UIEdgeInsets bottomIndicatorInsets;

@property (nonatomic, assign) BOOL isShowSplitLine;
@property (nonatomic, assign) UIEdgeInsets splitLineInsets;
@property (nonatomic, assign) CGFloat splitLineWidth;
@property (nonatomic, assign) UIColor *splitLineColor;

//内部默认实现子item为[UIButton class]
+ (instancetype)quickCreateTabsViewWithTitles:(NSArray<NSString *> *)titles
                             isNeedEqualWidth:(BOOL)isNeedEqualWidth;

+ (instancetype)quickCreateTabsViewWithTitles:(NSArray<NSString *> *)titles
                                    iconImage:(NSArray<NSString *> *)icons
                                   iconImageH:(NSArray<NSString *> *)iconsH
                                   iconImageS:(NSArray<NSString *> *)iconsS
                             isNeedEqualWidth:(BOOL)isNeedEqualWidth;

+ (instancetype)quickCreateTabsViewWithTitles:(NSArray<NSString *> *)titles
                                    iconImage:(NSArray<NSString *> *)icons
                                   iconImageH:(NSArray<NSString *> *)iconsH
                                   iconImageS:(NSArray<NSString *> *)iconsS
                                      bgImage:(NSArray<NSString *> *)bgImages
                                     bgImageH:(NSArray<NSString *> *)bgImagesH
                                     bgImageS:(NSArray<NSString *> *)bgImagesS
                             isNeedEqualWidth:(BOOL)isNeedEqualWidth;
//如果是上面快速方法创建的tab, 用这个方法调整btn的图片和文字位置
- (void)configTabItemBtn:(YCFTabsItemBtnType)btnType contentInsets:(UIEdgeInsets)contentInsets titleInsets:(UIEdgeInsets)titleInsets iconInsets:(UIEdgeInsets)iconInsets;

/**
 *  如果想使用这个方法快速管理内部布局, 子item必须有明确的bounds
 */
+ (instancetype)layoutForCustomTabs:(NSArray<UIView *> *)tabs
                   isNeedEqualWidth:(BOOL)isNeedEqualWidth;

//选中某个item
- (void)selectedTabItemAtIndex:(NSInteger)index;

/**
 *  没有多余margin, 计算出紧凑的尺寸(注意自定义的customItems, 需要有尺寸)
 *
 *  @param max max = width(when hor layout), max = height(when ver layout)
 *
 *  @param margin 间距, 这里会将margin保存到columnMargin
 *
 *  @return size
 */
- (CGSize)sizeToFitWithMax:(CGFloat)max margin:(CGFloat)margin;

@end
