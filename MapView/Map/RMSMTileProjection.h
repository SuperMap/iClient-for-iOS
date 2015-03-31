//
//  RMSMTileProjection.h
//  MapView
//
//  Created by iclient on 13-6-9.
//
//

#import <Foundation/Foundation.h>
#import "RMMercatorToTileProjection.h"
#import "RMSMLayerInfo.h"


@class RMProjection;

/**
 * Class: RMSMTileProjection
 * SuperMap iServer地图服务投影
 */
@interface RMSMTileProjection : NSObject<RMMercatorToTileProjection>{
    /// Maximum zoom for which our tile server stores images
	NSUInteger maxZoom, minZoom;
	
	/// projected bounds of the planet, in meters
	RMProjectedRect planetBounds;
	
	/// Normally 256. This class assumes tiles are square.
	NSUInteger tileSideLength;
	
	/// The deal is, we have a scale which stores how many mercator gradiants per pixel
	/// in the image.
	/// If you run the maths, scale = bounds.width/(2^zoom * tileSideLength)
	/// or if you want, z = log(bounds.width/tileSideLength) - log(s)
	/// So here we'll cache the first term for efficiency.
	/// I'm using width arbitrarily - I'm not sure what the effect of using the other term is when they're not the same.
	double scaleFactor;
//    RMSMLayerInfo* m_pInfo;
    NSMutableArray* m_dResolutions;
    BOOL isBaseLayer;
}
@property (nonatomic,retain) RMSMLayerInfo* m_pInfo;

- (id) initFromProjection:(RMProjection*)projection tileSideLength:(NSUInteger)tileSideLength maxZoom: (NSUInteger) aMaxZoom minZoom: (NSUInteger) aMinZoom info:(RMSMLayerInfo*) info resolutions:(NSMutableArray*) dResolutions;

- (void) setTileSideLength: (NSUInteger) aTileSideLength;
- (void) setMinZoom: (NSUInteger) aMinZoom;
- (void) setMaxZoom: (NSUInteger) aMaxZoom;
- (void) setIsBaseLayer:(BOOL)bIsBaseLayer;
@end
