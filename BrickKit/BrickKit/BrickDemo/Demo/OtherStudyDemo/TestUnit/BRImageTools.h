//
//  BRImageTools.h
//  BrickKit
//
//  Created by jinxiaofei on 16/8/24.
//  Copyright © 2016年 JJ.sevn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BRImageTools : NSObject

+ (instancetype)shareTools;


- (NSString *)dealImage:(NSString *)image;//处理图片

+ (NSString *)dealImage:(NSString *)image;//作参照, 同名类方法怎么stub

@end
