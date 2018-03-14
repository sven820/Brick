//
//  RuntimeObj.h
//  Brick
//
//  Created by 靳小飞 on 2018/2/22.
//  Copyright © 2018年 jinxiaofei. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol TestProtocol_super <NSObject>
@property (nonatomic, strong) NSString *superp;
- (void)test;
@end
@protocol TestProtocol_one <TestProtocol_super>
@property (nonatomic, strong) NSString *one;
- (void)test;
@end
@protocol TestProtocol_two <TestProtocol_super>
@property (nonatomic, strong) NSString *two;
- (void)test;
@end

@interface SuperObj : NSObject <TestProtocol_super>
{
    NSString * _super_add;
}
@property (nonatomic, strong) NSString *superName;
- (void)superFunc;
+ (void)superClassFunc;
@end

@interface RuntimeObj : SuperObj <TestProtocol_one, TestProtocol_two>
{
    NSString * _add;
}
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *desc;

- (void)oriMethod;
+ (void)classFunc;
- (void)testMethod:(NSString *)p1 p2:(NSString *)p2;

- (void)getPropertyList;
- (void)getIvarList;
- (void)getProtocolList;
- (void)getInstanceMethodList;
- (void)getClassMethodList;
- (void)replaceMethod;
- (void)addMethod;
- (void)addProperty;
- (void)addIvar;
- (void)replacePorperty;
- (void)editIvar;
- (void)createClass;
@end
//categary
@interface RuntimeObj (Extension)
@property (nonatomic, strong) NSString *title;
@end


