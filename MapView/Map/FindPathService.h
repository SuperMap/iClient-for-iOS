//
//  FindPathService.h
//  MapView
//
//  Created by iclient on 14-5-27.
//
//

#import <Foundation/Foundation.h>
#import "FindPathParameters.h"
#import "FindPathResult.h"

/**
 * Class: FindPathService
 * 最佳路径分析服务类。
 * 最佳路径是在网络数据集中指定一些结点，按照结点的选择顺序，
 * 顺序访问这些结点从而求解起止点之间阻抗最小的路经。
 * 该类负责将客户端指定的最佳路径分析参数传递给服务端，并接收服务端返回的结果数据。
 */
@interface FindPathService : NSObject
{
    NSString *strFindPathUrl;
    NSMutableData *data;
    FindPathResult *lastResult;

}

/**
 * Constructor: FindPathService
 * 最佳路径分析服务类构造函数。
 *
 * 例如：
 * (start code)
 * TransportationAnalystResultSetting *resultSetting=[[TransportationAnalystResultSetting alloc]init];
 * resultSetting.returnPathGuides=YES;
 * TransportationAnalystParameter *analystParameter=[[TransportationAnalystParameter alloc]init];
 * analystParameter.weightFieldName=@"length";
 * analystParameter.resultSetting=resultSetting;
 *
 * NSMutableArray *nodeArray=[[NSMutableArray alloc]initWithObjects:point1,point2, nil];
 * FindPathParameters *parameters=[[FindPathParameters alloc]init:NO bHasLeastEdgeCount:NO nodes:nodeArray parameter:analystParameter];
 *
 * FindPathService *findPathService=[[FindPathService alloc]init:@"http://support.supermap.com.cn:8090/iserver/services/transportationanalyst-sample/rest/networkanalyst/RoadNet@Changchun"];
 *
 * [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(processCompleted:) name:@"findPathCompleted" object:nil];
 * [findPathService processAsync:parameters];
 * (end)
 *
 * Parameters:
 * strUrl - {NSString} 网络分析服务地址。请求网络分析服务，URL应为：
 * http://{服务器地址}:{服务端口号}/iserver/services/{网络分析服务名}/rest/networkanalyst/{网络数据集@数据源}；
 * 例如:"http://localhost:8090/iserver/services/components-rest/rest/networkanalyst/RoadNet@Changchun"。
 */
-(id) init:(NSString*)strUrl;

/**
 * APIMethod: processAsync
 * 负责将客户端的查询参数传递到服务端。
 * 请求成功通知标识为"findPathCompleted"
 *
 * Parameters:
 * parameters - {<FindPathParameters>} 最佳路径分析参数类。
 */
-(void) processAsync:(FindPathParameters*)parameters;
@property (assign) FindPathResult *lastResult;
@end
