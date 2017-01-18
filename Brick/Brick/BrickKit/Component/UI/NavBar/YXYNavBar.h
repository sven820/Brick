//
//  YXYNavBar.h
//  Brick
//
//  Created by jinxiaofei on 16/10/2.
//  Copyright © 2016年 jinxiaofei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YXYPopView.h"

@interface YXYNavBar : UIView
@property (nonatomic, strong) UIView *leftView;
@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) UIView *rightView;

@property (nonatomic, strong) NSString *left;
@property (nonatomic, strong) UIImage *leftImage;

@property (nonatomic, strong) NSString *title;

@property (nonatomic, strong) NSString *right;
@property (nonatomic, strong) UIImage *rightImage;


@property (nonatomic, strong) NSString *tip;
- (void)showTip;
- (void)hideTip;

- (void)addTargetForTipView:(id)target sel:(SEL)sel;
@end
