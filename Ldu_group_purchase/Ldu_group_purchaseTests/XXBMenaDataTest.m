//
//  XXBMenaDataTest.m
//  Ldu_group_purchase
//
//  Created by Jinhong on 15/1/14.
//  Copyright (c) 2015年 xiaoxiaobing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "XXBMetaDataTool.h"
#import "XXBCategory.h"
#import "XXBCity.h"
#import "XXBCityGroup.h"
#import "XXBSort.h"
 

@interface XXBMenaDataTest : XCTestCase

@end

@implementation XXBMenaDataTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    XCTAssert(YES, @"Pass");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}
- (void)testLoadMetaDataTool
{
    XXBMetaDataTool *tools = [XXBMetaDataTool sharedMetaDataTool];
    XCTAssert(tools.categories.count > 0 ,@"分类数据加载失败");
    XCTAssert(tools.cities.count > 0 ,@"分类数据加载失败");
    XCTAssert(tools.cityGroups.count > 0 ,@"分类数据加载失败");
    XCTAssert(tools.sorts.count > 0 ,@"分类数据加载失败");
}
@end
