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
#import "RMImageSource.h"

@interface ViewController (){

    CALayer *subLayer ;
    RMImageSource *imageSource;
    UIImage *image;

}

@end
@implementation ViewController
@synthesize mapView;
- (void)viewDidLoad {
    [super viewDidLoad];
    //////////////////////
    //打开天地图服务示范代码
    //////////////////////
    CGRect bounds = [[UIScreen mainScreen] bounds];
    [self setMapView:[[RMMapView alloc] initWithFrame:CGRectMake(0.0, 0.0, bounds.size.width, bounds.size.height)] ];
    //self.view = mapView;
    [super loadView];
    [self.view insertSubview:mapView atIndex:0];
    //RMMapContents *mapContents;
    mapView.delegate=self;
    /////////////////////////
    
//    //打开天地图矢量底图
    SMTianDiTuTileSource* tianditu = [[SMTianDiTuTileSource alloc] init];
    mapContents = [[RMMapContents alloc] initWithView:mapView tilesource:tianditu];
//
//    //添加天地图标注图
    SMTianDiTu_cva_c_TileSource *cva=[[SMTianDiTu_cva_c_TileSource alloc]init];
    [mapContents addTileSource:(id<RMTileSource>)cva atIndex:1];

    
    [mapView setContents:mapContents];
    
    // 瓦片地图上叠加图片
    RMProjectedRect projRect =   RMMakeProjectedRect(73.620048522949, 3.8537260781999, 61.148414611821, 49.700015376878);
    imageSource = [[RMImageSource alloc] initWithUrl:@"http://support.supermap.com.cn:8090/iserver/iClient/forJavaScript/examples/images/china.png" mapContents:mapContents imageBounds:projRect];
    
//     RMProjectedRect projRect =   RMMakeProjectedRect(-180, -90, 360, 180);
//     imageSource = [[RMImageSource alloc] initWithUrl:@"http://support.supermap.com.cn:8090/iserver/iClient/forJavaScript/examples/images/Day.jpg" mapContents:mapContents imageBounds:projRect];
    
    CALayer *layer =   [mapView layer];
    subLayer = [[CALayer alloc] init];
    image =[imageSource image];
    if (image) {
        subLayer.contents = (id)image.CGImage;
    }
    subLayer.position = [imageSource center];
    subLayer.bounds = [imageSource screenBounds];
    [subLayer setOpacity:0.4];
    
     // 叠加图片
//    [layer addSublayer:subLayer];

}
-(void)afterMapMove:(RMMapView *)map
{
    image =[imageSource image];
    if (image) {
        subLayer.contents = (id)image.CGImage;
    }
    subLayer.position = [imageSource center];
    subLayer.bounds = [imageSource screenBounds];
    
}

-(void)afterMapZoom:(RMMapView *)map byFactor:(float)zoomFactor near:(CGPoint)center{

    image =[imageSource image];
    if (image) {
        subLayer.contents = (id)image.CGImage;
    }
    subLayer.position = [imageSource center];
    subLayer.bounds = [imageSource screenBounds];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (IBAction)moveClick:(id)sender
{   //设置地图范围
    CLLocationCoordinate2D NE={.longitude=120,.latitude=39};
    CLLocationCoordinate2D SW={.longitude=115,.latitude=38.5};
    [mapContents zoomWithLatLngBoundsNorthEast:NE SouthWest:SW];
}

@end
