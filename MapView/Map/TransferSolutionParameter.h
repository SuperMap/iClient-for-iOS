//
//  TransferSolutionParameter.h
//  MapView
//
//  Created by supermap on 15-3-6.
//
//

/*
 *  乘车方案参数类
 *
 */

#import <Foundation/Foundation.h>
#import "TransferTactic.h"
@interface TransferSolutionParameter : NSObject

@property(nonatomic,retain) NSMutableArray *points;
// 返回的乘车方案的数量
@property(nonatomic) NSInteger solutionCount;
// 步行与公交的消耗权重比，默认值为10
@property(nonatomic) double walkingRatio;
// 公交换乘策略类型，包括时间最短，距离最短，最少换乘，少步行四种选择
@property(nonatomic,retain) NSString *transferTactic;
// 乘车偏好枚举
@property(nonatomic,retain) NSString *transferPreference;

-(id)initWithPoints:(NSArray *)points solutionCount:(NSInteger *)solutionCount walkingRatio:(double) walkingRatio transferTactic:(NSString *) transferTactic transferPreference:(NSString *)transferPreference;
@end
