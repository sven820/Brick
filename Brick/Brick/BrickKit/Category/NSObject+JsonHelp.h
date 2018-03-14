//
//  NSDictionary+YXYDictionary.h
//  YXY
//
//  Created by jinxiaofei on 16/12/1.
//  Copyright © 2016年 Guangzhou TalkHunt Information Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (JSONDictionary)
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;
+ (NSDictionary *)dictionaryWithJsonData:(NSData *)jsonData;
+ (NSString *)jsonStringWithDictionary:(NSDictionary *)dictionary option:(NSJSONWritingOptions)option;

@end


@interface NSArray (JSONArray)
+ (NSArray *)arrayWithJsonString:(NSString *)jsonString;
+ (NSArray *)arrayWithJsonData:(NSData *)jsonData;
+ (NSString *)jsonStringWithArray:(NSArray *)array option:(NSJSONWritingOptions)option;
@end

@interface NSSet (JSONSet)
+ (NSSet *)setWithJsonString:(NSString *)jsonString;
+ (NSSet *)setWithJsonData:(NSData *)jsonData;
+ (NSString *)jsonStringWithSet:(NSSet *)set option:(NSJSONWritingOptions)option;
@end
