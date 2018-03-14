//
//  NSObject+JSONExtension.m
//  Brick
//
//  Created by 靳小飞 on 2018/2/23.
//  Copyright © 2018年 jinxiaofei. All rights reserved.
//

#import "NSObject+JSONExtension.h"
#import "NSObject+JsonHelp.h"
#import <objc/runtime.h>

@implementation NSObject (JSONExtension)
- (NSDictionary *)modelToJsonObject
{
    Class cls = self.class;
    BOOL exit = NO;
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    do {
        
        unsigned int count = 0;
        Ivar *ivars = class_copyIvarList(cls, &count);
        for (int i = 0; i<count; i++) {
            // 取出i位置对应的成员变量
            Ivar ivar = ivars[i];
            // 查看成员变量
            const char *name = ivar_getName(ivar);
            // 归档
            NSString *key = [NSString stringWithUTF8String:name];
            //kvc 设值
            id value = [self valueForKey:key];
            if ([value isKindOfClass:[NSDictionary class]]) //处理嵌套
            {
            }
            else if ([value isKindOfClass:[NSArray class]]) //处理嵌套
            {
                
            }
            else if ([value isKindOfClass:[NSSet class]]) //处理嵌套
            {
                
            }
            else if ([value isKindOfClass:[NSValue class]] ||
                     [value isKindOfClass:[NSString class]])
            {
                [dic setObject:value forKey:key];
            }
            else{
                //custom obj
                NSDictionary *t_dic = [value modelToJsonObject];
                [dic setObject:t_dic forKey:key];
            }
            
        }
        free(ivars);
        
        cls = cls.superclass;
        if ([cls isEqual:[NSObject class]]) {
            exit = YES;
        }
    } while (!exit);
    return dic;
}

//- (NSArray *)modelArrToArr:(NSArray *)models;
//
//- (NSString *)modelToJsonString;
//- (NSString *)modelArrToJsonString:(NSArray *)models;
//
//+ (instancetype)jsonStringToModel:(NSString *)jsonString;
//+ (NSArray *)jsonStringToModelArr:(NSString *)jsonString;
@end
