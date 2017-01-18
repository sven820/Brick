//
//  YXYItemView.h
//  YXY
//
//  Created by jinxiaofei on 16/9/18.
//  Copyright © 2016年 Guangzhou TalkHunt Information Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BRItemView;

typedef NS_ENUM(NSUInteger, YXYItemViewStatus) {
    YXYItemViewStatusDisabled,
    YXYItemViewStatusSelected,
    YXYItemViewStatusUnselected,
};
typedef NS_ENUM(NSUInteger, YXYItemAttributeDetailMode) {
    YXYItemAttributeDetailModeRight,
    YXYItemAttributeDetailModeCenter,
    YXYItemAttributeDetailModeLeft,
};

@interface BRItemAttributeModel : NSObject
@property (nonatomic, strong) UIImage *leftIcon;

@property (nonatomic, strong) UIImage *rightIcon;
@property (nonatomic, strong) NSString *rightTitle;

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *titleTagNum;
@property (nonatomic, strong) UIImage *titleTagImage;

@property (nonatomic, strong) NSString *detail;
@property (nonatomic, strong) UIImage *detailImage;
@property (nonatomic, assign) YXYItemAttributeDetailMode mode;
@property (nonatomic, assign) UIEdgeInsets detailInsets;//只有左右有效
@property (nonatomic, assign) CGFloat detailImagesMargin;
@property (nonatomic, strong) NSArray *detailImages;//优先级比detailImage高
@end

@interface BRItemView : UIView

@property (nonatomic, assign, readonly) YXYItemViewStatus status;

- (instancetype)initWithTarget:(id)target sel:(SEL)sel;
- (void)configWithItemModel:(BRItemAttributeModel *)itemModel;

- (void)setTopLineShow:(BOOL)isShow;//默认隐藏
- (void)setBottomLineShow:(BOOL)isShow;//默认显示

@end
