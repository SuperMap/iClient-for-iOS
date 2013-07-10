//
//  RMSMMeasureParameters.m
//  MapView
//
//  Created by iclient on 13-6-19.
//
//

#import "RMSMMeasureParameters.h"

@implementation RMSMMeasureParameters

@synthesize m_Unit,m_Path;

- (id) init:(RMPath*)geometry
{
    m_Path = geometry;
    m_Unit = [[NSString alloc] initWithString:METRE];
    return  self;
}

@end
