//
//  TransferGuideItem.m
//  MapView
//
//  Created by supermap on 15-3-3.
//
//

#import "TransferGuideItem.h"
#import "Point2D.h"
#import "ServerGeometry.h"

@implementation TransferGuideItem
-(id)initWithDict:(NSDictionary *)dict{
    [self init];
     _endIndex = [[dict objectForKey:@"endIndex"] integerValue];
     _endPosition = [[Point2D alloc] initWithDict:[dict objectForKey:@"endPosition"]] ;
     _endStopName = [dict objectForKey:@"endStopName"];
     _isWalking =[dict objectForKey:@"isWalking"];
     _lineName = [dict objectForKey:@"lineName"];
     _lineType = [[dict objectForKey:@"lineType"] integerValue];
     _passStopCount =[[dict objectForKey:@"passStopCount"] integerValue];
     _route = [[ServerGeometry alloc]fromJsonDt:[dict objectForKey:@"route"]];
    
     _startIndex = [[dict objectForKey:@"startIndex"] integerValue];
     _startPosition = [[Point2D alloc] initWithDict:[dict objectForKey:@"startPosition"]];
     _startStopName = [dict objectForKey:@"startStopName"];
    return self;
}
@end
