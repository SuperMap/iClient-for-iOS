//
//  DatasourceConnectionInfo.m
//  MapView
//
//  Created by iclient on 13-6-25.
//
//

#import "DatasourceConnectionInfo.h"

@implementation DatasourceConnectionInfo

@synthesize alias,connect,dataBase,driver,exclusive,OpenLinkTable,password,readOnly,server,user;

- (NSMutableDictionary *)toNSDictionary
{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setValue:self.alias forKey:@"alias"];
    [dictionary setValue:self.connect forKey:@"connect"];
    [dictionary setValue:self.dataBase forKey:@"dataBase"];
    [dictionary setValue:self.driver forKey:@"driver"];
    [dictionary setValue:self.exclusive forKey:@"exclusive"];
    [dictionary setValue:self.OpenLinkTable forKey:@"OpenLinkTable"];
    [dictionary setValue:self.password forKey:@"password"];
    [dictionary setValue:self.readOnly forKey:@"readOnly"];
    [dictionary setValue:self.server forKey:@"server"];
    [dictionary setValue:self.user forKey:@"user"];
    
    return dictionary;
}
@end
