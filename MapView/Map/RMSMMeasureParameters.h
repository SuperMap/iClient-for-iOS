//
//  RMSMMeasureParameters.h
//  MapView
//
//  Created by iclient on 13-6-19.
//
//

#import <Foundation/Foundation.h>
#import "RMPath.h"
#import "RMGlobalConstants.h"

/**
 *	@brief	量算参数类。
 * 客户端要量算的地物间的距离或某个区域的面积
 * 它将与指定的量算单位一起作为量算参数传到服务端。最终服务端将以指定单位返回得到的距离或面积。
 */
@interface RMSMMeasureParameters : NSObject{
    RMPath* m_Path;
    NSString* m_Unit;
}

- (id) init:(RMPath*)geometry;

@property (copy,readwrite) NSString* m_Unit;
@property (retain,readwrite) RMPath* m_Path;

@end
