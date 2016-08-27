//
//  BRURLManager.m
//  BrickKit
//
//  Created by jinxiaofei on 16/7/23.
//  Copyright © 2016年 JJ.sevn. All rights reserved.
//

#import "BRURLManager.h"

@implementation BRURLManager

- (void)managerOpenUrl:(NSString *)url
{
    
}

- (BOOL)managerOpenUrl:(NSURL *)url defatuleTitle:(NSString *)defaultTitle
{
    return YES;
}

- (BOOL)managerOpenUrl:(NSURL *)url defatuleTitle:(NSString *)defaultTitle withCompleteOpenLoginBlock:(CompleteOpenLoginBlock)completeOpenLoginBlock
{
    return YES;
}

- (BOOL)managerOpenUrl:(NSURL *)url defatuleTitle:(NSString *)defaultTitle userInfo:(NSDictionary *)userInfo withCompleteOpenLoginBlock:(CompleteOpenLoginBlock)completeOpenLoginBlock completeOtherHandler:(CompleteOtherHandler)completeHandler
{
    return YES;
}

- (void)openWebView:(NSString *)value defaultTitle:(NSString *)defaultTitle
{
    
}
@end
