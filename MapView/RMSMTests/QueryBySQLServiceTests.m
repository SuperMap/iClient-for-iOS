//
//  QueryBySQLServiceTests.m
//  MapView
//
//  Created by iclient on 14-7-24.
//
//

#import <XCTest/XCTest.h>
#import "QueryBySQLService.h"
@interface QueryBySQLServiceTests : XCTestCase
{
    QueryBySQLService *queryBySQLService;
}
@end

@implementation QueryBySQLServiceTests

- (void)setUp
{
    [super setUp];
    queryBySQLService=[[QueryBySQLService alloc]init:@"http://support.supermap.com.cn:8090/iserver/services/map-world/rest/maps/World"];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testConstructor
{
    FilterParameter *filterParameters = [[FilterParameter alloc] init];
    filterParameters.name = @"Countries@World";
    filterParameters.attributeFilter = @"SMID = 1";
    QueryBySQLParameters* parameters = [[QueryBySQLParameters alloc] init];
    [parameters.queryParams addObject:filterParameters];
    
    XCTAssertNotNil(queryBySQLService,@"queryBySQLService is not nil");
    XCTAssertNoThrow([queryBySQLService processAsync:parameters], @"testConstructor_processAsync");
    XCTAssertNotNil(queryBySQLService.lastResult, @"testConstructor_lastResult");
    
    XCTAssertTrue([[[queryBySQLService lastResult]recordsets]count]==1, @"testConstructor_lastResult_recordsets is not nil");
    XCTAssertTrue([[queryBySQLService lastResult]totalCount]==1, @"testConstructor_lastResult_totalCount");
    XCTAssertTrue([[queryBySQLService lastResult]currentCount]==1, @"testConstructor_lastResult_currentCount");
    XCTAssertTrue([[[[[queryBySQLService lastResult]recordsets] objectAtIndex:0]datasetName] isEqualToString:@"Countries@World"], @"testConstructor_lastResult_recordsets_datasetName");
}

- (void)testQueryParams
{
    FilterParameter *filterParameters = [[FilterParameter alloc] init];
    filterParameters.name = @"Countries@World";
    filterParameters.attributeFilter = @"SMID < 3";
    
    FilterParameter *filterParameters1 = [[FilterParameter alloc] init];
    filterParameters1.name = @"Capitals@World";
    filterParameters1.attributeFilter = @"SMID < 3";
    
    QueryBySQLParameters* parameters = [[QueryBySQLParameters alloc] init];
    [parameters.queryParams addObject:filterParameters];
    [parameters.queryParams addObject:filterParameters1];
    
    XCTAssertNotNil(queryBySQLService,@"queryBySQLService is not nil");
    XCTAssertNoThrow([queryBySQLService processAsync:parameters], @"testQueryParams_processAsync");
    XCTAssertNotNil(queryBySQLService.lastResult, @"testQueryParams_lastResult");
    
    XCTAssertTrue([[[queryBySQLService lastResult]recordsets]count]==2, @"testQueryParams_lastResult_recordsets count =2");
    XCTAssertTrue([[queryBySQLService lastResult]totalCount]==4, @"testQueryParams_lastResult_totalCount");
    XCTAssertTrue([[queryBySQLService lastResult]currentCount]==4, @"testQueryParams_lastResult_currentCount");
    XCTAssertTrue([[[[[queryBySQLService lastResult]recordsets] objectAtIndex:0]datasetName] isEqualToString:@"Countries@World"], @"testQueryParams_lastResult_recordsets_0_datasetName");
    XCTAssertTrue([[[[[queryBySQLService lastResult]recordsets] objectAtIndex:0]features]count]==2,@"testQueryParams_lastResult_recordsets_0_features");
    XCTAssertTrue([[[[[queryBySQLService lastResult]recordsets] objectAtIndex:1]datasetName] isEqualToString:@"Capitals@World"], @"testQueryParams_lastResult_recordsets_1_datasetName");
    XCTAssertTrue([[[[[queryBySQLService lastResult]recordsets] objectAtIndex:1]features]count]==2,@"testQueryParams_lastResult_recordsets_1_features");
}
//测试无SQL相关过滤参数时
- (void)testWithoutQueryParams
{
    QueryBySQLParameters* parameters = [[QueryBySQLParameters alloc] init];
    
    XCTAssertNotNil(queryBySQLService,@"queryBySQLService is not nil");
    XCTAssertNoThrow([queryBySQLService processAsync:parameters], @"testWithoutQueryParams_processAsync");
   
    XCTAssertTrue([[queryBySQLService.lastResult recordsets]count]==0, @"testWithoutQueryParams_lastResult_recordsets");
}

//测试无对应的目标图层时
- (void)testLayerNotExist
{
    FilterParameter *filterParameters = [[FilterParameter alloc] init];
    filterParameters.name = @"CountriesNo@World";
    filterParameters.attributeFilter = @"SMID = 1";
    QueryBySQLParameters* parameters = [[QueryBySQLParameters alloc] init];
    [parameters.queryParams addObject:filterParameters];
   
    XCTAssertNoThrow([queryBySQLService processAsync:parameters], @"testLayerNotExist_processAsync");
     XCTAssertTrue([[queryBySQLService.lastResult recordsets]count]==0, @"testLayerNotExist_lastResult_recordsets");
}
@end
