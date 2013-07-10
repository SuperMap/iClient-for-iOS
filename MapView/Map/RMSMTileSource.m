//
//  RMSMTileSource.m
//  MapView
//
//  Created by iclient on 13-6-8.
//
//

#import "RMSMTileSource.h"
#import "RMTransform.h"
#import "RMTileImage.h"
#import "RMTileLoader.h"
#import "RMSMTileProjection.h"
#import "RMTiledLayerController.h"
#import "RMProjection.h"

@implementation RMSMTileSource

-(id) init
{
	if (![super init])
		return nil;
    
    networkOperations = TRUE;
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkOperationsNotification:) name:RMSuspendNetworkOperations object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkOperationsNotification:) name:RMResumeNetworkOperations object:nil];
	
	return self;
}

-(id) initWithInfo:(RMSMLayerInfo*) info
{
    [self init];
    
    CGRect rect_screen = [[UIScreen mainScreen] bounds];
    int width = rect_screen.size.width;
    int height = rect_screen.size.height;
    m_Info = info;
    
    m_dResolutions = [[NSMutableArray alloc] initWithCapacity:16];
    m_dScale = [[NSMutableArray alloc] initWithCapacity:16];

    double wRes = m_Info.dWidth / width;
    double hRes = m_Info.dHeight / height;
    double maxResolution = wRes>hRes?wRes:hRes;
    double base = 2.0;
    NSString*  strScale;
    double dScale;
    for(int i=0;i<16;++i)
    {
        dScale = maxResolution/pow(base,i);
        [m_dResolutions addObject:[NSNumber numberWithDouble:dScale]];
        strScale = [m_Info getScaleFromResolutionDpi:dScale];
        //NSLog(@"%@",strScale);
        [m_dScale addObject:strScale];
    }
    
    //NSLog(@"%@",m_dResolutions);
    
    tileProjection = [[RMSMTileProjection alloc] initFromProjection:[self projection] tileSideLength:256 maxZoom:[m_dResolutions count]-1 minZoom:0 info:m_Info resolutions:m_dResolutions];
    
	[self setMaxZoom:15];
	[self setMinZoom:0];
    return  self;
}

-(id) initWithInfo:(RMSMLayerInfo*) info resolutions:(NSMutableArray*)resolutions
{
    [self init];
    
    m_Info = info;
    int nCount = [resolutions count];
    m_dResolutions = [[NSMutableArray alloc] initWithCapacity:nCount];
    m_dScale = [[NSMutableArray alloc] initWithCapacity:nCount];
    
    NSString*  strScale;
    id dScale;
    for(int i=0;i<nCount;++i)
    {
        dScale = [m_dResolutions objectAtIndex:(int)i];
        [m_dResolutions addObject:[NSNumber numberWithDouble:[dScale doubleValue]]];
        strScale = [m_Info getScaleFromResolutionDpi:[dScale doubleValue]];
        //NSLog(@"%@",strScale);
        [m_dScale addObject:strScale];
    }
    
    tileProjection = [[RMSMTileProjection alloc] initFromProjection:[self projection] tileSideLength:256 maxZoom:[m_dResolutions count]-1 minZoom:0 info:m_Info resolutions:m_dResolutions];
    
	[self setMaxZoom:[m_dResolutions count]-1];
	[self setMinZoom:0];
    return  self;
}

- (void) networkOperationsNotification: (NSNotification*) notification
{
	if(notification.name == RMSuspendNetworkOperations)
		networkOperations = FALSE;
	else if(notification.name == RMResumeNetworkOperations)
		networkOperations = TRUE;
}

-(void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:RMSuspendNetworkOperations object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:RMResumeNetworkOperations object:nil];
	[tileProjection release];
	[super dealloc];
}

-(int)tileSideLength
{
	return tileProjection.tileSideLength;
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

-(RMTileImage *)tileImage:(RMTile)tile
{
	RMTileImage *image;
	
	tile = [tileProjection normaliseTile:tile];
	
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
    double dHeight = m_Info.dHeight;
    double dWidth = m_Info.dWidth;
    double dleft = m_Info.m_pntOrg.latitude;
    double dbottom = m_Info.m_pntOrg.longitude - dHeight;
    RMProjectedRect theBounds = RMMakeProjectedRect(dleft,dbottom,dWidth,dHeight);
    
    return [RMProjection smProjection:theBounds];
}

-(void) didReceiveMemoryWarning
{
	LogMethod();
}

-(NSString*) tileURL: (RMTile) tile
{
	NSAssert4(((tile.zoom >= self.minZoom) && (tile.zoom <= self.maxZoom)),
			  @"%@ tried to retrieve tile with zoomLevel %d, outside source's defined range %f to %f",
			  self, tile.zoom, self.minZoom, self.maxZoom);
    
    NSString* strScale = [m_dScale objectAtIndex:(int)tile.zoom];
	//float fScale = [result floatValue];
        
    NSString* strUrl = [NSString stringWithFormat:@"%@/tileImage.png?transparent=true&cacheEnabled=true&redirect=true&width=256&height=256&x=%d&y=%d&scale=%@",m_Info.smurl,tile.x, tile.y,strScale];
    //NSLog(@"%@",strUrl);

	return strUrl;
}

-(NSString*) uniqueTilecacheKey
{
	return @"SuperMap";
}

-(NSString *)shortName
{
	return @"SM";
}
-(NSString *)longDescription
{
	return @"Su";
}
-(NSString *)shortAttribution
{
	return @"SuperMap iServer REST Map";
}
-(NSString *)longAttribution
{
	return @"SuperMap iServer REST Map";
}
-(void) removeAllCachedImages
{
}



@end
