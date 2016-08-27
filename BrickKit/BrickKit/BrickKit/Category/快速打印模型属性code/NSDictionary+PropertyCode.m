//
//  NSDictionary+PropertyCode.m
//  07-Runtime(字典转模型KVC实现)
//
//  Created by xmg on 16/1/11.
//  Copyright © 2016年 xiaomage. All rights reserved.
//

#import "NSDictionary+PropertyCode.h"

// isKindOfClass:判断下是否是当前类或者子类

@implementation NSDictionary (PropertyCode)
// 自动生成,解析字典去生成,有多少key,就有多少个属性
- (void)propertyCode
{
    NSMutableString *codes = [NSMutableString string];
    
    // 遍历字典中所有key
    [self enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull value, BOOL * _Nonnull stop) {
        
        NSString *code;
        
        if ([value isKindOfClass:NSClassFromString(@"__NSCFBoolean")]) {
            
            code  = [NSString stringWithFormat:@"@property (nonatomic, assign) BOOL %@;",key];
            
        } else if ([value isKindOfClass:[NSString class]]) {
            
            code  = [NSString stringWithFormat:@"@property (nonatomic, strong) NSString *%@;",key];
            
        } else if ([value isKindOfClass:[NSArray class]]) {
            
            code  = [NSString stringWithFormat:@"@property (nonatomic, strong) NSArray *%@;",key];
            
        } else if ([value isKindOfClass:[NSDictionary class]]) {
            
            code  = [NSString stringWithFormat:@"@property (nonatomic, strong) NSDictionary *%@;",key];
            
        } else if ([value isKindOfClass:[NSNumber class]]) {
            
            code  = [NSString stringWithFormat:@"@property (nonatomic, assign) NSInteger %@;",key];
            
        }
        
        // 生成一行属性代码 reposts_count:@property (nonatomic, assign) NSInteger reposts_count;
        
        [codes appendFormat:@"\n%@\n",code];
        
    }];
    
    NSLog(@"%@",codes);

}

@end
