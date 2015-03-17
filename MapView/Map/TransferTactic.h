//
//  TransferTactic.h
//  MapView
//
//  Created by supermap on 15-3-6.
//
//
/**
 * Class: TransferTactic 
 * 公交换乘策略类,包括LESS_TIME(时间最短)，LESS_TRANSFER(少换乘)，LESS_WALK(少步行),MIN_DISTANCE(距离最短)四种换乘策略。
 *
 * Inherits from:
 *  - <NSObject>
 */
static NSString * const LESS_TIME = @"LESS_TIME"; // 时间最短
static NSString * const LESS_TRANSFER = @"LESS_TRANSFER"; // 少换乘
static NSString * const LESS_WALK = @"LESS_WALK"; // 少步行
static NSString * const MIN_DISTANCE = @"MIN_DISTANCE"; //距离最短

#import <Foundation/Foundation.h>
@interface TransferTactic : NSObject

@end
