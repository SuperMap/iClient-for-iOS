//
//  ViewController.m
//  tianditutest
//
//  Created by zhoushibin on 15-4-10.
//  Copyright (c) 2015年 SuperMapSupportCenter. All rights reserved.
//

#import "ViewController.h"
#import "RMMapView.h"
#import "SMTianDiTuTileSource.h"
#import "RMOpenStreetMapSource.h"
#import "RMCloudMapSource.h"
#import "SMTianDiTu_cva_c_TileSource.h"
@interface ViewController ()

@end
@implementation ViewController
@synthesize mapView;
- (void)viewDidLoad {
    [super viewDidLoad];
    //////////////////////
    //打开天地图服务示范代码
    //////////////////////
    NSLog(@"%@",mapView);
    CGRect bounds = [[UIScreen mainScreen] bounds];
    [self setMapView:[[RMMapView alloc] initWithFrame:CGRectMake(0.0, 0.0, bounds.size.width, bounds.size.height)] ];
    //self.view = mapView;
    [super loadView];
    [self.view insertSubview:mapView atIndex:0];
    //RMMapContents *mapContents;
    mapView.delegate=self;
    /////////////////////////
    //打开天地图矢量底图
    SMTianDiTuTileSource* tianditu = [[SMTianDiTuTileSource alloc] init];
    mapContents = [[RMMapContents alloc] initWithView:mapView tilesource:tianditu];
    
    //添加天地图标注图
    SMTianDiTu_cva_c_TileSource *cva=[[SMTianDiTu_cva_c_TileSource alloc]init];
    [mapContents addTileSource:(id<RMTileSource>)cva atIndex:1];
    /////////////////////////
    //叠加iServer发布的数据
//    NSMutableDictionary* params=[[NSMutableDictionary alloc] init];
//    info=[[RMSMLayerInfo alloc]initWithTile:@"China" linkurl:@"http://192.168.18.191:8090/iserver/services/map-World/rest/maps/layers_test@China400" params:params isUseDisplayFilter:YES];
//    RMSMTileSource *smtileSource=[[RMSMTileSource alloc]initWithInfo:info];
//    [mapContents addTileSource:(id<RMTileSource>)smtileSource atIndex:2];
    [mapView setContents:mapContents];
    
    //设置中心点
    RMProjectedPoint prjPnt;
    prjPnt.easting =  118.711610;
    prjPnt.northing = 32.070176;
    [mapContents setCenterProjectedPoint:prjPnt];
    //设置默认出图层级
    mapContents.zoom=5;
    
    //设置地图范围
    CLLocationCoordinate2D NE={.longitude=116,.latitude=39};
    CLLocationCoordinate2D SW={.longitude=115.5,.latitude=38.5};
    
    [mapContents zoomWithLatLngBoundsNorthEast:NE SouthWest:SW];
    //刷新地图
    [mapContents refreshMap];
    //设置图层ID，控制图层显示
    //参数设置图层的索引为字符串[0,1,2].例如服务中有3个图层，需要设置第3个不可见，字符串为[0,1]
    //[mapContents setLayerID:@"[0,1]" forTileSourceAtIndex:2];
//    [mapContents setLayerID:@"[0,1]" forTileSource:smtileSource];
//    
//    NSMutableDictionary *dict =[[NSMutableDictionary alloc] init];
//    [dict setValue:@"SMID < 10" forKey:@"1"];
//    [mapContents setDisplayFilter:dict forTileSource:smtileSource];
    aaa=116;
    
}
-(void)afterMapMove:(RMMapView *)map
{
//     NSLog(@"%f  %f",map.contents.centerProjectedPoint.easting,map.contents.centerProjectedPoint.northing);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)moveClick:(id)sender
{ //设置地图范围
    aaa=aaa+1;
    CLLocationCoordinate2D NE={.longitude=aaa,.latitude=39};
    CLLocationCoordinate2D SW={.longitude=115.5,.latitude=38.5};
    //[mapContents zoomWithLatLngBoundsNorthEast:<#(CLLocationCoordinate2D)#> SouthWest:<#(CLLocationCoordinate2D)#>]
    [mapContents zoomWithLatLngBoundsNorthEast:NE SouthWest:SW];
    //刷新地图
    //[mapContents refreshMap];
}

@end
