//
//  BRURLManager.h
//  BrickKit
//
//  Created by jinxiaofei on 16/7/23.
//  Copyright © 2016年 JJ.sevn. All rights reserved.
//

#import "BRBaseManager.h"

typedef void(^CompleteOpenLoginBlock)(NSString *callBackUrl);
typedef void(^CompleteOtherHandler)(NSString *callBackStr, NSDictionary *userInfo);

@interface BRURLManager : BRBaseManager

/*
 *伪协议：XXXXXXX://somepage/{$id}
 *userInfo: 自定义字段，目前暂时用于java统计
 */

/**
 * 打开 url，处理处理 XXXXXXX:// 标识的自定义协议。
 * 如果打开 url 为 XXXXXXX://login 或 XXXXXXX://forcelogin 且未登录，则在进入登录页面，用户执行登录后回调 completeOpenLoginBlock 。
 * @param url 将打开的 url 字符串
 * @param completeOpenLoginBlock 如果打开 url 为 XXXXXXX://login 或 XXXXXXX://forcelogin 且未登录，则在进入登录页面，用户执行登录后回调 completeOpenLoginBlock
 * @return 如果成功处理则返回 YES, 否则返 NO.
 */
- (void)managerOpenUrl:(NSString *)url;

- (BOOL)managerOpenUrl:(NSURL *)url defatuleTitle:(NSString *)defaultTitle;

- (BOOL)managerOpenUrl:(NSURL *)url defatuleTitle:(NSString *)defaultTitle withCompleteOpenLoginBlock:(CompleteOpenLoginBlock)completeOpenLoginBlock;

- (BOOL)managerOpenUrl:(NSURL *)url defatuleTitle:(NSString *)defaultTitle userInfo:(NSDictionary *)userInfo withCompleteOpenLoginBlock:(CompleteOpenLoginBlock)completeOpenLoginBlock completeOtherHandler:(CompleteOtherHandler)completeHandler;



/*
 * 使用 webView 打开链接
 */
- (void)openWebView:(NSString *)value defaultTitle:(NSString *)defaultTitle;
@end
