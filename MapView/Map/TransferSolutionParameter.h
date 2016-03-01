//
//  TransferSolutionParameter.h
//  MapView
//
//  Created by supermap on 15-3-6.
//
//

/**
 * Class: TransferSolutionParameter
 * 换乘分析方案请求参数类
 * 
 * Inherits from:
 *  - <NSObject>
 */
#import <Foundation/Foundation.h>
#import "TransferTactic.h"
@interface TransferSolutionParameter : NSObject
/**
 * APIProperty: points
 * {NSMutableArray} 乘车方案的起始和终止点组成的数组，可以起始或终止点的地理坐标 即{<Point2D>}类型数组,也可以是站点id组成的Integer数组
 */
@property(nonatomic,retain) NSMutableArray *points;
/**
 * APIProperty: solutionCount
 * {NSInteger} 返回的乘车方案的数量。
 */
@property(nonatomic) NSInteger solutionCount;
/**
 * APIProperty: walkingRatio
 * {double} 步行与公交的消耗权重比，默认值为10。
 */
@property(nonatomic) double walkingRatio;
/**
 * APIProperty: transferTactic
 * {NSString} 公交换乘策略类型。在{<TransferTactic>}类中定义。
 */
@property(nonatomic,retain) NSString *transferTactic;
/**
 * APIProperty: transferPreference
 * {NSString} 乘车偏好，在{<TransferPreference>}类中定义。
 */
@property(nonatomic,retain) NSString *transferPreference;

/**
 * APIProperty: evadelLines
 * {NSMutableArray} 避让线路ID集合，可选参数。
 */
@property(nonatomic,retain) NSMutableArray *evadelLines;

/**
 * APIProperty: evadelStops
 * {NSMutableArray} 避让站点ID集合，可选参数。
 */
@property(nonatomic,retain) NSMutableArray *evadelStops;
/**
 * APIProperty: priorLines
 * {NSMutableArray} 优先线路ID集合，可选参数。
 */
@property(nonatomic,retain) NSMutableArray *priorLines;

/**
 * APIProperty: priorStops
 * {NSMutableArray} 优先站点ID集合，可选参数。
 */
@property(nonatomic,retain) NSMutableArray *priorStops;

/**
 * 出行时间，如:早上八点半--"8:30"。设置了该参数，分析时，会考虑线路的首末班车时间的限制。过滤掉运行时间不包含出行时间的线路。
 */
@property(nonatomic,retain)NSString* travelTime;
/**
 * Constructor: TransferSolutionParameter
 * 交通换乘方案类
 *
 * Parameters:
 * points - {NSMutableArray} 乘车方案的起始和终止点组成的数组，可以起始或终止点的
 *           地理坐标即{<Point2D>}类型数组,也可以是站点id组成的Integer数组。
 *
 * solutionCount - {NSInteger}返回的乘车方案的数量，默认值为5。
 *
 * walkingRatio - {double}步行与公交的消耗权重比，默认值为10。
 *
 * transferTactic - {NSString}公交换乘策略类型。在{<TransferTactic>}类中定义。
 *
 * transferPreference - {NSString} 乘车偏好，在{<TransferPreference>}类中定义
 */
-(id)initWithPoints:(NSArray *)points solutionCount:(NSInteger *)solutionCount walkingRatio:(double) walkingRatio transferTactic:(NSString *) transferTactic transferPreference:(NSString *)transferPreference;

@end
