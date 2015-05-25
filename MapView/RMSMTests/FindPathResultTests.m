//
//  FindPathResultTests.m
//  MapView
//
//  Created by iclient on 14-6-18.
//
//

#import <XCTest/XCTest.h>
#import "FindPathResult.h"
#import "Path.h"
@interface FindPathResultTests : XCTestCase
{
    FindPathResult *result;
}

@end

@implementation FindPathResultTests

- (void)setUp
{
    [super setUp];
    result=[[FindPathResult alloc]init];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}


- (void)testConstructor
{
    XCTAssertNil(result.pathList, @"pathList");
}


@end
