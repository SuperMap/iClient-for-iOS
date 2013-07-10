//
//  QueryByBoundsParameters.m
//  MapView
//
//  Created by iclient on 13-6-25.
//
//

#import "QueryByBoundsParameters.h"

@implementation QueryByBoundsParameters

@synthesize bounds;

-(id) init:(RMProjectedRect)mbounds
{
    if (![super init])
		return nil;
    
    bounds = mbounds;
    return self;
}

@end
