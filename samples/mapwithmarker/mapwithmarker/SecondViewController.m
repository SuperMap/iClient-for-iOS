//
//  SecondViewController.m
//  mapwithmarker
//
//  Created by iclient on 13-9-3.
//  Copyright (c) 2014年 iclient. All rights reserved.
//

#import "SecondViewController.h"
#import "RMOpenCycleMapSource.h"

@interface SecondViewController ()

@end

@implementation SecondViewController

@synthesize mapView;
- (void)loadView {
    CGRect bounds = [[UIScreen mainScreen] bounds];
    [self setMapView:[[RMMapView alloc] initWithFrame:CGRectMake(0.0, 0.0, bounds.size.width, bounds.size.height)] ];
    self.view = mapView;
    
    id <RMTileSource> tileSource;
	
	tileSource = [[RMOpenCycleMapSource alloc] init] ;
	
//	[[mapView contents] setTileSource:tileSource];
    // Your own code
    
    RMProjectedPoint prjPnt = (RMProjectedPoint){12969236.42061722,4863568.820204712};
    [self setMapCenter:prjPnt];
    mapView.contents.zoom = 14;
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

-(void)setMapCenter:(RMProjectedPoint) prjPnt
{
    [mapView.contents setCenterProjectedPoint:prjPnt];
}

@end
