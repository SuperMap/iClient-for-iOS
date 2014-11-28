//
//  ViewController.m
//  simplemap
//
//  Created by iclient on 13-9-2.
//  Copyright (c) 2014年 iclient. All rights reserved.
//

#import "ViewController.h"
#import "ServerStytle.h"
@interface ViewController ()

@end

@implementation ViewController
{
    NSString *tileThing ;
    RMSMTileSource* smSource1 ;
    NSString *tileThing2 ;
}
@synthesize mapView;
- (void)loadView {
    CGRect bounds = [[UIScreen mainScreen] bounds];
    [self setMapView:[[RMMapView alloc] initWithFrame:CGRectMake(0.0, 0.0, bounds.size.width, bounds.size.height)] ];
    self.view = mapView;
    
    tileThing = @"http://192.168.1.24:8090/iserver/services/map-changchun/rest/maps/长春市区图";
    //最佳路径分析服务地址
    tileThing2= @"http://192.168.1.24:8090/iserver/services/spatialanalyst-changchun/restjsr/spatialanalyst";
    
    info = [[RMSMLayerInfo alloc] initWithTile:@"Changchun" linkurl:tileThing];
    // 判断获取iServer服务配置信息失败，为NULL时失败
    NSAssert(info != NULL,@"RMSMLayerInfo Connect fail");
    smSource1 = [[RMSMTileSource alloc] initWithInfo:info];
    newContents = [[RMMapContents alloc] initWithView:mapView tilesource:smSource1];
    [mapView setContents:newContents];
    
    RMProjectedPoint prjPnt;
    prjPnt.easting = 4503;
    prjPnt.northing = -3861;
    
    [newContents setCenterProjectedPoint:prjPnt];
    newContents.zoom = 1;
    
    //动态分段
    [self generateSpatialData];
}

-(void)generateSpatialData
{
    
    DataReturnOption *option=[[DataReturnOption alloc]initWithDataset:@"generateSpatialDatas@Changchun"];
    
    GenerateSpatialDataParameters *param=[[GenerateSpatialDataParameters alloc]initWithRouteTable:@"RouteDT_road@Changchun" routeIDField:@"RouteID" eventTable:@"LinearEventTabDT@Changchun" eventRouteIDField:@"RouteID" measureStartField:@"LineMeasureFrom" measureEndField:@"LineMeasureTo" dataReturnOption:option];
    
    GenerateSpatialDataService *service=[[GenerateSpatialDataService alloc]initWithURL:tileThing2];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(processCompletedGenerateSpatialData:) name:@"processCompleted" object:nil];
    
    [service processAsync:param];
    
}

-(void)processCompletedGenerateSpatialData:(NSNotification *)notification
{
    if (notification.userInfo) {
        //获取动态分段的结果
        GenerateSpatialDataResult *result=[notification.userInfo objectForKey:@"GenerateSpatialDataResult"];
        if(result && result.dataset)
        {
            
            NSString *datasetName=[[result.dataset componentsSeparatedByString:@"@"]objectAtIndex:0];
            
            ServerStytle* stytle1 =[[ServerStytle alloc]initLineStytleWithFillForeColor:[UIColor colorWithRed:242/255.0 green:48/255.0 blue:48/255.0 alpha:1] lineColor:[UIColor colorWithRed:242/255.0 green:48/255.0 blue:48/255.0 alpha:1] lineWidth:1];
            
            ServerStytle* stytle2 =[[ServerStytle alloc]initLineStytleWithFillForeColor:[UIColor colorWithRed:255/255.0 green:159/255.0 blue:25/255.0 alpha:1] lineColor:[UIColor colorWithRed:255/255.0 green:159/255.0 blue:25/255.0 alpha:1] lineWidth:1];
            
            
            ServerStytle* stytle3 =[[ServerStytle alloc]initLineStytleWithFillForeColor:[UIColor colorWithRed:91/255.0 green:195/255.0 blue:69/255.0 alpha:1] lineColor:[UIColor colorWithRed:91/255.0 green:195/255.0 blue:69/255.0 alpha:1] lineWidth:1];
            ServerStytle* defaultStytle =[[ServerStytle alloc]initLineStytleWithFillForeColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1] lineColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1] lineWidth:1];
            
            ThemeUniqueItem *item1=[[ThemeUniqueItem alloc]initWithUnique:@"拥挤" serverStyle:stytle1];
            ThemeUniqueItem *item2=[[ThemeUniqueItem alloc]initWithUnique:@"缓行" serverStyle:stytle2];
            ThemeUniqueItem *item3=[[ThemeUniqueItem alloc]initWithUnique:@"畅通" serverStyle:stytle3];
            NSMutableArray *items=[[NSMutableArray alloc]initWithObjects:item1,item2,item3,nil];
            
            ThemeUnique *themeUinque=[[ThemeUnique alloc]initWithUniqueExpression:@"TrafficStatus"items:items defaultStyle:defaultStytle];
            
            ThemeParameters *param=[[ThemeParameters alloc]initWithDatasetNames:datasetName  dataSourceName:@"Changchun"  themeUnique:themeUinque];
            ThemeService *service=[[ThemeService alloc]initWithURL:tileThing];
            
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(processCompletedTheme:) name:@"processCompleted" object:nil];
            
            [service processAsync:param];
            
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//最佳路径分析结果
-(void)processCompletedTheme:(NSNotification *)notification

{
    if (notification.userInfo) {
        ThemeResult *result=[notification.userInfo objectForKey:@"ThemeResult"];
        if(result.resourceInfo && result.resourceInfo.resourceID)
        {
            NSMutableDictionary *infoParam=[[NSMutableDictionary alloc]initWithObjectsAndKeys:result.resourceInfo.resourceID,@"layersID",[NSNumber numberWithBool:NO],@"cacheEnabled",nil];
            
            info2 = [[RMSMLayerInfo alloc] initWithTile:@"theme" linkurl:tileThing params:infoParam];
            // 判断获取iServer服务配置信息失败，为NULL时失败
            NSAssert(info2 != NULL,@"RMSMLayerInfo2 Connect fail");
            RMSMTileSource* smSource2 = [[RMSMTileSource alloc] initWithInfo:info2];
            [newContents addTileSource:smSource2 atIndex:1];
            
        }
    }
}


@end
