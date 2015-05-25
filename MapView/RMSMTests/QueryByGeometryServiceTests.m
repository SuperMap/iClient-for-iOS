//
//  QueryByGeometryServiceTests.m
//  MapView
//
//  Created by iclient on 14-7-24.
//
//

#import <XCTest/XCTest.h>
#import "QueryByGeometryService.h"
@interface QueryByGeometryServiceTests : XCTestCase
{
    QueryByGeometryService *queryByGeometryService;
    RMMapContents *mapContents;
}
@end

@implementation QueryByGeometryServiceTests

- (void)setUp
{
    [super setUp];
    queryByGeometryService=[[QueryByGeometryService alloc]init:@"http://support.supermap.com.cn:8090/iserver/services/map-world/rest/maps/World"];
    mapContents=[RMMapContents alloc];

}

- (void)tearDown
{
        [super tearDown];
}

- (void)testConstructor_Point
{
    FilterParameter* filterParameter = [[FilterParameter alloc] init];
    filterParameter.name = @"Countries@World";
    RMPath* pPoint = [[RMPath alloc] initWithContents:mapContents];
    RMProjectedPoint prjPnt;
    prjPnt.easting = 116;
    prjPnt.northing = 40;
    [pPoint moveToXY:prjPnt ];
    QueryByGeometryParameters *parameters=[[QueryByGeometryParameters alloc]init:pPoint];
    [parameters.queryParams addObject:filterParameter];
    
    XCTAssertNotNil(queryByGeometryService,@"queryByGeometryService is not nil");
    XCTAssertNoThrow([queryByGeometryService processAsync:parameters], @"testConstructor_Point_processAsync");
    XCTAssertNotNil(queryByGeometryService.lastResult, @"testConstructor_Point_Point_lastResult");
    
    XCTAssertTrue([[[queryByGeometryService lastResult]recordsets]count]>0, @"testConstructor_Point_lastResult_recordsets is not nil");
    XCTAssertTrue([[queryByGeometryService lastResult]totalCount]==1, @"testConstructor_Point_lastResult_totalCount");
    XCTAssertTrue([[queryByGeometryService lastResult]currentCount]==1, @"testConstructor_Point_lastResult_currentCount");
    XCTAssertTrue([[[[[queryByGeometryService lastResult]recordsets] objectAtIndex:0]datasetName] isEqualToString:@"Countries@World"], @"testConstructor_Point_lastResult_recordsets_datasetName");
    XCTAssertTrue([[[[[queryByGeometryService lastResult]recordsets] objectAtIndex:0]features] count]==1, @"testConstructor_Point_lastResult_recordsets_datasetName");

}
- (void)testConstructor_Polygon
{
    RMProjectedPoint leftBom, leftTop, rightTop, rightBom;
    leftBom=(RMProjectedPoint){4.6055437100213,39.914712153518};
    leftTop=(RMProjectedPoint){47.974413646055,39.914712153518};
    rightTop=(RMProjectedPoint){47.974413646055,66.780383795309};
    rightBom=(RMProjectedPoint){4.6055437100213,66.780383795309};
  
    RMPath* pPolygon = [[RMPath alloc] initWithContents:mapContents];
    [pPolygon moveToXY:leftBom];
    [pPolygon addLineToXY:leftTop];
    [pPolygon addLineToXY:rightBom];
    [pPolygon addLineToXY:rightTop];
    [pPolygon closePath];

    FilterParameter* filterParameter = [[FilterParameter alloc] init];
    filterParameter.name = @"Capitals@World";
    filterParameter.attributeFilter=@"SmID<100";
       QueryByGeometryParameters *parameters=[[QueryByGeometryParameters alloc]init:pPolygon];
    [parameters.queryParams addObject:filterParameter];
    XCTAssertNotNil(queryByGeometryService,@"queryByGeometryService is not nil");
    XCTAssertNoThrow([queryByGeometryService processAsync:parameters], @"testConstructor_Polygon_processAsync");
    XCTAssertNotNil(queryByGeometryService.lastResult, @"testConstructor_Polygon_lastResult");
    
    XCTAssertTrue([[[queryByGeometryService lastResult]recordsets]count]>0, @"testConstructor_Polygon_lastResult_recordsets is not nil");
    XCTAssertTrue([[queryByGeometryService lastResult]totalCount]==4, @"testConstructor_Polygon_lastResult_totalCount");
    XCTAssertTrue([[queryByGeometryService lastResult]currentCount]==4, @"testConstructor_Polygon_lastResult_currentCount");
    XCTAssertTrue([[[[[queryByGeometryService lastResult]recordsets] objectAtIndex:0]datasetName] isEqualToString:@"Capitals@World"], @"testConstructor_Polygon_lastResult_recordsets_datasetName");
     XCTAssertTrue([[[[[queryByGeometryService lastResult]recordsets] objectAtIndex:0]features] count]==4, @"testConstructor_Point_lastResult_recordsets_datasetName");
    
}
-(void)testQueryByGeometryServiceFail
{
    RMPath* pPoint = [[RMPath alloc] initWithContents:mapContents];
    RMProjectedPoint prjPnt;
    prjPnt.easting = 116;
    prjPnt.northing = 40;
    [pPoint moveToXY:prjPnt ];
    QueryByGeometryParameters *parameters=[[QueryByGeometryParameters alloc]init:pPoint];
    
    XCTAssertNotNil(queryByGeometryService,@"queryByGeometryService is not nil");
    XCTAssertNoThrow([queryByGeometryService processAsync:parameters], @"testQueryByGeometryServiceFail_processAsync");
    XCTAssertNotNil(queryByGeometryService.lastResult, @"testQueryByGeometryServiceFail_lastResult");
    XCTAssertTrue([[[queryByGeometryService lastResult]recordsets]count]==0, @"testQueryByGeometryServiceFail_recordsets is nil");
    XCTAssertTrue([[queryByGeometryService lastResult]totalCount]==0, @"testQueryByGeometryServiceFail__lastResult_totalCount");
    XCTAssertTrue([[queryByGeometryService lastResult]currentCount]==0, @"testQueryByGeometryServiceFail__lastResult_currentCount");

}
@end
