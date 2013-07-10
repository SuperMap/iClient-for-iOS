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
 *	@brief	SuperMap iServer REST量算服务
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

- (id)init:(NSString*)mapurl;
- (void) processAsync:(RMSMMeasureParameters*)para;

@end
