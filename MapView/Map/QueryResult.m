//
//  QueryResult.m
//  MapView
//
//  Created by iclient on 13-6-26.
//
//

#import "QueryResult.h"

@implementation QueryResult

@synthesize totalCount,currentCount,customResponse,recordsets;

-(void) fromJson:(NSString*)strJson
{
    NSError *e;
    NSDictionary *JSON =
    [NSJSONSerialization JSONObjectWithData: [strJson dataUsingEncoding:NSUTF8StringEncoding]
                                    options: NSJSONReadingMutableContainers
                                      error: &e];
    
    totalCount = [[JSON objectForKey:@"totalCount"] intValue];
    currentCount = [[JSON objectForKey:@"totalCount"] intValue];
    customResponse = [JSON objectForKey:@"customResponse"];
    
    NSArray* rsArray = [JSON objectForKey:@"recordsets"];
    
    recordsets = [[NSMutableArray alloc] init];
    for (int i=0; i<[rsArray count]; i++) {
        [recordsets addObject:[[Recordset alloc] initfromJson:[rsArray objectAtIndex:i]]];
    }
    
    //NSString* str = [rsArray objectForKey:@"datasetName"];
    //NSLog(@"%d",[[[recordsets objectAtIndex:0] features] count]);
}
@end
