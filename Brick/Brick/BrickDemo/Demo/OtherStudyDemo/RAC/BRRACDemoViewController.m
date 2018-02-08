//
//  BRRACDemoViewController.m
//  BrickKit
//
//  Created by jinxiaofei on 16/8/16.
//  Copyright © 2016年 JJ.sevn. All rights reserved.
//

#import "BRRACDemoViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>


@interface BRRACDemoViewController ()
@property(nonatomic, strong) UITextField *t1;
@property(nonatomic, strong) UITextField *t2;
@end

@implementation BRRACDemoViewController


//http://benbeng.leanote.com/post/ReactiveCocoaTutorial-part1
//http://benbeng.leanote.com/post/ReactiveCocoaTutorial-part2

//http://www.jianshu.com/p/87ef6720a096
//http://www.jianshu.com/p/e10e5ca413b7
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
//    [self textFieldDemo_filter];
    
//    [self textFieldDemo_map];
    
//    [self textFieldDemo_map_transform];
    
//    [self textFieldDemo_combinSignal];
    
    [self subjectDemo];
    
    //综合小练习, login
    [self practiceWithLittleDemo];
}

#pragma mark - 综合练习
/**综合练习*****************************************************************************/
- (void)practiceWithLittleDemo
{
    UIButton *btn = [[UIButton alloc] init];
    [self.view addSubview:btn];
    [btn setTitle:@"登录" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [btn setBackgroundColor:[UIColor blueColor]];
    btn.frame = CGRectMake(200, 100, 100, 30);
    btn.enabled = NO;
    
    UITextField *t1 = [[UITextField alloc] init];
    t1.backgroundColor = [UIColor redColor];
    [self.view addSubview:t1];
    t1.frame = CGRectMake(10, 200, 150, 30);
    self.t1 = t1;
    
    UITextField *t2 = [[UITextField alloc] init];
    t2.backgroundColor = [UIColor redColor];
    [self.view addSubview:t2];
    t2.frame = CGRectMake(170, 200, 150, 30);
    self.t2 = t2;
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"登录" message:@"登录成功" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
    /*
//1. 处理textField
    RACSignal *signal1 = [t1.rac_textSignal map:^id(NSString *value) {
        BOOL temp = value.length > 3;
        UIColor *color = temp ? [UIColor greenColor] : [UIColor lightGrayColor];
        t1.backgroundColor = color;
        return @(temp);
    }];
    RACSignal *signal2 = [t2.rac_textSignal map:^id(NSString *value) {
        BOOL temp = value.length > 3;
        UIColor *color = temp ? [UIColor greenColor] : [UIColor lightGrayColor];
        t2.backgroundColor = color;
        return @(temp);
    }];
    
    //聚合信号的事件数据如果是YES, 就代表可以提交登录
    [[RACSignal combineLatest:@[signal1, signal2] reduce:^id(NSNumber *value1, NSNumber *value2){
        return @([value1 boolValue] && [value2 boolValue]);
    }] subscribeNext:^(id x) {
        btn.enabled = [x boolValue];
    }];
    
// 处理button
    // - flattenMap: 把按钮点击信号转换成登录请求信号
    // - doNext, 是一些同步的辅助操作, 它不会影响事件的数据流
    [[[[btn rac_signalForControlEvents:UIControlEventTouchUpInside] doNext:^(id x) {
        btn.enabled = NO;
    }] flattenMap:^RACStream *(id value) {
        return [self getLoginServiceSignal];
    }] subscribeNext:^(id x) {
        btn.enabled = YES;
        NSString *res = [x boolValue] ? @"登录成功" : @"登录失败";
        alertView.message = res;
        [alertView show];
    }];
    
    //最后
    //我们可以从上看出RAC的特点: 高聚合, 逻辑待吗基本都聚合在信号流的"管道中" \
                             简化代码, 至始至终, 我只定义了两个属性, 所有数据流都在信号流的管道内 \
                              低耦合, 数据流通过block传递, 耦合性降低  \
    注意block的循环引用, 可以用RAC自带的@(WeakSelf)和@(StrongSelf)
*/
}

//- (RACSignal *)getLoginServiceSignal
//{
    /*
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [self mockLoginService:self.t1.text pwd:self.t2.text completeBlock:^(BOOL value) {
            [subscriber sendNext:@(value)];
            [subscriber sendCompleted];
        }];
        return [RACDisposable disposableWithBlock:^{
            
            // block调用时刻：当信号发送完成或者发送错误，就会自动执行这个block,取消订阅信号。
            
            // 执行完Block后，当前信号就不在被订阅了。
            
            NSLog(@"信号被销毁");
            
        }];
    }];
    return signal;
     */
//    return nil;
//}

- (void)mockLoginService:(NSString *)name pwd:(NSString *)pwd completeBlock:(void(^)(BOOL value))complete
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        BOOL res = [name isEqualToString:@"jjjjj"] && [pwd isEqualToString:@"12345"];
        complete(res);
    });
}



#pragma mark - 分解学习
/**分解学习*****************************************************************************/
- (void)textFieldDemo_filter
{
    UITextField *t = [[UITextField alloc] init];
    t.backgroundColor = [UIColor greenColor];
    [self.view addSubview:t];
    t.frame = CGRectMake(100, 150, 200, 30);
    
    /*
    [[t.rac_textSignal filter:^BOOL(id value) {
        NSString *text = value;
        return text.length > 3;
    }] subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];
    */
    /** RACSignal的每个操作都会返回一个RACsignal，这在术语上叫做连贯接口（fluent interface）。这个功能可以让你直接构建管道，而不用每一步都使用本地变量。
     
        分解如下三个步骤
     */
    
    /*
     RACSignal *t_signal = t.rac_textSignal;
     
     RACSignal *t_filter_signal = [t_signal filter:^BOOL(id value) {
     NSString *str = value;
     return str.length > 3;
     }];
     
     [t_filter_signal subscribeNext:^(id x) {
     NSLog(@"%@", x);
     }];
     */
    
}

- (void)textFieldDemo_map
{
    UITextField *t = [[UITextField alloc] init];
    t.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:t];
    t.frame = CGRectMake(100, 200, 200, 30);
    
    /*
    [[t.rac_textSignal map:^id(NSString *str) {
        
        return @(str.length);
    }] subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];
     */
}

- (void)textFieldDemo_map_transform
{
    UITextField *t = [[UITextField alloc] init];
    t.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:t];
    t.frame = CGRectMake(100, 250, 200, 30);
    
//    [[t.rac_textSignal map:^id(NSString *value) {
//        return value.length > 3 ? [UIColor redColor] : [UIColor lightGrayColor];
//    }] subscribeNext:^(UIColor *color) {
//        t.backgroundColor = color;
//    }];
    
    //也可用RAC的宏来简化
    /*
    RAC(t, backgroundColor) = [t.rac_textSignal map:^id(NSString *value) {
        return value.length > 3 ? [UIColor redColor] : [UIColor lightGrayColor];
    }];
     */
}

- (void)textFieldDemo_combinSignal
{
    UITextField *t = [[UITextField alloc] init];
    t.backgroundColor = [UIColor redColor];
    [self.view addSubview:t];
    t.frame = CGRectMake(10, 300, 150, 30);
    
    UITextField *t2 = [[UITextField alloc] init];
    t2.backgroundColor = [UIColor redColor];
    [self.view addSubview:t2];
    t2.frame = CGRectMake(170, 300, 150, 30);
    
    /*
    RACSignal *signal = [t.rac_textSignal map:^id(NSString *str) {
        BOOL temp = str.length > 3;
        UIColor *color = temp ? [UIColor greenColor] : [UIColor lightGrayColor];
        t.backgroundColor = color;
        return @(temp);
    }];
    
    RACSignal *signal1 = [t2.rac_textSignal map:^id(NSString *str) {
        BOOL temp = str.length > 3;
        UIColor *color = temp ? [UIColor greenColor] : [UIColor lightGrayColor];
        t2.backgroundColor = color;
        return @(temp);
    }];
    
    RACSignal *combinSignal = [RACSignal combineLatest:@[signal, signal1] reduce:^id(NSNumber *value1, NSNumber *value2){
        // 这里返回新的事件数据
        return @([value1 boolValue] && [value2 boolValue]);
    }];
    
    [combinSignal subscribeNext:^(NSNumber *value) {
        NSString *res = [value boolValue] == YES ? @"绿灯" : @"红灯";
        NSLog(@"%@", res);
    }];
     */
}

- (void)subjectDemo
{
    /*
    // 1.创建信号
    RACSubject *subject = [RACSubject subject];
    
    // 2.订阅信号
    [subject subscribeNext:^(id x) {
        // block调用时刻：当信号发出新值，就会调用.
        NSLog(@"第一个订阅者%@",x);
    }];
    [subject subscribeNext:^(id x) {
        // block调用时刻：当信号发出新值，就会调用.
        NSLog(@"第二个订阅者%@",x);
    }];
    
    // 3.发送信号
    [subject sendNext:@"1"];
     */
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

///***常见用法*****************************************************************************/
//#pragma mark - *常见用法
//#pragma mark - 宏
//- (void)hongDeShiYong
//{
//    UIButton *btn = [UIButton new];
//    /** 属性绑定*/
//    RAC(btn, backgroundColor) = [btn rac_signalForControlEvents:UIControlEventTouchUpInside];
//    
//    /** KVO*/
//    [RACObserve(btn, backgroundColor) subscribeNext:^(id x) {
//        
//    }];
//    
//    /** @weakify(Obj)和@strongify(Obj),一般两个都是配套使用,在主头文件(ReactiveCocoa.h)中并没有导入，需要自己手动导入，RACEXTScope.h才可以使用。但是每次导入都非常麻烦，只需要在主头文件自己导入就好了。
//     */
//    
//    /** RACTuplePack：把数据包装成RACTuple（元组类）*/
//    RACTuple *tuple = RACTuplePack(@(10), @(20));
//    
//    /** RACTupleUnpack：把RACTuple（元组类）解包成对应的数据。*/
//    RACTuple *person = RACTuplePack(@"jinxiaofei", @(25));
//    RACTupleUnpack(NSString *name, NSNumber *age) = tuple;
//    NSLog(@"%@---%@", name, age);
//}

#pragma mark - 开发中常用方法
/**
 7.1 代替代理:
 
 rac_signalForSelector：用于替代代理。
 7.2 代替KVO :
 
 rac_valuesAndChangesForKeyPath：用于监听某个对象的属性改变。
 7.3 监听事件:
 
 rac_signalForControlEvents：用于监听某个事件。
 7.4 代替通知:
 
 rac_addObserverForName:用于监听某个通知。
 7.5 监听文本框文字改变:
 
 rac_textSignal:只要文本框发出改变就会发出这个信号。
 7.6 处理当界面有多次请求时，需要都获取到数据时，才能展示界面
 
 rac_liftSelector:withSignalsFromArray:Signals:当传入的Signals(信号数组)，每一个signal都至少sendNext过一次，就会去触发第一个selector参数的方法。
 使用注意：几个信号，参数一的方法就几个参数，每个参数对应信号发出的数据。
 */

#pragma mark - RAC常见类的介绍
/**
 RACSiganl:信号类,一般表示将来有数据传递，只要有数据改变，信号内部接收到数据，就会马上发出数据。
    - 信号类(RACSiganl)，只是表示当数据改变时，信号内部会发出数据，它本身不具备发送信号的能力，而是交给内部一个订阅者去发出。
 
    - 默认一个信号都是冷信号，也就是值改变了，也不会触发，只有订阅了这个信号，这个信号才会变为热信号，值改变了才会触发。
 
    - 如何订阅信号：调用信号RACSignal的subscribeNext就能订阅
 */

/**
 RACSubscriber:表示订阅者的意思，用于发送信号，这是一个协议，不是一个类，只要遵守这个协议，并且实现方法才能成为订阅者。通过create创建的信号，都有一个订阅者，帮助他发送数据。
 */

/**
 RACDisposable:用于取消订阅或者清理资源，当信号发送完成或者发送错误的时候，就会自动触发它。
 */

/**
 RACSubject:RACSubject:信号提供者，自己可以充当信号，又能发送信号。
    - 使用场景:通常用来代替代理，有了它，就不必要定义代理了。
    - RACReplaySubject:重复提供信号类，RACSubject的子类。
 
    - RACReplaySubject与RACSubject区别:
    - RACReplaySubject可以先发送信号，在订阅信号，RACSubject就不可以。
    - 使用场景一:如果一个信号每被订阅一次，就需要把之前的值重复发送一遍，使用重复提供信号类。
    - 使用场景二:可以设置capacity数量来限制缓存的value的数量,即只缓充最新的几个值。
 */

/**
 RACTuple:元组类,类似NSArray,用来包装值.
 */

/**
 RACSequence:RAC中的集合类，用于代替NSArray,NSDictionary,可以使用它来快速遍历数组和字典。
 */

/**
 RACCommand:RAC中用于处理事件的类，可以把事件如何处理,事件中的数据如何传递，包装到这个类中，他可以很方便的监控事件的执行过程。
 
 使用场景:监听按钮点击，网络请求
 */

/** 
 RACMulticastConnection:用于当一个信号，被多次订阅时，为了保证创建信号时，避免多次调用创建信号中的block，造成副作用，可以使用这个类处理。
 
 使用注意:RACMulticastConnection通过RACSignal的-publish或者-muticast:方法创建.
 */

/**
 RACScheduler:RAC中的队列，用GCD封装的。
 */

/** 
 RACUnit :表⽰stream不包含有意义的值,也就是看到这个，可以直接理解为nil.
 */

/** 
 RACEvent: 把数据包装成信号事件(signal event)。它主要通过RACSignal的-materialize来使用，然并卵。
 */
@end
