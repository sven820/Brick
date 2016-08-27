//
//  BRTestViewModelTest.m
//  BrickKit
//
//  Created by jinxiaofei on 16/8/24.
//  Copyright © 2016年 JJ.sevn. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "BRTestViewModel.h"
#import <OCMock/OCMock.h>
#import "BRImageTools.h"

@interface BRTestViewModelTest : XCTestCase

@property(nonatomic, strong) BRTestViewModel *viewModel;
@end

@interface BRTestViewModel (TestBRTestViewModel)

- (NSString *)privateMehtodDealImage:(NSString *)image;
@property(nonatomic, strong) NSString *img; //BRTestViewModel 私有属性
@end

@implementation BRTestViewModelTest


// 这里做一些初始化的处理, 比如初始化被测试instance
- (void)setUp {
    [super setUp];
    
    self.viewModel = [[BRTestViewModel alloc] init];
}

// 这里做一些测试后清理的工作
- (void)tearDown {
    [super tearDown];
    
    self.viewModel = nil;
}

- (void)testGetImage
{
    // 私有属性通过category来暴露注入接口, 详细见下面私有方法测试相关说明
    self.viewModel.img = @"图片";
    
    // [BRImageTools shareTools], 注意单例的Mock, 为了保证单例在测试过程中的唯一性, 除了通常写法,你应该如下
    id mockClass = OCMClassMock([BRImageTools class]);
    OCMStub([BRImageTools shareTools]).andReturn(mockClass);//保证后续如果用到[BRImageTools shareTools], 那也是合理的
    
    // 非当前方法逻辑, 你不应该测试别人的方法逻辑, 比如这里的 '[tool dealImage:self.img]', 这应该单独写个测试方法. 而正确的做法是stub, 通俗来说这就是造数据, 因为我们不想测别人的逻辑, 那我们就只能替换掉别人的方法, 并返回我们假设的结果, 这样就能进行下一步的测试验证
    
    //如果没有返回值, 则可以用断言该方法被执行了: 'OCMVerify([mockClass dealImage:[OCMArg any]]);'
    OCMStub([mockClass dealImage:[OCMArg any]]).andReturn(@"图片超人");
    
        // 如果是stubClass method, 你可以直接上面写法, 也可以下面写法,ClassMethod作区分.
            // 当方法里同时存在同名类方法和实例方法, 就需要用ClassMethod作区分
        // OCMStub(ClassMethod([mockClass dealImage:[OCMArg any]])).andReturn(@"图片超人");
    
    // '[OCMArg any]', 作用, 用来限制方法的参数类型, 如果类型不匹配, 则stub无效, 即andReturn不会返回结果. 具体类型限定看OCMock官方文档说明
    /*
     OCMStub([mock someMethod:aValue)
     OCMStub([mock someMethod:[OCMArg isNil]])
     OCMStub([mock someMethod:[OCMArg isNotNil]])
     OCMStub([mock someMethod:[OCMArg isNotEqual:aValue]])
     OCMStub([mock someMethod:[OCMArg isKindOfClass:[SomeClass class]]])
     OCMStub([mock someMethod:[OCMArg checkWithSelector:aSelector onObject:anObject]])
     OCMStub([mock someMethod:[OCMArg checkWithBlock:^BOOL(id value) {  return YES if value is ok  }]])
     */
    
    // 私有方法怎么测, '[self privateMehtodDealImage:img]'
    
    // 1.首先一般私有逻辑是不需要测的, 2,往往我们代码的私有逻辑包括了很多复杂逻辑(编码不好),有时需要我们来测. 3 私有方法没注入点,不能stub
    
    // 私有方法或属性应为是私有的, 没有注入接口, 因此这是测试里面最蛋疼的, 因此这就要对编码有较高的要求, 因此你的编码的粒度要小, 聚合度要高, 当所有都模块化, 那就没有或很少的私有方法了. 采用TDD(测试驱动开发)方式编码的话, 你会发现你基本不用考虑私有方法, 因为一开始你就把测试逻辑写进去了, 你要做的就是按照测试逻辑编码, 那这样你的模块化会很高, 就不会出现私有.
    // 但如果是旧代码写单元测试, 难免会碰到私有属性方法, 这里提供一种解决思路. 通过category在本测试类中暴露私有属性或方法, 这样会更优雅. 缺点你要维护两个地方, 一旦你私有方法名变更, 你也要变更测试类中的
    
    //这里我们的私有方法逻辑很简单, 不用测试, 这里我们假设很复杂, 有测试的需求, 用category来写, 参见category
    
    //因为category暴露了接口, 我们就可以愉快stub了, 当然你要测试私有方法, 就另起个testPrivate...
    
    //写到这, 其实, 不难看出, 不如重构下...
    
    id mockViewModel = OCMPartialMock(self.viewModel);
    // 这里你不能直接用self.viewModel来stub, 你stub的应该是Mock的对象(具体Mock方式有以下三种)
        // strictClassMock: 调用一个没有stub的方法是会报错
        // classMock: 当调用一个没有stub的方法时, 不会报错, 但这相当于你执行stub的这句代码无效, 会造成潜在错误
        // partialMock: 当调用一个没有stub的方法时, 会转到到真实对象去调用
        // 使用场景:strictClassMock试用需要Mock对象所有方法stub的,classMock和partialMock适用于Mock对象某些方法需要stub
    
    OCMStub([mockViewModel privateMehtodDealImage:[OCMArg any]]).andReturn(@"图片超人归来");
    
    NSString *image = [self.viewModel getImage];
    
    NSString *expectImage = @"图片超人归来";
    
    //断言结果, 通过断言, 判断测试时成功或失败
    XCTAssertEqual(image, expectImage, @"图片不一样");
    
    // 其它
        // 主动去停止Mock, MockClass会转移到真实实例上
    [mockClass stopMocking];
        // 忽略所有参数类型, 时髦语法...
    [[[mockClass stub] ignoringNonObjectArgs] dealImage:0];
    // Mock通知
    id observerMock = OCMObserverMock();
    [[NSNotificationCenter defaultCenter] addMockObserver:observerMock name:@"SomeNotification" object:nil];
    [[observerMock expect] notificationWithName:@"SomeNotification" object:[OCMArg any]];
        // OCMVerifyAll(observerMock);
    // 其它注意看官网
}

// 测试私有方法
- (void)testPrivateMehtodDealImage
{
    // test your private method
    // ...
}

// 性能测试, MesureBlock, 通俗来说就是测试你某段程序的性能
// 注意, 性能测试比较耗时, 一般单独放在某个测试类中, 性能测试只测性能消耗大的, 你想优化的, 性能测试会展示一些性能数据, 比如耗时等
- (void)testXingNeng
{
    [self measureBlock:^{
        for (int i =0 ; i < 10000; i++)
        {
            NSLog(@"性能测试");
        }
    }];
    
    // 从输出结果可以看出，相同的代码重复执行 10 次，统计计算时间，得到平均时间，也计算出了标准差等。
    // 基线自己设置, 大于基线的则视为失败
    /*
      measured [Time, seconds] average: 2.069, relative standard deviation: 35.706%, values: [2.354806, 3.961855, 2.337706, 2.257307, 2.165324, 1.776657, 1.595242, 1.225981, 1.403932, 1.608733],
     */
   
    
    /*
     performanceMetricID:com.apple.XCTPerformanceMetric_WallClockTime, baselineName: "", baselineAverage: , maxPercentRegression: 10.000%, maxPercentRelativeStandardDeviation: 10.000%, maxRegression: 0.100, maxStandardDeviation: 0.100
     Test Case '-[BRTestViewModelTest testXingNeng]' passed (21.245 seconds).
     
     */
    
}
@end



