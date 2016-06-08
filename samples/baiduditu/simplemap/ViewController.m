//
//  ViewController.m
//  simplemap
//
//  Created by iclient on 13-9-2.
//  Copyright (c) 2014年 iclient. All rights reserved.
//

#import "ViewController.h"
#import "ServerStytle.h"
#import "SMBaiduTileSource.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize mapView;
- (void)loadView {
    
    CGRect bounds = [[UIScreen mainScreen] bounds];
    [self setMapView:[[RMMapView alloc] initWithFrame:CGRectMake(0.0, 0.0, bounds.size.width, bounds.size.height)] ];
    self.view = mapView;
    
    
    //百度数据源
    SMBaiduTileSource *baidu=[[SMBaiduTileSource alloc]init];
    //设置地图缓存路径
    baidu.m_Info.cachePath = [NSHomeDirectory() stringByAppendingString:@"/tmp/SMrest"];;
    

    RMSMLayerInfo* info = [[RMSMLayerInfo alloc] initWithTile:@"Changchun" linkurl:@"http://192.168.15.99:8090/iserver/services/map-testmap/rest/maps/District"];
    // 判断获取iServer服务配置信息失败，为NULL时失败
    NSAssert(info != NULL,@"RMSMLayerInfo Connect fail");
    //叠加数据源
    RMSMTileSource* overlay = [[RMSMTileSource alloc]initWithInfo:info];
    //用于用户叠加第三方地图，纠偏。
    overlay.redressValue = CGSizeMake(-880, 14300);
    
    newContents = [[RMMapContents alloc] initWithView:mapView tilesource:baidu];
    [newContents addTileSource:overlay atIndex:1];
    [mapView setContents:newContents];
    

    newContents.zoom = 3;
    
}




@end
