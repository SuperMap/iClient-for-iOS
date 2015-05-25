//
//  FindPathParametersTests.m
//  MapView
//
//  Created by iclient on 14-6-18.
//
//

#import <XCTest/XCTest.h>
#import "FindPathParameters.h"

@interface FindPathParametersTests : XCTestCase
{
    FindPathParameters *parameters;
}
@end

@implementation FindPathParametersTests

- (void)setUp
{
    [super setUp];
    
}

- (void)tearDown
{
    [parameters autorelease];
    [super tearDown];
}

- (void)testConstructorWihtAnalystById
{
    
    NSMutableArray *nodeArray=[[NSMutableArray alloc]initWithObjects:[NSNumber numberWithFloat:2657],[NSNumber numberWithFloat:2525],nil];
    TransportationAnalystParameter *analystParameter=[[TransportationAnalystParameter alloc]init];
    parameters=[[FindPathParameters alloc]init:YES bHasLeastEdgeCount:YES nodes:nodeArray parameter:analystParameter];
    XCTAssert(parameters.isAnalystById, @"testConstructorWihtAnalystById_isAnalystById");
    XCTAssert(parameters.hasLeastEdgeCount, @"testConstructorWihtAnalystById_hasLeastEdgeCount");
    XCTAssertEqual(parameters.nodes, nodeArray, "testConstructorWihtAnalystById_nodes");
    XCTAssertEqual(parameters.parameter, analystParameter, "testConstructorWihtAnalystById_analystParameter");
}

- (void)testConstructorWihtAnalystByPath
{
    TransportationAnalystParameter *analystParameter=[[TransportationAnalystParameter alloc]init];
    
    RMProjectedPoint prjPnt; prjPnt.easting = 2328.5375449003; prjPnt.northing = -3656.9550357373;
    RMProjectedPoint prjPnt2;  prjPnt2.easting = 4129.2262366137; prjPnt2.northing = -3686.2345266594;
    RMMapContents *newContents=[RMMapContents alloc];
    RMPath *point1=[[RMPath alloc]initWithContents:newContents];[point1 moveToXY:prjPnt];
    RMPath *point2=[[RMPath alloc]initWithContents:newContents];[point2 moveToXY:prjPnt2];
    NSMutableArray *nodeArray=[[NSMutableArray alloc]initWithObjects:point1,point2,nil];
    
    parameters=[[FindPathParameters alloc]init:NO bHasLeastEdgeCount:NO nodes:nodeArray parameter:analystParameter];
    XCTAssertFalse(parameters.isAnalystById, @"testConstructorWihtAnalystByPath_isAnalystById");
    XCTAssertFalse(parameters.hasLeastEdgeCount, @"testConstructorWihtAnalystByPath_hasLeastEdgeCount");
    XCTAssertEqual(parameters.nodes, nodeArray, "testConstructorWihtAnalystByPath_nodes");
    XCTAssertEqual(parameters.parameter, analystParameter, "testConstructorWihtAnalystByPath_analystParameter");
    
}

-(void)testToStringWihtAnalystByPath{
    
    TransportationAnalystParameter *analystParameter=[[TransportationAnalystParameter alloc]init];
    
    RMProjectedPoint prjPnt; prjPnt.easting = 2328.5375449003; prjPnt.northing = -3656.9550357373;
    RMProjectedPoint prjPnt2;  prjPnt2.easting = 4129.2262366137; prjPnt2.northing = -3686.2345266594;
    RMMapContents *newContents=[RMMapContents alloc];
    RMPath *point1=[[RMPath alloc]initWithContents:newContents];[point1 moveToXY:prjPnt];
    RMPath *point2=[[RMPath alloc]initWithContents:newContents];[point2 moveToXY:prjPnt2];
    NSMutableArray *nodeArray=[[NSMutableArray alloc]initWithObjects:point1,point2,nil];
    
    parameters=[[FindPathParameters alloc]init:NO bHasLeastEdgeCount:NO nodes:nodeArray parameter:analystParameter];
    
    XCTAssertNoThrow([parameters toString], @"toStringWihtAnalystByPath");
}

-(void)testToStringWihtAnalystById{
    NSMutableArray *nodeArray=[[NSMutableArray alloc]initWithObjects:[NSNumber numberWithFloat:2657],[NSNumber numberWithFloat:2525],nil];
    TransportationAnalystParameter *analystParameter=[[TransportationAnalystParameter alloc]init];
    parameters=[[FindPathParameters alloc]init:YES bHasLeastEdgeCount:YES nodes:nodeArray parameter:analystParameter];
   
    XCTAssertNoThrow([parameters toString], @"toStringWihtAnalystById");
}
@end
