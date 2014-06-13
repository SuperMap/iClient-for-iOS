//
//  QueryByGeometryParameters.h
//  MapView
//
//  Created by iclient on 13-6-27.
//
//

#import "QueryParameters.h"
#import "RMPath.h"

/**
 * Class: QueryByGeometryParameters
 * Geometry 查询参数类。
 * 该类用于设置 Geometry查询的相关参数。
 *
 * Inherits from:
 *  - <QueryParameters>
 */
@interface QueryByGeometryParameters : QueryParameters

{
    RMPath* geometry;
    NSString* spatialQueryMode;
}

/**
 * APIProperty: geometry
 * {RMPath} 用于查询的几何对象。
 */
@property (retain,readwrite) RMPath* geometry;

/**
 * APIProperty: spatialQueryMode
 * {NSString} 空间查询模式。
 */
@property (copy,readwrite) NSString* spatialQueryMode;

/**
 * Constructor: init
 * Geometry 查询参数类构造函数。
 *
 * Parameters:
 * mGeo - {<RMPath>} 用于查询的几何对象。
 */
-(id) init:(RMPath*)mGeo;

@end
