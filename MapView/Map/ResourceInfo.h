//
//  ResourceInfo.h
//  MapView
//
//  Created by iclient on 14/11/24.
//
//

#import <Foundation/Foundation.h>

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
