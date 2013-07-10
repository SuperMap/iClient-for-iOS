//
//  QueryBySQLService.h
//  MapView
//
//  Created by iclient on 13-6-27.
//
//

#import "QueryService.h"

/**
 *	@brief	SQL 查询服务类。\n
 * 在一个或多个指定的图层上查询符合 SQL 条件的空间地物信息。
 */
@interface QueryBySQLService : QueryService


-(NSString*) getJsonParameters:(QueryParameters*)params;

@end
