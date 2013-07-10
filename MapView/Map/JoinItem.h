//
//  JoinItem.h
//  MapView
//
//  Created by iclient on 13-6-25.
//
//

#import <Foundation/Foundation.h>

/**
 *	@brief	连接信息类。\n
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

@property (copy,readwrite) NSString* foreignTableName;
@property (copy,readwrite) NSString* joinFilter;
@property (copy,readwrite) NSString* joinType;

- (NSMutableDictionary *)toNSDictionary;

@end
