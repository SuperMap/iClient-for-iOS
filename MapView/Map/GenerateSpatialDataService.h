//
//  GenerateSpatialDataService.h
//  MapView
//
//  Created by iclient on 14/11/26.
//
//

#import <Foundation/Foundation.h>
#import "GenerateSpatialDataParameters.h"
#import "GenerateSpatialDataResult.h"

/**
 * Class: GenerateSpatialDataService
 * 动态分段分析服务类。
 * 该类负责将客户设置的动态分段分析服务参数传递给服务端，并接收服务端返回的动态分段分析结果数据。
 * 动态分段分析结果通过该类支持的事件的监听函数获取，获取的结果数据为服务端返回的动态分段分析结果result， 保存在GenerateSpatialDataResult 对象中。
 *
 * Inherits from:
 *  - <NSObject>
 */
@interface GenerateSpatialDataService : NSObject



/**
 * Constructor: GenerateSpatialDataService
 * 动态分段分析服务类。
 *
 * 例如：
 * (start code)
 * DataReturnOption *option=[[DataReturnOption alloc]initWithDataset:@"generateSpatialData@Changchun"];
 * 
 * GenerateSpatialDataParameters *param=[[GenerateSpatialDataParameters alloc]initWithRouteTable:@"RouteDT_road@Changchun" routeIDField:@"RouteID" eventTable:@"LinearEventTabDT@Changchun" eventRouteIDField:@"RouteID" measureStartField:@"LineMeasureFrom" measureEndField:@"LineMeasureTo" dataReturnOption:option];
 *
 * GenerateSpatialDataService *service=[[GenerateSpatialDataService alloc]initWithURL:tileThing2];
 *
 * [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(processCompletedGenerateSpatialData:) name:@"generateSpatialCompleted" object:nil];
 *
 * [service processAsync:param];
 * (end)
 *
 * Parameters:
 * strUrl - {NSString} 动态分段分析服务地址。请求网络分析服务，URL应为：
 * http://{服务器地址}:{服务端口号}/iserver/services/{空间分析服务名}/restjsr/spatialanalyst/；
 * 例如:@"http://192.168.1.24:8090/iserver/services/spatialanalyst-changchun/restjsr/spatialanalyst"。
 */
-(instancetype)initWithURL:(NSString *) strUrl;

/**
 * APIMethod: processAsync
 * 负责将客户端的查询参数传递到服务端。
 * 请求成功通知标识为"generateSpatialCompleted"，失败为"generateSpatialFailed"
 *
 * Parameters:
 * parameters - {<GenerateSpatialDataParameters>} 动态分段分析参数类。
 */
-(void) processAsync:(GenerateSpatialDataParameters*)parameters;


@end
