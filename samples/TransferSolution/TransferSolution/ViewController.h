//
//  ViewController.h
//  TransferSolution
//
//  Created by supermap on 15-3-4.
//  Copyright (c) 2015年 supermap. All rights reserved.
//
@class RMMapView;
@class RMSMLayerInfo;
@class RMMapContents;

#import <UIKit/UIKit.h>
#import "ZSYPopoverListView.h"

@interface ViewController : UIViewController<ZSYPopoverListDatasource, ZSYPopoverListDelegate> {
    RMSMLayerInfo* info;
    RMMapContents *newContents;
    RMSMLayerInfo* info2;
    
}

@property(nonatomic,retain) IBOutlet RMMapView *mapView;
@property(nonatomic,retain) IBOutlet UITextField *startTF;
@property(nonatomic,retain) IBOutlet UITextField *endTF;
@end
