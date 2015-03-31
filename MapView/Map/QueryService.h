//
//  QueryService.h
//  MapView
//
//  Created by iclient on 13-6-25.
//
//

#import <Foundation/Foundation.h>
#import "QueryParameters.h"
#import "QueryResult.h"
/**
 * Class: QueryService
 * 查询服务基类。
 */
@protocol QueryService

-(NSString *) getJsonParameters:(QueryParameters*)params;
@end

@interface QueryService : NSObject
{
    NSString* strQueryUrl;
    NSMutableData *data;
    QueryResult* lastResult;
}

@property (retain,atomic) QueryResult* lastResult;


/**
 * Constructor: QueryService
 * 查询服务基类
 *
 * 例如：
 * (start code)
 * FilterParameter *filterParameters = [[FilterParameter alloc] init];
 * filterParameters.name = @"Countries@World";
 * filterParameters.attributeFilter = @"SMID = 1";
 * QueryBySQLParameters* parameters = [[QueryBySQLParameters alloc] init];
 * [parameters.queryParams addObject:filterParameters];
 * QueryService *queryService=[[QueryService alloc]init:@"http://192.168.18.142:8090/iserver/services/map-world/rest/maps/World/queryResults.json"];
 *
 * [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(processCompleted:) name:@"queryCompleted" object:nil];
 * [QueryService processAsync:parameters];
 * (end)
 *
 * Parameters:
 * strUrl - {NSString} 查询服务地址。请求地图查询服务，URL应为：
 * http://{服务器地址}:{端口}/iserver/services/{地图服务名}/rest/maps/{地图名}/queryResult；
 * 例如:"http://192.168.18.142:8090/iserver/services/map-world/rest/maps/World/queryResults.json"。
 */
-(id) init:(NSString*)strUrl;
/**
 * APIMethod: processAsync
 * 负责将客户端的量算参数传递到服务端。
 * 请求成功通知标识为"queryCompleted"
 *
 * Parameters:
 * params - {<QueryParameters>} 查询参数。
 */
-(void) processAsync:(QueryParameters*)params;

-(QueryParameters*) getQueryParameters:(QueryParameters*)params;

@end
