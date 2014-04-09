//
//  JoinItem.h
//  MapView
//
//  Created by iclient on 13-6-25.
//
//

#import <Foundation/Foundation.h>

/**
 * Class: JoinItem
 * 连接信息类。
 * 该类用于定义矢量数据集与外部表的连接信息。
 * 外部表可以为另一个矢量数据集（其中纯属性数据集中没有空间几何信息）
 * 所对应的 DBMS(Database Management System，数据库管理系统)表，
 * 也可以是用户自建的业务表。需要注意的是，矢量数据集与外部表必须属于同一数据源。
 * 用于连接两个表的字段的名称不一定相同，但类型必须一致。
 */
@interface JoinItem : NSObject

{
    NSString* foreignTableName;
    NSString* joinFilter;
    NSString* joinType;    
}

/**
 * APIProperty: foreignTableName
 * {NSString} 外部表的名称。
 * 如果外部表的名称是以“表名@数据源名”命名方式，则该属性只需赋值表名。
 * 例如：外部表 Name@changchun，Name 为表名，changchun 为数据源名称，则该属性的赋值应为：Name。
 */
@property (copy,readwrite) NSString* foreignTableName;

/**
 * APIProperty: joinFilter
 * {NSString} 矢量数据集与外部表之间的连接表达式，即设定两个表之间关联的字段。
 * 例如，将房屋面数据集（Building）的 district 字段与房屋拥有者的纯属性数据集（Owner）的 region 字段相连接，
 * 两个数据集对应的表名称分别为 Table_Building 和 Table_Owner，
 * 则连接表达式为 Table_Building.district = Table_Owner.region。
 * 当有多个字段相连接时，用 AND 将多个表达式相连。
 */
@property (copy,readwrite) NSString* joinFilter;

/** APIProperty: joinType
 * {NSString} 两个表之间连接类型。
 * 连接类型决定了对两个表进行连接查询后返回的记录的情况。
 */
@property (copy,readwrite) NSString* joinType;

- (NSMutableDictionary *)toNSDictionary;

@end
