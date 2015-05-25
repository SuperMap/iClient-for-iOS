//
//  TransportationAnalystParameter.h
//  MapView
//
//  Created by iclient on 14-5-28.
//
//

#import <Foundation/Foundation.h>
#import "TransportationAnalystResultSetting.h"

/**
 * Class: TransportationAnalystParameter
 * 交通网络分析通用参数类。
 * 该类主要用来提供交通网络分析所需的通用参数。
 * 通过本类可以设置障碍边、障碍点、权值字段信息的名称标识、转向权值字段等信息，还可以对分析结果包含的内容进行一些设置。
 */
@interface TransportationAnalystParameter : NSObject
{
    NSMutableArray *barrierEdgeIDs;
    NSMutableArray *barrierNodeIDs;
    NSMutableArray *barrierPoints;
    NSString *weightFieldName;
    NSString *turnWeightField;
    TransportationAnalystResultSetting *resultSetting;
}

/**
 * APIProperty: barrierEdgeIDs
 * {NSMutableArray} 网络分析中障碍弧段的 ID 数组。弧段设置为障碍边之后，表示双向都不通。
 */
@property (retain,readwrite)  NSMutableArray *barrierEdgeIDs;

/**
 * APIProperty: barrierNodeIDs
 * {NSMutableArray} 网络分析中障碍点的 ID 数组。结点设置为障碍点之后，表示任何方向都不能通过此结点。
 */
@property (retain,readwrite)  NSMutableArray *barrierNodeIDs;

/**
 * APIProperty: barrierPoints
 * {NSMutableArray(<RMPath>)}网络分析中 RMPath 类型的障碍点数组。障碍点表示任何方向都不能通过此点。
 * 当各网络分析参数类中的 isAnalyzeById 属性设置为 NO 时，该属性才生效。
 */
@property (retain,readwrite)  NSMutableArray *barrierPoints;

/**
 * APIProperty: weightFieldName
 * {NSString} 阻力字段的名称，标识了进行网络分析时所使用的阻力字段，例如表示时间、长度等的字段都可以用作阻力字段。
 * 该字段默值为服务器发布的所有耗费字段的第一个字段。
 */
@property (retain,readwrite)  NSString *weightFieldName;

/**
 * APIProperty: turnWeightField
 * {NSString} 转向权重字段的名称。
 */
@property (retain,readwrite)  NSString *turnWeightField;

/**
 * APIProperty: resultSetting
 * {<TransportationAnalystResultSetting>} 分析结果返回内容。
 */
@property (retain,readwrite)   TransportationAnalystResultSetting *resultSetting;

-(id) init;

-(NSString *) toString;
@end
