//
//  BrickKitDefine.h
//  BrickKit
//
//  Created by jinxiaofei on 16/6/20.
//  Copyright © 2016年 JJ.sevn. All rights reserved.
//

#ifndef BrickKitDefine_h
#define BrickKitDefine_h

#pragma mark - define field
/**
 *  开发环境配置 begin
 */

//#warning 需要手动更改的环境配置
/**
 *  需要手动更改的配置(发布正式环境包时要全部注释) begin
 */

//#define BrickDevelop // 开发环境
//#define BrickTest // 测试环境
//#define BrickCloud // 云环境
//#define BrickDebug // 可在多环境中切换， 默认为测试环境
#define BrickShowLog // 线上环境（带Log） !! 内部测试用。 这个只是log的开关，测试的时候建议打开!!! 上线的时候，请关闭!!
#define BrickCanDebugger // 是否允许调试，默认允许，上线时不能允许调试，请注释本行代码！！！

// 需要手动更改的配置 end

#ifdef YCFShowLog

#else
    // 禁止log
//    #define NSLog(...);
    #undef DEBUG
#endif // end YCFShowLog

#pragma mark - 各接口环境配置
#pragma mark - 开发环境
#pragma mark - 测试环境
#pragma mark - 云环境
#pragma mark - 线上环境

#pragma mark - 配置文件
//是否需要header签名开关，默认1为开启,0为关闭

#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)

//判断是否为iPhone
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)

//判断是否为iPad
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

//判断是否为ipod
#define IS_IPOD ([[[UIDevice currentDevice] model] isEqualToString:@"iPod touch"])

#define ios92 ([[[UIDevice currentDevice] systemVersion] doubleValue]>=9.2f)
#define ios9 ([[[UIDevice currentDevice] systemVersion]doubleValue]>=9.0f)
#define ios8 ([[[UIDevice currentDevice] systemVersion]doubleValue]>=8.0f)
#define ios7 ([[[UIDevice currentDevice] systemVersion]doubleValue]>=7.0f && [[[UIDevice currentDevice] systemVersion]doubleValue]<8.0f)

// 是否高清屏
#define isRetina ([[UIScreen mainScreen] scale] > 1.0f)

// 资源文件
/** warning edit for yourself*/
#define YCFKitBundle [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"yourBundleName" ofType:@"bundle"]]

#define de_appStoreUrl  @"http://itunes.apple.com/us/app/yao-chu-fa-lu-xing/id509256354?ls=1&mt=8"
#define de_commentsAppStoreUrl @"itms-apps://itunes.apple.com/app/id509256354"

//屏幕的宽（point）
#define kSCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define kSCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)


// 全局导航栈
#define YCFGlobalTabbarViewCtrl (((AppDelegate *)[UIApplication sharedApplication].delegate).tabbarVC)
#define YCFGlobalNavigationCtrl ([YCFGlobalTabbarViewCtrl nav])
#define TABBAR_HEIGHT 49


#define MM_VersionNum [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
#define MM_VersionStr [NSString stringWithFormat:@"system=ios&version=%@",MM_VersionNum]
#define kSystem @"ios" // 区分是ios还是android系统
#define kSystemVerion ([[UIDevice currentDevice] systemVersion])
#define kItemsPerPage 10 // 每页10条
#define kItemsPerPageForSort 20 // 每页20条记录，因为android是按照20条每页请求的，并且，分类排序时，页长不一样，排序的结果也不一样。总之，一句话：要适配android的。!!!

#endif /* BrickKitDefine_h */