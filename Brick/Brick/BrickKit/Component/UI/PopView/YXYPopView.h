//
//  YXYPopView.h
//  YXY
//
//  Created by jinxiaofei on 16/9/27.
//  Copyright © 2016年 Guangzhou TalkHunt Information Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YXYPopView : UIView
@property (nonatomic, strong) UIImage *popImage;

@property (nonatomic, assign, setter=setCount:) NSInteger count;
@property (nonatomic, strong, setter=setTitle:) NSString *title;
@property (nonatomic, strong, setter=setSubTitle:) NSString *subTitle;
@property (nonatomic, strong, setter=setSubImage:) UIImage *subImage;

- (void)addTargetForPop:(id)target action:(SEL)sel controlEvents:(UIControlEvents)events;
- (void)addTargetForSubAera:(id)target action:(SEL)sel controlEvents:(UIControlEvents)events;
@end
