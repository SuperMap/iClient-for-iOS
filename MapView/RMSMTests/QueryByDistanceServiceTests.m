//
//  QueryByDistanceServiceTests.m
//  MapView
//
//  Created by iclient on 14-7-24.
//
//

#import <XCTest/XCTest.h>
#import "querybydistanceservice.h"
#import "FilterParameter.h"
@interface QueryByDistanceServiceTests : XCTestCase
{
    QueryByDistanceService *queryByDistanceService;
    RMPath* pPoint;
    
}
@end

@implementation QueryByDistanceServiceTests

- (void)setUp
{
    [super setUp];
    queryByDistanceService=[[QueryByDistanceService alloc]init:@"http://support.supermap.com.cn:8090/iserver/services/map-world/rest/maps/World"];
    RMMapContents *mapContents=[RMMapContents alloc];
    pPoint = [[RMPath alloc] initWithContents:mapContents];
    RMProjectedPoint prjPnt;
    prjPnt.easting = 116;
    prjPnt.northing = 40;
    [pPoint moveToXY:prjPnt ];}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testConstructor
{
    FilterParameter* filterParameter = [[FilterParameter alloc] init];
    filterParameter.name = @"Capitals@World";
    
    QueryByDistanceParameters* parameters = [[QueryByDistanceParameters alloc] init:30 mGeometry:pPoint bNearest:false];
    [parameters.queryParams addObject:filterParameter];
  
    XCTAssertNotNil(queryByDistanceService,@"queryByDistanceService is not nil");
    XCTAssertNoThrow([queryByDistanceService processAsync:parameters], @"testConstructor_processAsync");
    XCTAssertNotNil(queryByDistanceService.lastResult, @"testConstructor_lastResult");
    
    XCTAssertTrue([[[queryByDistanceService lastResult]recordsets]count]>0, @"testConstructor_lastResult_recordsets is not nil");
    XCTAssertTrue([[queryByDistanceService lastResult]totalCount]==9, @"testConstructor_lastResult_totalCount");
    XCTAssertTrue([[queryByDistanceService lastResult]currentCount]==9, @"testConstructor_lastResult_currentCount");
    XCTAssertTrue([[[[[queryByDistanceService lastResult]recordsets] objectAtIndex:0]datasetName] isEqualToString:@"Capitals@World"], @"testConstructor_lastResult_recordsets_datasetName");
}

-(void)testQueryByDistanceServiceFail
{
    QueryByDistanceParameters* parameters = [[QueryByDistanceParameters alloc] init:30 mGeometry:pPoint bNearest:false];
    
    XCTAssertNoThrow([queryByDistanceService processAsync:parameters], @"testQueryByDistanceServiceFail_processAsync");
    XCTAssertNotNil([queryByDistanceService lastResult],@"testQueryByDistanceServiceFail_lastResult");
    XCTAssertTrue([[[queryByDistanceService lastResult]recordsets]count]==0, @"testQueryByDistanceServiceFail_lastResult_recordsets is not nil");
    XCTAssertTrue([[queryByDistanceService lastResult]totalCount]==0, @"testQueryByDistanceServiceFail_lastResult_totalCount");
    XCTAssertTrue([[queryByDistanceService lastResult]currentCount]==0, @"testQueryByDistanceServiceFail_lastResult_currentCount");
    XCTAssertTrue([[queryByDistanceService lastResult]customResponse]==0, @"testQueryByDistanceServiceFail_lastResult_currentCount");
}

@end
