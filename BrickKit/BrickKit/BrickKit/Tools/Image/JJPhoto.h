//
//  JJPhoto.h
//  JJBaiSiBuDeJie
//
//  Created by jxf on 16/2/20.
//  Copyright © 2016年 JJ.sevn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JJPhoto : NSObject

+ (void)saveImage:(UIImage *)image errorBlock:(void(^)())errorOperation andSuccessBlock:(void(^)())successOperation;

@end