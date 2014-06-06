//
//  FindPathParameters.h
//  MapView
//
//  Created by iclient on 14-5-27.
//
//

#import <Foundation/Foundation.h>

#import "TransportationAnalystParameter.h"
#import "RMPath.h"
#import "ServerGeometry.h"
@interface FindPathParameters : NSObject

{
    BOOL isAnalystById;
    BOOL hasLeastEdgeCount;
    NSMutableArray *nodes;
    TransportationAnalystParameter *parameter;
    
}
@property (readwrite) BOOL isAnalystById;

@property (readwrite) BOOL hasLeastEdgeCount;

@property (retain,readwrite)  NSMutableArray *nodes;

@property (retain,readwrite) TransportationAnalystParameter *parameter;

-(id) init:(BOOL)bIsAnalystById bHasLeastEdgeCount:(BOOL)bHasLeastEdgeCount nodes:(NSMutableArray *)mNodes parameter:(TransportationAnalystParameter *)tParameter;

-(NSString *) toString;
@end
