//
//  BRTitleView.h
//  BrickKit
//
//  Created by jinxiaofei on 16/7/6.
//  Copyright © 2016年 JJ.sevn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BRTitleView : UIView
+ (instancetype)createTitleViewWithWidth:(CGFloat)width itemWidth:(CGFloat)itemWidth andContents:(NSArray<NSString *> *)contents canScroll:(BOOL)canScroll;
@end
