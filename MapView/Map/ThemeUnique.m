//
//  ThemeUnique.m
//  MapView
//
//  Created by iclient on 14/11/24.
//
//

#import "ThemeUnique.h"

@implementation ThemeUnique
-(instancetype)init
{
    if (!(self = [super init]))
        return nil;
 
    return self;
    
}

-(instancetype)initWithUniqueExpression:(NSString*)uniqueExpression items:(NSMutableArray*)items defaultStyle:(ServerStytle*) defaultStyle
{
    [self init];
   
    _uniqueExpression=[[NSString alloc]initWithString:uniqueExpression];
    _items=[[NSMutableArray alloc]initWithArray:items];
    _defaultStyle=defaultStyle;
    
    return self;
    
}
-(NSMutableDictionary *)toDictionary
{
    NSMutableArray *items=[[NSMutableArray alloc]initWithCapacity:3];
    for(ThemeUniqueItem * item in _items)
    {
        [items addObject:[item toDictionary]];
        
    }

    NSString *themeID=[[NSString alloc]initWithString:@"UNIQUE"];
    
    NSMutableDictionary *themeUniqueDictionary=[NSMutableDictionary new];
    [themeUniqueDictionary setValue:[_defaultStyle toDictionary]forKey:@"defaultStyle"];
     [themeUniqueDictionary setValue:themeID forKey:@"type"];
    [themeUniqueDictionary setValue:_uniqueExpression forKey:@"uniqueExpression"];
    [themeUniqueDictionary setValue:items forKey:@"items"];
   
    return themeUniqueDictionary;

}

@end
