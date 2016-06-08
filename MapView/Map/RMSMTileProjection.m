//
//  RMSMTileProjection.m
//  MapView
//
//  Created by iclient on 13-6-9.
//
//

#import "RMSMTileProjection.h"
#import "RMMercatorToScreenProjection.h"
#import "RMProjection.h"
#import "RMSMTileProjection_inner.h"
#import <math.h>

@implementation RMSMTileProjection

@synthesize maxZoom, minZoom,curZoom,curScale;
@synthesize tileSideLength;
@synthesize planetBounds;
@synthesize orinXY;
-(id) initFromProjection:(RMProjection*)projection tileSideLength:(NSUInteger)aTileSideLength maxZoom: (NSUInteger) aMaxZoom minZoom: (NSUInteger) aMinZoom info:(RMSMLayerInfo*) info resolutions:(NSMutableArray*) dResolutions
{
    if (![super init])
        return nil;
    
    self.m_pInfo = info;
    
    // We don't care about the rest of the projection... just the bounds is important.
    //左下角和宽高
    planetBounds = [projection planetBounds];
    m_dResolutions = [dResolutions copy];
    if (planetBounds.size.width == 0.0f || planetBounds.size.height == 0.0f)
    {
        /// \bug magic string literals
        @throw [NSException exceptionWithName:@"RMUnknownBoundsException"
                                       reason:@"RMFractalTileProjection was initialised with a projection with unknown bounds"
                                     userInfo:nil];
    }
    
    tileSideLength = aTileSideLength;
    maxZoom = aMaxZoom;
    minZoom = aMinZoom;
    isBaseLayer=NO;
    //NSLog(@"max %d",maxZoom);
    
    return self;
}

- (void) setTileSideLength: (NSUInteger) aTileSideLength
{
    tileSideLength = aTileSideLength;
}

- (void) setMinZoom: (NSUInteger) aMinZoom
{
    minZoom = aMinZoom;
}

- (void) setMaxZoom: (NSUInteger) aMaxZoom
{
    maxZoom = aMaxZoom;
}
- (void) setIsBaseLayer:(BOOL)bIsBaseLayer
{
    isBaseLayer=bIsBaseLayer;
}
- (double) normaliseZoom: (double) zoom
{
    double normalised_zoom = roundf(zoom);
    
    if (normalised_zoom > maxZoom)
    {
        normalised_zoom = maxZoom;
    }
    if (normalised_zoom < minZoom){
        normalised_zoom = minZoom;
    }
    
    return normalised_zoom;
}

- (double) limitFromNormalisedZoom: (double) zoom
{
    return exp2f(zoom);
}

- (RMTile) normaliseTile: (RMTile) tile
{
   // tile.y = tile.sliceCountH - tile.y;
    return  tile;
    // The mask contains a 1 for every valid x-coordinate bit.
    uint32_t mask = 1;
    for (int i = 0; i < tile.zoom; i++)
        mask <<= 1;
    
    mask -= 1;
    
    tile.x &= mask;
    
    // If the tile's y coordinate is off the screen
    if (tile.y & (~mask))
    {
        return RMTileDummy();
    }
    
    return tile;
}
//修正左上角点坐标的easting
- (RMProjectedPoint) constrainPointHorizontally: (RMProjectedPoint) aPoint
{
    //如果是叠加图层直接用offset修正
    if(isBaseLayer)
    {
        while (aPoint.easting < planetBounds.origin.easting)
            aPoint.easting = planetBounds.origin.easting;
    }
    while (aPoint.easting > (planetBounds.origin.easting + planetBounds.size.width))
        aPoint.easting -= planetBounds.size.width;
    
    return aPoint;
}

- (RMTilePoint) projectInternal: (RMProjectedPoint)aPoint normalisedZoom:(double)zoom limit:(double) limit
{
    RMTilePoint tile;
    //矫正左上角点的easting
    RMProjectedPoint newPoint = [self constrainPointHorizontally:aPoint];
    
    double fMeterPerTile = limit;// * tileSideLength;
    //NSLog(@"limit %f",limit);
    //NSLog(@"tileSideLength %d",tileSideLength);
    //NSLog(@"fmeter %f",fMeterPerTile);
    
    //左上角与地图范围原点x 偏差的切片值
    double sliceCountW = (planetBounds.origin.easting+planetBounds.size.width) / fMeterPerTile;
    double x = (newPoint.easting - planetBounds.origin.easting) / fMeterPerTile;
    //NSLog(@"easting %f",newPoint.easting);
    //NSLog(@"planetBounds.origin.easting %f",planetBounds.origin.easting);
    //NSLog(@"x %f",x);
    // Unfortunately, y is indexed from the bottom left.. hence we have to translate it.
    
    //左上角与地图范围原点y 偏差的切片值
    double sliceCountH = (planetBounds.origin.northing + planetBounds.size.height) / fMeterPerTile - 1;
    double y = ((planetBounds.origin.northing + planetBounds.size.height - newPoint.northing) / fMeterPerTile);
    //    NSLog(@"y %f",y);
    if (y<=-1) {
        tile.tile.y=0;
    }
    else {
//        NSLog(@"%e",y);
        tile.tile.y =(uint32_t)(y) ;
    }
    //    NSLog(@"x %f",x);
    if (x<=-1) {
        tile.tile.x=0;
    }
    else{
//        NSLog(@"%e",x);
        tile.tile.x = (uint32_t)(x);
    }
    tile.tile.sliceCountH = sliceCountH;
    tile.tile.sliceCountW = sliceCountW;
    
    tile.tile.zoom = zoom;
    tile.offset.x = (double)x - tile.tile.x;
    tile.offset.y = (double)y - tile.tile.y;
    if(self.orinXY!=nil){
        NSArray* resultArr = self.orinXY[[[NSNumber alloc] initWithInt:zoom]];
        NSString* strX = resultArr[0];
        NSString* strY = resultArr[1];
        tile.tile.x += [strX integerValue];
        tile.tile.y += [strY integerValue];
    }
   
    return tile;
}

- (RMTilePoint) project: (RMProjectedPoint)aPoint atZoom:(double)zoom
{
    double normalised_zoom = [self normaliseZoom:zoom];
    double limit = [self limitFromNormalisedZoom:normalised_zoom];
    
    return [self projectInternal:aPoint normalisedZoom:normalised_zoom limit:limit];
}

////aRect:视图内地理范围
- (RMTileRect) projectRect: (RMProjectedRect)aRect atZoom:(double)zoom
{
    
    /// \bug assignment of double to int, WTF?
   
    int normalised_zoom = [self normaliseZoom:zoom];
    //一个切片的地理范围
    double limit = [self calculateScaleFromZoom:normalised_zoom] * self.tileSideLength;
    //NSLog(@"limit is %f",limit);
    RMTileRect tileRect;
    
    // The origin for projectInternal will have to be the top left instead of the bottom left.
    //左上角 视图的左上角地理坐标
    RMProjectedPoint topLeft = aRect.origin;
    topLeft.northing += aRect.size.height;
    
    
    //计算当前缩放级别下地图的左上角点及偏移量
    tileRect.origin = [self projectInternal:topLeft normalisedZoom:normalised_zoom limit:limit];
    
    if (!isBaseLayer) {
        if(!(((planetBounds.origin.easting>aRect.origin.easting && planetBounds.origin.easting < aRect.origin.easting+aRect.size.width) || (planetBounds.origin.easting +planetBounds.size.width>aRect.origin.easting && planetBounds.origin.easting +planetBounds.size.width <aRect.origin.easting+aRect.size.width)||planetBounds.size.width > aRect.size.width )  && ((planetBounds.origin.northing >aRect.origin.northing && planetBounds.origin.northing < aRect.origin.northing +aRect.size.height) || (planetBounds.origin.northing + planetBounds.size.height >aRect.origin.northing && planetBounds.origin.northing + planetBounds.size.height < aRect.origin.northing+aRect.size.height) || planetBounds.size.height >aRect.size.height)))
        {

            tileRect.size=CGSizeZero;
            return tileRect;
        }
    }
    
    
    //NSLog(@"width is %f",aRect.size.width);
    //NSLog(@"height is %f",aRect.size.height);
    //NSLog(@"limit is %f",limit);
    
    //视图内切片个数x
    tileRect.size.width = aRect.size.width / limit;
    tileRect.size.height = aRect.size.height / limit;
    
//    NSLog(@"width is %f",tileRect.size.width);
//    NSLog(@"height is %f",tileRect.size.height);
//    NSLog(@"limit is %f",limit);
    //
    
    return tileRect;
}

-(RMTilePoint) project: (RMProjectedPoint)aPoint atScale:(double)scale
{
    return [self project:aPoint atZoom:[self calculateZoomFromScale:scale]];
}
//返回当前级别下地图的地理原点及切片x,y的个数
-(RMTileRect) projectRect: (RMProjectedRect)aRect atScale:(double)scale
{
    return [self projectRect:aRect atZoom:[self calculateZoomFromScale:scale]];
}

-(RMTileRect) project: (RMMercatorToScreenProjection*)screen;
{
    return [self projectRect:[screen projectedBounds] atScale:[screen metersPerPixel]];
}

-(double) calculateZoomFromScale: (double) scale
{
    int zoom = 0;
    for (id value in m_dResolutions) {
        double fValue = [value doubleValue];

        if(fabs(fValue-scale)<0.00000001)
            break ;
        
        if(scale>fValue)
        {
            break;
        }
        zoom++;
    }
    curZoom = zoom;
    curScale = scale;
  //  NSLog(@"zoom %d",zoom);
    return zoom;
}

-(double) calculateNormalisedZoomFromScale: (double) scale
{
    return [self normaliseZoom:[self calculateZoomFromScale:scale]];
}

-(double) calculateScaleFromZoom: (double) zoom
{
    id result = [m_dResolutions objectAtIndex:(int)zoom];
    return [result doubleValue];
}

@end
