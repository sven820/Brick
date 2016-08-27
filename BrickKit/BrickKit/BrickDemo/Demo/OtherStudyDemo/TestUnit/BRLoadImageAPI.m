//
//  BRLoadImageAPI.m
//  BrickKit
//
//  Created by jinxiaofei on 16/8/24.
//  Copyright © 2016年 JJ.sevn. All rights reserved.
//

#import "BRLoadImageAPI.h"

@implementation BRLoadImageAPI

+ (void)loadImageSuccess:(void(^)(NSString *image, NSInteger statusCode))successBlock errBlock:(void(^)(NSString *errorMessage, NSInteger statusCode))errorBlock
{
    __block NSInteger res;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        res = arc4random_uniform(5);
    });
    
    if (res > 2)
    {
        successBlock(@"图片", 200);
    }
    else
    {
        errorBlock(@"错误", 500);
    }
    
}
@end
