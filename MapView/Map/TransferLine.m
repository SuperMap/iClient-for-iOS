//
//  TransferLine.m
//  MapView
//
//  Created by supermap on 15-3-4.
//
//

#import "TransferLine.h"

@implementation TransferLine

-(id)initWithDict:(NSDictionary *)dict{
    [self init];
    
    _endStopIndex = [[dict objectForKey:@"endStopIndex"] integerValue];
    _endStopName = [dict objectForKey:@"endStopName"];
    _lineID = [[dict objectForKey:@"lineID"] integerValue];
    _lineName = [dict objectForKey:@"lineName"];
    _startStopIndex = [[dict objectForKey:@"startStopIndex"] integerValue];
    _startStopName = [dict objectForKey:@"startStopName"];

    return self;
}
-(NSMutableDictionary *)castToDict{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:[NSString stringWithFormat:@"%d",_endStopIndex ]forKey:@"endStopIndex"];
    [dict setValue:[NSString stringWithFormat:@"%d",_startStopIndex ] forKey:@"startStopIndex"];
    [dict setValue:[NSString stringWithFormat:@"%ld",_lineID ] forKey:@"lineID"];
    return dict;
}

-(NSString *)castToJson{
    return [NSString stringWithFormat:@"{'lineID':%ld,'startStopIndex':%d,'endStopIndex':%d}",_lineID,_startStopIndex,_endStopIndex];
}
@end
