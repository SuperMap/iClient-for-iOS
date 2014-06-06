//
//  Path.h
//  MapView
//
//  Created by iclient on 14-5-28.
//
//

#import <Foundation/Foundation.h>
#import "ServerFeature.h"
#import "PathGuideItem.h"
@interface Path : NSObject
{
    NSMutableArray *edgeFeatures;
    NSMutableArray *edgeIDs;
    NSMutableArray *nodeFeatures;
    NSMutableArray *nodeIDs;
    NSMutableArray *pathGuideItems;
    NSMutableArray *stopWeights;
    float weight;
    
}
@property (readonly) NSMutableArray *edgeFeatures;

@property (readonly) NSMutableArray *edgeIDs;

@property (readonly) NSMutableArray *nodeFeatures;

@property (readonly) NSMutableArray *nodeIDs;

@property (readonly) NSMutableArray *pathGuideItems;

@property (readonly) NSMutableArray *stopWeights;

@property (readonly) float weight;

//未加属性：rout

-(id) initFromJson:(NSDictionary*)dictJson;
@end
