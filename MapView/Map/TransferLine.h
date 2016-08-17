//
//  TransferLine.h
//  MapView
//
//  Created by supermap on 15-3-4.
//
//
/**
 * Class: TransferLine 
 *  换乘线路信息类。
 * 
 * Inherits from:
 *  - <NSObject>
 */
#import <Foundation/Foundation.h>

@interface TransferLine : NSObject

/**
 * APIProperty: endStopIndex
 * {NSInteger} 下车站点在本公交线路中的索引。
 */
@property NSInteger endStopIndex;
/**
 * APIProperty: endStopName
 * {NSString} 下车站点名称。
 */
@property(nonatomic,retain) NSString *endStopName;

/**
 * APIProperty: endStopName
 * {NSString} 下车站点名称别名。
 */
@property(nonatomic,retain) NSString *endStopAliasName;
/**
 * APIProperty: lineID
 * {long} 乘车线路id。
 */
@property long lineID;
/**
 * APIProperty: lineName
 * {NSString} 乘车线路名称。
 */
@property(nonatomic,retain) NSString *lineName;

/**
 * APIProperty: lineName
 * {NSString} 乘车线路名称别名。
 */
@property(nonatomic,retain) NSString *lineAliasName;
/**
 * APIProperty: startStopIndex
 * {NSInteger} 上车站点在本公交线路中的索引。
 */
@property NSInteger startStopIndex;
/**
 * APIProperty: startStopName
 * {NSString} 上车站点名称。
 */
@property(nonatomic,retain) NSString *startStopName;

/**
 * APIProperty: lineName
 * {NSString} 乘车线路名称别名。
 */
@property(nonatomic,retain) NSString *startStopAliasName;
/**
 * Constructor: TransferLine
 *  换乘线路信息类。
 *
 * Parameters:
 *      dict - {NSDictionary} 对象。
 */
-(id)initWithDict:(NSDictionary *)dict;
/**
 * APIMethod: castToDict
 * 转换为字典，只返回endStopIndex，lineID，startStopIndex三个键值对，用做Path服务请求参数
 */
-(NSMutableDictionary *)castToDict;
/**
 * APIMethod: castToDict
 * 返回一个字典，用于转换为json格式数据。
 */
-(NSString *)castToJson;
@end
