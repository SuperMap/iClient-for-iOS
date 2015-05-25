//
//  ServerStytle.m
//  MapView
//
//  Created by iclient on 14/11/24.
//
//

#import "ServerStytle.h"

@implementation ServerStytle

{
    float _fillForeColorAlpha;
    
}
-(instancetype)init
{
    if (!(self = [super init]))
        return nil;
    _fillForeColor=[UIColor colorWithRed:255 green:0 blue:0 alpha:1];
    _lineColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:1];
    _lineWidth=1;
    _fillOpaqueRate=100;
    _lineSymbolID=0;
    
    return self;
    
}

-(instancetype)initLineStytleWithFillForeColor:(UIColor *)aFillForeColor lineColor:(UIColor *)alineColor lineWidth:(CGFloat)alineWidth
{
    [self init];
    
    _fillForeColor=aFillForeColor;
    _lineColor=alineColor;
    _lineWidth=alineWidth;
    CGFloat aFillOpaqueRate=[self getFillForeColorAlpha:aFillForeColor];
    _fillOpaqueRate=aFillOpaqueRate?round(aFillOpaqueRate*100):100;
    _lineSymbolID=0;
    
    return self;
    
}

-(instancetype)initLineStytleWithFillForeColor:(UIColor *)aFillForeColor lineColor:(UIColor *)alineColor lineWidth:(CGFloat)alineWidth :(CGFloat)fillOpaqueRate
{
    [self init];
    
    _fillForeColor=aFillForeColor;
    _lineColor=alineColor;
    _lineWidth=alineWidth;
    _fillOpaqueRate=fillOpaqueRate;
    _lineSymbolID=0;
    
    return self;
    
}
-(NSMutableDictionary*)toDictionary
{
    NSMutableDictionary *styleDictionary=[NSMutableDictionary new];
    [styleDictionary setValue:[self strRBGWithColor:_fillForeColor] forKey:@"fillForeColor"];
    [styleDictionary setValue:[self strRBGWithColor:_lineColor] forKey:@"lineColor"];
    [styleDictionary setValue:[NSNumber numberWithFloat:_lineWidth] forKey:@"lineWidth"];
    [styleDictionary setValue:[NSNumber numberWithFloat:_fillOpaqueRate] forKey:@"fillOpaqueRate"];
    [styleDictionary setValue:[NSNumber numberWithInteger:_lineSymbolID] forKey:@"lineSymbolID"];
    
    return styleDictionary;
}

-(NSMutableDictionary *)strRBGWithColor:(UIColor*)color
{
    
    NSMutableDictionary *colorDictionary=[NSMutableDictionary new];
    
    CGColorRef colorRef = [color CGColor];
    int numComponents = [[NSNumber numberWithUnsignedLong:CGColorGetNumberOfComponents(colorRef)] intValue];
    if (numComponents == 4)
    {
        const CGFloat *components = CGColorGetComponents(colorRef);
        
        [colorDictionary setValue:[NSNumber numberWithLong:lround(components[0] * 255)] forKey:@"red"];
        [colorDictionary setValue:[NSNumber numberWithLong:lround(components[1] * 255)] forKey:@"green"];
        [colorDictionary setValue:[NSNumber numberWithLong:lround(components[2] * 255)] forKey:@"blue"];
    }
    else
    {
        NSLog(@"the UIColor in ServerStytle is bad");
    }
    return colorDictionary;
}
-(CGFloat)getFillForeColorAlpha:(UIColor*)color
{
    CGFloat alpha;
    
    CGColorRef colorRef = [color CGColor];
    const CGFloat *components = CGColorGetComponents(colorRef);
    alpha = components[3];
    
    return alpha;
}


@end
