//
//  ViewController.m
//  simplemap
//
//  Created by iclient on 13-9-2.
//  Copyright (c) 2014年 iclient. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize mapView;
- (void)loadView {
    CGRect bounds = [[UIScreen mainScreen] bounds];
    [self setMapView:[[RMMapView alloc] initWithFrame:CGRectMake(0.0, 0.0, bounds.size.width, bounds.size.height)] ];
    self.view = mapView;
    NSString *tileThing = @"http://support.supermap.com.cn:8090/iserver/services/map-changchun/rest/maps/长春市区图";
    NSString *tileThing2= @"http://support.supermap.com.cn:8090/iserver/services/transportationanalyst-sample/rest/networkanalyst/RoadNet@Changchun";
    info = [[RMSMLayerInfo alloc] initWithTile:@"Changchun" linkurl:tileThing];
    // 判断获取iServer服务配置信息失败，为NULL时失败
    NSAssert(info != NULL,@"RMSMLayerInfo Connect fail");
    RMSMTileSource* smSource = [[RMSMTileSource alloc] initWithInfo:info];
    newContents = [[RMMapContents alloc] initWithView:mapView tilesource:smSource];
    //[newContents set]
    [mapView setContents:newContents];
    RMProjectedPoint prjPnt;
    prjPnt.easting = 2328.5375449003;
    prjPnt.northing = -3656.9550357373;
    [newContents setCenterProjectedPoint:prjPnt];
    newContents.zoom = 1;
    
    //最佳路径分析
    //TransportationAnalystResultSetting *resultSetting=[[TransportationAnalystResultSetting alloc]init];
    TransportationAnalystParameter *analystParameter=[[TransportationAnalystParameter alloc]init];
    analystParameter.weightFieldName=@"length";
    
    
   // RMProjectedPoint prjPnt1;
   // prjPnt1.easting = 2328.5375449003;
  //  prjPnt1.northing = -3656.9550357373;
    RMProjectedPoint prjPnt2;
    prjPnt2.easting = 4129.2262366137;
    prjPnt2.northing = -3686.2345266594;
    RMPath *point1=[[RMPath alloc]initWithContents:newContents];
    [point1 moveToXY:prjPnt];
    RMPath *point2=[[RMPath alloc]initWithContents:newContents];
    [point2 moveToXY:prjPnt2];
   
    UIImage *image = [UIImage imageNamed:@"marker.png"];
    RMMarker *newMarker = [[RMMarker alloc] initWithUIImage:image anchorPoint:CGPointMake(0.5, 1)];
     RMMarker *newMarker2 = [[RMMarker alloc] initWithUIImage:image anchorPoint:CGPointMake(0.5, 1)];
    [mapView.contents.markerManager addMarker:newMarker atProjectedPoint:prjPnt];
    [mapView.contents.markerManager addMarker:newMarker2 atProjectedPoint:prjPnt2];
    
   // NSMutableArray *nodeArray=[[NSMutableArray alloc]initWithObjects:[NSNumber numberWithFloat:2657],[NSNumber numberWithFloat:2525],nil];
    NSMutableArray *nodeArray=[[NSMutableArray alloc]initWithObjects:point1,point2, nil];
    
    //最佳路径分析参数设置
    FindPathParameters *parameters=[[FindPathParameters alloc]init:NO bHasLeastEdgeCount:NO nodes:nodeArray parameter:analystParameter];
    
    FindPathService *findPathService=[[FindPathService alloc]init:tileThing2];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(processCompleted:) name:@"processCompleted" object:nil];
    [findPathService processAsync:parameters];
    
    
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)processCompleted:(NSNotification *)notification

{
    if (notification.userInfo) {
        FindPathResult *result=[notification.userInfo objectForKey:@"FindPathResult"];
        
        for (int j=0; j<[result.pathList count];j++ ) {
            NSMutableArray *pathGuideItems=[[result.pathList objectAtIndex:j] pathGuideItems];
            int ncount=[pathGuideItems count];
            for (int k=0; k<ncount;k++ ) {
               
                ServerGeometry *guideGeometry=[[pathGuideItems objectAtIndex:k]geometry];
                //行驶引导描述信息
                NSString *description=[[pathGuideItems objectAtIndex:k]description];
                NSLog(@"%@",description);
                RMPath *path=[guideGeometry toRMPath:newContents];
                //加载图层
                [mapView.contents.overlay addSublayer:path];
            }
        }
        
    }
    
}


@end
