//
//  PathGuideItem.h
//  MapView
//
//  Created by iclient on 14-5-28.
//
//

#import <Foundation/Foundation.h>
#import <RMFoundation.h>
#import "ServerGeometry.h"

@interface PathGuideItem : NSObject
{
    RMProjectedRect bounds;
    NSString *directionType;
    float distance;
    long int ID;
    int index;
    BOOL isEdge;
    BOOL isStop;
    double dLength;
    NSString *name;
    NSString *sideType;
    float turnAngle;
    NSString *turnType;
    float weight;
    NSString *description;
    ServerGeometry *geometry;
}
@property (readwrite)RMProjectedRect bounds;

@property(retain,readwrite) NSString *directionType;

@property(readwrite)float distance;

@property(readwrite)long int ID;

@property(readwrite)int index;

@property(readwrite)BOOL isEdge;

@property(readwrite)BOOL isStop;

@property(readwrite)double dLength;

@property(retain,readwrite)NSString *name;

@property(retain,readwrite)NSString *sideType;

@property(readwrite)float turnAngle;

@property(retain,readwrite)NSString *turnType;

@property(readwrite)float weight;

@property(retain,readwrite)NSString *description;

@property(retain,readwrite)ServerGeometry *geometry;

-(id) initFromJson:(NSDictionary*)dictJson;


@end
