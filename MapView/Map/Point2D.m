//
//  Point2D.m
//  MapView
//
//  Created by supermap on 15-3-4.
//
//

#import "Point2D.h"

@implementation Point2D
-(id)initWithDict:(NSDictionary *)dict{
    [self init];
    
    if ([dict isKindOfClass:[NSDictionary class]]) {
        _x = [[dict objectForKey:@"x"] doubleValue];
        _y = [[dict objectForKey:@"y"] doubleValue];
    }
    return self;
}

-(id)initWithx:(double)x y:(double)y{
    [self init];
    _x = x;
    _y = y;
    
    return self;
}

-(NSDictionary *)castToDict{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:[NSString stringWithFormat:@"%f",_x] forKey:@"x"];
    [dict setObject:[NSString stringWithFormat:@"%f",_y] forKey:@"y"];
        
    return dict;
}
@end
