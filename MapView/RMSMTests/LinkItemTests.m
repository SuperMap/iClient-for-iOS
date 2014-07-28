//
//  LinkItemTests.m
//  MapView
//
//  Created by iclient on 14-7-21.
//
//

#import <XCTest/XCTest.h>
#import "LinkItem.h"
@interface LinkItemTests : XCTestCase

@end

@implementation LinkItemTests

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
    DatasourceConnectionInfo *dataSourceConnectionInfo=[[DatasourceConnectionInfo alloc]init];
    dataSourceConnectionInfo.alias=@"linkAlias";
    dataSourceConnectionInfo.connect=YES;
    NSString *foreignKeys=@"key";
     NSString *foreignTable=@"foreignTable";
    LinkItem *linkItem=[[LinkItem alloc]init];
    linkItem.datasourceConnectionInfo=dataSourceConnectionInfo;
    linkItem.foreignKeys=foreignKeys;
    linkItem.foreignTable=foreignTable;
    XCTAssertNotNil(linkItem, @"linkItem is not null");
    XCTAssertEqual(linkItem.datasourceConnectionInfo, dataSourceConnectionInfo, @"linkItem.datasourceConnectionInfo");
    XCTAssertEqual(linkItem.foreignKeys, foreignKeys,@"linkItem.foreignKeys");
    XCTAssertEqual(linkItem.foreignTable, foreignTable,@"inkItem.foreignTable");
    XCTAssertNil(linkItem.linkFields, @"linkItem.linkFields");
     XCTAssertNil(linkItem.linkFilter, @"linkItem.linkFilter");
     XCTAssertNil(linkItem.name, @"linkItem.name");
     XCTAssertEqual([[linkItem primaryKeys]count],0, @"linkItem.linkFields");
    

    
}

@end
