//
//  UIView+draw.h
//  BrickKit
//
//  Created by jinxiaofei on 16/6/28.
//  Copyright © 2016年 JJ.sevn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (draw)

+ (instancetype)drawLineWithWidth:(CGFloat)width;

+ (instancetype)drawLineWithWidth:(CGFloat)width color:(UIColor *)color;

+ (instancetype)drawLineWithWidth:(CGFloat)width height:(CGFloat)height color:(UIColor *)color;
@end
