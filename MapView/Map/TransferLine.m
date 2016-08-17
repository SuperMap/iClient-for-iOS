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
    _endStopAliasName = [dict objectForKey:@"endStopAliasName"];
    _lineID = [[dict objectForKey:@"lineID"] integerValue];
    _lineName = [dict objectForKey:@"lineName"];
    _lineAliasName = [dict objectForKey:@"lineAliasName"];
    _startStopIndex = [[dict objectForKey:@"startStopIndex"] integerValue];
    _startStopName = [dict objectForKey:@"startStopName"];
    _startStopAliasName= [dict objectForKey:@"startStopAliasName"];
    
    
    return self;
}
-(NSMutableDictionary *)castToDict{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:[NSString stringWithFormat:@"%ld",(long)_endStopIndex ]forKey:@"endStopIndex"];
    [dict setValue:[NSString stringWithFormat:@"%ld",(long)_startStopIndex ] forKey:@"startStopIndex"];
    [dict setValue:[NSString stringWithFormat:@"%ld",_lineID ] forKey:@"lineID"];
    return dict;
}

-(NSString *)castToJson{
    return [NSString stringWithFormat:@"{'lineID':%ld,'startStopIndex':%ld,'endStopIndex':%ld}",_lineID,(long)_startStopIndex,(long)_endStopIndex];
}
@end
