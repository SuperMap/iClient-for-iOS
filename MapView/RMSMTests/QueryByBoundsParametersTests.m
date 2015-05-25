//
//  QueryByBoundsParametersTests.m
//  MapView
//
//  Created by iclient on 14-7-16.
//
//

#import <XCTest/XCTest.h>
#import "QueryByBoundsParameters.h"
@interface QueryByBoundsParametersTests : XCTestCase

@end

@implementation QueryByBoundsParametersTests

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

- (void)testConstructor
{
    RMProjectedRect rect=RMMakeProjectedRect(4.6055437100213,39.914712153518,47.974413646055-4.6055437100213,66.780383795309-39.914712153518);
    QueryByBoundsParameters *parameters=[[QueryByBoundsParameters alloc]init:rect];
    
    XCTAssertEqual(parameters.bounds.origin.easting,rect.origin.easting, @"testConstructor");
    XCTAssertEqual(parameters.bounds.size.width,rect.size.width, @"testConstructor");
    
    XCTAssertNil(parameters.customParams, @"testConstructor_customParams");
    XCTAssertEqual(parameters.expectCount, 100000,@"testConstructor_expectCount");
    XCTAssertTrue([parameters.networkType isEqualToString:@"LINE"], @"testConstructor_networkType");
    XCTAssertTrue([parameters.queryOption isEqualToString:@"ATTRIBUTEANDGEOMETRY"], @"testConstructor_queryOption");
    XCTAssertEqual([parameters.queryParams count],0, @"testConstructor_queryParams");
    XCTAssertEqual(parameters.startRecord,0, @"testConstructor_startRecord");
    XCTAssertEqual(parameters.holdTime,10, @"testConstructor_holdTime");
    XCTAssertFalse(parameters.returnCustomResult, @"testConstructor_returnCustomResult");
    XCTAssertTrue(parameters.returnContent, @"testConstructor_returnContent");
}

@end
