//
//  PathGuideItemTests.m
//  MapView
//
//  Created by iclient on 14-6-19.
//
//

#import <XCTest/XCTest.h>
#import "PathGuideItem.h"
@interface PathGuideItemTests : XCTestCase
{
    PathGuideItem *pathGuide;
}
@end

@implementation PathGuideItemTests

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
    XCTAssertNil(pathGuide.description, @"description");
     XCTAssertNil(pathGuide.name, @"name");
     XCTAssertNil(pathGuide.sideType, @"sideType");
    XCTAssertNil(pathGuide.turnType, @"turnType");
    XCTAssertNil(pathGuide.directionType, @"directionType");
    XCTAssertNil(pathGuide.geometry, @"geometry");
    
  }

@end
