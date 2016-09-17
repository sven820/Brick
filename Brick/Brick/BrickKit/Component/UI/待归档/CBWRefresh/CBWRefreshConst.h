//
//  CBWRefreshConst.h
//  CBWRefresh
//
//  Created by 陈博文 on 16/5/30.
//  Copyright © 2016年 陈博文. All rights reserved.
//

#import <Foundation/Foundation.h>

FOUNDATION_EXTERN float const headerHeight;
FOUNDATION_EXTERN float const footerHeight;
FOUNDATION_EXTERN float const fontSize;
FOUNDATION_EXTERN float const CBWRefreshFastAnimationDuration;

FOUNDATION_EXTERN NSString *scrollViewContentSizeKeyPath;
FOUNDATION_EXTERN NSString *scrollViewContentOffsetKeyPath;
FOUNDATION_EXTERN NSString *scrollViewPanStateKeyPath;

FOUNDATION_EXTERN NSString *CBWRefreshHeaderTimeKey;

// 运行时objc_msgSend
#define CBWRefreshMsgSend(...) ((void (*)(void *, SEL, UIView *))objc_msgSend)(__VA_ARGS__)
#define CBWRefreshMsgTarget(target) (__bridge void *)(target)

// 图片路径
#define CBWRefreshSrcName(file) [@"CBWRefresh.bundle" stringByAppendingPathComponent:file]
#define CBWRefreshFrameworkSrcName(file) [@"Frameworks/CBWRefresh.framework/CBWRefresh.bundle" stringByAppendingPathComponent:file]




