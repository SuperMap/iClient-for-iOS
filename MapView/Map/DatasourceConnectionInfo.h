//
//  DatasourceConnectionInfo.h
//  MapView
//
//  Created by iclient on 13-6-25.
//
//

#import <Foundation/Foundation.h>

/**
 *	@brief	数据源连接信息类。
 * 该类包含了数据源名称、数据源连接的数据库或文件等相关信息
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
 *	@brief	数据源别名
 */
@property (copy,readwrite) NSString* alias;
/**
 *	@brief	数据源是否自动连接数据
 */
@property (readwrite) BOOL connect;

/**
 *	@brief	数据源连接的数据库名
 */
@property (copy,readwrite) NSString* dataBase;

/**
 *	@brief	使用 ODBC(Open Database Connectivity，开放数据库互连)的数据库的驱动程序名
 */
@property (copy,readwrite) NSString* driver;

/**
 *	@brief	是否以独占方式打开数据源
 */
@property (readwrite) BOOL exclusive;

/**
 *	@brief	是否把数据库中的其他非 SuperMap 数据表作为 LinkTable 打开
 */
@property (readwrite) BOOL OpenLinkTable;

/**
 *	@brief	登录数据源连接的数据库或文件的密码
 */
@property (copy,readwrite) NSString* password;

/**
 *	@brief	是否以只读方式打开数据源
 */
@property (readwrite) BOOL readOnly;

/**
 *	@brief	数据库服务器名或本地数据文件名
 */
@property (copy,readwrite) NSString* server;

/**
 *	@brief	登录数据库的用户名
 */
@property (copy,readwrite) NSString* user;

- (NSMutableDictionary *)toNSDictionary;


@end
