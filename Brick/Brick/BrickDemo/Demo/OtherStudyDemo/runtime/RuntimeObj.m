//
//  RuntimeObj.m
//  Brick
//
//  Created by 靳小飞 on 2018/2/22.
//  Copyright © 2018年 jinxiaofei. All rights reserved.
//

#import "RuntimeObj.h"
#import <objc/runtime.h>

@interface SuperObj ()
{
    NSString * _super_private_add;
}
@property (nonatomic, strong) NSString *private_superDetail;
@end
@implementation SuperObj
- (void)superFunc
{
    NSLog(@"%s", __func__);
}
+ (void)superClassFunc
{
    NSLog(@"%s", __func__);
}
- (void)test
{
    NSLog(@"%s", __func__);
}
@end

@interface RuntimeObj ()
{
    NSString * _private_add;
}
@property (nonatomic, strong) NSString *private_detail;
@end

@implementation RuntimeObj
+ (void)load
{
//    NSLog(@"%s", __func__);
//    [self simpleSwizzle];
    [self bestSwizzle];
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.private_detail = @"private_detail";
//        [self getPropertyList];
    }
    return self;
}
- (void)oriMethod
{
    NSLog(@"oriMethod");
}
+ (void)classFunc
{
    NSLog(@"%s", __func__);
}
- (void)testMethod:(NSString *)p1 p2:(NSString *)p2
{
    NSLog(@"%@----%@", p1, p2);
}
#pragma mark - get
- (void)getPropertyList
{
    //获取当前类的所有属性，包括私有属性和分类添加的属性，不包括父类属性
    //测试发现当当前类遵循协议时会有@[@"superclass", @"description", @"debugDescription", @"hash"]属性，应该是<NSObject>中的;
    unsigned int p_c = 0;
    objc_property_t *p_list = class_copyPropertyList(self.class, &p_c);
    NSArray *filter = @[@"superclass", @"description", @"debugDescription", @"hash"];
    for (unsigned int i = 0; i < p_c; i++) {
        //property
        objc_property_t property = p_list[i];
        NSString *name = [NSString stringWithUTF8String:property_getName(property)];
        //filter
        if ([filter containsObject:name]) {
            continue;
        }
        NSLog(@"property: %@", name);
        //property attribute
        /*
         各种符号对应类型，部分类型在新版SDK中有所变化，如long 和long long
         c char         C unsigned char
         i int          I unsigned int
         l long         L unsigned long
         s short        S unsigned short
         d double       D unsigned double
         f float        F unsigned float
         q long long    Q unsigned long long
         B BOOL
         @ 对象类型 //指针 对象类型 如NSString 是T@“NSString”
         64位下long 和long long 都是Tq
         */
        NSString * attr_name = [NSString stringWithUTF8String:property_getAttributes(property)];
        NSLog(@"property attr: %@", attr_name);
        /*
         objc_property_attribute_t的value和name
         
         常用attribute        name    value
         nonatomic           "N"    ""
         strong/retain       "&"    ""
         weak                "W"    ""
         属性的类型type        "T"    "@TypeName", eg"@\"NSString\""
         属性对应的实例变量Ivar  "V"    "Ivar_name", eg "_name"
         readonly            "R"    ""
         getter              "G"    "GetterName", eg"isRight"
         setter              "S"    "SetterName", eg"setName"
         assign/atomic       默认即为assign和retain
         */
        unsigned int pattr_c = 0;
        objc_property_attribute_t *pattr_list = property_copyAttributeList(property, &pattr_c);
        for (unsigned int i = 0; i < pattr_c; i++) {
            objc_property_attribute_t attr = pattr_list[i];
            NSLog(@"attr name:%s, value:%s", attr.name, attr.value);
        }
        free(pattr_list);
        NSLog(@"=================");
    }
    free(p_list);
}
- (void)getIvarList
{
    //获取当前类的所有成员变量，包括私有的，不包括父类，分类添加的属性不属于成员变量，但属于属性列表中
    unsigned int p_c = 0;
    Ivar *ivar_list = class_copyIvarList(self.class, &p_c);
    for (unsigned int i = 0; i < p_c; i++) {
        NSLog(@"Ivar name: %s, Ivar type:%s, Ivar offset:%td",
              ivar_getName(ivar_list[i]), ivar_getTypeEncoding(ivar_list[i]), ivar_getOffset(ivar_list[i]));
    }
    free(ivar_list);
}

- (void)getProtocolList
{
    unsigned int count = 0;
    __unsafe_unretained Protocol **protocol_list = class_copyProtocolList(self.class, &count);
    for (unsigned int i = 0; i < count; i++) {
        Protocol *p = protocol_list[i];
        //protocol name
        NSLog(@"protocol name:%s", protocol_getName(p));
        //protocol property
        objc_property_t property = protocol_getProperty(p, "one", YES, YES);
        if (property) {
            NSLog(@"protocol property name:%s", property_getName(property));
        }
        //protocol property list
        unsigned int property_count = 0;
        objc_property_t *property_list = protocol_copyPropertyList(p, &property_count);
        //objc_property_t *property_list2 = protocol_copyPropertyList2(p, &property_count, YES, YES);
        
        //protocol method list
        unsigned int method_count = 0;
        struct objc_method_description *method_list = protocol_copyMethodDescriptionList(p, YES, YES, &method_count);
        //adopted protocol
        unsigned int adopted_p_count = 0;
        __unsafe_unretained Protocol **adopted_p_list = protocol_copyProtocolList(p, &adopted_p_count);
        for (unsigned int j = 0; j < adopted_p_count; j++) {
            Protocol *adopted_p = adopted_p_list[j];
            NSLog(@"adopted protocol name:%s", protocol_getName(adopted_p));
        }
        
        NSLog(@"=================");
    }
    free(protocol_list);
    //unsigned int all_p_count = 0;
    //__unsafe_unretained Protocol **all_p_list = objc_copyProtocolList(&all_p_count);
}

- (void)getInstanceMethodList
{
    /*
     struct objc_method {
         SEL _Nonnull method_name                                 OBJC2_UNAVAILABLE;
         char * _Nullable method_types                            OBJC2_UNAVAILABLE;
         IMP _Nonnull method_imp                                  OBJC2_UNAVAILABLE;
     }
     */
    unsigned int instance_m_count = 0;
    Method *m_list = class_copyMethodList(self.class, &instance_m_count);
    
    //Method instance_method =  class_getInstanceMethod(self.class, NSSelectorFromString(@"getInstanceMethodList"));

    for (unsigned int i = 0; i < instance_m_count; i++) {
        Method m = m_list[i];
        NSLog(@"method name:%@ type:%s",
              NSStringFromSelector(method_getName(m)), method_getTypeEncoding(m));
        NSLog(@"=================");
    }
    free(m_list);
}

- (void)getClassMethodList
{
    unsigned int class_m_count = 0;
    Class metal_cls = objc_getMetaClass([NSStringFromClass(self.class) cStringUsingEncoding:NSUTF8StringEncoding]);
    Method *m_list = class_copyMethodList(metal_cls, &class_m_count);
    
    //Method class_method =  class_getClassMethod(self.class, NSSelectorFromString(@"classFunc"));

    for (unsigned int i = 0; i < class_m_count; i++) {
        Method m = m_list[i];
        NSLog(@"method name:%@ type:%s",
              NSStringFromSelector(method_getName(m)), method_getTypeEncoding(m));
        NSLog(@"=================");
    }
    free(m_list);
}
#pragma mark - edit
//
- (void)replaceMethod
{
    [self theReplacedOriMethod];

    Method m = class_getInstanceMethod(self.class, @selector(theReplacedMethod));
    class_replaceMethod(self.class, @selector(theReplacedOriMethod), method_getImplementation(m), method_getTypeEncoding(m));
    
    [self theReplacedOriMethod];
}
- (void)theReplacedMethod
{
    NSLog(@"我是被替换的方法");
}
- (void)theReplacedOriMethod
{
    NSLog(@"我是被替换之前的方法");
}
//
void theAddMethod(id self, SEL _cmd){
    NSLog(@"我是被添加的方法");
}
- (void)addMethod
{
    NSString *addSel = @"addsel";
    //符号含义：https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtTypeEncodings.html
    class_addMethod(self.class, NSSelectorFromString(addSel), (IMP)theAddMethod, "v@:");
    [self performSelector:NSSelectorFromString(addSel)];
}
- (void)addProperty
{
    unsigned int count = 5;
    objc_property_attribute_t *pattr_list[5];
    
    objc_property_attribute_t attr0 = {};
    pattr_list[0] = &attr0;
    
//    class_addProperty(self.class, "runtime_add_property", *pattr_list, count);
}
- (void)addIvar
{
//    class_addIvar(<#Class  _Nullable __unsafe_unretained cls#>, <#const char * _Nonnull name#>, <#size_t size#>, <#uint8_t alignment#>, <#const char * _Nullable types#>)
}
- (void)replacePorperty
{
//    class_replaceProperty(<#Class  _Nullable __unsafe_unretained cls#>, <#const char * _Nonnull name#>, <#const objc_property_attribute_t * _Nullable attributes#>, <#unsigned int attributeCount#>)    
}

//
- (void)editIvar
{
    Ivar ivar = class_getInstanceVariable(self.class, "_private_detail");
    id orivalue = object_getIvar(self, ivar);
    object_setIvar(self, ivar, @"private_detail_eidted");
    NSLog(@"orivalue:%@ edit ivar: %@",orivalue, self.private_detail);
}
- (void)createClass
{
    
}

//method swizzle
- (void)swizzleSuperFunc
{
    [self swizzleSuperFunc];
    NSLog(@"hooked super func");
}
/*
 - (void)superFunc
 {
 NSLog(@"sub rewrite super func");
 }
 */

+ (void)simpleSwizzle
{
    //可能的问题
    //当父类对象调用oriMethod时，因为父类并未实现swizzleSuperFunc，所以崩溃
    SEL oriSel = @selector(superFunc);
    SEL swizzleSel = @selector(swizzleSuperFunc);
    //会去父类找
    Method oriM = class_getInstanceMethod(self, oriSel);
    Method swizzleM = class_getInstanceMethod(self, swizzleSel);
    method_exchangeImplementations(oriM, swizzleM);
}
+ (void)bestSwizzle
{
    //解决了simple swizzle 问题，因为把父类superFunc的实现加到了子类里面了，父类对象调用superFunc时不会去调用swizzleSuperFunc
    //可能问题
    //当superFunc没有实现的时候（比如协议），则oriM为nil，则exchange则不会起作用，造成swizzleSuperFunc里自己调用自己，死循环
    SEL oriSel = @selector(superFunc);
    SEL swizzleSel = @selector(swizzleSuperFunc);
    Method oriM = class_getInstanceMethod(self, oriSel);
    Method swizzleM = class_getInstanceMethod(self, swizzleSel);
    if (!oriM) {
        //解决，oriM为nil时，用一个空实现method代替oriM完成替换
        class_addMethod(self, oriSel, method_getImplementation(swizzleM), method_getTypeEncoding(swizzleM));
        method_setImplementation(swizzleM, imp_implementationWithBlock(^(id self, SEL _cmd){ }));
    }
    BOOL didAddMethod = class_addMethod(self, oriSel, method_getImplementation(swizzleM), method_getTypeEncoding(swizzleM));
    if (didAddMethod) {
        class_replaceMethod(self, swizzleSel, method_getImplementation(oriM), method_getTypeEncoding(oriM));
    }else{
        method_exchangeImplementations(oriM, swizzleM);
    }
}
@end



//categary
@implementation RuntimeObj (Extension)
+ (void)load
{
//    NSLog(@"%s", __func__);
    SEL oriSel = @selector(oriMethod);
    SEL swizzleSel = @selector(hookOriMethod);
    Method oriM = class_getInstanceMethod(self, oriSel);
    Method swizzleM = class_getInstanceMethod(self, swizzleSel);
    method_exchangeImplementations(oriM, swizzleM);
}

- (void)hookOriMethod
{
    [self hookOriMethod];
    NSLog(@"hookOriMethod");
}
- (NSString *)title
{
    return objc_getAssociatedObject(self, @selector(title));
}
- (void)setTitle:(NSString *)title
{
    objc_setAssociatedObject(self, @selector(title), title, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
@end
