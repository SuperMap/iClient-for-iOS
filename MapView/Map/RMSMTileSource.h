//
//  RMSMTileSource.h
//  MapView
//
//  Created by iclient on 13-6-8.
//
//

#import <Foundation/Foundation.h>
#import "RMTileSource.h"
#import "RMSMTileProjection.h"
#import "RMSMLayerInfo.h"

/**
 *@brief	SuperMap iServer地图
 * RMSMTileSource用于在iOS上加载iServer地图服务，方便的将iServer发布的地图服务显示在地图框架中 \n
 * 使用范例如下：
 * @code
 * //字符串为SuperMap iServer地图服务的url链接
 * NSString *mapUrl = @"http://support.supermap.com.cn:8090/iserver/services/map-china400/rest/maps/China";
 * //创建地图服务配置信息，参数为地图名和链接地址
 * RMSMLayerInfo* info = [[RMSMLayerInfo alloc] initWithTile:@"China" linkurl:mapUrl];
 * // 创建iServer地图服务
 * RMSMTileSource* smSource = [[RMSMTileSource alloc] initWithInfo:info];
 * // 加载该地图服务
 * RMMapContents *newContents = [[RMMapContents alloc] initWithView:self tilesource:smSource];
 * @endcode
 * 通过如上的方法，你可以获取该地图服务的配置信息，方便地图服务的创建和加载
 */
@interface RMSMTileSource : NSObject <RMTileSource> {
	RMSMTileProjection *tileProjection;
    BOOL networkOperations;
    RMSMLayerInfo* m_Info;
    NSMutableArray* m_dResolutions;
    NSMutableArray* m_dScale;
}


/**
 *	@brief	初始化构造函数
 *
 *	@return	RMSMTileSource类
 */
-(id) init;

/**
 *	@brief	初始化构造函数
 *
 *	@return	RMSMTileSource类
 */
-(id) initWithInfo:(RMSMLayerInfo*) info ;

/**
 *	@brief	初始化构造函数
 *
 *	@param 	resolutions 	指定地图服务分辨率数组
 *
 *	@return	RMSMTileSource类
 */
-(id) initWithInfo:(RMSMLayerInfo*) info resolutions:(NSMutableArray*)resolutions;

-(void) networkOperationsNotification: (NSNotification*) notification;


/**
 *	@brief	获取该地图服务每一个Tile瓦片的像素大小，默认为256像素
 *
 *	@return	每一个Tile瓦片的像素大小
 */
-(int) tileSideLength;

/**
 *	@brief	指定每一个Tile瓦片的像素大小
 */
-(void) setTileSideLength: (NSUInteger) aTileSideLength;


/**
 *	@brief	最小显示层级
 *
 *	@return	最小显示层级
 */
-(float) minZoom;

/**
 *	@brief	最大显示层级
 *
 *	@return	最大显示层级
 */
-(float) maxZoom;

-(RMSphericalTrapezium) latitudeLongitudeBoundingBox;

-(NSString *)shortName;


-(NSString *)longDescription;

-(NSString *)shortAttribution;

-(NSString *)longAttribution;


@end
