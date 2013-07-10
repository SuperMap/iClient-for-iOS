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
 *	@brief	Geometry 查询参数类。
 * 该类用于设置 Geometry查询的相关参数。
 */
@interface QueryByGeometryParameters : QueryParameters

{
    RMPath* geometry;
    NSString* spatialQueryMode;
}

@property (retain,readwrite) RMPath* geometry;
@property (copy,readwrite) NSString* spatialQueryMode;

-(id) init:(RMPath*)mGeo;

@end
