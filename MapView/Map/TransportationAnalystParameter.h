//
//  TransportationAnalystParameter.h
//  MapView
//
//  Created by iclient on 14-5-28.
//
//

#import <Foundation/Foundation.h>
#import "TransportationAnalystResultSetting.h"

@interface TransportationAnalystParameter : NSObject
{
    NSMutableArray *barrierEdgeIDs;
    NSMutableArray *barrierNodeIDs;
    NSMutableArray *barrierPoints;
    NSString *weightFieldName;
    NSString *turnWeightField;
    TransportationAnalystResultSetting *resultSetting;
}

@property (copy,readwrite)  NSMutableArray *barrierEdgeIDs;

@property (copy,readwrite)  NSMutableArray *barrierNodeIDs;

@property (copy,readwrite)  NSMutableArray *barrierPoints;

@property (copy,readwrite)  NSString *weightFieldName;

@property (copy,readwrite)  NSString *turnWeightField;

@property (copy,readwrite)   TransportationAnalystResultSetting *resultSetting;

-(NSString *) toString;
@end
