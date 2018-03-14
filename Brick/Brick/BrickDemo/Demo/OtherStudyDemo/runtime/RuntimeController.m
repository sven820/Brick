//
//  RuntimeController.m
//  Brick
//
//  Created by 靳小飞 on 2018/2/22.
//  Copyright © 2018年 jinxiaofei. All rights reserved.
//

#import "RuntimeController.h"
#import "RuntimeObj.h"
#import "AutoCodingObj.h"
#import "MethodForwrad.h"


@interface Myobj ()
@property (nonatomic, strong) NSString *testDesc;
- (void)testExtension;
@end


@interface RuntimeController ()

@end

@implementation RuntimeController

/**
 *  runtime
 *
 *  Runtime 又叫运行时，是一套底层的 C 语言 API，其为 iOS 内部的核心之一，我们平时编写的 OC 代码，底层都是基于它来实现的
 *  Objc 在三种层面上与 Runtime 系统进行交互：
         通过 Objective-C 源代码
         通过 Foundation 框架的 NSObject 类定义的方法
         通过对 Runtime 库函数的直接调用
 *  术语
        SEL 它是selector在 Objc 中的表示(Swift 中是 Selector 类)。selector 是方法选择器，其实作用就和名字一样
                typedef struct objc_selector *SEL;
        id 是一个参数类型，它是指向某个类的实例的指针。定义如下：
                typedef struct objc_object *id;
                struct objc_object { Class isa; }; //isa 指针在代码运行时并不总指向实例对象所属的类型，所以不能依靠它来确定类型，要想确定类型还是需要用对象的 -class 方法,KVO 的实现机理就是将被观察对象的 isa 指针指向一个中间类而不是真实类型
        Class
                typedef struct objc_class *Class;Class 其实是指向 objc_class 结构体的指针
                 struct objc_class {
                     Class isa  OBJC_ISA_AVAILABILITY;
 
                     #if !__OBJC2__
                     Class super_class                                        OBJC2_UNAVAILABLE;
                     const char *name                                         OBJC2_UNAVAILABLE;
                     long version                                             OBJC2_UNAVAILABLE;
                     long info                                                OBJC2_UNAVAILABLE;
                     long instance_size                                       OBJC2_UNAVAILABLE;
                     struct objc_ivar_list *ivars                             OBJC2_UNAVAILABLE;
                     struct objc_method_list **methodLists                    OBJC2_UNAVAILABLE;
                     struct objc_cache *cache                                 OBJC2_UNAVAILABLE;
                     struct objc_protocol_list *protocols                     OBJC2_UNAVAILABLE;
                     #endif
                 } OBJC2_UNAVAILABLE;
                 注:extension（编译期决议） 和 category（运行期决议的）
                        extension在编译期决议，它就是类的一部分，在编译期和头文件里的@interface以及实现文件里的@implement一起形成一个完整的类，它伴随类的产生而产生，亦随之一起消亡。
                        category和extension的区别来看，我们可以推导出一个明显的事实，extension可以添加实例变量，而category是无法添加实例变量的（因为在运行期，对象的内存布局已经确定，如果添加实例变量就会破坏类的内部布局，这对编译型语言来说是灾难性的）
         Method 代表类中某个方法的类型
             typedef struct objc_method *Method;
 
                 struct objc_method {
                 SEL method_name                                          OBJC2_UNAVAILABLE;
                 char *method_types                                       OBJC2_UNAVAILABLE;
                 IMP method_imp                                           OBJC2_UNAVAILABLE;
             }

         Ivar 是表示成员变量的类型。
 
             typedef struct objc_ivar *Ivar;
 
                 struct objc_ivar {
                 char *ivar_name                                          OBJC2_UNAVAILABLE;
                 char *ivar_type                                          OBJC2_UNAVAILABLE;
                 int ivar_offset                                          OBJC2_UNAVAILABLE;
                 #ifdef __LP64__
                 int space                                                OBJC2_UNAVAILABLE;
                 #endif
             }
             其中 ivar_offset 是基地址偏移字节
         IMP
             IMP在objc.h中的定义是：
 
             typedef id (*IMP)(id, SEL, ...);
             它就是一个函数指针，这是由编译器生成的。当你发起一个 ObjC 消息之后，最终它会执行的那段代码，就是由这个函数指针指定的。而 IMP 这个函数指针就指向了这个方法的实现。
         Cache
         Cache 定义如下：
 
             typedef struct objc_cache *Cache
 
         Property
             typedef struct objc_property *Property;
             typedef struct objc_property *objc_property_t;//这个更常用
             可以通过class_copyPropertyList 和 protocol_copyPropertyList 方法获取类和协议中的属性：
 
             objc_property_t *class_copyPropertyList(Class cls, unsigned int *outCount)
             objc_property_t *protocol_copyPropertyList(Protocol *proto, unsigned int *outCount)
 
             struct objc_cache {
                unsigned int mask                                       OBJC2_UNAVAILABLE; //total = mask + 1
                unsigned int occupied                                    OBJC2_UNAVAILABLE;
                Method buckets[1]                                        OBJC2_UNAVAILABLE;
            };
            Cache 为方法调用的性能进行优化，每当实例对象接收到一个消息时，它不会直接在 isa 指针指向的类的方法列表中遍历查找能够响应的方法，因为每次都要查找效率太低了，而是优先在 Cache 中查找。

            Runtime 系统会把被调用的方法存到 Cache 中，如果一个方法被调用，那么它有可能今后还会被调用，下次查找的时候就会效率更高。就像计算机组成原理中 CPU 绕过主存先访问 Cache 一样。
 */

typedef struct {
    int no;
    char *name;
}City;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self testRunTime];
}
//runtime
- (void)testRunTime
{
    RuntimeObj *obj = [RuntimeObj new];
    SuperObj *super_obj = [SuperObj new];
    
    obj.name = @"obj";
    obj.desc = @"desc";
    //分类属性绑定
    obj.title = @"title";
//    NSLog(@"category get title: %@", obj.title);
    //method exchange | hook
//    [obj oriMethod];
    //
//    [obj getPropertyList];
    //
//    [obj getIvarList];
    //
//    [obj getProtocolList];
    //
//    [obj getInstanceMethodList];
    //
//    [obj getClassMethodList];
    //
//    [obj replaceMethod];
    //
//    [obj addMethod];
    //
//    [obj addProperty];
    //
//    [obj editIvar];
    //swizzle
//    [obj superFunc];
//    [super_obj superFunc];
    
    //coding | JSONExtension
    /*
     AutoCodingObj *codingObj = [AutoCodingObj new];
     codingObj.name = @"coding_obj";
     codingObj.addr = @"coding";
     NSData *codingData = [NSKeyedArchiver archivedDataWithRootObject:codingObj];
     NSLog(@"codingData: %@", codingData);
     AutoCodingObj *decodeCodingObj = [NSKeyedUnarchiver unarchiveObjectWithData:codingData];
     NSLog(@"decodeCodingObj: %@", decodeCodingObj);
     */
    
    //method forward
    MethodForwrad *forward = [MethodForwrad new];
    [forward methodForward];
}
//伪多继承
- (void)testMyProxy
{
    MyProxy *p = [MyProxy proxy];
    [p grabMouse];
    [p defend];
}
//注入
- (void)testInjectProxy
{
    Cat *c = [Cat new];
    Dog *d = [Dog new];
    
    id<InjectProtocol, MyProxyForCat, MyProxyForDog> p = injectProxyCreate();
    [p injectDependencyObject:c forProtocol:@protocol(MyProxyForCat)];
    [p injectDependencyObject:d forProtocol:@protocol(MyProxyForDog)];
    
    [p grabMouse];
    [p defend];
}
- (void)testExtension
{
    /*extension一般用来隐藏类的私有信息，你必须有一个类的源码才能为一个类添加extension，所以你无法为系统的类比如NSString添加extension。*/
    Myobj *obj = [Myobj new];
    [obj testExtension];
    obj.testDesc = @"testDesc";
    NSLog(@"%@", obj.testDesc);
}
- (void)testPointer
{
    City c = {};
    c.no = 1;
    c.name = "guangzhou";
    
    City *p = &c;
    City cc = *p;
    
    City **pp = &p;
    City *s = *pp;
    City ccc = *s;
    City cccc = **pp;
    
    NSLog(@"p:%p, no:%d, name:%s",p, p->no, p->name);
}
@end

@implementation Myobj (Extension)
- (void)testExtension
{
    NSLog(@"Myobj testExtension");
}
- (void)setTestDesc:(NSString *)testDesc
{
    NSLog(@"setTestDesc %@", testDesc);
}
@end
