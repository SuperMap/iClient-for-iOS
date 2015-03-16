//
//  TransferGuide.m
//  MapView
//
//  Created by supermap on 15-3-4.
//
//

#import "TransferGuide.h"
#import "TransferGuideItem.h"

@implementation TransferGuide
-(id)initWithDict:(NSDictionary *)dict{
    [self init];
    _count = [[dict objectForKey:@"count"] integerValue];
    _totalDistance = [[dict objectForKey:@"totalDistance"] doubleValue];
    _transferCount = [[dict objectForKey:@"transferCount"] integerValue];
    NSArray *arr = [dict objectForKey:@"items"];
    _transferGuideItems = [[NSMutableArray alloc] init];
    for (int i=0; i<[arr count]; i++) {
        TransferGuideItem *item = [[TransferGuideItem alloc] initWithDict:[arr objectAtIndex:i]];
        [_transferGuideItems addObject:item];
    }
    
    return self;
}

@end
