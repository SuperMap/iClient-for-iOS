//
//  QueryByBoundsServiceTests.m
//  MapView
//
//  Created by iclient on 14-7-16.
//
//

#import <XCTest/XCTest.h>
#import "QueryByBoundsService.h"
@interface QueryByBoundsServiceTests : XCTestCase
{
    QueryByBoundsService *queryByBoundsService;
}
@end

@implementation QueryByBoundsServiceTests

- (void)setUp
{
    [super setUp];
    queryByBoundsService=[[QueryByBoundsService alloc]init:@"http://support.supermap.com.cn:8090/iserver/services/map-world/rest/maps/World"];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testConstructor
{
    FilterParameter* filterParameter = [[FilterParameter alloc] init];
    filterParameter.name=[[NSString alloc] initWithString:@"Countries@World"];
    
    QueryByBoundsParameters *queryByBoundsParameters  = [[QueryByBoundsParameters alloc] init:RMMakeProjectedRect(0,0,20,20)];
    [queryByBoundsParameters.queryParams addObject:filterParameter];
    
    XCTAssertNotNil(queryByBoundsService,@"queryByBoundsService is not nil");
    XCTAssertNoThrow([queryByBoundsService processAsync:queryByBoundsParameters], @"testConstructor_processAsync");
    XCTAssertNotNil(queryByBoundsService.lastResult, @"testConstructor_lastResult");
}

-(void)testCustom
{
    FilterParameter* filterParameter = [[FilterParameter alloc] init];
    filterParameter.name = [[NSString alloc] initWithString:@"Capitals@World"];
    filterParameter.attributeFilter=@"SmID>10";
   
    QueryByBoundsParameters* queryByBoundsParameters = [[QueryByBoundsParameters alloc] init:RMMakeProjectedRect(4.6055437100213,39.914712153518,47.974413646055-4.6055437100213,66.780383795309-39.914712153518)];
    [queryByBoundsParameters.queryParams addObject:filterParameter];
    queryByBoundsParameters.networkType=[[NSString alloc]initWithString:GeometryType_POINT];
   
    XCTAssertNoThrow([queryByBoundsService processAsync:queryByBoundsParameters], @"testCustom_processAsync");
    XCTAssertTrue([[[queryByBoundsService lastResult]recordsets]count]>0, @"testCustom_lastResult_recordsets is not nil");
    XCTAssertTrue([[queryByBoundsService lastResult]totalCount]==36, @"testCustom_lastResult_totalCount");
    XCTAssertTrue([[queryByBoundsService lastResult]currentCount]==36, @"testCustom_lastResult_currentCount");
    XCTAssertTrue([[[[[queryByBoundsService lastResult]recordsets] objectAtIndex:0]datasetName] isEqualToString:@"Capitals@World"], @"testCustom_lastResult_recordsets_datasetName");
}
// 查询过滤条件参数为空
-(void)testQueryByBoundsServiceFail
{
    QueryByBoundsParameters* queryByBoundsParameters = [[QueryByBoundsParameters alloc] init:RMMakeProjectedRect(4.6055437100213,39.914712153518,47.974413646055-4.6055437100213,66.780383795309-39.914712153518)];
    
    XCTAssertNoThrow([queryByBoundsService processAsync:queryByBoundsParameters], @"testQueryByBoundsServiceFail_processAsync");
    XCTAssertNotNil([queryByBoundsService lastResult],@"");
    XCTAssertTrue([[[queryByBoundsService lastResult]recordsets]count]==0, @"testQueryByBoundsServiceFail_lastResult_recordsets is not nil");
    XCTAssertTrue([[queryByBoundsService lastResult]totalCount]==0, @"testQueryByBoundsServiceFail_lastResult_totalCount");
    XCTAssertTrue([[queryByBoundsService lastResult]currentCount]==0, @"testQueryByBoundsServiceFail_lastResult_currentCount");
    XCTAssertTrue([[queryByBoundsService lastResult]customResponse]==0, @"testQueryByBoundsServiceFail_lastResult_currentCount");
}


@end
