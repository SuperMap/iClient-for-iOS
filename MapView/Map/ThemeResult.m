//
//  ThemeResult.m
//  MapView
//
//  Created by iclient on 14/11/24.
//
//

#import "ThemeResult.h"

@implementation ThemeResult

-(instancetype)init
{
    if (!(self = [super init]))
        return nil;

    return self;
    
}

-(instancetype)initWithJson:(NSString *)strJson
{
    [self init];
    
    _resourceInfo=[[ResourceInfo alloc]initWitJson:strJson];
    
    return self;
    
}


@end
