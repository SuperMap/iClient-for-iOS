//
//  GenerateSpatialDataResult.m
//  MapView
//
//  Created by iclient on 14/11/26.
//
//

#import "GenerateSpatialDataResult.h"

@implementation GenerateSpatialDataResult

-(instancetype)init
{
    if (!(self = [super init]))
        return nil;
    
    _dataset=[NSString new];
    _message=[NSString new];
    _recordset=[Recordset new];
    _succeed=NO;
    return self;
    
}

-(instancetype)initWithJson:(NSString *)strJson
{
    [self init];
    NSError *e;
    NSDictionary *JSON =[NSJSONSerialization JSONObjectWithData: [strJson dataUsingEncoding:NSUTF8StringEncoding]
                                                        options: NSJSONReadingMutableContainers
                                                          error: &e];
    
       _dataset=[[NSString alloc]initWithString:[JSON objectForKey:@"dataset"]];
       _succeed=[[NSNumber alloc]initWithInt:[JSON objectForKey:@"succeed"]];
    
    if (![[JSON objectForKey:@"message"]isEqual:[NSNull null]]) {
         _message=[JSON objectForKey:@"message"];
    }

    
    NSDictionary *recordSet=[JSON objectForKey:@"recordset"];
    if(![recordSet isEqual:[NSNull null]])
    {
        _recordset=[[Recordset alloc]initfromJson:recordSet];
    }
    
    return self;
}

@end
