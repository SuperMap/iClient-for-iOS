//
//  TransferLines.m
//  MapView
//
//  Created by supermap on 15-3-4.
//
//

#import "TransferLines.h"
#import "TransferLine.h"

@implementation TransferLines

-(id)initWithArr:(NSDictionary *)dict{
    [self init];
    _lineItems = [[NSMutableArray alloc] init];
    NSArray *arr = [dict objectForKey:@"lineItems"];
    for (int i=0; i<[arr count]; i++) {
        TransferLine *line = [[TransferLine alloc] initWithDict:[arr objectAtIndex:i]];
        [_lineItems addObject:line];
    }
    
    return self;
}

-(NSDictionary *)castToDict{
    NSMutableDictionary  *dict = [[NSMutableDictionary alloc] init];
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    for (int i=0; i<[_lineItems count]; i++) {
       [arr addObject:[[_lineItems objectAtIndex:i] castToDict]];
    }
    
    [dict setObject:arr forKey:@"lineItems" ];
    return dict;
}

@end
