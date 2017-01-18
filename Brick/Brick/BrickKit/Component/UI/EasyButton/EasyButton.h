//
//  EasyButton.h
//  YXY
//
//  Created by jinxiaofei on 16/10/9.
//  Copyright © 2016年 Guangzhou TalkHunt Information Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, EasyBtnType) {
    EasyBtnTypeHorizontaIconTitle,
    EasyBtnTypeBtnTypeHorizontaTitleIcon,
    EasyBtnTypeBtnTypeVerticalIconTitle,
    EasyBtnTypeBtnTypeVerticalTitleIcon,
};

@interface EasyButton : UIButton
- (void)configTabItemBtn:(EasyBtnType)btnType contentInsets:(UIEdgeInsets)contentInsets titleInsets:(UIEdgeInsets)titleInsets iconInsets:(UIEdgeInsets)iconInsets isSetIconRound:(BOOL)isSetIconRound;

@end
