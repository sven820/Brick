//
//  YCFKeyBoardManager.h
//  keyboar
//
//  Created by jinxiaofei on 16/8/3.
//  Copyright © 2016年 JJ.sevn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, YCFKeyBoardMaskToolItemType) {
    YCFKeyBoardMaskToolItemTypeCustom = -1, //自定义
    YCFKeyBoardMaskToolItemTypePhotos = 0, //相册
    YCFKeyBoardMaskToolItemTypeAlt, //@
    YCFKeyBoardMaskToolItemTypeTopic, //话题
    YCFKeyBoardMaskToolItemTypeEmoji, //表情键盘
    YCFKeyBoardMaskToolItemTypeMore, //更多items
    YCFKeyBoardMaskToolItemTypeResignKeyBoard, //退出键盘
};
@protocol YCFKeyBoardToolBarDelegate <UITextFieldDelegate, UITextViewDelegate>

@optional
/**
  * 键盘弹出时,非键盘区域加了个maskView来点击退出键盘,默认内部已实现了对UITextField, UITextView, UIControl的忽略, 这里传入其他要被忽略的view, 这样maskView不会遮挡这些view的交互效果
 */
- (NSArray *)hitTextIgnoreViewsWhenClickMaskView:(UIView *)editView;

//在默认基础上追加/删除项
- (void)configDefaultKeyBoardToolBarItemsForAddOrDelete:(NSMutableArray<NSNumber *> *)defaultItems toolBar:(UICollectionView *)toolBar;//defaultItems<YCFKeyBoardMaskToolItemType> from 0..., if insert, insert YCFKeyBoardMaskToolItemTypeCustom
- (NSString *)iconForItemCellIfNeedAtIndex:(NSInteger)index toolBar:(UICollectionView *)toolBar;
- (NSString *)titleForItemCellIfNeedAtIndex:(NSInteger)index toolBar:(UICollectionView *)toolBar;

//以下方法实现全部自定义
- (NSInteger)numberOfKeyBoardToolBarItems:(UICollectionView *)toolBar;
- (UICollectionViewCell *)itemCellAtIndex:(NSInteger)index toolBar:(UICollectionView *)toolBar;
- (CGSize)itemSizeAtIndex:(NSInteger)index toolBar:(UICollectionView *)toolBar;

//选中某个item
- (void)didSelectedToolBarItemAtIndex:(NSInteger)index toolBar:(UICollectionView *)toolBar itemType:(YCFKeyBoardMaskToolItemType)itemType;
//设置键盘工具条在键盘退出后是否显示在底部
- (BOOL)isNeedToolBarHideWhenResignKeyboard:(UICollectionView *)toolBar;

//更多工具, todo!
@end

typedef NS_ENUM(NSUInteger, YCFKeyBoardStatusType) {
    YCFKeyBoardStatusDidHide,
    YCFKeyBoardStatusWillShow,
    YCFKeyBoardStatusDidShow,
    YCFKeyBoardStatusWillHide,
};

#warning 如果选择了isNeedManageKeyBoardResign = YES,会加maskView管理键盘退出, 因此当页面发生push,modul的时候, 一定要隐藏键盘,不然maskView会一直存在, 遮挡后续界面
@interface YCFKeyBoardManager : NSObject

+ (instancetype)shareInstance;

@property(nonatomic, assign) CGFloat distanceWithKeyBoard;//键盘和编辑框的间隔, 默认0

@property(nonatomic, assign) YCFKeyBoardStatusType status;

@property(nonatomic, assign) BOOL isNeedManageKeyBoardResign;//默认YES, NO则不会加maskView
@property(nonatomic, assign) BOOL isNeedKeyBoardToolBar;//默认YES

@property(nonatomic, assign, readonly) CGFloat keyBoardDuration;
@property(nonatomic, assign, readonly) CGRect keyBoardFrame;
@property(nonatomic, assign, readonly) UIViewAnimationOptions keyBoardAnimationOptions;

@property(nonatomic, weak, setter=setCurEditView:) UIView *curEditView;

@property(nonatomic, assign) CGFloat keyBoardToolBarHeight;//默认30

- (void)resetKeyBoard;

- (void)showToolBarWithAnimation:(BOOL)animation;
- (void)hideToolBarWithAnimation:(BOOL)animation;
- (void)bottomToolBarWithAnimation:(BOOL)animation;
@end
