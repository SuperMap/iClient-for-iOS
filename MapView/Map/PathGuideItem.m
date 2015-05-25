//
//  PathGuideItem.m
//  MapView
//
//  Created by iclient on 14-5-28.
//
//

#import "PathGuideItem.h"

@implementation PathGuideItem
@synthesize  bounds,directionType,distance,ID,index,isEdge,isStop,dLength,name,turnType,weight,description,geometry,sideType,turnAngle;

-(id) initFromJson:(NSDictionary*)dictJson
{
    NSDictionary *abounds =[[NSDictionary alloc]init];
    abounds=[dictJson objectForKey:@"bounds"];
    
    double dleft = [[abounds objectForKey:@"left"] doubleValue];
    double dbottom = [[abounds objectForKey:@"bottom"] doubleValue];
    double dright = [[abounds objectForKey:@"right"] doubleValue];
    double dtop = [[abounds objectForKey:@"top"] doubleValue];
    double dWidth = dright - dleft;
    double dHeight = dtop - dbottom;

    bounds=RMMakeProjectedRect(dleft, dbottom, dWidth, dHeight);
    directionType=[dictJson objectForKey:@"directionType"];
    distance=[[dictJson objectForKey:@"distance"]floatValue];
    ID=(long int)[dictJson objectForKey:@"id"];
   // NSLog(@"id::%ld",ID);
    index=(int)[dictJson objectForKey:@"index"];
    isEdge=(BOOL)[dictJson objectForKey:@"isEdge"];
    isStop=(BOOL)[dictJson objectForKey:@"isStop"];
    dLength=(double)[[dictJson objectForKey:@"length"]doubleValue];
    name=[dictJson objectForKey:@"name"];
    sideType=[dictJson objectForKey:@"sideType"];
    turnAngle=[[dictJson objectForKey:@"turnAngle"]floatValue];
    turnType=[dictJson objectForKey:@"turnType"];
    weight=[[dictJson objectForKey:@"weight"]floatValue];
    description=[dictJson objectForKey:@"description"];
    geometry=[[ServerGeometry alloc]fromJsonDt:[dictJson objectForKey:@"geometry"]];
    return self;
}


@end
