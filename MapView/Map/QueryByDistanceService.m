//
//  QueryByDistanceService.m
//  MapView
//
//  Created by iclient on 13-6-27.
//
//

#import "QueryByDistanceService.h"
#import "ServerGeometry.h"

@implementation QueryByDistanceService

-(id) init
{
    if (![super init])
		return nil;
    
    return self;
}

-(NSString*) getJsonParameters:(QueryParameters*)params
{
    QueryParameters* base = [self getQueryParameters:params];
    
    NSMutableArray *baseparams = [[NSMutableArray alloc] init];
    
    [baseparams addObject:[base toNSDictionary]];
    //NSLog(@"%@",[base toNSDictionary]);
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:[base toNSDictionary]
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    NSString *jsonStringParams = [[NSString alloc] initWithData:jsonData
                                                       encoding:NSUTF8StringEncoding];
    
    QueryByDistanceParameters* paramsByDistance = (QueryByDistanceParameters*)params;
    
    ServerGeometry* pGeo = [[ServerGeometry alloc] fromRMPath:paramsByDistance.geometry];
    
    NSString* strGeoJson = [[NSString alloc] initWithString:[pGeo toJson]];
    
    
    
    NSString *strJsonParam = [[NSString alloc] initWithString:@"{"];
    strJsonParam = [strJsonParam stringByAppendingString:paramsByDistance.isNearest?@"'queryMode':'FindNearest','queryParameters':":@"'queryMode':'DistanceQuery','queryParameters':"];
    strJsonParam = [strJsonParam stringByAppendingString:jsonStringParams];
    NSString* strDistance = [[NSString alloc] initWithFormat:@",'geometry':%@,'distance':%f",strGeoJson,paramsByDistance.distance];
    strJsonParam = [strJsonParam stringByAppendingString:strDistance];
    strJsonParam = [strJsonParam stringByAppendingString:@"}"];
    
    return strJsonParam;
}


@end
