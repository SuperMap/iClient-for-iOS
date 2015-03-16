//
//  TransferPreference.h
//  MapView
//
//  Created by supermap on 15-3-6.
//
//

/*
 *  交通换乘是乘车偏好
 */

static NSString *  BUS = @"BUS"; // 公交优先
static NSString *  NO_SUBWAY = @"NO_SUBWAY"; // 地铁优先
static NSString *  NONE = @"NONE"; // 无乘车偏好
static NSString *  SUBWAY = @"SUBWAY";// 地铁优先
#import <Foundation/Foundation.h>

@interface TransferPreference : NSObject

@end
