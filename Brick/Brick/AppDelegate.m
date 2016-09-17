//
//  AppDelegate.m
//  weexDemo
//
//  Created by jinxiaofei on 16/8/18.
//  Copyright © 2016年 jinxiaofei. All rights reserved.
//

#import "AppDelegate.h"
#import "BRDemoTabBarController.h"

@interface AppDelegate () <UISplitViewControllerDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor lightGrayColor];
    BRDemoTabBarController *rootVc = [[BRDemoTabBarController alloc] init];
   
    self.window.rootViewController = rootVc;
    [self.window makeKeyAndVisible];

    
    return YES;
}

@end
