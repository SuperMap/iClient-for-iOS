//
//  PathTests.m
//  MapView
//
//  Created by iclient on 14-6-19.
//
//

#import <XCTest/XCTest.h>
#import "Path.h"
@interface PathTests : XCTestCase
{
    Path *path;
}
@end

@implementation PathTests

- (void)setUp
{
    path=[[Path alloc]init];
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
    XCTAssertNil(path.edgeFeatures, @"pathList");
    XCTAssertNil(path.edgeIDs,@"pathList");
    XCTAssertNil(path.nodeFeatures, @"pathList");
    XCTAssertNil(path.nodeIDs, @"pathList");
    XCTAssertEqual(path.weight, 0.000, @"pathList");
}

@end
