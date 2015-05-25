//
//  ViewController.h
//  tianditutest
//
//  Created by zhoushibin on 15-4-10.
//  Copyright (c) 2015年 SuperMapSupportCenter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RMMapView.h"
@interface ViewController : UIViewController<RMMapViewDelegate>
{
    //RMMapView *mapView;
     RMSMLayerInfo *info;
    RMMapContents *mapContents;
    double aaa;
}
@property (nonatomic, retain) RMMapView *mapView;
- (IBAction)moveClick:(id)sender;

@end

