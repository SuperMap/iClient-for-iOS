//
//  QueryByBoundsParameters.h
//  MapView
//
//  Created by iclient on 13-6-25.
//
//

#import "QueryParameters.h"
#import "RMFoundation.h"

/**
 * Class: QueryByBoundsParameters
 * Bounds 查询参数类。
 * 该类用于设置 Bounds 查询的相关参数。
 *
 * Inherits from:
 *  - <QueryParameters>
 */
@interface QueryByBoundsParameters : QueryParameters

{
    RMProjectedRect bounds;    
}

/**
 * APIProperty: bounds
 * {<RMProjectedRect>} 指定的查询范围。
 */
@property (readwrite) RMProjectedRect bounds;

/**
 * Constructor: init
 * Bounds 查询参数类构造函数。
 *
 * Parameters:
 * mbounds - {RMProjectedRect} 指定的查询范围。
 */
-(id) init:(RMProjectedRect)mbounds;

@end
