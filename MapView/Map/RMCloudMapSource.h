//
//  RMCloudMapSource.h
//  MapView
//
//  Created by iclient on 13-7-4.
//
//

#import "RMAbstractMercatorWebSource.h"
#import "RMSMTileSource.h"
@class RMSMTileProjection;

/**
 * Class: RMCloudMapSource
 * SuperMap云地图服务
 */
@interface RMCloudMapSource :RMSMTileSource
{
//    RMSMTileProjection *tileProjection;
//    BOOL networkOperations;
//    NSMutableArray* m_dResolutions;
//    NSMutableArray* m_dScales;
//    BOOL _isBaseLayer;
}

@property (nonatomic)BOOL isHidden;

/**
 * Constructor: init
 * RMCloudMapSource用于在iOS上加载云地图服务，方便的将iServer发布的地图服务显示在地图框架中
 * (start code)
 * RMCloudMapSource* cloud = [[RMCloudMapSource alloc] init];
 * RMMapContents *newContents = [[RMMapContents alloc] initWithView:self tilesource:cloud];
 * (end)
 */
-(id) init;

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
-(NSMutableArray*) m_dScales;
-(void) setIsBaseLayer:(BOOL)isBaseLayer;
-(void) networkOperationsNotification: (NSNotification*) notification;

-(NSString *)shortName;


-(NSString *)longDescription;

-(NSString *)shortAttribution;

-(NSString *)longAttribution;




@end

