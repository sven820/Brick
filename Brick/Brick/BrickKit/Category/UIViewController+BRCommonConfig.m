//
//  UIViewController+BRCommonConfig.m
//  BrickKit
//
//  Created by jinxiaofei on 16/8/25.
//  Copyright © 2016年 jinxiaofei. All rights reserved.
//

#import "UIViewController+BRCommonConfig.h"
#import <objc/runtime.h>
#import "BRDemoTabBarController.h"

@implementation UIViewController (BRCommonConfig)
+ (void)load
{
    Method method1 = class_getInstanceMethod(self, @selector(br_viewDidLoad));
    Method method2 = class_getInstanceMethod(self, @selector(viewDidLoad));
    method_exchangeImplementations(method1, method2);
}

- (void)br_viewDidLoad
{
    [self br_viewDidLoad];
    
//    NSLog(@"-----%@", self);
#warning toTest for kinds of ios plateform
    if ([self isKindOfClass:NSClassFromString(@"UIInputWindowController")] ||
        [self isKindOfClass:NSClassFromString(@"UICompatibilityInputViewController")] ||
        [self isKindOfClass:NSClassFromString(@"UIAlertController")] ||
        [self isKindOfClass:NSClassFromString(@"UIApplicationRotationFollowingController")])
    {
        return;
    }
    self.view.backgroundColor = [UIColor whiteColor];
}
@end
