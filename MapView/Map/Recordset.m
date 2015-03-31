//
//  Recordset.m
//  MapView
//
//  Created by iclient on 13-6-26.
//
//

#import "Recordset.h"


@implementation Recordset

@synthesize datasetName,fieldCaptions,fields,fieldTypes,features;

-(id) initfromJson:(NSDictionary*)strJson
{    
    datasetName = [[NSString alloc] initWithString:[strJson objectForKey:@"datasetName"]];
    fieldCaptions = [strJson valueForKey:@"fieldCaptions"];
    fieldTypes = [strJson valueForKey:@"fieldTypes"];
    fields = [strJson valueForKey:@"fields"];
    
    NSArray* fsArray = [strJson valueForKey:@"features"];
    
    features = [[NSMutableArray alloc] init];
    
    for (int i=0;i<[fsArray count];  i++) {
        ServerFeature* pF = [[ServerFeature alloc] initfromJson:[fsArray objectAtIndex:i]];
        [features addObject:pF];
    }
        
    return self;
}

@end
