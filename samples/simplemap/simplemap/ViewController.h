//
//  ViewController.h
//  simplemap
//
//  Created by iclient on 13-9-2.
//  Copyright (c) 2013年 iclient. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "RMMapView.h"

@interface ViewController : UIViewController
{
    RMMapView *mapView;
    RMSMLayerInfo* info;
}

@property (nonatomic, retain) RMMapView *mapView;
@property (nonatomic, retain) RMSMLayerInfo* info;

@end
