//
//  QueryBySQLParametersTests.m
//  MapView
//
//  Created by iclient on 14-7-24.
//
//

#import <XCTest/XCTest.h>
#import "QueryBySQLParameters.h"
#import "FilterParameter.h"
@interface QueryBySQLParametersTests : XCTestCase

@end

@implementation QueryBySQLParametersTests

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
    QueryBySQLParameters* parameters = [[QueryBySQLParameters alloc] init];
    XCTAssertNotNil(parameters, @"queryBySQLParameters is not nil");
   
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
    FilterParameter *filterParameters = [[FilterParameter alloc] init];
    filterParameters.name = @"Countries@World";
    filterParameters.attributeFilter = @"SMID = 1";
    QueryBySQLParameters* parameters = [[QueryBySQLParameters alloc] init];
    [parameters.queryParams addObject:filterParameters];
    
    XCTAssertNotNil(parameters, @"queryBySQLParameters is not nil");
    XCTAssertTrue([[[parameters.queryParams objectAtIndex:0]name]isEqualToString:@"Countries@World"], @"testCustom_queryParams_filterParameters.name");
     XCTAssertTrue([[[parameters.queryParams objectAtIndex:0]attributeFilter]isEqualToString:@"SMID = 1"], @"testCustom_queryParams_filterParameters.attributeFilter");
    
    XCTAssertNil(parameters.customParams, @"testCustom_customParams");
    XCTAssertEqual(parameters.expectCount, 100000,@"testCustom_expectCount");
    XCTAssertTrue([parameters.networkType isEqualToString:@"LINE"], @"testCustom_networkType");
    XCTAssertTrue([parameters.queryOption isEqualToString:@"ATTRIBUTEANDGEOMETRY"], @"testCustom_queryOption");
    XCTAssertEqual([parameters.queryParams count],1, @"testCustom_queryParams");
    XCTAssertEqual(parameters.startRecord,0, @"testCustom_startRecord");
    XCTAssertEqual(parameters.holdTime,10, @"testCustom_holdTime");
    XCTAssertFalse(parameters.returnCustomResult, @"testCustom_returnCustomResult");
    XCTAssertTrue(parameters.returnContent, @"testCustom_returnContent");
}
@end
