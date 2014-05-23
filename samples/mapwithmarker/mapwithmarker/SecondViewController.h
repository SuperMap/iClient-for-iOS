//
//  SecondViewController.h
//  mapwithmarker
//
//  Created by iclient on 13-9-3.
//  Copyright (c) 2014年 iclient. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RMMapView.h"

@interface SecondViewController : UIViewController{
    RMMapView* mapView;
}

-(void)setMapCenter:(RMProjectedPoint) prjPnt;

@property (nonatomic, strong) RMMapView *mapView;

@end
