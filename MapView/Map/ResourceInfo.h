//
//  ResourceInfo.h
//  MapView
//
//  Created by iclient on 14/11/24.
//
//

#import <Foundation/Foundation.h>

/**
 * Class: ResourceInfo
 * 结果资源信息类
 * 从中可以获取到相应资源在服务端的地址 url 和资源的 ID 号。
 * 这是临时的资源，默认的生命周期是7天，用户可以设置临时资源的存活时间，详情请见SuperMap iServer 7C帮助文档（iServer REST API > 临时资源的生命周期）。
 * 
 * Inherits from:
 *  - <NSObject>
 */
@interface ResourceInfo : NSObject

/**
 * APIProperty: isSucceed
 * {BOOL} 资源是否成功。
 */
@property(readonly)BOOL isSucceed;

/**
 * APIProperty: resourceLocation
 * {NSString} 资源的 URL 。
 */
@property(readonly)NSString* resourceLocation;

/**
 * APIProperty: resourceID
 * {NSString} 资源的 ID 。
 */
@property(readonly)NSString* resourceID;
/**
 * APIProperty: error
 * {NSString} 资源失败的错误信息 。
 */
@property(readonly)NSString* error;

-(instancetype)initWitJson:(NSString*)strJson;
@end
