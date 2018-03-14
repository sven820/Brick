//
//  NSDictionary+YXYDictionary.m
//  YXY
//
//  Created by jinxiaofei on 16/12/1.
//  Copyright © 2016年 Guangzhou TalkHunt Information Technology Co., Ltd. All rights reserved.
//

#import "NSObject+JsonHelp.h"

@implementation NSDictionary (JSONDictionary)
/*!
 * @brief 把格式化的JSON格式的字符串转换成字典
 * @param jsonString JSON格式的字符串
 * @return 返回字典
 */
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@ --- ori json: %@",err, jsonString);
        return nil;
    }
    return dic;
}
+ (NSDictionary *)dictionaryWithJsonData:(NSData *)jsonData
{
    if (jsonData == nil) {
        return nil;
    }
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@ ---",err);
        return nil;
    }
    return dic;
}
+ (NSString *)jsonStringWithDictionary:(NSDictionary *)dictionary option:(NSJSONWritingOptions)option
{
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary options:option error:&parseError];
    if (parseError) {
        NSLog(@"字典序列化失败 error:%@ dic:%@", parseError,dictionary);
        return nil;
    }
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}
@end


@implementation NSArray (JSONArray)
+ (NSArray *)arrayWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSArray *arr = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@ --- ori json: %@",err, jsonString);
        return nil;
    }
    return arr;
}
+ (NSArray *)arrayWithJsonData:(NSData *)jsonData
{
    if (jsonData == nil) {
        return nil;
    }
    NSError *err;
    NSArray *arr = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@ ---",err);
        return nil;
    }
    return arr;
}
+ (NSString *)jsonStringWithArray:(NSArray *)array option:(NSJSONWritingOptions)option
{
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:array options:option error:&parseError];
    if (parseError) {
        NSLog(@"数组序列化失败 error:%@ array:%@", parseError,array);
        return nil;
    }
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}
@end

@implementation NSSet (JSONSet)
+ (NSSet *)setWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSSet *set = [NSJSONSerialization JSONObjectWithData:jsonData
                                                   options:NSJSONReadingMutableContainers
                                                     error:&err];
    if(err) {
        NSLog(@"json解析失败：%@ --- ori json: %@",err, jsonString);
        return nil;
    }
    return set;
}
+ (NSSet *)setWithJsonData:(NSData *)jsonData
{
    if (jsonData == nil) {
        return nil;
    }
    NSError *err;
    NSSet *set = [NSJSONSerialization JSONObjectWithData:jsonData
                                                   options:NSJSONReadingMutableContainers
                                                     error:&err];
    if(err) {
        NSLog(@"json解析失败：%@ ---",err);
        return nil;
    }
    return set;
}
+ (NSString *)jsonStringWithSet:(NSSet *)set option:(NSJSONWritingOptions)option
{
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:set options:option error:&parseError];
    if (parseError) {
        NSLog(@"Set 数组序列化失败 error:%@ set:%@", parseError,set);
        return nil;
    }
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}
@end
