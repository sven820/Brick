//
//  AutoCodingObj.m
//  Brick
//
//  Created by 靳小飞 on 2018/2/23.
//  Copyright © 2018年 jinxiaofei. All rights reserved.
//

#import "AutoCodingObj.h"
#import <objc/runtime.h>

@implementation SuperAutoCodingObj
@end

@interface AutoCodingObj () <NSCoding>
@property (nonatomic, assign) NSInteger num;
@end

@implementation AutoCodingObj

- (void)encodeWithCoder:(nonnull NSCoder *)aCoder {
    /*
     [aCoder encodeObject:self.superName forKey:@"supername"];
     [aCoder encodeObject:self.name forKey:@"name"];
     [aCoder encodeObject:self.addr forKey:@"addr"];
     [aCoder encodeInteger:self.num forKey:@"num"];
     */
    
    Class cls = self.class;
    BOOL exit = NO;
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
            //object_getIvar获取非对象value会crash
#warning test
            if ([key isEqualToString:@"_num"]) {
                ptrdiff_t offset = ivar_getOffset(ivar);
                unsigned char *stuffBytes = (unsigned char *)(__bridge void *)self;
                NSInteger value = * ((NSInteger *)(stuffBytes + offset));
                NSLog(@"ivar for non obj ======== %zd", value);
            }else{
                id value = object_getIvar(self, ivar);
                //            [aCoder encodeObject:value forKey:key];
            }
            
            //kvc 设值
            id value2 = [self valueForKey:key];
            if ([value2 isKindOfClass:[NSNumber class]]) {
                
            }else if([value2 isKindOfClass:[NSValue class]]){
                
            }else{
            }
            [aCoder encodeObject:value2 forKey:key];
            
        }
        free(ivars);
        
        cls = cls.superclass;
        if ([cls isEqual:[NSObject class]]) {
            exit = YES;
        }
    } while (!exit);
    
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        /*
         self.superName = [aDecoder decodeObjectForKey:@"supername"];
         self.name = [aDecoder decodeObjectForKey:@"name"];
         self.addr = [aDecoder decodeObjectForKey:@"addr"];
         self.num = [aDecoder decodeIntegerForKey:@"num"];
         */
        
        Class cls = self.class;
        BOOL exit = NO;
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
                id value = [aDecoder decodeObjectForKey:key];
                // object_setIvar 只作用于对象，非对象属性设值还没搞懂
                //            object_setIvar(self, ivar, value);
                //kvc赋值
                [self setValue:value forKey:key];
            }
            free(ivars);
            
            cls = cls.superclass;
            if ([cls isEqual:[NSObject class]]) {
                exit = YES;
            }
        } while (!exit);
    }
    return self;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.num = 10;
        self.superName = @"super _name";
    }
    return self;
}
- (NSString *)description
{
    return [NSString stringWithFormat:@"info:%@, %@, %@, %zd", self.superName, self.name, self.addr, self.num];
}
@end
