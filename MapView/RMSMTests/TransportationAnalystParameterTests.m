//
//  TransportationAnalystParameterTests.m
//  MapView
//
//  Created by iclient on 14-6-19.
//
//

#import <XCTest/XCTest.h>
#import "TransportationAnalystParameter.h"

@interface TransportationAnalystParameterTests : XCTestCase
{
    TransportationAnalystParameter *analystParameter;
}
@end

@implementation TransportationAnalystParameterTests

- (void)setUp
{
    [super setUp];
    analystParameter=[[TransportationAnalystParameter alloc]init];

}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [analystParameter autorelease];
    [super tearDown];
}

- (void)testConstructor
{
    XCTAssertEqual([analystParameter.barrierEdgeIDs count], 0, @"barrierEdgeIDs");
    XCTAssertEqual([analystParameter.barrierNodeIDs count], 0, @"barrierNodeIDs");
    XCTAssertEqual([analystParameter.barrierPoints count], 0, @"barrierPoints");
    XCTAssertEqual([analystParameter.weightFieldName length],0, @"weightFieldName");
    XCTAssertEqual([analystParameter.turnWeightField length],0, @"turnWeightField");
}

- (void)testProperties
{
    TransportationAnalystResultSetting *resultSetting=[[TransportationAnalystResultSetting alloc]init];
    NSMutableArray *barrierEdgeIDs=[[NSMutableArray alloc]initWithObjects:[NSNumber numberWithInt:1],[NSNumber numberWithInt:2],[NSNumber numberWithInt:3],[NSNumber numberWithInt:4],nil];
    
     NSMutableArray *barrierNodeIDs=[[NSMutableArray alloc]initWithObjects:[NSNumber numberWithInt:1],[NSNumber numberWithInt:2],nil];

    analystParameter.barrierEdgeIDs=barrierEdgeIDs;
    analystParameter.barrierNodeIDs=barrierNodeIDs;
    analystParameter.resultSetting=resultSetting;
    analystParameter.weightFieldName=@"SMID";
    analystParameter.turnWeightField=@"length";
    
    XCTAssertEqual([analystParameter barrierEdgeIDs],barrierEdgeIDs, @"barrierEdgeIDs");
    XCTAssertEqual(analystParameter.barrierNodeIDs, barrierNodeIDs, @"barrierNodeIDs");
    XCTAssertEqual(analystParameter.resultSetting, resultSetting, @"resultSetting");
    XCTAssertEqual([analystParameter.barrierPoints count], 0, @"barrierPoints");
    XCTAssertEqual( analystParameter.weightFieldName,@"SMID", @"weightFieldName");
    XCTAssertEqual(analystParameter.turnWeightField,@"length", @"turnWeightField");
}

-(void)testToStringWithConstructor{
    XCTAssertNoThrow([analystParameter toString], @"testToStringWithConstructor");
}

-(void)testToStringWithProperties{
    
    TransportationAnalystResultSetting *resultSetting=[[TransportationAnalystResultSetting alloc]init];
    NSMutableArray *barrierEdgeIDs=[[NSMutableArray alloc]initWithObjects:[NSNumber numberWithInt:1],[NSNumber numberWithInt:2],[NSNumber numberWithInt:3],[NSNumber numberWithInt:4],nil];
    
    NSMutableArray *barrierNodeIDs=[[NSMutableArray alloc]initWithObjects:[NSNumber numberWithInt:1],[NSNumber numberWithInt:2],nil];
    
    analystParameter.barrierEdgeIDs=barrierEdgeIDs;
    analystParameter.barrierNodeIDs=barrierNodeIDs;
    analystParameter.resultSetting=resultSetting;
    analystParameter.weightFieldName=@"SMID";
    analystParameter.turnWeightField=@"length";
    
    XCTAssertNoThrow([analystParameter toString], @"testToStringWithProperties");
}
@end
