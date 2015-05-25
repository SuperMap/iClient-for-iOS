//
//  DataReturnOption.m
//  MapView
//
//  Created by iclient on 14/11/26.
//
//

#import "DataReturnOption.h"
#import "RMGlobalConstants.h"
@implementation DataReturnOption


-(instancetype)init
{
    if (!(self = [super init]))
        return nil;
    _expectCount=1000;
    _dataset=[NSString new];
    _deleteExistResultDataset=YES;
    _dataReturnMode=[NSString new];
    
    return self;
    
}
-(instancetype)initWithDataset:(NSString*)dataset
{
    [self init];
    
    _dataset=dataset;
    _dataReturnMode=[[NSString alloc]initWithString:DATASET_ONLY];
    
    return self;
    
}


-(instancetype)initWithExpectCount:(NSInteger)expectCount dataset:(NSString*)dataset deleteExistResultDataset:(BOOL) deleteExistResultDataset dataReturnMode:(NSString*) dataReturnMode
{
    [self init];
    _expectCount=expectCount;
    _dataset=dataset;
    _deleteExistResultDataset=deleteExistResultDataset;
    _dataReturnMode=dataReturnMode;

    return self;
    
}

-(NSMutableDictionary*)toDictionary
{
    NSMutableDictionary *returnOption=[NSMutableDictionary new];
    
    [returnOption setValue:[NSNumber numberWithInteger:_expectCount] forKey:@"expectCount"];
    [returnOption setValue:_dataset forKey:@"dataset"];
    [returnOption setValue:[NSNumber numberWithBool:_deleteExistResultDataset] forKey:@"deleteExistResultDataset"];
    [returnOption setValue:_dataReturnMode forKey:@"dataReturnMode"];
    
    return returnOption;
}

@end
