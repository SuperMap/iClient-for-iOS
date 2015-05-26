//
//  QueryByDistanceParameters.h
//  MapView
//
//  Created by iclient on 13-6-27.
//
//

#import "QueryParameters.h"
#import "RMPath.h"

/**
 * Class: QueryByDistanceParameters
 * Distance 查询参数类。
 * 该类用于设置 Distance 查询的相关参数。
 *
 * Inherits from:
 *  - <QueryParameters>
 */
@interface QueryByDistanceParameters : QueryParameters

{
    double distance;
    RMPath* geometry;
    BOOL isNearest;
}

/**
 * APIProperty: geometry
 * {<RMPath>} 用于查询的地理对象，必设属性。
 */
@property (copy,readwrite) RMPath* geometry;

/**
 * APIProperty: distance
 * {double} 查询距离，默认为0.0，单位与所查询图层对应的数据集单位相同。
 * 当查找最近地物时，该属性无效。
 */
@property (readwrite) double distance;

/**
 * APIProperty: isNearest
 * {BOOL} 是否为最近距离查询。
 * 建议该属性与 expectCount 属性联合使用。
 * 当该属性为 true 时，即表示查找最近地物，expectCount（继承自 QueryParameters）。
 * 表示期望返回几个最近地物，地物返回的先后顺序按距离从近到远排列。
 */
@property (readwrite) BOOL isNearest;

/**
 * Constructor: init
 * Distance 查询参数类构造函数。
 *
 * Parameters:
 * dis - {int} 查询距离。
 * mGeometry - {RMPath} 用于查询的地理对象。
 * bNearest - {BOOL} 是否为最近距离查询。
*/
-(id) init:(double)dis mGeometry:(RMPath*)mGeometry bNearest:(BOOL)bNearest;

@end
