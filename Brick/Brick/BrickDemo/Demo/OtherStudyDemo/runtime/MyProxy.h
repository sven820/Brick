//
//  MyProxy.h
//  Brick
//
//  Created by 靳小飞 on 2018/2/22.
//  Copyright © 2018年 jinxiaofei. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MyProxyForCat <NSObject>
- (void)grabMouse;
@end
@protocol MyProxyForDog <NSObject>
- (void)defend;
@end

@interface Cat : NSObject <MyProxyForCat>
@end
@interface Dog : NSObject <MyProxyForDog>
@end
/**
 *  NSProxy
 *
 *  主要作用就是做代理，用来消息转发，比如实现一个伪多继承, 鸭子类型, 依赖注入等模式
 */

//伪多继承
@interface MyProxy : NSProxy <MyProxyForCat, MyProxyForDog>
+ (instancetype)proxy;
@end

//鸭子类型 | 依赖注入
@protocol InjectProtocol <NSObject>
- (void)injectDependencyObject:(id)object forProtocol:(Protocol *)protocol;
- (void)removeInjectForProtocol:(Protocol *)protocol;
@end
extern id injectProxyCreate();

@interface Myobj : NSObject
@end

