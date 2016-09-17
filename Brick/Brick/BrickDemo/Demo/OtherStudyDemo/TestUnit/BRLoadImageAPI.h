//
//  BRLoadImageAPI.h
//  BrickKit
//
//  Created by jinxiaofei on 16/8/24.
//  Copyright © 2016年 JJ.sevn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BRLoadImageAPI : NSObject

+ (void)loadImageSuccess:(void(^)(NSString *image, NSInteger statusCode))successBlock errBlock:(void(^)(NSString *errorMessage, NSInteger statusCode))errorBlock;
@end
