//
//  QueryParametersTests.m
//  MapView
//
//  Created by iclient on 14-7-25.
//
//

#import <XCTest/XCTest.h>
#import "QueryParameters.h"
#import "RMGlobalConstants.h"

@interface QueryParametersTests : XCTestCase
{
    QueryParameters *parameters;
}
@end

@implementation QueryParametersTests

- (void)setUp
{
    [super setUp];
    parameters=[[QueryParameters alloc]init];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testConstructor
{
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

- (void)testCustom
{
    parameters.expectCount=100;
    parameters.networkType = [[NSString alloc] initWithString:GeometryType_POINT];
    parameters.startRecord = 1;
    parameters.holdTime = 15;
    parameters.returnContent = true;
    
    XCTAssertNil(parameters.customParams, @"testCustom_customParams");
    XCTAssertEqual(parameters.expectCount, 100,@"testCustom_expectCount");
    XCTAssertTrue([parameters.networkType isEqualToString:@"POINT"], @"testCustom_networkType");
    XCTAssertTrue([parameters.queryOption isEqualToString:@"ATTRIBUTEANDGEOMETRY"], @"testCustom_queryOption");
    XCTAssertEqual([parameters.queryParams count],0, @"testCustom_queryParams");
    XCTAssertEqual(parameters.startRecord,1, @"testCustom_startRecord");
    XCTAssertEqual(parameters.holdTime,15, @"testCustom_holdTime");
    XCTAssertFalse(parameters.returnCustomResult, @"testCustom_returnCustomResult");
    XCTAssertTrue(parameters.returnContent, @"testCustom_returnContent");
}

- (void)testToNSDictionary_defaultConstructor
{
    XCTAssertNoThrow([parameters toNSDictionary],"testToNSDictionary_default");
}
- (void)testToNSDictionary_Custom
{
    parameters.expectCount=100;
    parameters.networkType = [[NSString alloc] initWithString:GeometryType_POINT];
    parameters.startRecord = 1;
    parameters.holdTime = 15;
    parameters.returnContent = true;
    
    XCTAssertNoThrow([parameters toNSDictionary],"testToNSDictionary_Custom");
}
@end
