//
//  UIScrollView+CBWFrame.h
//  CBWRefresh
//
//  Created by 陈博文 on 16/5/30.
//  Copyright © 2016年 陈博文. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (CBWFrame)

/** 顶部*/
@property (assign, nonatomic) CGFloat insetT;
/** 底部*/
@property (assign, nonatomic) CGFloat insetB;
/** 左部*/
@property (assign, nonatomic) CGFloat insetL;
/** 右部*/
@property (assign, nonatomic) CGFloat insetR;

@property (assign, nonatomic) CGFloat offsetX;
@property (assign, nonatomic) CGFloat offsetY;

@property (assign, nonatomic) CGFloat contentW;
@property (assign, nonatomic) CGFloat contentH;

@end
