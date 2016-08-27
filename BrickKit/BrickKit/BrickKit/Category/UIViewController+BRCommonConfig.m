//
//  UIViewController+BRCommonConfig.m
//  BrickKit
//
//  Created by jinxiaofei on 16/8/25.
//  Copyright © 2016年 jinxiaofei. All rights reserved.
//

#import "UIViewController+BRCommonConfig.h"
#import <objc/runtime.h>

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
    if ([self isKindOfClass:NSClassFromString(@"UIInputWindowController")])return;//UITextEffectsWindow
    
    self.view.backgroundColor = [UIColor whiteColor];
}
@end
