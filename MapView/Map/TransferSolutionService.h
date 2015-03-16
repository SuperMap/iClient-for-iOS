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

@interface TransferSolutionService : NSObject


    /*
     * Parameters:
     *  strUrl - {NSString} 公交换乘分析服务地址。请求公交换乘分析服务，URL应为：
     * http://{服务器地址+端口号}/iserver/services/{公交换乘分析服务名}/restjsr/ traffictransferanalyst/{networkName}/{soulutions}.json；
     * 例如:@"http://172.27.180.1:8090/iserver/services/traffictransferanalyst-sample/restjsr/traffictransferanalyst"。
     */
-(instancetype)initWithUrl:(NSString *) strUrl;

 /* 
  *  @Parameters:
  *     param:请求乘车方案的参数
  *     finishBlock:请求成功后执行的回调block，可以在block中书写逻辑处理代码，block不处与主线程中，不能做ui更新处理
  */
-(void) processAsync4SolutionWithParam:(TransferSolutionParameter *) param finishBlock:(void(^)(TransferSolutionResult * transferSolutionResult))finishBlock;

/*
 *  @Parameters:
 *     points:乘车方案的起始和终止点组成的数组，可以起始或终止点的地理坐标,也可以是站点id
 *     transferLines:换乘分段数组，其中存放的元素为TransferLine对象
 *     finishBlock:请求成功后执行的回调block，可以在block中书写逻辑处理代码,block不处与主线程中，不能做ui更新处理
 */
-(void) processAsync4PathWithPoints:(NSArray *) points transferLines:(NSArray *)transferLines finishBlock:(void(^)(TransferGuide * transferGuide))finishBlock;

/*
 *  @Parameters:
 *     keyWord:站点查询关键字
 *     returnPosition：是否返回查询站点的地理坐标
 *     finishBlock:请求成功后执行的回调block，可以在block中书写逻辑处理代码，block不处与主线程中，不能做ui更新处理
 */
-(void)ProcessAsync4StopsWithKeyWord:(NSString *)keyWord returnPosition:(BOOL)returnPosition finishBlock:(void(^)(NSArray * transferStopsInfo))finishBlock;
@end
