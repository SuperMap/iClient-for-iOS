//
//  TransferPreference.h
//  MapView
//
//  Created by supermap on 15-3-6.
//
//
/**
 * Class: TransferPreference
 * 交通换乘是乘车偏好类，类中定义了公交换乘偏好常量。包括BUS(公交优先)，NO_SUBWAY(地铁优先)，NONE(无乘车偏好)，SUBWAY(地铁优先)四种偏好类型.
 *
 * Inherits from:
 *  - <NSObject>
 */


static NSString *  BUS = @"BUS"; // 公交优先
static NSString *  NO_SUBWAY = @"NO_SUBWAY"; // 地铁优先
static NSString *  NONE = @"NONE"; // 无乘车偏好
static NSString *  SUBWAY = @"SUBWAY";// 地铁优先
#import <Foundation/Foundation.h>

@interface TransferPreference : NSObject

@end
