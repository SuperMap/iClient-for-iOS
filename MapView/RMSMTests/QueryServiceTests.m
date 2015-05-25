//
//  QueryServiceTests.m
//  MapView
//
//  Created by iclient on 14-7-16.
//
//

#import <XCTest/XCTest.h>
#import "QueryService.h"
@interface QueryServiceTests : XCTestCase
{
    QueryService *queryService;
}
@end

@implementation QueryServiceTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testConstrctor
{
    queryService=[[QueryService alloc]init:@"http://support.supermap.com.cn/:8090/iserver/services/map-world/rest/maps/World"];
    XCTAssertNotNil(queryService, @"QueryService is not nil");
}

@end
