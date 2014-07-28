//
//  QueryParameters.m
//  MapView
//
//  Created by iclient on 13-6-25.
//
//

#import "QueryParameters.h"
#import "RMGlobalConstants.h"

@implementation QueryParameters

@synthesize customParams,expectCount,networkType,queryOption,queryParams,startRecord,holdTime,returnContent,returnCustomResult;

-(id) init
{
    customParams = nil;
    expectCount = 100000;
    networkType = [[NSString alloc] initWithString:GeometryType_LINE];
    queryOption = [[NSString alloc] initWithString:QueryOption_ATTRIBUTEANDGEOMETRY];
    queryParams = [[NSMutableArray alloc] init];
    startRecord = 0;
    holdTime = 10;
    returnCustomResult = false;
    returnContent = true;
    return self;
}

- (NSMutableDictionary *)toNSDictionary
{
    NSMutableArray *fpList = [[NSMutableArray alloc] init];
    for(FilterParameter* fp in self.queryParams){
        [fpList addObject:[fp toNSDictionary]];
    }
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setValue:self.customParams forKey:@"customParams"];
    [dictionary setValue:[NSNumber numberWithInt:self.expectCount] forKey:@"expectCount"];
    [dictionary setValue:self.networkType forKey:@"networkType"];
    [dictionary setValue:self.queryOption forKey:@"queryOption"];
    [dictionary setValue:fpList forKey:@"queryParams"];
    [dictionary setValue:[NSNumber numberWithInt:self.startRecord] forKey:@"startRecord"];
    [dictionary setValue:[NSNumber numberWithInt:self.holdTime] forKey:@"holdTime"];
    [dictionary setValue:[NSNumber numberWithBool:returnCustomResult] forKey:@"returnCustomResult"];
    
    return dictionary;
}

@end
