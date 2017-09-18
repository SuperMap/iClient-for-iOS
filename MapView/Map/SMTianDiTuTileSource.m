//
//  NSObject+SMTiDiTuTileSource.m
//  MapView
//
//  Created by zhoushibin on 15-4-13.
//
//

#import "SMTianDiTuTileSource.h"
#import "RMNotifications.h"
#import "RMSMLayerInfo.h"
#import "RMSMTileProjection.h"
#import "RMProjection.h"
#import "RMTileImage.h"
#import "ToolKit.h"

@implementation SMTianDiTuTileSource
@synthesize tileLoader=_tileLoader,imagesOnScreen=_imagesOnScreen,renderer=_renderer;

/*-(id) initWithInfo:(RMSMLayerInfo*) info
{
    [self init];
    
    CGRect rect_screen = [[UIScreen mainScreen] bounds];
    int width = rect_screen.size.width;
    int height = rect_screen.size.height;
    self.m_Info = info;
    
    m_dResolutions = [[NSMutableArray alloc] initWithCapacity:18];
    m_dScales = [[NSMutableArray alloc] initWithCapacity:18];
    
    double wRes = self.m_Info.dWidth / width;
    double hRes = self.m_Info.dHeight / height;
    double maxResolution = wRes>hRes?wRes:hRes;
    maxResolution = 0.703125;
    double base = 2.0;
    NSString*  strScale;
    double dResolutions;
    for(int i=0;i<18;++i)
    {
        dResolutions = maxResolution/pow(base,i);
        [m_dResolutions addObject:[NSNumber numberWithDouble:dResolutions]];
        strScale = [self.m_Info getScaleFromResolutionDpi:dResolutions];
        //NSLog(@"%@",strScale);
        [m_dScales addObject:strScale];
    }
    
    //NSLog(@"%@",m_dResolutions);
    smProjection=[[RMProjection alloc] initForSMProjection];
    tileProjection = [[RMSMTileProjection alloc] initFromProjection:[self projection] tileSideLength:256 maxZoom:[m_dResolutions count]-1 minZoom:0 info:self.m_Info resolutions:m_dResolutions];
    
    [self setMaxZoom:[m_dResolutions count]-1];
    [self setMinZoom:0];
    return  self;
}*/

-(id) init
{
    if (![super init])
        return nil;
    networkOperations = TRUE;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkOperationsNotification:) name:RMSuspendNetworkOperations object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkOperationsNotification:) name:RMResumeNetworkOperations object:nil];
    _isBaseLayer=NO;
     [self setIsUseCache:YES];
    
    ////
    m_dResolutions = [[NSMutableArray alloc] initWithCapacity:18];
    m_dScales = [[NSMutableArray alloc] initWithCapacity:18];
    
    double maxResolution = 0.703125;
    double base = 2.0;
    NSString*  strScale;
    double dResolutions;
    for(int i=0;i<18;++i)
    {
        dResolutions = maxResolution/pow(base,i);
        [m_dResolutions addObject:[NSNumber numberWithDouble:dResolutions]];
        //strScale = [self.m_Info getScaleFromResolutionDpi:dResolutions];
        //NSLog(@"%@",strScale);95.9999923
        //[m_dScales addObject:strScale];
    }
    
    //NSLog(@"%@",m_dResolutions);
    smProjection=[[RMProjection alloc] initForSMProjection];
    tileProjection = [[RMSMTileProjection alloc] initFromProjection:[self projection] tileSideLength:256 maxZoom:[m_dResolutions count]-1 minZoom:0 info:self.m_Info resolutions:m_dResolutions];
    
    [self setMaxZoom:[m_dResolutions count]-1];
    [self setMinZoom:0];
    return self;

}
-(void) setM_dScales:(NSMutableArray*) scales
{
    tileProjection = [[RMSMTileProjection alloc] initFromProjection:[self projection] tileSideLength:256 maxZoom:[m_dScales  count]-1 minZoom:0 info:self.m_Info resolutions:m_dResolutions];
    
    
}

-(NSString *) tileURL: (RMTile) tile
{
    ///天地图url
    url = @"http://t2.tianditu.com/DataServer?T=vec_c";
    NSString* strUrl;
    strUrl = [NSString stringWithFormat:@"%@&X=%d&Y=%d&L=%d",url,tile.x,tile.y,(int)tile.zoom+1];
    
//    NSLog(@"%u====%u====%u",tile.x,tile.y,tile.zoom+1);
    return strUrl;
}
-(RMTileImage *)tileImage:(RMTile)tile
{
    RMTileImage *image;
    
    if(self.isHidden)
        return nil;
    tile = [tileProjection normaliseTile:tile];
    
    //NSLog(@"x :%d y:%d,z:%d",tile.x,tile.y,tile.zoom+1);
    NSString *file = [self tileFile:tile];
    
    if(file && [[NSFileManager defaultManager] fileExistsAtPath:file])
    {
        image = [RMTileImage imageForTile:tile fromFile:file];
    }
    else if(networkOperations)
    {
        image = [RMTileImage imageForTile:tile withURL:[self tileURL:tile]];
        image.cachePath = file;
    }
    else
    {
        image = [RMTileImage dummyTile:tile];
    }
    
    return image;
}
-(float) minZoom
{
    return (float)tileProjection.minZoom;
}

-(float) maxZoom
{
    return (float)tileProjection.maxZoom;
}
-(NSMutableArray*) m_dScales
{
    return m_dScales;
}
-(float) numberZoomLevels
{
    return [m_dScales count]-1;
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
    if(self.m_Info.cachePath!=nil)
        [ToolKit createFileDirectories:[NSString stringWithFormat:@"%@/TianDiTu/%i",self.m_Info.cachePath,tile.zoom]];
    
    return [NSString stringWithFormat:@"%@/TianDiTu/%i/%i_%i.png",self.m_Info.cachePath,tile.zoom,tile.x,tile.y];
}

-(NSString*) tilePath
{
    return nil;
}
-(void) removeAllCachedImages
{
}
-(int)tileSideLength
{
    return [[NSNumber numberWithUnsignedLong:tileProjection.tileSideLength] intValue];
}

- (void) setTileSideLength: (NSUInteger) aTileSideLength
{
    [tileProjection setTileSideLength:aTileSideLength];
}
-(id<RMMercatorToTileProjection>) mercatorToTileProjection
{
    return [[tileProjection retain] autorelease];
}
-(RMProjection*) projection
{
    
    double dHeight = 90*2;
    double dWidth = 180*2;
    double dleft = -180;
    double dbottom = -90;
    
    //NSLog(@"%f,%f,%f,%f",dleft,dbottom,dWidth,dHeight);
    RMProjectedRect theBounds = RMMakeProjectedRect(dleft,dbottom,dWidth,dHeight);
    
    return [RMProjection smProjection:theBounds];
    
}


-(void) didReceiveMemoryWarning
{
    LogMethod();
}

-(NSString*) uniqueTilecacheKey
{
    return @"tianditu";
}

-(NSString *)shortName
{
    return @"tianditu";

}
-(NSString *)longDescription
{
    return @"tianditu";

}
-(NSString *)shortAttribution
{
    return @"tianditu";

}
-(NSString *)longAttribution
{
    return @"tianditu";

}
-(BOOL) isBaseLayer
{
    return _isBaseLayer;
}
-(void) setIsBaseLayer:(BOOL)isBaseLayer
{
    _isBaseLayer=isBaseLayer;
}
@end
