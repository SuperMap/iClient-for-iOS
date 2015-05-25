//
//  TransportationAnalystParameter.m
//  MapView
//
//  Created by iclient on 14-5-28.
//
//

#import "TransportationAnalystParameter.h"

@implementation TransportationAnalystParameter
@synthesize  barrierEdgeIDs,barrierNodeIDs,barrierPoints,weightFieldName,turnWeightField,resultSetting;

-(id) init
{
    
    barrierEdgeIDs=[[NSMutableArray alloc]init];
    barrierNodeIDs=[[NSMutableArray alloc]init];
    barrierPoints=[[NSMutableArray alloc]init];
    weightFieldName=nil;
    turnWeightField=nil;
    resultSetting=[[TransportationAnalystResultSetting alloc]init];
    return self;
    
}
-(NSString *) toString
{
    NSMutableDictionary *dictionary=[[NSMutableDictionary alloc]init];
    [dictionary setValue:self.barrierEdgeIDs forKey:@"barrierEdgeIDs"];
    [dictionary setValue:self.barrierNodeIDs forKey:@"barrierNodeIDs"];
    [dictionary setValue:self.barrierPoints forKey:@"barrierPoints"];
    [dictionary setValue:self.weightFieldName forKey:@"weightFieldName"];
    [dictionary setValue:self.turnWeightField forKey:@"turnWeightField"];
    
    NSString *strResultSetting=@",\"resultSetting\":";
    strResultSetting=[strResultSetting stringByAppendingString:[self.resultSetting toString]];
    
    NSError *error;
    NSData *jsonData=[NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:&error];
    NSString *strAnalystParameter=[[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    strAnalystParameter=[[[strAnalystParameter substringToIndex:[strAnalystParameter length]-1] stringByAppendingString:strResultSetting]stringByAppendingString:@"}"];
    
    return  strAnalystParameter;
}


@end
