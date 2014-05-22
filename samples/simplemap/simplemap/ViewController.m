//
//  ViewController.m
//  simplemap
//
//  Created by iclient on 13-9-2.
//  Copyright (c) 2013年 iclient. All rights reserved.
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
    // Your own code
    
    //NSString *tileThing = @"http://192.168.13.174:8090/iserver/services/map-china400/rest/maps/China";
    NSString *tileThing = @"http://support.supermap.com.cn:8090/iserver/services/map-changchun/rest/maps/长春市区图";
    info = [[RMSMLayerInfo alloc] initWithTile:@"China" linkurl:tileThing];
    // 判断获取iServer服务配置信息失败，为NULL时失败
    NSAssert(info != NULL,@"RMSMLayerInfo Connect fail");
    NSMutableArray *resolutions = [[NSMutableArray alloc] init];
    
    [resolutions addObject:[NSNumber numberWithDouble:0.25]];
    [resolutions addObject:[NSNumber numberWithDouble:0.125]];
    [resolutions addObject:[NSNumber numberWithDouble:0.0625]];
    [resolutions addObject:[NSNumber numberWithDouble:0.03125]];
    [resolutions addObject:[NSNumber numberWithDouble:0.015625]];
    [resolutions addObject:[NSNumber numberWithDouble:0.0078125]];
    [resolutions addObject:[NSNumber numberWithDouble:0.00390625]];
    
    RMSMTileSource* smSource = [[RMSMTileSource alloc] initWithInfo:info];
    //RMSMTileSource* smSource = [[RMSMTileSource alloc] initWithInfo:info resolutions:resolutions];

    RMMapContents *newContents = [[RMMapContents alloc] initWithView:mapView tilesource:smSource];
    //[newContents set]
    
    [mapView setContents:newContents];
    
    RMProjectedPoint prjPnt;
    prjPnt.easting = 4503;
    prjPnt.northing = -3816;
    [newContents setCenterProjectedPoint:prjPnt];
    newContents.zoom = 1;
    
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

@end
