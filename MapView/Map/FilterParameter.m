//
//  FilterParameter.m
//  MapView
//
//  Created by iclient on 13-6-25.
//
//

#import "FilterParameter.h"
#import "JoinItem.h"
#import "LinkItem.h"

@implementation FilterParameter

@synthesize attributeFilter,name,joinItems,linkItems,ids,orderBy,groupBy,fields;

- (NSMutableDictionary *)toNSDictionary
{
    NSMutableArray *joinList = [[NSMutableArray alloc] init];
    for(JoinItem* item in self.joinItems){
        [joinList addObject:[item toNSDictionary]];
    }
    
    NSMutableArray *linkList = [[NSMutableArray alloc] init];
    for(LinkItem* item in self.linkItems){
        [linkList addObject:[item toNSDictionary]];
    }
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setValue:self.attributeFilter forKey:@"attributeFilter"];
    [dictionary setValue:self.name forKey:@"name"];
    if ([joinList count] > 0) {
        [dictionary setValue:joinList forKey:@"joinItems"];
    }else{
        [dictionary setValue:NULL forKey:@"joinItems"];
    }
    if ([linkList count] > 0) {
        [dictionary setValue:linkList forKey:@"linkItems"];
    }else{
        [dictionary setValue:NULL forKey:@"linkItems"];
    }
    
    [dictionary setValue:self.ids forKey:@"ids"];
    [dictionary setValue:self.orderBy forKey:@"orderBy"];
    [dictionary setValue:self.groupBy forKey:@"groupBy"];
    [dictionary setValue:self.fields forKey:@"fields"];
    
    return dictionary;
}

@end
