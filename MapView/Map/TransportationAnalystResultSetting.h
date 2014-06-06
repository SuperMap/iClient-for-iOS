//
//  TransportationAnalystResultSetting.h
//  MapView
//
//  Created by iclient on 14-5-28.
//
//

#import <Foundation/Foundation.h>

@interface TransportationAnalystResultSetting : NSObject
{
    BOOL returnEdgeFeatures;
    BOOL returnEdgeGeometry;
    BOOL returnEdgeIDs;
    BOOL returnNodeFeatures;
    BOOL returnNodeGeometry;
    BOOL returnNodeIDs;
    BOOL returnPathGuides;
  //  BOOL returnRoute;
}

@property (readwrite) BOOL returnEdgeFeatures;

@property (readwrite) BOOL returnEdgeGeometry;

@property (readwrite) BOOL returnEdgeIDs;

@property (readwrite) BOOL returnNodeGeometry;

@property (readwrite) BOOL returnNodeFeatures;

@property (readwrite) BOOL returnNodeIDs;

@property (readwrite) BOOL returnPathGuides;

//@property (readwrite) BOOL returnRoute;


-(NSString *) toString;

@end
