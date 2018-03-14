//
//  NSObject+JSONExtension.h
//  Brick
//
//  Created by 靳小飞 on 2018/2/23.
//  Copyright © 2018年 jinxiaofei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (JSONExtension)
- (NSDictionary *)modelToDic;
- (NSArray *)modelArrToArr:(NSArray *)models;

- (NSString *)modelToJsonString;
- (NSString *)modelArrToJsonString:(NSArray *)models;

+ (instancetype)jsonStringToModel:(NSString *)jsonString;
+ (NSArray *)jsonStringToModelArr:(NSString *)jsonString;
@end
