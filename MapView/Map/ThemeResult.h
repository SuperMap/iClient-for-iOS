//
//  ThemeResult.h
//  MapView
//
//  Created by iclient on 14/11/24.
//
//

#import <Foundation/Foundation.h>
#import "ResourceInfo.h"

/**
 * Class: ThemeResult
 * 专题图结果类。 
 * 专题图结果类中包含了专题图结果资源（ResourceInfo)的相关信息。
 *
 * Inherits from:
 *  - <NSObject>
 */
@interface ThemeResult : NSObject

/**
 * APIProperty: resourceInfo
 * {<ResourceInfo>} 专题图结果资源,从中可以获取到相应资源在服务端的地址 url 和资源的 ID 号。
 * 这是临时的资源，默认的生命周期是7天，用户可以设置临时资源的存活时间，详情请见SuperMap iServer 7C帮助文档（iServer REST API > 临时资源的生命周期）。
 */
@property(readonly)ResourceInfo* resourceInfo;


-(instancetype)initWithJson:(NSString *)strJson;
@end
