//
//  QueryByBoundsService.h
//  MapView
//
//  Created by iclient on 13-6-25.
//
//

#import "QueryService.h"

/**
 *	@brief	Bounds 查询服务类。
 */
@interface QueryByBoundsService : QueryService


-(id) init;

-(NSString*) getJsonParameters:(QueryParameters*)params;

@end
