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
    RMProjection *smProjection;
	RMSMTileProjection *tileProjection;
    BOOL networkOperations;
//    RMSMLayerInfo* m_Info;
    NSMutableArray* m_dResolutions;
    NSMutableArray* m_dScales;
    
    RMTileImageSet* _imagesOnScreen;
    RMTileLoader* _tileLoader;
    RMMapRenderer* _renderer;
    BOOL _isBaseLayer;
    BOOL _isUseCache;
}
//@property (nonatomic, assign) RMTileImageSet * imagesOnScreen;
//@property (nonatomic, assign) RMTileLoader * tileLoader;
//@property (nonatomic, assign) RMMapRenderer * renderer;
@property (nonatomic,retain) RMSMLayerInfo* m_Info;

/**
 * APIProperty: isUseCache
 * {BOOL} 用于判断在加载地图是是否使用本地缓存
 */
@property (nonatomic) BOOL isUseCache;
//用于用户和第三方地图叠加，自定义纠偏
@property (nonatomic,assign)CGSize redressValue;
@property(nonatomic,strong)NSString* cachePath;
@property (nonatomic)BOOL isHidden;
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
 * resolutions - {NSMutableArray}  指定分辨率数组。
 */
-(id) initWithInfo:(RMSMLayerInfo*) info resolutions:(NSMutableArray*) resolutions;

/**
 *	@brief	初始化构造函数
 *
 *	@param 	scales 	指定地图服务比例尺数组
 *
 *	@return	RMSMTileSource类
 */

/**
 * Constructor: initWithInfo
 * RMSMTileSource用于在iOS上加载iServer地图服务，方便的将iServer发布的地图服务显示在地图框架中
 *
 * Parameters:
 * info - {RMSMLayerInfo}  地图服务属性信息。
 * scales - {NSMutableArray}  指定比例尺数组。
 */

-(id) initWithInfo:(RMSMLayerInfo*) info scales:(NSMutableArray*) scales;

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

//清除本地缓存
-(void)clearCache;

/**
 * APIProperty: minZoom
 * {float} 当前地图最小显示层级。
 */
-(float) minZoom;
-(BOOL) isBaseLayer;
-(void) setIsBaseLayer:(BOOL)isBaseLayer;
/**
 * APIProperty: maxZoom
 * {float} 当前地图最大显示层级。
 */
-(float) maxZoom;

-(float) numberZoomLevels;
-(NSMutableArray*) m_dScales;
-(void) setM_dScales:(NSMutableArray*) scales;

-(RMSphericalTrapezium) latitudeLongitudeBoundingBox;

-(NSString *)shortName;


-(NSString *)longDescription;

-(NSString *)shortAttribution;

-(NSString *)longAttribution;


@end
