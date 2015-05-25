    //
    //  FindPathServiceTests.m
    //  MapView
    //
    //  Created by iclient on 14-6-18.
    //
    //

    #import <XCTest/XCTest.h>
    #import "FindPathService.h"

    @interface FindPathServiceTests : XCTestCase
    {
        FindPathService *findPathService;
        FindPathResult *result;
        
    }
    @end

    @implementation FindPathServiceTests

    - (void)setUp
    {
        
        [super setUp];
        findPathService=[[FindPathService alloc]init:@"http://support.supermap.com.cn:8090/iserver/services/transportationanalyst-sample/rest/networkanalyst/RoadNet@Changchun"];
    }

    - (void)tearDown
    {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        [super tearDown];
    }
    //Test Default Parameters,
    - (void)testDefaultParameters_analystById
    {
        TransportationAnalystParameter *analystParameter=[[TransportationAnalystParameter alloc]init];
        NSMutableArray *nodeArray=[[NSMutableArray alloc]initWithObjects:[NSNumber numberWithFloat:3495],[NSNumber numberWithFloat:3259],nil];
        FindPathParameters *parameters=[[FindPathParameters alloc]init:YES bHasLeastEdgeCount:YES nodes:nodeArray parameter:analystParameter];
        
        XCTAssertNoThrow([findPathService processAsync:parameters],@"DefaultParameters_analystById_processAsync");
        
        result=findPathService.lastResult;
        
        XCTAssertNotNil(result.pathList,@"testDefaultParameters_analystById_lastResult");
    }

    - (void)testDefaultParameters_analystByPath{
        
        TransportationAnalystParameter *analystParameter=[[TransportationAnalystParameter alloc]init];
        
        RMProjectedPoint prjPnt; prjPnt.easting = 2328.5375449003; prjPnt.northing = -3656.9550357373;
        RMProjectedPoint prjPnt2;  prjPnt2.easting = 4129.2262366137; prjPnt2.northing = -3686.2345266594;
        RMMapContents *newContents=[RMMapContents alloc];
        RMPath *point1=[[RMPath alloc]initWithContents:newContents];[point1 moveToXY:prjPnt];
        RMPath *point2=[[RMPath alloc]initWithContents:newContents];[point2 moveToXY:prjPnt2];
        NSMutableArray *nodeArray=[[NSMutableArray alloc]initWithObjects:point1,point2,nil];
        
        FindPathParameters *parameters=[[FindPathParameters alloc]init:NO bHasLeastEdgeCount:YES nodes:nodeArray parameter:analystParameter];
        
        XCTAssertNoThrow([findPathService processAsync:parameters],@"testDefaultParameters_analystByPath_processAsync");
        result=findPathService.lastResult;
        XCTAssertNotNil(result.pathList,@"testDefaultParameters_analystByPath_lastResult");
    }

    - (void)testReturn{
        
        TransportationAnalystResultSetting *resultSetting=[[TransportationAnalystResultSetting alloc]init];
        resultSetting.returnEdgeFeatures=YES;
        resultSetting.returnEdgeGeometry=YES;
        resultSetting.returnEdgeIDs=YES;
        resultSetting.returnNodeFeatures=YES;
        resultSetting.returnNodeGeometry=YES;
        resultSetting.returnNodeIDs=YES;
        
        TransportationAnalystParameter *analystParameter=[[TransportationAnalystParameter alloc]init];
        analystParameter.weightFieldName=@"length";
        analystParameter.resultSetting=resultSetting;
        RMProjectedPoint prjPnt; prjPnt.easting = 2328.5375449003; prjPnt.northing = -3656.9550357373;
        RMProjectedPoint prjPnt2;  prjPnt2.easting = 4129.2262366137; prjPnt2.northing = -3686.2345266594;
        RMMapContents *newContents=[RMMapContents alloc];
        RMPath *point1=[[RMPath alloc]initWithContents:newContents];[point1 moveToXY:prjPnt];
        RMPath *point2=[[RMPath alloc]initWithContents:newContents];[point2 moveToXY:prjPnt2];
        NSMutableArray *nodeArray=[[NSMutableArray alloc]initWithObjects:point1,point2,nil];
        
        FindPathParameters *parameters=[[FindPathParameters alloc]init:NO bHasLeastEdgeCount:YES nodes:nodeArray parameter:analystParameter];
        
        XCTAssertNoThrow([findPathService processAsync:parameters],@"testReturn_processAsync");
        result=findPathService.lastResult;
        XCTAssertNotNil([result.pathList objectAtIndex:0],@"testReturn_pathList");
        XCTAssertNotNil([[[result.pathList objectAtIndex:0] pathGuideItems ]objectAtIndex:0],@"testReturn_pathList_pathGuideItems");
        XCTAssertNotNil([[[[result.pathList objectAtIndex:0] pathGuideItems]objectAtIndex:0]geometry],@"testReturn_pathList_pathGuideItems_geometry");
        XCTAssertNotNil([[[[result.pathList objectAtIndex:0] pathGuideItems]objectAtIndex:0]description], @"testReturn_pathList_pathGuideItems_description");
        
        XCTAssertNotNil([[[[result pathList]objectAtIndex:0]edgeIDs]objectAtIndex:0],@"testReturn_pathList_edgeIDs");
        XCTAssertNotNil([[[[[result pathList]objectAtIndex:0]edgeFeatures]objectAtIndex:0] fieldNames],@"testReturn_pathList_edgeFeatures");
        XCTAssertNotNil([[[[result pathList]objectAtIndex:0]nodeIDs]objectAtIndex:0],@"testReturn_pathList_nodeIDs");
        XCTAssertNotNil([[[[[result pathList]objectAtIndex:0]nodeFeatures]objectAtIndex:0]fieldNames],@"testReturn_pathList_nodeFeatures");
    
    }

- (void)testParameters_analystByPath_butIdArray
{
    TransportationAnalystParameter *analystParameter=[[TransportationAnalystParameter alloc]init];
    NSMutableArray *nodeArray=[[NSMutableArray alloc]initWithObjects:[NSNumber numberWithFloat:3495],[NSNumber numberWithFloat:3259],nil];
    FindPathParameters *parameters=[[FindPathParameters alloc]init:YES bHasLeastEdgeCount:NO nodes:nodeArray parameter:analystParameter];
    
    XCTAssertNoThrow([findPathService processAsync:parameters],@"parameters_analystByPath_butIdArray");
    

}

- (void)testParameters_analystById_butPathArray
{
    TransportationAnalystParameter *analystParameter=[[TransportationAnalystParameter alloc]init];
    
    RMProjectedPoint prjPnt; prjPnt.easting = 2328.5375449003; prjPnt.northing = -3656.9550357373;
    RMProjectedPoint prjPnt2;  prjPnt2.easting = 4129.2262366137; prjPnt2.northing = -3686.2345266594;
    RMMapContents *newContents=[RMMapContents alloc];
    RMPath *point1=[[RMPath alloc]initWithContents:newContents];[point1 moveToXY:prjPnt];
    RMPath *point2=[[RMPath alloc]initWithContents:newContents];[point2 moveToXY:prjPnt2];
    NSMutableArray *nodeArray=[[NSMutableArray alloc]initWithObjects:point1,point2,nil];
    
    FindPathParameters *parameters=[[FindPathParameters alloc]init:YES bHasLeastEdgeCount:NO nodes:nodeArray parameter:analystParameter];
    
   // XCTAssertNoThrow([findPathService processAsync:parameters],@"parameters_analystById_butPathArray");
    
   
    XCTAssertThrows([findPathService processAsync:parameters],@"parameters_analystById_butPathArray");
    
}

- (void)testParameters_analystParameter_wihtWrongWeightFieldName
{
    TransportationAnalystParameter *analystParameter=[[TransportationAnalystParameter alloc]init];
    analystParameter.weightFieldName=@"length1";
    NSMutableArray *nodeArray=[[NSMutableArray alloc]initWithObjects:[NSNumber numberWithFloat:3495],[NSNumber numberWithFloat:3259],nil];
    FindPathParameters *parameters=[[FindPathParameters alloc]init:YES bHasLeastEdgeCount:YES nodes:nodeArray parameter:analystParameter];
    
    XCTAssertNoThrow([findPathService processAsync:parameters],@"parameters_analystParameter_wihtWrongWeightFieldName");
    XCTAssertNil(result.pathList,@"testDefaultParameters_analystById_lastResult");
}


@end
