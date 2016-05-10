//
//  RMGestureState.m
//  MapView
//
//  Created by imobile-xzy on 16/5/9.
//
//

#import "RMMapTap.h"


static BOOL isDoubleFinger,isTouchEnd,isDoZoom;

@implementation RMMapTap

+(int)getCurGestureState{
    if(isDoZoom && isTouchEnd)
        return 1;
    return 0;
}
+(void)touch:(RMGestureDetails)touches Type:(int)bTouch{
    if(bTouch==1){//begin
        isTouchEnd = NO;
        isDoZoom = NO;
        isDoubleFinger = NO;
        if( touches.numTouches == 2)
            isDoubleFinger = YES;
        
    }else if (bTouch==2){//move
        if( touches.numTouches==2 || isDoubleFinger)
            isDoZoom = YES;
        
    }else if (bTouch==3){//end
        isTouchEnd = YES;
    }
}
@end
