//
//  QueryByGeometryParametersTests.m
//  MapView
//
//  Created by iclient on 14-7-24.
//
//

#import <XCTest/XCTest.h>
#import "QueryByGeometryParameters.h"
#import "RMMapContents.h"
@interface QueryByGeometryParametersTests : XCTestCase

@end

@implementation QueryByGeometryParametersTests

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
    RMMapContents *mapContents=[RMMapContents alloc];
    RMPath* pPoint = [[RMPath alloc] initWithContents:mapContents];
    CLLocationCoordinate2D mPoint;
    mPoint.latitude = 0;
    mPoint.longitude = 0;
    [pPoint moveToLatLong:mPoint ];
    QueryByGeometryParameters *parameters=[[QueryByGeometryParameters alloc]init:pPoint];
    
    XCTAssertNotNil(parameters, "QueryByGeometryParameters is not nill");
    XCTAssertEqual(parameters.geometry,pPoint, @"testConstructor_geometry");
    XCTAssertTrue([parameters.spatialQueryMode isEqualToString:@"INTERSECT"], @"testConstructor_spatialQueryMode");
    
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
