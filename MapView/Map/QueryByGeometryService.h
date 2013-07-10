//
//  QueryByGeometryService.h
//  MapView
//
//  Created by iclient on 13-6-27.
//
//

#import "QueryService.h"

/**
 *	@brief	Geometry 查询服务类。
 */
@interface QueryByGeometryService : QueryService


-(NSString*) getJsonParameters:(QueryParameters*)params;

@end
