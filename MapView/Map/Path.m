//
//  Path.m
//  MapView
//
//  Created by iclient on 14-5-28.
//
//

#import "Path.h"

@implementation Path

@synthesize edgeFeatures,edgeIDs,nodeFeatures,nodeIDs,pathGuideItems,stopWeights,weight;


-(id) initFromJson:(NSDictionary*)dictJson
{
    edgeIDs=[dictJson objectForKey:@"edgeIDs"];
    nodeIDs=[dictJson objectForKey:@"nodeIDs"];
    stopWeights=[dictJson objectForKey:@"stopWeights"];
    weight=[[dictJson objectForKey:@"weight"]floatValue];
    
    edgeFeatures=[[NSMutableArray alloc]init];
    nodeFeatures=[[NSMutableArray alloc]init];
    pathGuideItems=[[NSMutableArray alloc]init];
    
    NSArray *aEdgeFeatures=[dictJson objectForKey:@"edgeFeatures"];
    if ((NSNull *)aEdgeFeatures!=[NSNull null]){
        for (int i=0;i<[aEdgeFeatures count] ; i++) {
            ServerFeature *sFeature=[[ServerFeature alloc]initfromJson:[aEdgeFeatures objectAtIndex:i]];
            [edgeFeatures addObject:sFeature];
        }
    }
    
    NSArray *aNodeFeatures=[dictJson objectForKey:@"nodeFeatures"];
    if ((NSNull *)aNodeFeatures!=[NSNull null]){
        for (int i=0;i<[aNodeFeatures count] ; i++) {
            ServerFeature *sFeature=[[ServerFeature alloc]initfromJson:[aNodeFeatures objectAtIndex:i]];
            [nodeFeatures addObject:sFeature];
        }
    }
    NSArray *aPathGuideItems=[dictJson objectForKey:@"pathGuideItems"];
    if ((NSNull *)aPathGuideItems!=[NSNull null]){
        for (int i=0;i<[aPathGuideItems count] ; i++) {
            PathGuideItem *pathGuide=[[PathGuideItem alloc]initFromJson:[aPathGuideItems objectAtIndex:i]];
            [pathGuideItems addObject:pathGuide];
        }
    }
    
    return self;
    
}


@end
