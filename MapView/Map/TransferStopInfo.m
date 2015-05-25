//
//  TransferStopInfo.m
//  MapView
//
//  Created by supermap on 15-3-5.
//
//

#import "TransferStopInfo.h"
#import "Point2D.h"
@implementation TransferStopInfo

-(id)initWithDict:(NSDictionary *)dict{
    [self init];
    _alias =  [dict objectForKey:@"alias"];
    __id = [[dict objectForKey:@"id"] integerValue];
    _name = [dict objectForKey:@"name"];
    _position = [[Point2D alloc] initWithDict:[dict objectForKey:@"position"]];
    _stopID = [[dict objectForKey:@"stopID"] longValue];
    
    return self;
}
@end
