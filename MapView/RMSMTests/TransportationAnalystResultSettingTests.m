//
//  TransportationAnalystResultSettingTests.m
//  MapView
//
//  Created by iclient on 14-6-19.
//
//

#import <XCTest/XCTest.h>
#import "TransportationAnalystResultSetting.h"

@interface TransportationAnalystResultSettingTests : XCTestCase
{
    TransportationAnalystResultSetting *resultSetting;
}

@end

@implementation TransportationAnalystResultSettingTests

- (void)setUp
{
    [super setUp];
     resultSetting=[[TransportationAnalystResultSetting alloc]init];
   
}

- (void)tearDown
{
    [resultSetting autorelease];
    [super tearDown];
}

- (void)testConstructor
{
    XCTAssertEqual(resultSetting.returnEdgeFeatures, NO, @"returnEdgeFeatures");
    XCTAssertEqual(resultSetting.returnEdgeGeometry, NO, @"returnEdgeGeometry");
    XCTAssertEqual(resultSetting.returnEdgeIDs, NO, @"returnEdgeIDs");
    XCTAssertEqual(resultSetting.returnNodeFeatures, NO, @"returnNodeFeatures");
    XCTAssertEqual(resultSetting.returnNodeGeometry, NO, @"returnNodeGeometry");
    XCTAssertEqual(resultSetting.returnNodeIDs, NO, @"returnNodeIDs");
    XCTAssertEqual(resultSetting.returnPathGuides, YES, @"returnPathGuides");
}

- (void)testProperties
{
    resultSetting.returnEdgeFeatures=YES;
    resultSetting.returnEdgeGeometry=YES;
    resultSetting.returnEdgeIDs=YES;
    resultSetting.returnNodeFeatures=YES;
    resultSetting.returnNodeGeometry=YES;
    resultSetting.returnNodeIDs=YES;
    resultSetting.returnPathGuides=NO;
    
    XCTAssertEqual(resultSetting.returnEdgeFeatures, YES, @"returnEdgeFeatures");
    XCTAssertEqual(resultSetting.returnEdgeGeometry, YES, @"returnEdgeGeometry");
    XCTAssertEqual(resultSetting.returnEdgeIDs, YES, @"returnEdgeIDs");
    XCTAssertEqual(resultSetting.returnNodeFeatures, YES, @"returnNodeFeatures");
    XCTAssertEqual(resultSetting.returnNodeGeometry, YES, @"returnNodeGeometry");
    XCTAssertEqual(resultSetting.returnNodeIDs, YES, @"returnNodeIDs");
    XCTAssertEqual(resultSetting.returnPathGuides, NO, @"returnPathGuides");
}

-(void)testToString{
    
    XCTAssertNoThrow([resultSetting toString], @"toString");
}
@end
