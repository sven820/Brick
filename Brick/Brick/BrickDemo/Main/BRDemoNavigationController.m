//
//  BRDemoNavigationController.m
//  BrickKit
//
//  Created by jinxiaofei on 16/6/28.
//  Copyright © 2016年 JJ.sevn. All rights reserved.
//

#import "BRDemoNavigationController.h"

@implementation BRDemoNavigationController

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.childViewControllers.count > 0) {
        
        viewController.hidesBottomBarWhenPushed = YES;
        
       
    }
    [super pushViewController:viewController animated:animated];

}
@end
