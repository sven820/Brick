//
//  JJStatusBarExtension.h
//  JJStatusBarExtension
//
//  Created by jxf on 16/2/22.
//  Copyright © 2016年 JJ.sevn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JJStatusBarExtension : UIWindow 

+ (void)showWithStatusBarClickBlock:(void (^)())block;

+ (void)scrollToTopInsideView:(UIView *)view;

@property(nonatomic, assign) CGFloat statusBarAnimationDuration;
// 单例
+ (instancetype)sharedStatusBarExtension;
@end

#pragma mark ------------------------------------------
#pragma mark UIViewController分类

@protocol UIViewControllerStatusBarExtension <NSObject>
@optional
- (BOOL)jj_ignoreStatusBar;
@end

@interface UIViewController (JJStatusBarExtension)<UIViewControllerStatusBarExtension>

@end

