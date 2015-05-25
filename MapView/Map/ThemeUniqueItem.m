//
//  ThemeUniqueItem.m
//  MapView
//
//  Created by iclient on 14/11/24.
//
//

#import "ThemeUniqueItem.h"

@implementation ThemeUniqueItem
-(instancetype)init
{
    if (!(self = [super init]))
        return nil;
    
    _unique=[NSString new];
    _style=[ServerStytle new];
    _visible=YES;
    _caption=[NSString new];
    
    
    return self;
    
}

-(instancetype)initWithUnique:(NSString*)unique serverStyle:(ServerStytle *)style
{
    [self init];
    _unique=[[NSString alloc]initWithString:unique];
    _style=style;
    
    return self;
    
}
-(instancetype)initWithUnique:(NSString*)unique serverStyle:(ServerStytle *)style caption:(NSString*)caption
{
    [self init];
    
    _unique=unique;
    _style=style;
    _caption=caption;
    
    return self;
    
}
-(instancetype)initWithUnique:(NSString*)unique serverStyle:(ServerStytle *)style caption:(NSString*)caption visible:(BOOL)visible
{
    [self init];
    
    _unique=unique;
    _style=style;
    _caption=caption;
    _visible=visible;
    
    return self;
}

-(NSMutableDictionary*)toDictionary
{
    
    NSMutableDictionary *itemDictionary=[NSMutableDictionary new];
  
    [itemDictionary setValue:_unique forKey:@"unique"];
    [itemDictionary setValue:_caption forKey:@"caption"];
    [itemDictionary setValue:[_style toDictionary] forKey:@"style"];
    [itemDictionary setValue:[NSNumber numberWithBool:_visible] forKey:@"visible"];
    
    return itemDictionary;
    
}

@end
