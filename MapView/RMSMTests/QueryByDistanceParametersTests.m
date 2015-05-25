//
//  QueryByDistanceParametersTests.m
//  MapView
//
//  Created by iclient on 14-7-24.
//
//

#import <XCTest/XCTest.h>
#import "QueryByDistanceParameters.h"
#import "RMMapContents.h"
@interface QueryByDistanceParametersTests : XCTestCase
{
    QueryByDistanceParameters *parameters;
    RMMapContents *mapContents;
}
@end

@implementation QueryByDistanceParametersTests

- (void)setUp
{
    [super setUp];
    mapContents=[RMMapContents alloc];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testConstructor
{
    RMPath* pPoint = [[RMPath alloc] initWithContents:mapContents];
    CLLocationCoordinate2D mPoint;
    mPoint.latitude = 31;
    mPoint.longitude = 121;
    [pPoint moveToLatLong:mPoint ];
    parameters=[[QueryByDistanceParameters alloc]init:30 mGeometry:pPoint bNearest:NO];
   
    XCTAssertNotNil(parameters, "QueryByDistanceParameters is not nill");
    XCTAssertEqual(parameters.distance,30, @"testConstructor_distance");
     XCTAssertEqual(parameters.geometry,pPoint, @"testConstructor_geometry");
    XCTAssertFalse(parameters.isNearest, @"testConstructor_isNearest");
    
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
-(void)testCustom
{
    RMPath* pPoint = [[RMPath alloc] initWithContents:mapContents];
    CLLocationCoordinate2D mPoint;
    mPoint.latitude = 31;
    mPoint.longitude = 121;
    [pPoint moveToLatLong:mPoint ];
    parameters=[[QueryByDistanceParameters alloc]init:30 mGeometry:pPoint bNearest:YES];
    
    parameters.expectCount=100;
    parameters.networkType = [[NSString alloc] initWithString:GeometryType_POINT];
    parameters.startRecord = 1;
    parameters.holdTime = 15;
    parameters.returnContent = true;

    XCTAssertNotNil(parameters, "QueryByDistanceParameters is not nill");
    XCTAssertEqual(parameters.distance,30, @"testCustom_distance");
    XCTAssertEqual(parameters.geometry,pPoint, @"testCustom_geometry");
    XCTAssertTrue(parameters.isNearest, @"testCustom_isNearest");
    
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

@end
