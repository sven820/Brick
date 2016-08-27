//
//  BRDemoTabBarController.m
//  BrickKit
//
//  Created by jinxiaofei on 16/6/28.
//  Copyright © 2016年 JJ.sevn. All rights reserved.
//

#import "BRDemoTabBarController.h"
#import "BRDemoNavigationController.h"
#import "BrickDemoListViewController.h"
#import "BRGodsOfHonour.h"
#import "BRStudyDemoViewController.h"

@implementation BRDemoTabBarController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addChildViewControllers];
}

- (void)addChildViewControllers
{
    BRStudyDemoViewController *studyVc = [[BRStudyDemoViewController alloc] init];
    studyVc.title = @"学习日志";
    [self addChildViewControllerWithViewController:studyVc];

    BrickDemoListViewController *demoVc = [[BrickDemoListViewController alloc] init];
    demoVc.title = @"砖头库";
    [self addChildViewControllerWithViewController:demoVc];
    
    BRGodsOfHonour *honourVc = [[BRGodsOfHonour alloc] init];
    honourVc.title = @"封神榜";
    [self addChildViewControllerWithViewController:honourVc];
}

- (void)addChildViewControllerWithViewController:(UIViewController *)controller
{
    BRDemoNavigationController *navVc = [[BRDemoNavigationController alloc] initWithRootViewController:controller];
    navVc.tabBarItem.title = controller.title;
    [self addChildViewController:navVc];
}
@end
