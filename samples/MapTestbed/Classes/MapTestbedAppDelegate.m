//
//  MapTestbedAppDelegate.m
//  MapTestbed : Diagnostic map
//

#import "MapTestbedAppDelegate.h"
#import "RootViewController.h"
#import "MainViewController.h"

#import "RMPath.h"
#import "RMMarker.h"
#import "RMMarkerManager.h"
#import "RMSMMeasureService.h"
#import "ServerGeometry.h"
#import "QueryParameters.h"
#import "JoinItem.h"
#import "FilterParameter.h"
#import "QueryByBoundsParameters.h"
#import "QueryByBoundsService.h"
#import "QueryResult.h"
#import "ServerFeature.h"
#import "QueryByDistanceService.h"
#import "QueryByDistanceParameters.h"
#import "QueryBySQLParameters.h"
#import "QueryBySQLService.h"
#import "QueryByGeometryService.h"
#import "QueryByGeometryParameters.h"

@implementation MapTestbedAppDelegate


@synthesize window;
@synthesize rootViewController;

static void saveApplier(void* info, const CGPathElement* element)
{
	NSMutableArray* a = (NSMutableArray*) info;
    
	int nPoints;
	switch (element->type)
	{
		case kCGPathElementMoveToPoint:
			nPoints = 1;
			break;
		case kCGPathElementAddLineToPoint:
			nPoints = 1;
			break;
		case kCGPathElementAddQuadCurveToPoint:
			nPoints = 2;
			break;
		case kCGPathElementAddCurveToPoint:
			nPoints = 3;
			break;
		case kCGPathElementCloseSubpath:
			nPoints = 0;
			break;
		default:
			[a replaceObjectAtIndex:0 withObject:[NSNumber numberWithBool:NO]];
			return;
	}
    
	//NSNumber* type = [NSNumber numberWithInt:element->type];
	//NSData* points = [NSData dataWithBytes:element->points length:nPoints*sizeof(CGPoint)];
    //NSLog(@"num is %d",nPoints);
	//[a addObject:element->points];
    [a addObject:[NSNumber numberWithDouble:element->points[0].x]];
    [a addObject:[NSNumber numberWithDouble:element->points[0].y]];
}

-(RMMapContents *)mapContents
{
	return self.rootViewController.mainViewController.mapView.contents;
}
-(void)performTestPart2
{
	// a bug exists that offsets the path when we execute this moveToLatLong
	CLLocationCoordinate2D pt;
	pt.latitude = 48.86600492029781f;
	pt.longitude = 2.3194026947021484f;
	
	[self.mapContents moveToLatLong: pt];
}


-(void)performTestPart3
{
	// path returns to correct position after this zoom
	CLLocationCoordinate2D northeast, southwest;
	northeast.latitude = 48.885875363989435f;
	northeast.longitude = 2.338285446166992f;
	southwest.latitude = 48.860406466081656f;
	southwest.longitude = 2.2885894775390625;
	
	[self.mapContents zoomWithLatLngBoundsNorthEast:northeast SouthWest:southwest];
}	

/*
-(void) measureComplete
{
    NSLog(@"tt");
    //NSDictionary *dict = [notification userInfo];
}
 */
- (void)processCompleted:(NSNotification *)notification
{
    NSMutableDictionary *dict = [notification userInfo];
    UIImage *xMarkerImage = [UIImage imageNamed:@"marker-X.png"];
    
    NSLog(@"dict2:%@",dict);
    QueryResult* pRes = [dict objectForKey:@"QueryResult"];
    
    RMMapContents *mapContents = [self mapContents];
    
    int nCount = [pRes.recordsets count];
    for (int i=0; i<nCount; i++) {
        Recordset* pRs = [pRes.recordsets objectAtIndex:i];
        
        
        int nNum = [[[pRes.recordsets objectAtIndex:i] features] count];
        NSLog(@"%d",nNum);
        
        for (int j=0; j<nNum; j++) {
            ServerFeature* pF = [pRs.features objectAtIndex:j];
            
            /*
            CGPoint pnt = [[[[pF geometry] points] objectAtIndex:0] CGPointValue];
            CLLocationCoordinate2D one;
            one.latitude = pnt.y;
            one.longitude = pnt.x;
            
            RMMarker *newMarker;
            newMarker = [[RMMarker alloc] initWithUIImage:xMarkerImage anchorPoint:CGPointMake(0.5, 1.0)];
            [mapContents.markerManager addMarker:[newMarker autorelease] AtLatLong:one];
             */
            RMPath* testPath = [[pF geometry] toRMPath:mapContents];
    [testPath setLineColor:[UIColor clearColor]];
	[testPath setFillColor:[UIColor blueColor]];
	[testPath setLineWidth:0.0f];
    
    [[mapContents overlay] addSublayer:testPath];
        }
    }
}

- (void)measureComplete:(NSNotification *)notification
{
    NSDictionary *dict = [notification userInfo];
    
    NSArray *keys = [dict allKeys];
    
	// values in foreach loop
	for (NSString *key in keys) {
		NSLog(@"%@ is %@",key, [dict objectForKey:key]);
	}
}

-(void) measureError:(NSNotification *)notification
{    
    NSDictionary *dict = [notification userInfo];
    
    NSArray *keys = [dict allKeys];
    
	// values in foreach loop
	for (NSString *key in keys) {
		NSLog(@"%@ is %@",key, [dict objectForKey:key]);
	}
}

- (void)performTest
{
    UIImage *xMarkerImage = [UIImage imageNamed:@"markerflag.png"];
    
    CLLocationCoordinate2D one, two, three, four;
	//one.latitude = 4863568.7766;
	//one.longitude = 12969237.6;
    
    RMMapContents *mapContents = [self mapContents];
    
    RMProjectedPoint point;
    point.easting = 12969237.600603817;
    point.northing = 4863568.776619955;
    //one = [[mapContents projection] pointToLatLong:point];
    
    RMMarker *newMarker;
	newMarker = [[RMMarker alloc] initWithUIImage:xMarkerImage anchorPoint:CGPointMake(0.5, 1.0)];
	//[mapContents.markerManager addMarker:[newMarker autorelease] AtLatLong:one];
    [mapContents.markerManager addMarker:[newMarker autorelease] atProjectedPoint:point];
    return; 
    /*
    FilterParameter* pF = [[FilterParameter alloc] init];
    pF.name = [[NSString alloc] initWithString:@"Capitals@World.1"];
    
    QueryParameters* p = [[QueryParameters alloc] init];
    [p.queryParams addObject:pF];
    
    NSMutableArray *myCountryData = [[NSMutableArray alloc] init];
    
    [myCountryData addObject:[p toNSDictionary]];
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:myCountryData
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData
                                                 encoding:NSUTF8StringEncoding];
    
    NSLog(@"%@",jsonString);
    */
    
    
    ///////////////////////////////
    RMPath *testPath, *testRegion;
    
    
    one.latitude = 39.914712153518;
	one.longitude = 4.6055437100213;
    two.latitude = 39.914712153518;
	two.longitude = 47.974413646055;
	three.latitude = 66.780383795309;
	three.longitude = 47.974413646055;
	four.latitude = 66.780383795309;
	four.longitude = 4.6055437100213;
    
	testPath = [[RMPath alloc] initWithContents:mapContents];
	[testPath setLineColor:[UIColor clearColor]];
	[testPath setFillColor:[UIColor blueColor]];
	[testPath setLineWidth:0.0f];
    //[testPath setShadowColor:[UIColor colorWithWhite:0.0 alpha:0.8]];
    //[testPath setShadowBlur:4.0];
    //[testPath setShadowOffset:CGSizeMake(0, 4)];
	[testPath moveToLatLong:one];
	[testPath addLineToLatLong:two];
	[testPath addLineToLatLong:three];
	[testPath addLineToLatLong:four];
    [testPath closePath];

    //[[mapContents overlay] addSublayer:testPath];

    
    
    
    
    
    
    
    
    ///////////////////////////////
    // QueryBySQLService example
    // SuperMap iOS 示例：查询地物并在地图显示该Feature
    //////////////////////////////////
    
    //1 创建查询Service
     QueryBySQLService* ps = [[QueryBySQLService alloc] init:@"http://support.supermap.com.cn:8090/iserver/services/map-world/rest/maps/World"];
     FilterParameter* pF = [[FilterParameter alloc] init];
     pF.name = [[NSString alloc] initWithString:@"Countries@World.1"];
    //2 设置查询SQL： SMID 247 对应中国；SMID 1对应俄罗斯
     pF.attributeFilter = [[NSString alloc] initWithString:@"SMID = 1"];
     
     QueryBySQLParameters* p = [[QueryBySQLParameters alloc] init];
     [p.queryParams addObject:pF];
    
    //3 绑定查询成功的回调函数
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(processCompleted:) name:@"processCompleted" object:nil];
    
    //4 执行！
     [ps processAsync:p];
    
    
     return;
     ///////////////////////////////////
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    // QueryByGeometryService example
    /*/////////////////////////////////
     QueryByGeometryService* ps = [[QueryByGeometryService alloc] init:@"http://support.supermap.com.cn:8090/iserver/services/map-world/rest/maps/World"];
     FilterParameter* pF = [[FilterParameter alloc] init];
     pF.name = [[NSString alloc] initWithString:@"Capitals@World.1"];
         
     QueryByGeometryParameters* p = [[QueryByGeometryParameters alloc] init:testPath];
     [p.queryParams addObject:pF];
     
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(processCompleted:) name:@"processCompleted" object:nil];
     
     [ps processAsync:p];
     
     
     return;
     *///////////////////////////////////
    
    // QueryByDistanceService example
    /*/////////////////////////////////
    QueryByDistanceService* ps = [[QueryByDistanceService alloc] init:@"http://support.supermap.com.cn:8090/iserver/services/map-world/rest/maps/World"];
    FilterParameter* pF = [[FilterParameter alloc] init];
    pF.name = [[NSString alloc] initWithString:@"Capitals@World.1"];
    
    RMPath* pPoint = [[RMPath alloc] initWithContents:mapContents];
    CLLocationCoordinate2D mPoint;
    mPoint.latitude = 31;
    mPoint.longitude = 121;
    [pPoint moveToLatLong:mPoint];
    QueryByDistanceParameters* p = [[QueryByDistanceParameters alloc] init:30 mGeometry:pPoint bNearest:false];
    [p.queryParams addObject:pF];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(processCompleted:) name:@"processCompleted" object:nil];
    
    [ps processAsync:p];
    
    
    return;
    *///////////////////////////////////
    
     // QueryByBoundsService example
    /*//////////////////////////////
    QueryByBoundsService* ps = [[QueryByBoundsService alloc] init:@"http://support.supermap.com.cn:8090/iserver/services/map-world/rest/maps/World"];
    FilterParameter* pF = [[FilterParameter alloc] init];
    pF.name = [[NSString alloc] initWithString:@"Capitals@World.1"];
    
    QueryByBoundsParameters* p = [[QueryByBoundsParameters alloc] init:RMMakeProjectedRect(4.6055437100213,39.914712153518,47.974413646055-4.6055437100213,66.780383795309-39.914712153518)];
    [p.queryParams addObject:pF];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(processCompleted:) name:@"processCompleted" object:nil];
    
    [ps processAsync:p];
    
    
    return;
    *///////////////////////////////
	NSLog(@"testing paths");
	
    return;
	// if we zoom with bounds after the paths are created, nothing is displayed on the map
	CLLocationCoordinate2D northeast, southwest;
	northeast.latitude = 48.885875363989435f;
	northeast.longitude = 2.338285446166992f;
	southwest.latitude = 48.860406466081656f;
	southwest.longitude = 2.2885894775390625;
	//[mapContents zoomWithLatLngBoundsNorthEast:northeast SouthWest:southwest];
	
    one.latitude = 1;
	one.longitude = 3.294340133666992f;
    two.latitude = 2;
	two.longitude = 2.294340133666992f;
	three.latitude = 3;
	three.longitude = 2.2948551177978516f;
	four.latitude = 4;
	four.longitude = 2.3194026947021484f;
	
	// draw a green path south down an avenue and southeast on Champs-Elysees
	//RMPath *testPath, *testRegion;
	testPath = [[RMPath alloc] initWithContents:mapContents];
	[testPath setLineColor:[UIColor greenColor]];
	[testPath setFillColor:[UIColor clearColor]];
	[testPath setLineWidth:4.0f];
    [testPath setShadowColor:[UIColor colorWithWhite:0.0 alpha:0.8]];
    [testPath setShadowBlur:4.0];
    [testPath setShadowOffset:CGSizeMake(0, 4)];
	[testPath moveToLatLong:one];
	[testPath addLineToLatLong:two];
	[testPath addLineToLatLong:three];
	[testPath addLineToLatLong:four];
    [testPath closePath];
    
    ServerGeometry* sg = [[ServerGeometry alloc] fromRMPath:testPath];
    ServerGeometry* sg2 = [[ServerGeometry alloc] fromJson:[sg toJson]];
    RMPath* pp = [sg2 toRMPath:mapContents];
    
    
        /*
    NSArray *info = [NSArray arrayWithArray:arrayOfDicts2];
    
    NSError* error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:info
                                                       options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSLog(@"%@",jsonString);
     */
    
    // RMSMMeasureService example    
    /*/////////////////////////////////////////////
    // 构造量算参数
    RMSMMeasureParameters* para = [[RMSMMeasureParameters alloc] init:pp];
    
    NSString* strUrl = [[NSString alloc] initWithString:@"http://support.supermap.com.cn:8090/iserver/services/map-world/rest/maps/World"];
    // 构造量算服务
    RMSMMeasureService* service = [[RMSMMeasureService alloc] init:strUrl];
    // 绑定量算事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(measureComplete:) name:@"measureComplete" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(measureError:) name:@"measureError" object:nil];
    // 运行量算服务
    [service processAsync:para];
    *//////////////////////////////////////////////
    return;
	[[mapContents overlay] addSublayer:testPath];
	[testPath release];

	//RMMarker *newMarker;
	newMarker = [[RMMarker alloc] initWithUIImage:xMarkerImage anchorPoint:CGPointMake(0.5, 1.0)];
	[mapContents.markerManager addMarker:[newMarker autorelease] AtLatLong:one];
	newMarker = [[RMMarker alloc] initWithUIImage:xMarkerImage anchorPoint:CGPointMake(0.5, 1.0)];
	[mapContents.markerManager addMarker:[newMarker autorelease] AtLatLong:two];
	newMarker = [[RMMarker alloc] initWithUIImage:xMarkerImage anchorPoint:CGPointMake(0.5, 1.0)];
	[mapContents.markerManager addMarker:[newMarker autorelease] AtLatLong:three];
	newMarker = [[RMMarker alloc] initWithUIImage:xMarkerImage anchorPoint:CGPointMake(0.5, 1.0)];
	[mapContents.markerManager addMarker:[newMarker autorelease] AtLatLong:four];
	
	CLLocationCoordinate2D r1, r2, r3, r4;
	r1.latitude = 48.86637615203047f;
	r1.longitude = 2.3236513137817383f;
	r2.latitude = 48.86372241857954f;
	r2.longitude = 2.321462631225586f;
	r3.latitude = 48.86087090984738f;
	r3.longitude = 2.330174446105957f;
	r4.latitude = 48.86369418661614f;
	r4.longitude = 2.332019805908203f;
	
	// draw a blue-filled rectangle on top of the Tuileries
	testRegion = [[RMPath alloc] initWithContents:mapContents];
	[testRegion setFillColor:[UIColor colorWithRed: 0.1 green:0.1 blue: 0.8 alpha: 0.5 ]];
	[testRegion setLineColor:[UIColor blueColor]];
	[testRegion setLineWidth:2.0f];
	[testRegion addLineToLatLong:r1];
	[testRegion addLineToLatLong:r2];
	[testRegion addLineToLatLong:r3];
	[testRegion addLineToLatLong:r4];
	[testRegion closePath];
	[[mapContents overlay] addSublayer:testRegion];
	[testRegion release];
	newMarker = [[RMMarker alloc] initWithUIImage:xMarkerImage anchorPoint:CGPointMake(0.5, 1.0)];
	[mapContents.markerManager addMarker:[newMarker autorelease] AtLatLong:r1];
	newMarker = [[RMMarker alloc] initWithUIImage:xMarkerImage anchorPoint:CGPointMake(0.5, 1.0)];
	[mapContents.markerManager addMarker:[newMarker autorelease] AtLatLong:r2];
	newMarker = [[RMMarker alloc] initWithUIImage:xMarkerImage anchorPoint:CGPointMake(0.5, 1.0)];
	[mapContents.markerManager addMarker:[newMarker autorelease] AtLatLong:r3];
	newMarker = [[RMMarker alloc] initWithUIImage:xMarkerImage anchorPoint:CGPointMake(0.5, 1.0)];
	[mapContents.markerManager addMarker:[newMarker autorelease] AtLatLong:r4];
	
	[self performSelector:@selector(performTestPart2) withObject:nil afterDelay:3.0f]; 
	[self performSelector:@selector(performTestPart3) withObject:nil afterDelay:7.0f]; 
}

- (void)applicationDidFinishLaunching:(UIApplication *)application {
    window.rootViewController = rootViewController;
    [window makeKeyAndVisible];
	
	[self performSelector:@selector(performTest) withObject:nil afterDelay:0.25f]; 

}


- (void)dealloc {
    [rootViewController release];
    [window release];
    [super dealloc];
}

@end
