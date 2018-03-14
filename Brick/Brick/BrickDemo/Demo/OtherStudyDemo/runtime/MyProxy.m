//
//  MyProxy.m
//  Brick
//
//  Created by 靳小飞 on 2018/2/22.
//  Copyright © 2018年 jinxiaofei. All rights reserved.
//

#import "MyProxy.h"

@implementation Cat
- (void)grabMouse
{
    NSLog(@"cat grab mouse");
}
@end

@implementation Dog
- (void)defend
{
    NSLog(@"dog defend");
}
@end


//Myproxy
@interface MyProxy ()
{
    NSMutableArray * _proxys;
}
@end

@implementation MyProxy
+ (instancetype)proxy
{
    return [[self alloc] init];
}
- (instancetype)init
{
    Cat *cat = [Cat new];
    Dog *dog = [Dog new];
    _proxys = [NSMutableArray array];
    [_proxys addObject:dog];
    [_proxys addObject:cat];
    
    return self;
}
- (void)forwardInvocation:(NSInvocation *)invocation
{
    for (id proxyObj in _proxys) {
        if ([proxyObj respondsToSelector:invocation.selector]) {
            [invocation invokeWithTarget:proxyObj];
            return;
        }
    }
    return [super forwardInvocation:invocation];
}
- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel
{
    for (id proxyObj in _proxys) {
        if ([proxyObj respondsToSelector:sel]) {
            return [proxyObj methodSignatureForSelector:sel];
        }
    }
    return [super methodSignatureForSelector:sel];
}
@end



//Duckproxy
@interface DuckProxy : NSProxy <InjectProtocol>
{
    NSMutableDictionary * _impls;
}
+ (instancetype)proxy;
@end
id injectProxyCreate()
{
    return [DuckProxy proxy];
}
@implementation DuckProxy
+ (instancetype)proxy
{
    return [[self alloc] init];
}
- (instancetype)init
{
    _impls = [NSMutableDictionary dictionary];
    return self;
}
- (void)injectDependencyObject:(id)object forProtocol:(Protocol *)protocol
{
    NSParameterAssert(object && protocol);
    NSAssert([object conformsToProtocol:protocol], @"obj %@ dose not conform to protocol %@", object, protocol);
    _impls[NSStringFromProtocol(protocol)] = object;
}
- (void)removeInjectForProtocol:(Protocol *)protocol
{
    [_impls removeObjectForKey:NSStringFromProtocol(protocol)];
}
- (void)forwardInvocation:(NSInvocation *)invocation
{
    for (id object in _impls.allValues) {
        if ([object respondsToSelector:invocation.selector]) {
            [invocation invokeWithTarget:object];
            return;
        }
    }
    [super forwardInvocation:invocation];
}
- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel
{
    for (id object in _impls.allValues) {
        if ([object respondsToSelector:sel]) {
            return [object methodSignatureForSelector:sel];
        }
    }
    return [super methodSignatureForSelector:sel];
}
@end

@implementation Myobj
@end
