//
//  QueryByGeometryParameters.m
//  MapView
//
//  Created by iclient on 13-6-27.
//
//

#import "QueryByGeometryParameters.h"

@implementation QueryByGeometryParameters

@synthesize geometry,spatialQueryMode;

-(id) init:(RMPath*)mGeo
{
    if (![super init])
		return nil;
    
    geometry = mGeo;
    
    spatialQueryMode = [[NSString alloc] initWithString:SpatialQueryMode_INTERSECT];
    
    return self;
}
@end
