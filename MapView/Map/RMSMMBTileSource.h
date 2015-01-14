//
//  RMSMMBTileSource.h
//  MapView
//
//  Created by iclient on 13-7-11.
//
//

#import <UIKit/UIKit.h>
#import "RMTileSource.h"
#import "RMSMTileSource.h"

@class RMSMTileProjection;
@class FMDatabase;

/**
 * Class: RMSMMBTileSource
 * SuperMap MBTile离线地图,SuperMap iServer支持生成符合MBTiles规范的地图瓦片，以及一种对 MBTiles 格式的扩展格式，
 * 称为SMTiles格式。MBTiles是由MapBox制定的一种将瓦片地图数据存储到SQLite数据库中并可快速使用，管理和分享的规范。
 * SMTiles基于原规范对MBTiles格式进行了扩展,支持任意坐标系，支持任意比例尺，切片的起算原点为任意指定点，行列号的方向为原点开始向左下递增。
 */
@interface RMSMMBTileSource : RMSMTileSource
{
//    RMSMTileProjection *tileProjection;
    FMDatabase *db;
    
    NSMutableDictionary* m_config;
//    NSMutableArray* m_dResolutions;
//    NSMutableArray* m_dScales;
//    BOOL _isBaseLayer;
	
	NSString* file_extension;//mbtiles or smtiles
}

/**
 * Constructor: initWithTileSetURL
 * RMSMMBTileSource用于在iOS上加载MbTile离线地图服务，方便在离线情况下显示地图
 * (start code)
 * NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
 * NSString *documentsDirectory = [paths objectAtIndex:0];
 * NSString *name = @"China.mbtiles";
 * NSString *path = [documentsDirectory stringByAppendingPathComponent:name];
 * RMSMMBTileSource* mbSource = [[RMSMMBTileSource alloc] initWithTileSetURL:path];
 * RMMapContents *newContents = [[RMMapContents alloc] initWithView:self tilesource:mbSource];
 * (end)
 *
 * Parameters:
 * tileSetURL - {NSString}  离线地图数据地址。
 */
- (id)initWithTileSetURL:(NSString *)tileSetURL;

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
-(NSMutableArray*) m_dScales;
-(void) setM_dScales:(NSMutableArray*) scales;
-(void) setIsBaseLayer:(BOOL)isBaseLayer;
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
