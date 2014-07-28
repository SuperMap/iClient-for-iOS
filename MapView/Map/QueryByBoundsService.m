//
//  QueryByBoundsService.m
//  MapView
//
//  Created by iclient on 13-6-25.
//
//

#import "QueryByBoundsService.h"

@implementation QueryByBoundsService

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
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:[base toNSDictionary]
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    NSString *jsonStringParams = [[NSString alloc] initWithData:jsonData
                                                 encoding:NSUTF8StringEncoding];
    
    QueryByBoundsParameters* paramsByBounds = (QueryByBoundsParameters*)params;
    RMProjectedRect bounds = paramsByBounds.bounds;
    
    NSString *strJsonParam = [[NSString alloc] initWithString:@"{"];
    strJsonParam = [strJsonParam stringByAppendingString:@"'queryMode':'BoundsQuery','queryParameters':"];
    strJsonParam = [strJsonParam stringByAppendingString:jsonStringParams];
    NSString* strBounds = [[NSString alloc] initWithFormat:@",'bounds': {'rightTop':{'y':%f,'x':%f},'leftBottom':{'y':%f,'x':%f}}",bounds.origin.northing+bounds.size.height,bounds.origin.easting+bounds.size.width,bounds.origin.northing,bounds.origin.easting];
    strJsonParam = [strJsonParam stringByAppendingString:strBounds];
    strJsonParam = [strJsonParam stringByAppendingString:@"}"];
    
    return strJsonParam;    
}

@end
