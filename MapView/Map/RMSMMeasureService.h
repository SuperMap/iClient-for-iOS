//
//  RMSMMeasureService.h
//  MapView
//
//  Created by iclient on 13-6-19.
//
//

#import <Foundation/Foundation.h>
#import "RMURLConnectionOperation.h"
#import "RMGlobalConstants.h"
#import "RMSMMeasureParameters.h"

/**
 * Class: RMSMMeasureService
 * 量算服务类。
 * 该类负责将量算参数传递到服务端，并获取服务端返回的量算结果。
 *
 */
@interface RMSMMeasureService : NSObject{
    NSURL *url;
    NSString* strUrl;
    enum MeasureMode m_Mode;
    NSMutableData *data;
}

/**
 * Constructor: init
 * 量算服务类构造函数。
 *
 * 例如：
 * (start code)
 * // 构造量算参数
 * RMSMMeasureParameters* para = [[RMSMMeasureParameters alloc] init:pp];
 * NSString* strUrl = [[NSString alloc] initWithString:@"http://support.supermap.com.cn:8090/iserver/services/map-world/rest/maps/World"];
 * // 构造量算服务
 * RMSMMeasureService* service = [[RMSMMeasureService alloc] init:strUrl];
 * // 绑定量算事件
 * [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(measureComplete:) name:@"measureComplete" object:nil];
 * [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(measureError:) name:@"measureError" object:nil];
 * // 运行量算服务
 * [service processAsync:para];
 * (end)
 *
 * Parameters:
 * mapurl - {NSString} 服务访问的地址。如：http://localhost:8090/iserver/services/map-world/rest/maps/World+Map 。
 *
 */
- (id)init:(NSString*)mapurl;

/**
 * APIMethod: processAsync
 * 负责将客户端的量算参数传递到服务端。
 * 请求成功通知标识为"measureComplete"，失败为"measureError"
 *
 * Parameters:
 * params - {<RMSMMeasureParameters>} 量算参数。
 */
- (void) processAsync:(RMSMMeasureParameters*)para;

@end
