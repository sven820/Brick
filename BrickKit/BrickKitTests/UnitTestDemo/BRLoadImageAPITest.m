//
//  BRLoadImageAPITest.m
//  BrickKit
//
//  Created by jinxiaofei on 16/8/24.
//  Copyright © 2016年 JJ.sevn. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "BRLoadImageAPI.h"

@interface BRLoadImageAPITest : XCTestCase
@end

@implementation BRLoadImageAPITest

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

//测试接口(测试异步方法)
- (void)testLoadImage
{
    //使用XCTestExpectation
    //规则, 定义一个期望, 如果在规定时间内和规则内, 我们收到这个期望, 就代表测试成功
    XCTestExpectation *exp = [self expectationWithDescription:@"测试失败的描述"];
    
   [BRLoadImageAPI loadImageSuccess:^(NSString *image, NSInteger statusCode) {
       XCTAssert(statusCode == 200, @"请求状态码不对");
       XCTAssert(image && image.length > 0, @"未请求到图片");
       
       //当请求数据符合预期, 并且未超时, 则发送一条fullfill消息, 表示exp期望完成了, 测试成功
       [exp fulfill];
       
   } errBlock:^(NSString *errorMessage, NSInteger statusCode) {
       
       XCTAssert(statusCode == 500, @"状态码异常");
       if (errorMessage && errorMessage.length > 0 && statusCode == 500)
       {
           [exp fulfill]; //虽然请求失败了, 但该方法成功执行完成, 你可以选择宣布获得期望,测试成功, 或者写其他的断言
       }
   }];
    
    // 超时则测试失败, 执行这个方法
    [self waitForExpectationsWithTimeout:2.0 handler:^(NSError * _Nullable error) {
        
        //clear 或其他自定义处理
    }];
}

@end
