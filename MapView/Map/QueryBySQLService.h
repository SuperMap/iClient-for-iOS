//
//  QueryBySQLService.h
//  MapView
//
//  Created by iclient on 13-6-27.
//
//

#import "QueryService.h"
#import "QueryBySQLParameters.h"
/**
 * Class: QueryBySQLService
 * SQL 查询服务类。
 * 在一个或多个指定的图层上查询符合 SQL 条件的空间地物信息。
 *
 * Inherits from:
 *  - <QueryService>
 */
@interface QueryBySQLService : QueryService

/**
 * Constructor: init
 * SQL 查询服务类构造函数。
 *
 * 例如：
 * (start code)
 * QueryBySQLService* ps = [[QueryBySQLService alloc] init:@"http://support.supermap.com.cn:8090/iserver/services/map-world/rest/maps/World"];
 * FilterParameter* pF = [[FilterParameter alloc] init];
 * pF.name = [[NSString alloc] initWithString:@"Countries@World.1"];
 * pF.attributeFilter = [[NSString alloc] initWithString:@"SMID = 1"];
 * QueryBySQLParameters* p = [[QueryBySQLParameters alloc] init];
 * [p.queryParams addObject:pF];
 * [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(processCompleted:) name:@"processCompleted" object:nil];
 * [ps processAsync:p];
 * (end)
 *
 */
-(id) init;

-(NSString*) getJsonParameters:(QueryParameters*)params;

@end
