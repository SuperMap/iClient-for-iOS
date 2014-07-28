//
//  QueryByBoundsService.h
//  MapView
//
//  Created by iclient on 13-6-25.
//
//

#import "QueryService.h"
#import "QueryByBoundsParameters.h"
/**
 * Class: QueryByBoundsService
 * Bounds 查询服务类。
 *
 * Inherits from:
 *  - <QueryService>
 */
@interface QueryByBoundsService : QueryService

/**
 * Constructor: init
 * Bounds 查询服务类构造函数。
 *
 * 例如：
 * (start code)
 * QueryByBoundsService* ps = [[QueryByBoundsService alloc] init:@"http://support.supermap.com.cn:8090/iserver/services/map-world/rest/maps/World"];
 * FilterParameter* pF = [[FilterParameter alloc] init];
 * pF.name = [[NSString alloc] initWithString:@"Capitals@World.1"];
 *
 * QueryByBoundsParameters* p = [[QueryByBoundsParameters alloc] init:RMMakeProjectedRect(4.6055437100213,39.914712153518,47.974413646055-4.6055437100213,66.780383795309-39.914712153518)];
 * [p.queryParams addObject:pF];
 *
 * [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(processCompleted:) name:@"processCompleted" object:nil];
 *
 * [ps processAsync:p];
 * (end)
 *
 * Parameters:
 * url - {String} 服务的访问地址。如如访问World Map服务，只需将url设为：http://localhost:8090/iserver/services/map-world/rest/maps/World+Map 即可。
 */
-(id) init;

-(NSString*) getJsonParameters:(QueryParameters*)params;

@end
