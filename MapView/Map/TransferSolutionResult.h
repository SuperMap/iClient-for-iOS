//
//  TransferSolutionResult.h
//  MapView
//
//  Created by supermap on 15-3-3.
//
//
/**
 *  换乘引导类：
 *      该类记录了从换乘分析起始站点到终止站点的公交换乘引导方案
 *
 */
@class TransferSolution;
@class TransferGuide;

#import <Foundation/Foundation.h>

@interface TransferSolutionResult : NSObject

// 默认的乘车方案及相关信息
@property(nonatomic,retain) TransferGuide *defaultGuide;
// 乘车方案集合
@property(nonatomic,retain) NSMutableArray *transferSolution;
// 解析json数据
-(instancetype)initWithDict:(NSDictionary *)dict;
@end
