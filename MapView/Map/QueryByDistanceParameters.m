//
//  QueryByDistanceParameters.m
//  MapView
//
//  Created by iclient on 13-6-27.
//
//

#import "QueryByDistanceParameters.h"

@implementation QueryByDistanceParameters

@synthesize distance,geometry,isNearest;

-(id) init:(double)dis mGeometry:(RMPath*)mGeometry bNearest:(BOOL)bNearest
{
    if (![super init])
		return nil;
    
    distance = dis;
    geometry = mGeometry;
    isNearest = bNearest;
    return self;
}

@end
