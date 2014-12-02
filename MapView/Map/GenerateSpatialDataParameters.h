//
//  GenerateSpatialDataParameters.h
//  MapView
//
//  Created by iclient on 14/11/26.
//
//

#import <Foundation/Foundation.h>
#import "DataReturnOption.h"

/**
 * Class: GenerateSpatialDataParameters
 * 动态分段操作参数类。通过该类可以为动态分段提供参数信息。
 *
 * Inherits from:
 *  - <NSObject>
 */
@interface GenerateSpatialDataParameters : NSObject

/**
 * APIProperty: routeTable
 * {NSString} 路由数据集。
 */
@property (assign) NSString* routeTable;
/**
 * APIProperty: routeIDField
 * {NSString} 路由数据集的标识字段。
 */
@property (assign) NSString* routeIDField;
/**
 * APIProperty: eventTable
 * {NSString} 用于生成空间数据的事件表名。
 */
@property (assign) NSString* eventTable;
/**
 * APIProperty: eventRouteIDField
 * {NSString} 用于生成空间数据的事件表的路由标识字段。
 */
@property (assign) NSString* eventRouteIDField;
/**
 * APIProperty: measureField
 * {NSString} 用于生成空间数据的事件表的刻度字段，只有当事件为点事件的时候该属性才有意义
 */
@property (assign) NSString* measureField;
/**
 * APIProperty: measureStartField
 * {NSString} 用于生成空间数据的事件表的起始刻度字段，只有当事件为线事件的时候该属性才有意义。
 */
@property (assign) NSString* measureStartField;
/**
 * APIProperty: measureEndField
 * {NSString} 用于生成空间数据的事件表的终止刻度字段，只有当事件为线事件的时候该属性才有意义。
 */
@property (assign) NSString* measureEndField;
/**
 * APIProperty: measureOffsetField
 * {NSString} 刻度偏移量字段。
 */
@property (assign) NSString* measureOffsetField;
/**
 * APIProperty: errorInfoField
 * {NSString} 错误信息字段，直接写入原事件表，用于描述事件未能生成对应的点或线时的错误信息。
 */
@property (assign) NSString* errorInfoField;
/**
 * APIProperty: retainedFields
 * {Array(NSString)} 欲保留到结果空间数据中的字段集合（系统字段除外）。
 *  生成空间数据时，无论是否指定保留字段，路由 ID 字段、刻度偏移量字段、刻度值字段（点事件为刻度字段，线事件是起始和终止刻度字段）都会保留到结果空间数据中；
 *  如果没有指定 retainedFields 参数或者retainedFields 参数数组长度为0，则返回所有用户字段。
 */

@property (assign) NSString* retainedFields;

/**
 * APIProperty: dataReturnOption
 * {<DataReturnOption>} 设置数据返回的选项。
 */
@property (assign)DataReturnOption* dataReturnOption;


/**
 * Constructor: GenerateSpatialDataParameters
 * 动态分段操作参数类构造函数
 *
 * Parameters:
 * routeTable - {NSString} 路由数据集。
 * routeIDField - {NSString} 路由数据集的标识字段。
 * eventTable - {NSString} 用于生成空间数据的事件表名。
 * eventRouteIDField - {NSString} 用于生成空间数据的事件表的路由标识字段。
 * measureStartField - {NSString} 用于生成空间数据的事件表的起始刻度字段，只有当事件为线事件的时候该属性才有意义。
 * measureEndField - {NSString} 用于生成空间数据的事件表的终止刻度字段，只有当事件为线事件的时候该属性才有意义。
 * dataReturnOption - {<DataReturnOption>} 设置数据返回的选项。
 */
-(instancetype)initWithRouteTable:(NSString *)routeTable routeIDField:(NSString *)routeIDField eventTable:(NSString *)eventTable eventRouteIDField:(NSString *)eventRouteIDField measureStartField:(NSString *)measureStartField measureEndField:(NSString *)measureEndField  dataReturnOption:(DataReturnOption *)dataReturnOption;

-(NSMutableDictionary*)toDictionary;

@end
