//
//  JoinItem.m
//  MapView
//
//  Created by iclient on 13-6-25.
//
//

#import "JoinItem.h"

@implementation JoinItem

@synthesize foreignTableName,joinFilter,joinType;

-(id) init
{
    foreignTableName = nil;
    joinFilter = nil;
    joinType = nil;
    
    return self;
}

- (NSMutableDictionary *)toNSDictionary
{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setValue:self.foreignTableName forKey:@"foreignTableName"];
    [dictionary setValue:self.joinFilter forKey:@"joinFilter"];
    [dictionary setValue:self.joinType forKey:@"joinType"];
    
    return dictionary;
}
@end
