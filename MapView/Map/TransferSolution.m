//
//  TransferSolution.m
//  MapView
//
//  Created by supermap on 15-3-4.
//
//

#import "TransferSolution.h"
#import "TransferLines.h"

@implementation TransferSolution

-(id)initWithDict:(NSDictionary *)dict{
    [self init];
    _transferCount = [[dict objectForKey:@"transferCount"] integerValue];
    NSArray *arr = [dict objectForKey:@"linesItems"];
    _linesItems = [[NSMutableArray alloc] init];
    for (int i=0; i<[arr count]; i++) {
        TransferLines *lines = [[TransferLines alloc] initWithArr:[arr objectAtIndex:i]];
        [_linesItems addObject:lines];
    }
    
    return self;
}

-(NSDictionary *)castToDict{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    NSMutableArray *arr = [[NSMutableArray   alloc] init];
    for (int i=0; i<[_linesItems count]; i++) {
       [arr addObject:[[_linesItems objectAtIndex:i] castToDict]];
    }
    [dict setObject:arr forKey:@"linesItems"];
    [dict setObject:_transferCount forKey:@"transferCount"];
    return dict;
}
@end
