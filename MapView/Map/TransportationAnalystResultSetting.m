//
//  TransportationAnalystResultSetting.m
//  MapView
//
//  Created by iclient on 14-5-28.
//
//

#import "TransportationAnalystResultSetting.h"

@implementation TransportationAnalystResultSetting
@synthesize returnEdgeFeatures,returnEdgeGeometry,returnEdgeIDs,returnNodeFeatures,returnNodeGeometry,returnNodeIDs,returnPathGuides;

-(id) init
{
     returnEdgeFeatures = NO;
     returnEdgeGeometry = NO;
     returnEdgeIDs = NO;
     returnNodeFeatures = NO;
     returnNodeGeometry = NO;
     returnNodeIDs = NO;
     returnPathGuides = YES;
    // returnRoute = NO;
  
return self;
}

-(NSString *) toString
{
    NSMutableDictionary *dictionary=[[NSMutableDictionary alloc] init];
    [dictionary setValue:[NSNumber numberWithBool:self.returnEdgeFeatures] forKeyPath:@"returnEdgeFeatures"];
    [dictionary setValue:[NSNumber numberWithBool:self.returnEdgeGeometry] forKeyPath:@"returnEdgeGeometry"];
    [dictionary setValue:[NSNumber numberWithBool:self.returnEdgeIDs] forKeyPath:@"returnEdgeIDs"];
    [dictionary setValue:[NSNumber numberWithBool:self.returnNodeFeatures] forKeyPath:@"returnNodeFeatures"];
    [dictionary setValue:[NSNumber numberWithBool:self.returnNodeGeometry] forKeyPath:@"returnNodeGeometry"];
    [dictionary setValue:[NSNumber numberWithBool:self.returnNodeIDs] forKeyPath:@"returnNodeIDs"];
    [dictionary setValue:[NSNumber numberWithBool:self.returnPathGuides] forKeyPath:@"returnPathGuides"];
   // [dictionary setValue:self.returnRoute forKeyPath:@"returnRoute"];
    
   
    NSError *error;
    NSData *jsonData=[NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:&error];
    NSString *strResultSetting=[[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];

    return strResultSetting;
    
}



@end
