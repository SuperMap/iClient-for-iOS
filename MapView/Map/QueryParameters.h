//
//  QueryParameters.h
//  MapView
//
//  Created by iclient on 13-6-25.
//
//

#import <Foundation/Foundation.h>
#import "FilterParameter.h"

/**
 * Class: QueryParameters
 * 查询参数基类。
 * 距离查询、SQL 查询、几何地物查询等各自的参数均继承此类。
 */
@interface QueryParameters : NSObject

{
    NSString* customParams;
    int expectCount;
    NSString* networkType;
    NSString* queryOption;
    NSMutableArray* queryParams;
    int startRecord;
    int holdTime;
    BOOL returnCustomResult;
    BOOL returnContent;
}

/**
 * APIProperty: customParams
 * {NSString} 自定义参数，供扩展使用。
 */
@property (copy,readwrite) NSString* customParams;

/**
 * APIProperty: expectCount
 * {int} 期望返回结果记录个数，默认返回100000条查询记录，
 * 如果实际不足100000条则返回实际记录条数。
 */
@property (readwrite) int expectCount;

/**
 * APIProperty: networkType
 * {NSString} 网络数据集对应的查询类型，
 * 分为点和线两种类型，默认为线几何对象类型，即GeometryType.LINE。
 */
@property (copy,readwrite) NSString* networkType;

/**
 * APIProperty: queryOption
 * {NSString} 查询结果类型枚举类。
 * 该类描述查询结果返回类型，包括只返回属性、
 * 只返回几何实体以及返回属性和几何实体。
 */
@property (copy,readwrite) NSString* queryOption;

/**
 * APIProperty: queryParams
 * {NSMutableArray(<FilterParameter>)} 查询过滤条件参数数组。
 * 该类用于设置查询数据集的查询过滤参数。
 */
@property (copy,readwrite) NSMutableArray* queryParams;

/**
 * APIProperty: startRecord
 * {int} 查询起始记录号，默认值为0。
 */
@property (readwrite) int startRecord;

/**
 * APIProperty: holdTime
 * {int} 资源在服务端保存的时间。默认为10（分钟）。
 */
@property (readwrite) int holdTime;

@property (readwrite) BOOL returnContent;

/**
 * Property: returnCustomResult
 * {BOOL} 仅供三维使用。
 */
@property (readonly) BOOL returnCustomResult;

- (NSMutableDictionary *)toNSDictionary;

@end
