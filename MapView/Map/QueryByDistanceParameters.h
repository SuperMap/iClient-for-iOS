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
 *	@brief	Distance 查询参数类。\n
 * 该类用于设置 Distance 查询的相关参数。
 */
@interface QueryByDistanceParameters : QueryParameters

{
    int distance;
    RMPath* geometry;
    BOOL isNearest;
}

@property (copy,readwrite) RMPath* geometry;
@property (readwrite) int distance;
@property (readwrite) BOOL isNearest;

-(id) init:(int)dis mGeometry:(RMPath*)mGeometry bNearest:(BOOL)bNearest;

@end
