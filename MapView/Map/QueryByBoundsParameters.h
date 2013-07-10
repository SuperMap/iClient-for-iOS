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
 *	@brief	Bounds 查询参数类。\n
 * 该类用于设置 Bounds 查询的相关参数。
 */
@interface QueryByBoundsParameters : QueryParameters

{
    RMProjectedRect bounds;    
}

@property (readwrite) RMProjectedRect bounds;

-(id) init:(RMProjectedRect)mbounds;

@end
