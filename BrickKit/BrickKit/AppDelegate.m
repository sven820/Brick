//
//  AppDelegate.m
//  BrickKit
//
//  Created by jinxiaofei on 16/8/25.
//  Copyright © 2016年 jinxiaofei. All rights reserved.
//

#import "AppDelegate.h"
#import "BRDemoNavigationController.h"
#import "BrickDemoListViewController.h"
#import "BRDemoTabBarController.h"


@interface AppDelegate () <UISplitViewControllerDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor darkGrayColor];
    // 待优化
    self.window.rootViewController = [[BRDemoTabBarController alloc] init];
    [self.window makeKeyAndVisible];
    
    return YES;
}

#pragma mark - private methods
@end
