//
//  QueryByGeometryService.m
//  MapView
//
//  Created by iclient on 13-6-27.
//
//

#import "QueryByGeometryService.h"
#import "ServerGeometry.h"

@implementation QueryByGeometryService

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
    
    QueryByGeometryParameters* paramsByGeo = (QueryByGeometryParameters*)params;
    
    ServerGeometry* pGeo = [[ServerGeometry alloc] fromRMPath:paramsByGeo.geometry];
    
    NSString* strGeoJson = [[NSString alloc] initWithString:[pGeo toJson]];
    
    
    
    NSString *strJsonParam = [[NSString alloc] initWithString:@"{"];
    strJsonParam = [strJsonParam stringByAppendingString:@"'queryMode':'SpatialQuery','queryParameters':"];
    strJsonParam = [strJsonParam stringByAppendingString:jsonStringParams];
    NSString* strGeometry = [[NSString alloc] initWithFormat:@",'geometry':%@,'spatialQueryMode':%@",strGeoJson,paramsByGeo.spatialQueryMode];
    strJsonParam = [strJsonParam stringByAppendingString:strGeometry];
    strJsonParam = [strJsonParam stringByAppendingString:@"}"];
    
    return strJsonParam;
}
@end
