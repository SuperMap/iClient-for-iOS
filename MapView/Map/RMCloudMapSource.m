//
//  RMCloudMapSource.m
//  MapView
//
//  Created by iclient on 13-7-4.
//
//

#import "RMCloudMapSource.h"
#import "RMSMTileSource.h"
#import "RMTransform.h"
#import "RMTileImage.h"
#import "RMTileLoader.h"
#import "RMSMTileProjection.h"
#import "RMTiledLayerController.h"
#import "RMProjection.h"

@implementation RMCloudMapSource

-(id) init
{
	if(self = [super init])
	{
        networkOperations = TRUE;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkOperationsNotification:) name:RMSuspendNetworkOperations object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkOperationsNotification:) name:RMResumeNetworkOperations object:nil];
        _isBaseLayer=NO;
        
        m_dResolutions = [[NSMutableArray alloc] init];
        
        NSNumber *num1 = [NSNumber numberWithFloat:156605.46875];
        [m_dResolutions addObject:num1];
        NSNumber *num2 = [NSNumber numberWithFloat:78302.734375];
        [m_dResolutions addObject:num2];
        NSNumber *num3 = [NSNumber numberWithFloat:39151.3671875];
        [m_dResolutions addObject:num3];
        NSNumber *num4 = [NSNumber numberWithFloat:19575.68359375];
        [m_dResolutions addObject:num4];
        NSNumber *num5 = [NSNumber numberWithFloat:9787.841796875];
        [m_dResolutions addObject:num5];
        NSNumber *num6 = [NSNumber numberWithFloat:4893.9208984375];
        [m_dResolutions addObject:num6];
        NSNumber *num7 = [NSNumber numberWithFloat:2446.96044921875];
        [m_dResolutions addObject:num7];
        NSNumber *num8 = [NSNumber numberWithFloat:1223.48022460937];
        [m_dResolutions addObject:num8];
        NSNumber *num9 = [NSNumber numberWithFloat:611.740112304687];
        [m_dResolutions addObject:num9];
        NSNumber *num10 = [NSNumber numberWithFloat:305.870056152344];
        [m_dResolutions addObject:num10];
        NSNumber *num11 = [NSNumber numberWithFloat:152.935028076172];
        [m_dResolutions addObject:num11];
        NSNumber *num12 = [NSNumber numberWithFloat:76.4675140380859];
        [m_dResolutions addObject:num12];
        NSNumber *num13 = [NSNumber numberWithFloat:38.233757019043];
        [m_dResolutions addObject:num13];
        NSNumber *num14 = [NSNumber numberWithFloat:19.1168785095215];
        [m_dResolutions addObject:num14];
        NSNumber *num15 = [NSNumber numberWithFloat:9.55843925476074];
        [m_dResolutions addObject:num15];
        NSNumber *num16 = [NSNumber numberWithFloat:4.77921962738037];
        [m_dResolutions addObject:num16];
        NSNumber *num17 = [NSNumber numberWithFloat:2.38960981369019];
        [m_dResolutions addObject:num17];
        NSNumber *num18 = [NSNumber numberWithFloat:1.19480490684509];
        [m_dResolutions addObject:num18];
        NSNumber *num19 = [NSNumber numberWithFloat:0.597402453422546];
        [m_dResolutions addObject:num19];
        
		//http://wiki.openstreetmap.org/index.php/FAQ#What_is_the_map_scale_for_a_particular_zoom_level_of_the_map.3F
		tileProjection = [[RMSMTileProjection alloc] initFromProjection:[self projection] tileSideLength:256 maxZoom:[m_dResolutions count]-1 minZoom:0 info:nil resolutions:m_dResolutions];
        
        [self setMaxZoom:[m_dResolutions count]-1];
        [self setMinZoom:0];

	}
	return self;
}

-(int)tileSideLength
{
	return [[NSNumber numberWithUnsignedLong:tileProjection.tileSideLength] intValue];
}

- (void) setTileSideLength: (NSUInteger) aTileSideLength
{
	[tileProjection setTileSideLength:aTileSideLength];
}

-(float) minZoom
{
	return (float)tileProjection.minZoom;
}

-(float) maxZoom
{
	return (float)tileProjection.maxZoom;
}

-(float) numberZoomLevels
{
    return [m_dResolutions count]-1;
}
-(NSMutableArray*) m_dScales
{
    return m_dScales;
}
-(void) setIsBaseLayer:(BOOL)isBaseLayer
{
    _isBaseLayer=isBaseLayer;
}

-(void) setMinZoom:(NSUInteger)aMinZoom
{
	[tileProjection setMinZoom:aMinZoom];
}

-(void) setMaxZoom:(NSUInteger)aMaxZoom
{
	[tileProjection setMaxZoom:aMaxZoom];
}

-(RMSphericalTrapezium) latitudeLongitudeBoundingBox;
{
	return ((RMSphericalTrapezium){.northeast = {.latitude = 90, .longitude = 180}, .southwest = {.latitude = -90, .longitude = -180}});
}

-(NSString*) tileFile: (RMTile) tile
{
	return nil;
}

-(NSString*) tilePath
{
	return nil;
}

-(NSString*) tileURL: (RMTile) tile
{
	NSAssert4(((tile.zoom >= self.minZoom) && (tile.zoom <= self.maxZoom)),
			  @"%@ tried to retrieve tile with zoomLevel %d, outside source's defined range %f to %f",
			  self, tile.zoom, self.minZoom, self.maxZoom);
	return [NSString stringWithFormat:@"http://t0.supermapcloud.com/FileService/image?map=quanguo&type=web&x=%d&y=%d&z=%d",tile.x, tile.y,tile.zoom];
    
}

- (void) networkOperationsNotification: (NSNotification*) notification
{
	if(notification.name == RMSuspendNetworkOperations)
		networkOperations = FALSE;
	else if(notification.name == RMResumeNetworkOperations)
		networkOperations = TRUE;
}

-(RMTileImage *)tileImage:(RMTile)tile
{
	RMTileImage *image;
    if(self.isHidden)
        return nil;
	tile = [tileProjection normaliseTile:tile];
	
    //    NSLog(@"x :%d y:%d,z:%d",tile.x,tile.y,tile.zoom);
	NSString *file = [self tileFile:tile];
	
	if(file && [[NSFileManager defaultManager] fileExistsAtPath:file])
	{
		image = [RMTileImage imageForTile:tile fromFile:file];
	}
	else if(networkOperations)
	{
		image = [RMTileImage imageForTile:tile withURL:[self tileURL:tile]];
	}
	else
	{
		image = [RMTileImage dummyTile:tile];
	}
	
	return image;
}


-(id<RMMercatorToTileProjection>) mercatorToTileProjection
{
	return [[tileProjection retain] autorelease];
}

-(RMProjection*) projection
{
    double dHeight = 2.00375083427892E7*2;
    double dWidth = 2.00375083427892E7*2;
    double dleft = -2.00375083427892E7;
    double dbottom = -2.00375083427892E7;
   // NSLog(@"%f,%f,%f,%f",dleft,dbottom,dWidth,dHeight);
    RMProjectedRect theBounds = RMMakeProjectedRect(dleft,dbottom,dWidth,dHeight);
    
    return [RMProjection smProjection:theBounds];
}


-(NSString*) uniqueTilecacheKey
{
	return @"SuperMap Cloud";
}

-(NSString *)shortName
{
	return @"SuperMap Cloud";
}
-(NSString *)longDescription
{
	return @"SuperMap Cloud";
}
-(NSString *)shortAttribution
{
	return @"SuperMap Cloud";
}
-(NSString *)longAttribution
{
	return @"SuperMap Cloud";
}

@end
