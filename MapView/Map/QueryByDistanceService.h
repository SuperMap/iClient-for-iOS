//
//  QueryByDistanceService.h
//  MapView
//
//  Created by iclient on 13-6-27.
//
//

#import "QueryService.h"

/**
 *	@brief	Distance查询服务类。
 */
@interface QueryByDistanceService : QueryService


-(id) init;

-(NSString*) getJsonParameters:(QueryParameters*)params;

@end
