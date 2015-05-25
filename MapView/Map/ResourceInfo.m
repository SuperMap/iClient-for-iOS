//
//  ResourceInfo.m
//  MapView
//
//  Created by iclient on 14/11/24.
//
//

#import "ResourceInfo.h"

@implementation ResourceInfo
-(instancetype)init
{
    if (!(self = [super init]))
        return nil;
    _isSucceed=NO;
    _resourceID=nil;
    _resourceLocation=nil;
    
    _error=nil;
    
    return self;
    
}

-(instancetype)initWitJson:(NSString*)strJson
{
    NSError *e;
    NSDictionary *JSON =[NSJSONSerialization JSONObjectWithData: [strJson dataUsingEncoding:NSUTF8StringEncoding]
                                    options: NSJSONReadingMutableContainers
                                      error: &e];

    _isSucceed=(NSNumber*)[JSON objectForKey:@"succeed"];
     _resourceID=[JSON objectForKey:@"newResourceID"];
     _resourceLocation=[JSON objectForKey:@"newResourceLocation"];
    
    if ([JSON objectForKey:@"error"])
    {
        _error=[JSON objectForKey:@"error"];
        _isSucceed=NO;
    }
    
    return self;

}

@end
