//
//  LinkItem.m
//  MapView
//
//  Created by iclient on 13-6-25.
//
//

#import "LinkItem.h"

@implementation LinkItem

@synthesize datasourceConnectionInfo,foreignKeys,foreignTable,linkFields,linkFilter,name,primaryKeys;

- (NSMutableDictionary *)toNSDictionary
{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setValue:self.datasourceConnectionInfo forKey:@"datasourceConnectionInfo"];
    [dictionary setValue:self.foreignKeys forKey:@"foreignKeys"];
    [dictionary setValue:self.foreignTable forKey:@"foreignTable"];
    [dictionary setValue:self.linkFields forKey:@"linkFields"];
    [dictionary setValue:self.linkFilter forKey:@"linkFilter"];
    [dictionary setValue:self.name forKey:@"name"];
    [dictionary setValue:self.primaryKeys forKey:@"primaryKeys"];
    
    return dictionary;
}

@end
