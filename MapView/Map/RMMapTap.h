//
//  RMGestureState.h
//  MapView
//
//  Created by imobile-xzy on 16/5/9.
//
//

#import <Foundation/Foundation.h>
#import "RMMapView.h"

@interface RMMapTap : NSObject
+(int)getCurGestureState;
+(void)touch:(RMGestureDetails)touches Type:(int)bTouch;
@end
