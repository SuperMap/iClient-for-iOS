//
//  QueryByDistanceService.h
//  MapView
//
//  Created by iclient on 13-6-27.
//
//

#import "QueryService.h"
#import "QueryByDistanceParameters.h"

/**
 * Class: QueryByDistanceService
 * Distance查询服务类。
 *
 * Inherits from:
 *  - <QueryService>
 */
@interface QueryByDistanceService : QueryService

/**
 * Constructor: init
 * Distance查询服务类构造函数。
 *
 * 例如：
 * (start code)
 * QueryByDistanceService* ps = [[QueryByDistanceService alloc] init:@"http://support.supermap.com.cn:8090/iserver/services/map-world/rest/maps/World"];
 * FilterParameter* pF = [[FilterParameter alloc] init];
 * pF.name = [[NSString alloc] initWithString:@"Capitals@World.1"];
 * RMPath* pPoint = [[RMPath alloc] initWithContents:mapContents];
 * CLLocationCoordinate2D mPoint;
 * mPoint.latitude = 31;
 * mPoint.longitude = 121;
 * [pPoint moveToLatLong:mPoint];
 * QueryByDistanceParameters* p = [[QueryByDistanceParameters alloc] init:30 mGeometry:pPoint bNearest:false];
 * [p.queryParams addObject:pF];
 * [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(processCompleted:) name:@"processCompleted" object:nil];
 * [ps processAsync:p];
 * (end)
 *
 */
-(id) init;

-(NSString*) getJsonParameters:(QueryParameters*)params;

@end
