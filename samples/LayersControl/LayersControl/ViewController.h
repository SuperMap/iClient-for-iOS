//
//  ViewController.h
//  LayersControl
//
//  Created by supermap on 15/4/23.
//  Copyright (c) 2015年 supermap. All rights reserved.
//
@class RMMapContents;
@class RMMapView;
@class RMSMLayerInfo;

#import <UIKit/UIKit.h>
#import "RMMapViewDelegate.h"

@interface ViewController : UIViewController <UIAlertViewDelegate,RMMapViewDelegate>{
    RMMapContents *mapContent;
    RMSMLayerInfo *info;
}

@property (nonatomic,retain) IBOutlet RMMapView *mapView;
@property (nonatomic,retain) IBOutlet UIButton  *btn;
@end

