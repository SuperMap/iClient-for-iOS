//
//  ServerFeature.m
//  MapView
//
//  Created by iclient on 13-6-26.
//
//

#import "ServerFeature.h"

@implementation ServerFeature

@synthesize fieldNames,fieldValues,geometry;

-(id) initfromJson:(NSDictionary*)strJson
{
    fieldNames = [strJson valueForKey:@"fieldNames"];
    fieldValues = [strJson valueForKey:@"fieldValues"];
    
    NSDictionary* geoJson = [strJson valueForKey:@"geometry"];
    
    geometry = [[ServerGeometry alloc] fromJsonDt:geoJson];

    return self;
}

@end
