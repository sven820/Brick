//
//  UIScrollView+JJExtension.h
//  TableViewInfinite
//
//  Created by jxf on 16/3/27.
//  Copyright © 2016年 JJ.sevn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (JJExtension)
@property (assign, nonatomic) CGFloat jj_insetT;
@property (assign, nonatomic) CGFloat jj_insetB;
@property (assign, nonatomic) CGFloat jj_insetL;
@property (assign, nonatomic) CGFloat jj_insetR;

@property (assign, nonatomic) CGFloat jj_offsetX;
@property (assign, nonatomic) CGFloat jj_offsetY;

@property (assign, nonatomic) CGFloat jj_contentW;
@property (assign, nonatomic) CGFloat jj_contentH;

@end
