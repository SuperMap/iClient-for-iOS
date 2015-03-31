//
//  FindPathResult.m
//  MapView
//
//  Created by iclient on 14-5-28.
//
//

#import "FindPathResult.h"

@implementation FindPathResult
@synthesize pathList;

-(id) fromJson:(NSString*)strJson
{
    
    
    strJson = [strJson stringByReplacingOccurrencesOfString:@"\b" withString:@"\\b"];
    strJson = [strJson stringByReplacingOccurrencesOfString:@"\n" withString:@"\\n"];
    strJson = [strJson stringByReplacingOccurrencesOfString:@"\f" withString:@"\\f"];
    //strJson = [strJson stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
    strJson = [strJson stringByReplacingOccurrencesOfString:@"\r" withString:@"\\r"];
    strJson = [strJson stringByReplacingOccurrencesOfString:@"\t" withString:@"\t"];
    
    NSError *e;
    NSDictionary *JSON =
    [NSJSONSerialization JSONObjectWithData: [strJson dataUsingEncoding:NSUTF8StringEncoding]
                                    options: NSJSONReadingMutableContainers
                                      error: &e];
    
    
    pathList=[[NSMutableArray alloc]init];

    NSMutableArray *aPathList=[[NSMutableArray alloc] init];
    aPathList=[JSON objectForKey:@"pathList"];
    Path *aPath = nil;
    int nCount=[aPathList count]>0?[[NSNumber numberWithUnsignedLong:[aPathList count]] intValue]:0;
    if (nCount>0) {
        for (int i=0; i<[aPathList count]; i++) {
            aPath=[[Path alloc]initFromJson:[aPathList objectAtIndex:i]];
        }
        
        [pathList addObject:aPath];
        
    }
    return self;
    
}


@end
