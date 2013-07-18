//
//  DatasourceConnectionInfo.h
//  MapView
//
//  Created by iclient on 13-6-25.
//
//

#import <Foundation/Foundation.h>

/**
 * Class: DatasourceConnectionInfo
 * 数据源连接信息类。
 * 该类包含了数据源名称、数据源连接的数据库或文件等相关信息。
 */
@interface DatasourceConnectionInfo : NSObject
{
    NSString* alias;
    BOOL connect;
    NSString* dataBase;
    NSString* driver;
    BOOL exclusive;
    BOOL OpenLinkTable;
    NSString* password;
    BOOL readOnly;
    NSString* server;
    NSString* user;
}

/**
 * APIProperty: alias
 * {NSString} 数据源别名。
 */
@property (copy,readwrite) NSString* alias;

/**
 * APIProperty: connect
 * {BOOL} 数据源是否自动连接数据。
 */
@property (readwrite) BOOL connect;

/**
 * APIProperty: dataBase
 * {NSString} 数据源连接的数据库名。
 */
@property (copy,readwrite) NSString* dataBase;

/**
 * APIProperty: driver
 * {NSString} 使用 ODBC(Open Database Connectivity，开放数据库互连)的数据库的驱动程序名。
 */
@property (copy,readwrite) NSString* driver;

/**
 * APIProperty: exclusive
 * {BOOL} 是否以独占方式打开数据源。
 */
@property (readwrite) BOOL exclusive;

/**
 * APIProperty: OpenLinkTable
 * {BOOL} 是否把数据库中的其他非 SuperMap 数据表作为 LinkTable 打开。
 */
@property (readwrite) BOOL OpenLinkTable;

/**
 * APIProperty: password
 * {NSString} 登录数据源连接的数据库或文件的密码。
 */
@property (copy,readwrite) NSString* password;

/**
 * APIProperty: readOnly
 * {BOOL} 是否以只读方式打开数据源。
 */
@property (readwrite) BOOL readOnly;

/**
 * APIProperty: server
 * {NSString} 数据库服务器名或 SDB 文件名。
 */
@property (copy,readwrite) NSString* server;

/**
 * APIProperty: user
 * {NSString} 登录数据库的用户名。
 */
@property (copy,readwrite) NSString* user;

- (NSMutableDictionary *)toNSDictionary;


@end
