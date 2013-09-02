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
