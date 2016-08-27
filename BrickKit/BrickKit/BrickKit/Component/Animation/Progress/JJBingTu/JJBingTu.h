//
//  JJBingTu.h
//  饼图
//
//  Created by jxf on 15/12/8.
//  Copyright © 2015年 JJ.sevn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JJBingTu : UIView
@property(nonatomic, strong) NSDictionary * dict;
+ (instancetype)bingTu;
+ (instancetype)bingTuWithFrame:(CGRect)rect;
@end
