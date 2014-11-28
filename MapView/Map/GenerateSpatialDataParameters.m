//
//  GenerateSpatialDataParameters.m
//  MapView
//
//  Created by iclient on 14/11/26.
//
//

#import "GenerateSpatialDataParameters.h"

@implementation GenerateSpatialDataParameters

-(instancetype)init
{
    if (!(self = [super init]))
        return nil;
    
    _routeTable=[NSString new];
    _routeIDField=[NSString new];
    _eventTable=[NSString new];
    _eventRouteIDField=[NSString new];
    _measureStartField=[NSString new];
    _measureEndField=[NSString new];
    _dataReturnOption=[DataReturnOption new];
    _measureField=[NSString new];
    _errorInfoField=[NSString new];
    _measureOffsetField=[NSString new];
    
    return self;
    
}

-(instancetype)initWithRouteTable:(NSString *)routeTable routeIDField:(NSString *)routeIDField eventTable:(NSString *)eventTable eventRouteIDField:(NSString *)eventRouteIDField measureStartField:(NSString *)measureStartField measureEndField:(NSString *)measureEndField  dataReturnOption:(DataReturnOption *)dataReturnOption
{
    [self init];
    
    _routeTable=routeTable;
    _routeIDField=routeIDField;
    _eventTable=eventTable;
    _eventRouteIDField=eventRouteIDField;
    _measureStartField=measureStartField;
    _measureEndField=measureEndField;
    _dataReturnOption=dataReturnOption;
    
    return self;
}

-(NSMutableDictionary*)toDictionary
{
    NSMutableDictionary *parameters=[NSMutableDictionary new];
    
    [parameters setValue:_routeTable forKey:@"routeTable"];
    [parameters setValue:_routeIDField forKey:@"routeIDField"];
    [parameters setValue:_eventTable forKey:@"eventTable"];
    [parameters setValue:_eventRouteIDField forKey:@"eventRouteIDField"];
    [parameters setValue:_measureStartField forKey:@"measureStartField"];
    [parameters setValue:_measureEndField forKey:@"measureEndField"];
    [parameters setValue:[_dataReturnOption toDictionary] forKey:@"dataReturnOption"];
    [parameters setValue:_measureField forKey:@"measureField"];
    [parameters setValue:_errorInfoField forKey:@"errorInfoField"];
    [parameters setValue:_measureOffsetField forKey:@"measureOffsetField"];
    
    return parameters;
}



@end
