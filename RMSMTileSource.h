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
 * Class: RMSMTileSource
 * SuperMap iServer地图服务
 */
@interface RMSMTileSource : NSObject <RMTileSource> {
	RMSMTileProjection *tileProjection;
    BOOL networkOperations;
    RMSMLayerInfo* m_Info;
    NSMutableArray* m_dResolutions;
    NSMutableArray* m_dScale;
}

-(id) init;

/**
 * Constructor: initWithInfo
 * RMSMTileSource用于在iOS上加载iServer地图服务，方便的将iServer发布的地图服务显示在地图框架中
 * (start code)
 * //字符串为SuperMap iServer地图服务的url链接
 * NSString *mapUrl = @"http://support.supermap.com.cn:8090/iserver/services/map-china400/rest/maps/China";
 * //创建地图服务配置信息，参数为地图名和链接地址
 * RMSMLayerInfo* info = [[RMSMLayerInfo alloc] initWithTile:@"China" linkurl:mapUrl];
 * // 创建iServer地图服务
 * RMSMTileSource* smSource = [[RMSMTileSource alloc] initWithInfo:info];
 * // 加载该地图服务
 * RMMapContents *newContents = [[RMMapContents alloc] initWithView:self tilesource:smSource];
 * (end)
 *
 * Parameters:
 * info - {RMSMLayerInfo}  地图服务属性信息。
 */
-(id) initWithInfo:(RMSMLayerInfo*) info ;

/**
 *	@brief	初始化构造函数
 *
 *	@param 	resolutions 	指定地图服务分辨率数组
 *
 *	@return	RMSMTileSource类
 */

/**
 * Constructor: initWithInfo
 * RMSMTileSource用于在iOS上加载iServer地图服务，方便的将iServer发布的地图服务显示在地图框架中
 *
 * Parameters:
 * info - {RMSMLayerInfo}  地图服务属性信息。
 * resolutions - {NSMutableArray}  指定分辨率。
 */
-(id) initWithInfo:(RMSMLayerInfo*) info resolutions:(NSMutableArray*)resolutions;


-(void) networkOperationsNotification: (NSNotification*) notification;

/**
 * APIMethod: tileSideLength
 * 获取该地图服务每一个Tile瓦片的像素大小，默认为256像素
 *
 * Returns:
 * {<int>}  获取该地图服务每一个Tile瓦片的像素大小，默认为256像素。
 */
-(int) tileSideLength;

/**
 * APIMethod: setTileSideLength
 * 指定每一个Tile瓦片的像素大小
 *
 ** Parameters:
 * aTileSideLength - {NSUInteger}  指定的像素大小。
 */
-(void) setTileSideLength: (NSUInteger) aTileSideLength;


/**
 * APIProperty: minZoom
 * {float} 当前地图最小显示层级。
 */
-(float) minZoom;

/**
 * APIProperty: maxZoom
 * {float} 当前地图最大显示层级。
 */
-(float) maxZoom;

-(float) numberZoomLevels;

-(RMSphericalTrapezium) latitudeLongitudeBoundingBox;

-(NSString *)shortName;


-(NSString *)longDescription;

-(NSString *)shortAttribution;

-(NSString *)longAttribution;


@end
