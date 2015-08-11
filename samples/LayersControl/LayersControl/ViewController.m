//
//  ViewController.m
//  LayersControl
//
//  Created by supermap on 15/4/23.
//  Copyright (c) 2015年 supermap. All rights reserved.
//


#import "ViewController.h"
#import "RMSMTileSource.h"
#import "RMMapContents.h"
#import "RMMapView.h"
#import "RMSMLayerInfo.h"

@interface ViewController (){
    NSString *tileThing ;
    RMSMTileSource* smSource;
    UIAlertView  *alert;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    tileThing = @"http://192.168.18.79:8090/iserver/services/map-china400/rest/maps/China";

    NSMutableDictionary* params=[[NSMutableDictionary alloc] init];
//    [params setObject:@"e734aa481c2e45bfbad4ae78ce3d51b0_806d9c77e905471b8cc35014221c8fbf" forKey:@"layersID"];
    info = [[RMSMLayerInfo alloc] initWithTile:@"layers" linkurl:tileThing params:params];
//    info = [[RMSMLayerInfo alloc] initWithTile:@"layers" linkurl:tileThing params:params isUseDisplayFilter:YES];
//    info = [[RMSMLayerInfo alloc] initWithTile:@"layers" linkurl:tileThing params:params];
    // 判断获取iServer服务配置信息失败，为NULL时失败
    NSAssert(info != NULL,@"RMSMLayerInfo Connect fail");
    //底图
    smSource = [[RMSMTileSource alloc] initWithInfo:info];
    mapContent = [[RMMapContents alloc] initWithView:_mapView tilesource:smSource];
    [_mapView setContents:mapContent];
    
    alert = [[UIAlertView alloc] initWithTitle:@"临时图层" message:@"图层切换" delegate:self cancelButtonTitle:@"3 SMID < 10" otherButtonTitles:@"2.3 SMID < 10",@"2 SMID < 20", @"cancel", nil];
    [alert show];
    [info layerInfoList];
    // 获取图层名称列表
    for (int i=0; i<[[info layerInfoList] count]; i++) {
        NSLog(@"%@",[[[info layerInfoList]  objectAtIndex:i] objectForKey:@"name"]);
    }
    [_mapView setDelegate:self];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
//    [mapContent setLayerID:@"e734aa481c2e45bfbad4ae78ce3d51b0_806d9c77e905471b8cc35014221c8fbf" forTileSource:smSource];
    NSMutableDictionary *dict =[[NSMutableDictionary alloc] init];
    if (buttonIndex == 0) {
        [dict setValue:@"SMID < 10" forKey:@"3"];
        [mapContent setDisplayFilter:dict forTileSource:smSource];
    }else if(buttonIndex == 1){
//        [mapContent setLayerID:@"[0,1,2]" forTileSource:smSource];
        [dict setValue:@"SMID < 10" forKey:@"2"];
        [dict setValue:@"SMID < 10" forKey:@"3"];
        [mapContent setDisplayFilter:dict forTileSource:smSource];
    }else if(buttonIndex ==2){
        [dict setValue:@"SMID < 20" forKey:@"2"];
        [mapContent setDisplayFilter:dict forTileSource:smSource];
    }else{
     
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)showAlertView:(UIButton *) button{
      [alert show];
}
-(void)longTapOnMap:(RMMapView *)map At:(CGPoint)point{
    
}

-(void)singleTapOnMap:(RMMapView *)map At:(CGPoint)point{
    
}
@end