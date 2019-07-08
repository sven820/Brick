//
//  ZXRemoteNavgationController.m
//  ZXUserNotifications
//
//  Created by 靳小飞 on 2019/6/26.
//  Copyright © 2019 知学科技. All rights reserved.
//

#import "ZXRemoteNavgationController.h"

@interface ZXRemoteNavgationController ()

@end

@implementation ZXRemoteNavgationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
    UIViewController *popedVc = [super popViewControllerAnimated:animated];
    if (!popedVc) { //root pop不了了，dismiss掉
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    return popedVc;
}

//路由页面想pop rootvc 满足不了，直接dismiss
- (NSArray<UIViewController *> *)popToRootViewControllerAnimated:(BOOL)animated {
    [self dismissViewControllerAnimated:YES completion:nil];
    return [super popToRootViewControllerAnimated:animated];
}

//满足不了，直接dismiss
- (NSArray<UIViewController *> *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [self dismissViewControllerAnimated:YES completion:nil];
    return [super popToRootViewControllerAnimated:animated];;
}

static BOOL tryPushingViewController(UIViewController *viewController, UIViewController *candidateViewController) {
    UINavigationController *navigationController = nil;
    if ([candidateViewController isKindOfClass:[UINavigationController class]]) {
        navigationController = (UINavigationController *)candidateViewController;
    } else if (candidateViewController.navigationController) {
        navigationController = candidateViewController.navigationController;
    }
    
    if (navigationController) {
        [navigationController pushViewController:viewController animated:YES];
        return YES;
    }else {
        [candidateViewController presentViewController:[[ZXRemoteNavgationController alloc]initWithRootViewController:viewController] animated: YES completion:nil];
        return YES;
    }
    return NO;
}

- (void)pushViewController:(UIViewController *)viewController {
    UIViewController *mainViewController = self.mainViewController;
    if (!mainViewController || !viewController) {
        return;
    }
    
    if (tryPushingViewController(viewController, mainViewController)) {
        return;
    }
    
    if ([mainViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabBarController = (UITabBarController *)mainViewController;
        UIViewController *selectedViewController = tabBarController.viewControllers[tabBarController.selectedIndex];
        tryPushingViewController(viewController, selectedViewController);
    }
}
- (UIViewController *)mainViewController {
    return [self getTopVc];
}
- (UIViewController *)getTopVc {
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *topVC = appRootVC;
    UIViewController *currentVC = nil;
    if (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
        currentVC = topVC;
        if ([topVC.childViewControllers lastObject]) {
            currentVC = [topVC.childViewControllers lastObject];
        }
    } else {
        currentVC = [self getCurrentVC];
    }
    return currentVC;
}
//获取当前屏幕显示的viewcontroller
- (UIViewController *)getCurrentVC {
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal) {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows) {
            if (tmpWin.windowLevel == UIWindowLevelNormal) {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]]) {
        result = nextResponder;
    } else {
        result = window.rootViewController;
    }
    
    return result;
}
//获取当前屏幕显示的viewcontroller
- (UIViewController *)getTopVc {
    UIViewController* vc = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (1) {
        if ([vc isKindOfClass:[UITabBarController class]]) {
            vc = ((UITabBarController*)vc).selectedViewController;
        }
        if ([vc isKindOfClass:[UINavigationController class]]) {
            vc = ((UINavigationController*)vc).visibleViewController;
        }
        if (vc.presentedViewController) {
            vc = vc.presentedViewController;
        }else{
            break;
        }
    }
    return vc;
}
//iOS获取顶层的控制器

- (UIViewController *)appRootViewController

{
    
    UIViewController *RootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    UIViewController *topVC = RootVC;
    
    while (topVC.presentedViewController) {
        
        topVC = topVC.presentedViewController;
        
    }
    
    return topVC;
@end
