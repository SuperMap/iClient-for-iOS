//
//  NSObject+SMBaiduTileSource.m
//  MapView
//
//  Created by smSupport on 16/5/25.
//
//

#import "SMBaiduTileSource.h"
#import "RMNotifications.h"
#import "RMSMLayerInfo.h"
#import "RMSMTileProjection.h"
#import "RMProjection.h"
#import "RMTileImage.h"
#import "ToolKit.h"

@implementation SMBaiduTileSource

@synthesize tileLoader=_tileLoader,imagesOnScreen=_imagesOnScreen,renderer=_renderer;

-(NSString *) tileURL: (RMTile) tile
{
 
     NSString* strUrl;
    if(self.isUseSatelliteMap){
        url = @"http://shangetu1.map.bdimg.com/it/u=";
        strUrl = [NSString stringWithFormat:@"%@x=%d;y=%d;z=%d;v=009;type=sate&fm=46",url,tile.x-tile.sliceCountW,tile.sliceCountH - tile.y,(int)tile.zoom];
    }else{
        url = @"http://online1.map.bdimg.com/onlinelabel/?qt=tile";
        strUrl = [NSString stringWithFormat:@"%@&x=%d&y=%d&z=%d",url,tile.x-tile.sliceCountW,tile.sliceCountH - tile.y,(int)tile.zoom];
    }
    
   // NSLog(@"%@",strUrl);
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
    
    if(file && [[NSFileManager defaultManager] fileExistsAtPath:file]){
        image = [RMTileImage imageForTile:tile fromFile:file];
    }else if(networkOperations){
        image = [RMTileImage imageForTile:tile withURL:[self tileURL:tile]];
        image.cachePath = file;
    }else{
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
-(id) init
{
    if (![super init])
        return nil;
    networkOperations = TRUE;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkOperationsNotification:) name:RMSuspendNetworkOperations object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkOperationsNotification:) name:RMResumeNetworkOperations object:nil];
    _isBaseLayer=NO;
    [self setIsUseCache:YES];
    self.isUseSatelliteMap = YES;
    ////
    m_dResolutions = [[NSMutableArray alloc] initWithCapacity:18];
//    m_dScales = [[NSMutableArray alloc] initWithCapacity:18];
    
     //m_dResolutions = [[arr reverseObjectEnumerator] allObjects];
    for(int i=0;i<18;++i)
    {
        double dResolutions = pow(2.0,18-i);
        [m_dResolutions addObject:[NSNumber numberWithDouble:dResolutions]];

    }
	[m_dResolutions addObject:@(1.0)];
	[m_dResolutions addObject:@(0.5)];
    /*
     this.crs.unit = "meter";
     this.crs.wkid = 3857;
     this.isGCSLayer = false;
     */
    //self.
    //NSLog(@"%@",m_dResolutions);
    self.m_Info =  [[RMSMLayerInfo alloc]init];
    //self.m_Info.
    smProjection=[[RMProjection alloc] initForSMProjection];
    tileProjection = [[RMSMTileProjection alloc] initFromProjection:[self projection] tileSideLength:256 maxZoom:[m_dResolutions count]-1 minZoom:0 info:self.m_Info resolutions:m_dResolutions];
    
    [self setMaxZoom:[m_dResolutions count]-1];
    [self setMinZoom:3];
    return self;
    
}
-(void) setM_dScales:(NSMutableArray*) scales
{
    tileProjection = [[RMSMTileProjection alloc] initFromProjection:[self projection] tileSideLength:256 maxZoom:[m_dScales  count]-1 minZoom:0 info:self.m_Info resolutions:m_dResolutions];
    
    
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
        [ToolKit createFileDirectories:[NSString stringWithFormat:@"%@/BaiDuMap/%i",self.m_Info.cachePath,tile.zoom]];
    
    return [NSString stringWithFormat:@"%@/BaiDuMap/%i/%i_%i.png",self.m_Info.cachePath,tile.zoom,tile.x,tile.y];
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
    
//    double dHeight = 90*2;
//    double dWidth = 180*2;
//    double dleft = -180;
//    double dbottom = -90;
//    
//    //NSLog(@"%f,%f,%f,%f",dleft,dbottom,dWidth,dHeight);
//    RMProjectedRect theBounds = RMMakeProjectedRect(dleft,dbottom,dWidth,dHeight);
//    
//    return [RMProjection smProjection:theBounds];
    
//    double dHeight = 25165824*2;
//    double dWidth = 25165824*2;
//    double dleft = -25165824;
//    double dbottom = -25165824;
    
    double dHeight = 25165824*2;
    double dWidth = 25165824*2;
    double dleft = -25165824;
    double dbottom = -25165824;
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
