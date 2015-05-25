//
//  TransferSolutionService.h
//  MapView
//
//  Created by supermap on 15-3-3.
//
//
@class TransferGuide;
@class TransferSolutionResult;
@class TransferSolutionParameter;
@class TransferStopInfo;
#import <Foundation/Foundation.h>

/**
 * Class: TransferSolutionService 
 * 公交换乘分析服务类。
 * 该类支持：1.站点信息查询，根据关键字查询相应的站点信息或者站点信息列表。返回{<TransferStopInfo类型>}对象数组。
 *         2.换乘方案查询，根据起始站点，终止站点信息和分析参数，向服务器请求并返回指定数量的换乘方案列表，返回{<TransferGuide>}类型对象。
 *         3.引导信息查询.根据换乘方案返回对应的引导方案。返回result为{<TransferSolutionResult>}对象
 *
 * Inherits from:
 *  - <NSObject>
 */

@interface TransferSolutionService : NSObject

    /*
     * Constructor: TransferSolutionService
     *      公交换乘分析服务类参数构造类。
     *
     * Parameters:
     * strUrl - {NSString} 公交换乘分析服务地址。格式为http://{服务器地址+端口号}/iserver/services/{公交换乘分析服务名}/restjsr/traffictransferanalyst； 例如:@"http://172.27.180.1:8090/iserver/services/traffictransferanalyst-sample/restjsr/traffictransferanalyst"。
     */
-(instancetype)initWithUrl:(NSString *) strUrl;

 /* 
  *  APIMethod: processAsync4SolutionWithParam: param: finishBlock:
  *       向服务器发送公交换乘分析的参数，并返回{<TransferSolutionResult>}类型数据
  *  Parameters:
  *     param - {<TransferSolutionParameter>}公交换乘方案参数类
  *     finishBlock - 请求成功后执行的回调
  *     failedBlock - 请求失败执行的回调
  */
-(void) processAsync4SolutionWithParam:(TransferSolutionParameter *) param finishBlock:(void(^)(TransferSolutionResult * transferSolutionResult))finishBlock failedBlock:(void(^)(NSError * connectionError))failedBlock;

/*  
 *  APIMethod: processAsync4PathWithPoints: transferLines: finishBlock:
 *         向服务器发送的起始-终止站点信息以及线路信息，返回线路引导
 *  Parameters:
 *     points - 乘车方案的起始和终止点组成的数组，可以起始或终止点的地理坐标 即{<Point2D>}类型数组,也可以是站点id组成的Integer数组
 *     transferLines - 换乘分段数组，其中存放的元素为{<TransferLine>}对象。
 *     finishBlock - 请求成功后执行的回调
 *     failedBlock - 请求失败执行的回调
 */
-(void) processAsync4PathWithPoints:(NSArray *) points transferLines:(NSArray *)transferLines finishBlock:(void(^)(TransferGuide * transferGuide))finishBlock failedBlock:(void(^)(NSError * connectionError))failedBlock;

/*  
 *  APIMethod: ProcessAsync4StopsWithKeyWord: returnPosition: finishBlock:
 *         向服务器发送查询关键字，返回站点信息列表
 *  Parameters:
 *     keyWord - 站点查询关键字
 *     returnPosition - 是否返回查询站点的地理坐标
 *     finishBlock - 请求成功后执行的回调
 *     failedBlock - 请求失败执行的回调
 */
-(void)ProcessAsync4StopsWithKeyWord:(NSString *)keyWord returnPosition:(BOOL)returnPosition finishBlock:(void(^)(NSArray * transferStopsInfo))finishBlock failedBlock:(void(^)(NSError * connectionError))failedBlock;
@end
