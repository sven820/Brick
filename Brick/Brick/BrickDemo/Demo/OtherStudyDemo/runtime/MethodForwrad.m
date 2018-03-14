//
//  MethodForwrad.m
//  Brick
//
//  Created by 靳小飞 on 2018/2/23.
//  Copyright © 2018年 jinxiaofei. All rights reserved.
//

#import "MethodForwrad.h"
#import <objc/runtime.h>

@interface ForwardTarget : NSObject
@end
@implementation ForwardTarget
- (void)notRealizeMethod
{
    NSLog(@"ForwardTarget realize method");
}
@end

@interface MethodForwrad ()
- (void)notRealizeMethod;
- (void)notRealizeMethod_two:(NSString *)two;
@end

@implementation MethodForwrad
- (void)methodForward
{
    [self notRealizeMethod];
//    [self notRealizeMethod_two:@"two"];
    
    
//    [self testParams:@"p1" addMoreParams:@"p2", @"p3", @"p4",@"p5", nil];
//    simple_va_fun(1, 2, 3, 4, -1);
}

/*当 Runtime 系统在 Cache 和类的方法列表(包括父类)中找不到要执行的方法时，Runtime 会调用 resolveInstanceMethod: 或 resolveClassMethod: 来给我们一次动态添加方法实现的机会。我们需要用 class_addMethod 函数完成向特定类添加特定方法实现的操作*/
void handleForNoneRealizeMethod(id self, SEL _cmd, NSString *t){
    NSLog(@"不转发func: %@, para: %@", NSStringFromSelector(_cmd), t);
}
+ (BOOL)resolveClassMethod:(SEL)sel
{
    return [super resolveClassMethod:sel];
}
+ (BOOL)resolveInstanceMethod:(SEL)sel
{
    //return yes,则不继续转发处理，立刻处理消息，return no 继续转发消息
#warning 如何自动匹配参数
    if (sel == @selector(notRealizeMethod_two:)) {
        class_addMethod([self class], sel, (IMP)handleForNoneRealizeMethod, "v@:@");
        return YES;
    }else{
        return NO;
    }
    
//    return [super resolveInstanceMethod:sel];
}
//重定向消息
- (id)forwardingTargetForSelector:(SEL)aSelector
{
    return nil;
    //消息转发机制执行前，Runtime 系统允许我们替换消息的接收者为其他对象。通过 - (id)forwardingTargetForSelector:(SEL)aSelector 方法。
    if (aSelector == @selector(notRealizeMethod)) {
//        return [ForwardTarget new];
        
        //如果此方法返回 nil 或者 self，则会计入消息转发机制(forwardInvocation:)，否则将向返回的对象重新发送消息。
        return nil;
    }
    return [super forwardingTargetForSelector:aSelector];
}
//转发
- (void)forwardInvocation:(NSInvocation *)anInvocation
{
    //当动态方法解析不做处理返回 NO 时，则会触发消息转发机制。这时 forwardInvocation: 方法会被执行，我们可以重写这个方法来自定义我们的转发逻辑：
    //需要和methodSignatureForSelector一起重写
    NSLog(@"do forwardInvocation");
    return;
    ForwardTarget *t = [ForwardTarget new];
    if ([t respondsToSelector:[anInvocation selector]]) {
        [anInvocation invokeWithTarget:t];
    }else{
        [super forwardInvocation:anInvocation];
    }
}
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
    ForwardTarget *t = [ForwardTarget new];
    if ([t respondsToSelector:aSelector]) {
        return [t methodSignatureForSelector:aSelector];
    }else{
        return [super methodSignatureForSelector:aSelector];
    }
}
#pragma mark - 定义可变长参数
#warning 可变长参数参数类型可不可以不同， 还没弄明白
/*iOS实现传递不定长的多个参数的方法是使用va_list。va_list是C语言提供的处理变长参数的一种方法。在调用的时候要在参 数结尾的时候加nil
 va_list的使用需要注意:
 1.首先在函数里定义va_list型的变量，这个变量是指向参数的指针；
 2.然后用va_start初始化刚定义的va_list变量；
 3.然后用va_arg返回可变的参数，va_arg的第二个参数是你要返回的参数的类型.如果函数有多个可变参数的，依次调用va_arg获取各个参数；
 4.最后用va_end宏结束可变参数的获取
 
 NS_REQUIRES_NIL_TERMINATION，是一个宏，用于编译时非nil结尾的检查。 调用时要以nil结尾，否则会崩溃。
 
 */
- (void)testParams:(NSString *)title addMoreParams:(NSString *)string, ...NS_REQUIRES_NIL_TERMINATION {
    
    NSLog(@"传多个参数的第一个参数 %@",string);//是other1
    
    //1.定义一个指向个数可变的参数列表指针；
    va_list args;
    
    //2.va_start(args, str);string为第一个参数，也就是最右边的已知参数,这里就是获取第一个可选参数的地址.使参数列表指针指向函数参数列表中的第一个可选参数，函数参数列表中参数在内存中的顺序与函数声明时的顺序是一致的。
    va_start(args, string);
    
    if (string)
    {
        //依次取得除第一个参数以外的参数
        //4.va_arg(args,NSString)：返回参数列表中指针所指的参数，返回类型为NSString，并使参数指针指向参数列表中下一个参数。
        NSString *parm;
        do {
            parm = va_arg(args, NSString *);
            NSLog(@"otherString %@",parm);
        }while(parm);
    }
    //5.清空参数列表，并置参数指针args无效。
    va_end(args);
}
void simple_va_fun(int start, ...)
{
    va_list arg_ptr;
    int nArgValue =start;
    int nArgCout= 0;  //可变参数的数目
    va_start(arg_ptr,start);  //以固定参数的地址为起点确定变参的内存起始地址。
    do
    {
        ++nArgCout;
        printf("the %d th arg: %d \n",nArgCout,nArgValue); //输出各参数的值
        nArgValue = va_arg(arg_ptr,int);  //得到下一个可变参数的值
    } while(nArgValue != -1);//定义-1为结束符
    return;
}
@end
