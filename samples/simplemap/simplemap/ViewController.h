//
//  ViewController.h
//  simplemap
//
//  Created by iclient on 13-9-2.
//  Copyright (c) 2014年 iclient. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "RMMapView.h"
#import "FindPathService.h"
#import "RMPath.h"
#import "RMLayerCollection.h"
#import "RMMarkerManager.h"
#import "ThemeService.h"
#import "RMMapContents.h"
#import "GenerateSpatialDataService.h"

@interface ViewController : UIViewController
{
    RMMapView *mapView;
   
    RMMapContents *newContents;
    RMSMLayerInfo* info2;

 }

@property (nonatomic, retain) RMMapView *mapView;
//@property (nonatomic, retain) RMSMLayerInfo* info;
//@property (nonatomic, retain) RMSMLayerInfo* info2;

@end
