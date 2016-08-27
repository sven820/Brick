/**
 * Created by Weex.
 * Copyright (c) 2016, Alibaba, Inc. All rights reserved.
 *
 * This source code is licensed under the Apache Licence 2.0.
 * For the full copyright and license information,please view the LICENSE file in the root directory of this source tree.
 */

#import "WXEventModule.h"
#import "BRWeexViewController.h"
#import <WeexSDK/WXBaseViewController.h>

@implementation WXEventModule

@synthesize weexInstance;

WX_EXPORT_METHOD(@selector(openURL:))

//js中产生交互事件, 会执行openURL:(意思执行对应的jsBundle中的js代码, url就是*.js的路径)
//js通过runTime则会打开native的openURL:, 本地转换和拼接好正确的*.js路径, 这样实现交互功能
- (void)openURL:(NSString *)url
{
    NSString *newURL = url;
    newURL = [newURL stringByReplacingOccurrencesOfString:@"//Users/examples/build/" withString:@"/bundlejs/"];
    //    newURL = [newURL stringByReplacingOccurrencesOfString:@"//var/examples/build/" withString:@"/bundlejs/"];
    
    newURL = [[[NSBundle mainBundle] bundlePath] stringByAppendingString:newURL];;
    UIViewController *controller = [[BRWeexViewController alloc] init];
    ((BRWeexViewController *)controller).url = newURL;
    
    [[weexInstance.viewController navigationController] pushViewController:controller animated:YES];
}

@end

