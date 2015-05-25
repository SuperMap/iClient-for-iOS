//
//  ThemeParameters.m
//  MapView
//
//  Created by iclient on 14/11/24.
//
//

#import "ThemeParameters.h"

@implementation ThemeParameters
-(instancetype)init
{
    if (!(self = [super init]))
        return nil;
    
    return self;
    
}

-(instancetype)initWithDatasetNames:(NSString *)datasetName dataSourceName:(NSString *)dataSourceName themeUnique:(ThemeUnique *)theme
{
     [self init];    
    _datasetName=datasetName;
    _dataSourceName=dataSourceName;
    _theme=theme;
    
    return self;
}

-(NSString*) toJsonParameters
{
    NSString *strJsonParam = [[NSString alloc] initWithString:@"[{'type':'UGC','subLayers':{'layers':[{'theme':"];
    
    NSError *error;
    NSData *jsonDataTheme=[NSJSONSerialization dataWithJSONObject:[_theme toDictionary] options:NULL error:&error];
    NSString *strJsonTheme=[[NSString alloc]initWithData:jsonDataTheme encoding:NSUTF8StringEncoding];

    strJsonParam=[strJsonParam stringByAppendingString:strJsonTheme];
    strJsonParam=[strJsonParam stringByAppendingString:@",'type':'UGC','ugcLayerType':'THEME','datasetInfo': {'name':'"];
    strJsonParam=[strJsonParam stringByAppendingString:_datasetName];
    strJsonParam=[strJsonParam stringByAppendingString:@"','dataSourceName':'"];
    strJsonParam=[strJsonParam stringByAppendingString:_dataSourceName];
    strJsonParam=[strJsonParam stringByAppendingString:@"'}}]},"];
    
    
    
   
    return strJsonParam;
    
}

@end
