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
#import "RMProjection.h"
#import "RMTiledLayerController.h"
#import "ToolKit.h"

#import "MapView_Prefix.pch"

@implementation RMSMTileSource
@synthesize tileLoader=_tileLoader,imagesOnScreen=_imagesOnScreen,renderer=_renderer;
@synthesize cachePath;
-(id) init
{
    if (![super init])
        return nil;
    
    networkOperations = TRUE;
    _isBaseLayer=NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkOperationsNotification:) name:RMSuspendNetworkOperations object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkOperationsNotification:) name:RMResumeNetworkOperations object:nil];
    [self setIsUseCache:YES];
    return self;
}

-(id) initWithInfo:(RMSMLayerInfo*) info
{
    if(info==nil)
        return nil;
    [self init];
    
    CGRect rect_screen = [[UIScreen mainScreen] bounds];
    int width = rect_screen.size.width;
    int height = rect_screen.size.height;
    self.m_Info = info;
    
    int resolutionSize = 18;
    BOOL isNull = self.m_Info.scales.count>0?NO:YES;
    if (!isNull) {
        [self getResolutionsFromScales:self.m_Info.scales];
    }else{
        m_dResolutions = [[NSMutableArray alloc] initWithCapacity:resolutionSize];
        m_dScales = [[NSMutableArray alloc] initWithCapacity:resolutionSize];
        double wRes = self.m_Info.dWidth / width;
        double hRes = self.m_Info.dHeight / height;
        double maxResolution = wRes>hRes?wRes:hRes;
        //maxResolution = 0.703125;
        double base = 2.0;
        NSString*  strScale;
        double dResolutions;
        for(int i=0;i<resolutionSize;++i){
            dResolutions = maxResolution/pow(base,i);
            [m_dResolutions addObject:[NSNumber numberWithDouble:dResolutions]];
            strScale = [self.m_Info getScaleFromResolutionDpi:dResolutions];
            [m_dScales addObject:strScale];
        }

    }
    
    
    
    //NSLog(@"%@",m_dResolutions);
    smProjection=[[RMProjection alloc] initForSMProjection];
    tileProjection = [[RMSMTileProjection alloc] initFromProjection:[self projection] tileSideLength:256 maxZoom:[m_dResolutions count]-1 minZoom:0 info:self.m_Info resolutions:m_dResolutions];
    
    [self setMaxZoom:[m_dResolutions count]-1];
    [self setMinZoom:0];
    return  self;
}

-(id) initWithInfo:(RMSMLayerInfo*) info resolutions:(NSMutableArray*)resolutions
{
    [self init];
    
    self.m_Info = info;
    int nCount =[[NSNumber numberWithUnsignedLong:[resolutions count]] intValue];
    m_dResolutions = [[NSMutableArray alloc] initWithCapacity:nCount];
    // m_dResolutions = resolutions;
    m_dScales = [[NSMutableArray alloc] initWithCapacity:nCount];
    
    //对resolutions数组升序排列,并在计算scales时对m_dScales降序排列
    NSArray *resolutionsDescending=[resolutions sortedArrayUsingSelector:@selector(compare:)];
    NSString*  strScale;
    id dResolutions;
    //m_dScales降序排列
    for(int i=nCount-1;i>=0;--i)
    {
        dResolutions = [resolutionsDescending objectAtIndex:(int)i];
        [m_dResolutions addObject:[NSNumber numberWithDouble:[dResolutions doubleValue]]];
        strScale = [self.m_Info getScaleFromResolutionDpi:[dResolutions doubleValue]];
        [m_dScales addObject:strScale];
    }
    //NSLog(@"%@",m_dScales);
    smProjection=[[RMProjection alloc] initForSMProjection];
    tileProjection = [[RMSMTileProjection alloc] initFromProjection:[self projection] tileSideLength:256 maxZoom:[m_dResolutions count]-1 minZoom:0 info:self.m_Info resolutions:m_dResolutions];
    
    [self setMaxZoom:[m_dResolutions count]-1];
    [self setMinZoom:0];
    return  self;
}

-(id) initWithInfo:(RMSMLayerInfo*) info scales:(NSMutableArray*) scales
{
    [self init];
    
    self.m_Info = info;
    [self getResolutionsFromScales:scales];
    
    smProjection=[[RMProjection alloc] initForSMProjection];
    tileProjection = [[RMSMTileProjection alloc] initFromProjection:[self projection] tileSideLength:256 maxZoom:[m_dScales  count]-1 minZoom:0 info:self.m_Info resolutions:m_dResolutions];
    
    [self setMaxZoom:[m_dScales count]-1];
    [self setMinZoom:0];
    return  self;
}



-(void)getResolutionsFromScales:(NSMutableArray *) newScales
{
    int nCount = [[NSNumber numberWithUnsignedLong:[newScales count]] intValue];
    m_dScales = [[NSMutableArray alloc] initWithCapacity:nCount];
    m_dResolutions = [[NSMutableArray alloc] initWithCapacity:nCount];
    //对scales数组升序排列
    NSArray *scalesAscending=[newScales sortedArrayUsingSelector:@selector(compare:)];
    // NSLog(@"%@",scalesAscending);
    
    NSString*  strResoltion;
    NSString*  strScale;
    id dScale;
    for(int i=0;i<nCount;++i)
    {
        dScale = [scalesAscending objectAtIndex:(int)i];
        strResoltion = [self.m_Info getResolutionFromScaleDpi:[dScale doubleValue]];
        [m_dResolutions addObject:strResoltion];
        strScale =[NSString stringWithFormat:@"%.20f",[dScale doubleValue]];
        [m_dScales addObject:strScale];
    }
    
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
-(NSMutableArray*) m_dScales
{
    return m_dScales;
}

-(void) setM_dScales:(NSMutableArray*) scales
{
    //[m_dScales release];
    //[m_dResolutions release];
    //[self getResolutionsFromScales:scales];
    tileProjection = [[RMSMTileProjection alloc] initFromProjection:[self projection] tileSideLength:256 maxZoom:[m_dScales  count]-1 minZoom:0 info:self.m_Info resolutions:m_dResolutions];
    
    
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
        [ToolKit createFileDirectories:[NSString stringWithFormat:@"%@/SMMap/%i",self.m_Info.cachePath,tile.zoom]];
    
    return [NSString stringWithFormat:@"%@/SMMap/%i/%i_%i.png",self.m_Info.cachePath,tile.zoom,tile.x,tile.y];
}

-(NSString*) tilePath
{
    return nil;
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
        image.cachePath = file;
    }
    else
    {
        image = [RMTileImage dummyTile:tile];
    }
    
    return image;
}
-(void)clearCache{
    NSError* error;
    BOOL res = [[NSFileManager defaultManager] removeItemAtPath:self.m_Info.cachePath error:&error];
    if(!res){
        NSLog(@"%@",error);
    }
}
-(id<RMMercatorToTileProjection>) mercatorToTileProjection
{
    return [[tileProjection retain] autorelease];
}

-(RMProjection*) projection
{
    double dHeight = self.m_Info.dHeight;
    double dWidth = self.m_Info.dWidth;
    double dleft = self.m_Info.m_pntOrg.longitude;
    double dbottom = self.m_Info.m_pntOrg.latitude - dHeight;
    //    NSLog(@"%f,%f,%f,%f",dleft,dbottom,dWidth,dHeight);
    RMProjectedRect theBounds = RMMakeProjectedRect(dleft,dbottom,dWidth,dHeight);
    
    NSString *projection=self.m_Info.projection;
    
    return [smProjection projectionWithBounds:theBounds EPSGCode:projection];
    
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
    
    NSString* strScale = [m_dScales objectAtIndex:(int)tile.zoom];
    //float fScale = [result floatValue];
    //transparent=true&cacheEnabled=true&redirect=true&width=256&height=256&x=%d&y=%d&scale=%@
    NSString* strUrl = nil;
    if (self.m_Info.tempLayerName) {
        // 使用临时图层
        strUrl = [NSString stringWithFormat:@"%@/tileImage.png?%@&width=256&height=256&x=%d&y=%d&scale=%@&layersID=%@&transparent=true",self.m_Info.smurl,self.m_Info.strParams,tile.x, tile.y,strScale,self.m_Info.tempLayerName];
    }else{
        strUrl = [NSString stringWithFormat:@"%@/tileImage.png?%@&width=256&height=256&x=%d&y=%d&scale=%@&transparent=true",self.m_Info.smurl,self.m_Info.strParams,tile.x, tile.y,strScale];
    }
    
    
//    NSLog(@"%@",strUrl);
//    NSLog(@"%d",tile.zoom);
    return strUrl;
}

-(NSString*) uniqueTilecacheKey
{
    return self.m_Info.smurl;
}

-(NSString *)shortName
{
    return self.m_Info.smurl;
}
-(NSString *)longDescription
{
    return self.m_Info.smurl;
}
-(NSString *)shortAttribution
{
    return self.m_Info.smurl;
}
-(NSString *)longAttribution
{
    return self.m_Info.smurl;
}
-(void) removeAllCachedImages
{
}
-(void)setImagesOnScreen:(RMTileImageSet *)imagesOnScreen;
{
    _imagesOnScreen=imagesOnScreen;
}
-(void)setTileLoader:(RMTileLoader *)tileLoader;
{
    _tileLoader=tileLoader;
}
-(void)setRenderer:(RMMapRenderer *)renderer;
{
    _renderer=renderer;
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
