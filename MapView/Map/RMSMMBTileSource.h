//
//  RMSMMBTileSource.h
//  MapView
//
//  Created by iclient on 13-7-11.
//
//

#import <UIKit/UIKit.h>
#import "RMTileSource.h"

@class RMSMTileProjection;
@class FMDatabase;

/**
 * Class: RMSMMBTileSource
 * SuperMap MBTile离线地图
 */
@interface RMSMMBTileSource : NSObject <RMTileSource>
{
    RMSMTileProjection *tileProjection;
    FMDatabase *db;
    
    NSMutableDictionary* m_config;
    NSMutableArray* m_dResolutions;
    NSMutableArray* m_dScale;
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

/**
 * APIProperty: maxZoom
 * {float} 当前地图最大显示层级。
 */
-(float) maxZoom;

-(RMSphericalTrapezium) latitudeLongitudeBoundingBox;

-(NSString *)shortName;


-(NSString *)longDescription;

-(NSString *)shortAttribution;

-(NSString *)longAttribution;

@end
