//
//  LinkItem.h
//  MapView
//
//  Created by iclient on 13-6-25.
//
//

#import <Foundation/Foundation.h>
#import "DatasourceConnectionInfo.h"

/**
 * Class: LinkItem
 * 关联信息类。
 * 该类用于定义矢量数据集与外部表之间的关联信息。
 * 外部表可以为另一个矢量数据集（其中纯属性数据集中没有空间几何信息）所对应的 DBMS 表，也可以是用户自建的业务表。
 * 表之间的联系的建立有两种方式，一种是连接（join），一种是关联（link）。连接的相关设置是通过JoinItem类实现的，
 * 关联的相关设置是通过LinkItem类实现的，另外，用于建立连接的两个表必须在同一个数据源下，
 * 而用于建立关联关系的两个表可以不在同一个数据源下。矢量数据集与外部表可以属于不同的数据源。
 * 使用 LinkItem 的约束条件：空间数据和属性数据必须有关联条件，即主空间数据集与外部属性表之间存在关联字段。
 * 主空间数据集：用来与外部表进行关联的数据集。
 * 外部属性表：用户通过 Oracle 或者 SQL Server 创建的数据表，
 * 或者是另一个矢量数据集所对应的 DBMS(Database Management System，数据库管理系统)表。
 *
 */
@interface LinkItem : NSObject

{
    DatasourceConnectionInfo* datasourceConnectionInfo;
    NSString* foreignKeys;
    NSString* foreignTable;
    NSString* linkFields;
    NSString* linkFilter;
    NSString* name;
    NSMutableArray* primaryKeys;
}

/**
 * APIProperty: datasourceConnectionInfo
 * {<DatasourceConnectionInfo>} 关联的外部数据源信息 。
 */
@property (retain,readwrite) DatasourceConnectionInfo* datasourceConnectionInfo;

/**
 * APIProperty: foreignKeys
 * {NSString} 主空间数据集的外键。
 */
@property (copy,readwrite) NSString* foreignKeys;

/**
 * APIProperty: foreignTable
 * {NSString} 关联的外部属性表的名称。
 */
@property (copy,readwrite) NSString* foreignTable;

/**
 * APIProperty: linkFields
 * {NSString} 欲保留的外部属性表的字段。
 */
@property (copy,readwrite) NSString* linkFields;

/**
 * APIProperty: linkFilter
 * {NSString} 与外部属性表的连接条件。
 */
@property (copy,readwrite) NSString* linkFilter;

/**
 * APIProperty: name
 * {NSString} 此关联信息对象的名称。
 */
@property (copy,readwrite) NSString* name;

/**
 * APIProperty: primaryKeys
 * {NSMutableArray} 需要关联的外部属性表的主键。
 */
@property (retain,readwrite) NSMutableArray* primaryKeys;

- (NSMutableDictionary *)toNSDictionary;

@end
