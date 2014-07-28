//
//  QueryByGeometryService.h
//  MapView
//
//  Created by iclient on 13-6-27.
//
//

#import "QueryService.h"
#import "QueryByGeometryParameters.h"

/**
 * Class: QueryByGeometryService
 * Geometry 查询服务类。
 *
 * Inherits from:
 *  - <QueryService>
 */
@interface QueryByGeometryService : QueryService

/**
 * Constructor: init
 * Geometry 查询服务类构造函数。
 *
 * 例如：
 * (start code)
 * QueryByGeometryService* ps = [[QueryByGeometryService alloc] init:@"http://support.supermap.com.cn:8090/iserver/services/map-world/rest/maps/World"];
 * FilterParameter* pF = [[FilterParameter alloc] init];
 * pF.name = [[NSString alloc] initWithString:@"Capitals@World.1"];
 * QueryByGeometryParameters* p = [[QueryByGeometryParameters alloc] init:testPath];
 * [p.queryParams addObject:pF];
 * [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(processCompleted:) name:@"processCompleted" object:nil];
 * [ps processAsync:p];
 * (end)
 *
 */
-(id) init;
-(NSString*) getJsonParameters:(QueryParameters*)params;

@end
