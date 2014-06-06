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


@interface ViewController : UIViewController
{
    RMMapView *mapView;
    RMSMLayerInfo* info;
    RMMapContents *newContents;
 }

@property (nonatomic, retain) RMMapView *mapView;
@property (nonatomic, retain) RMSMLayerInfo* info;

@end
