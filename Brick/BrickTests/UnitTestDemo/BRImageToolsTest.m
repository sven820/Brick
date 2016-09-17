//
//  BRImageToolsTest.m
//  BrickKit
//
//  Created by jinxiaofei on 16/8/25.
//  Copyright © 2016年 jinxiaofei. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "BRImageTools.h"

@interface BRImageToolsTest : XCTestCase
@property(nonatomic, strong) BRImageTools *tool;
@end

@implementation BRImageToolsTest

- (void)setUp {
    [super setUp];
    self.tool = [BRImageTools shareTools];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
    self.tool = nil;
}

- (void)testDealImage_instanceMethod
{
    
}

- (void)testDealImage_classMethod
{
    
}
@end
