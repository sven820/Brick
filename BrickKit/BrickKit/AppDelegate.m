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

//weex
#import <WeexSDK/WeexSDK.h>
#import <WXDevtool/WXDevTool.h>
#import "WXEventModule.h"
#import "WXImgLoaderDefaultImpl.h"
#import "BRWXComponent.h"

@interface AppDelegate () <UISplitViewControllerDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor darkGrayColor];
    // 待优化
    self.window.rootViewController = [[BRDemoTabBarController alloc] init];
    [self.window makeKeyAndVisible];
    
    [self initWeex];
    
    return YES;
}

#pragma mark - private methods
- (void)initWeex
{
    //WXDevTool
    [WXDevTool setDebug:YES];//inspect, set NO
    [WXDevTool launchDevToolDebugWithUrl:@"ws://192.168.10.230:8088/debugProxy/native"];//打开的chorme地址, 安卓"ws://" + host + ":8088/debugProxy/native"
    
    //business configuration
    [WXAppConfiguration setAppGroup:@"AliApp"];
    [WXAppConfiguration setAppName:@"WeexDemo"];
    [WXAppConfiguration setAppVersion:@"1.0.0"];
    
    //init sdk enviroment
    [WXSDKEngine initSDKEnviroment];
    
    //注册图片加载代理, weex没有实现图片加载的相关实现, 而是通过协议方式丢给客户端实现, 因为客户端不同,图片加载的策略和框架不同, 这样增加扩展性, 减少依赖
    [WXSDKEngine registerHandler:[WXImgLoaderDefaultImpl new] withProtocol:@protocol(WXImgLoaderProtocol)];
    [WXSDKEngine registerHandler:[WXEventModule new] withProtocol:@protocol(WXEventModuleProtocol)];
    
    //注册时间监听的代理, 这里相当于一个桥
    [WXSDKEngine registerModule:@"event" withClass:[WXEventModule class]];
    
    //weex允许扩展组件, 如果想使用扩展的组件, 需要注册, 这样就能在.we文件中使用
    [WXSDKEngine registerComponent:@"xxxView" withClass:[BRWXComponent class]];
    
    //set debug
    [WXDebugTool setDebug:YES];
    [WXLog setLogLevel:WXLogLevelInfo];

}
@end
