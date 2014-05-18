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
#import <math.h>

@implementation RMSMTileProjection

@synthesize maxZoom, minZoom;
@synthesize tileSideLength;
@synthesize planetBounds;

-(id) initFromProjection:(RMProjection*)projection tileSideLength:(NSUInteger)aTileSideLength maxZoom: (NSUInteger) aMaxZoom minZoom: (NSUInteger) aMinZoom info:(RMSMLayerInfo*) info resolutions:(NSMutableArray*) dResolutions
{
	if (![super init])
		return nil;
	
    m_pInfo = info;
    
	// We don't care about the rest of the projection... just the bounds is important.
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

- (float) normaliseZoom: (float) zoom
{
	float normalised_zoom = roundf(zoom);
    
	if (normalised_zoom > maxZoom)
		normalised_zoom = maxZoom;
	if (normalised_zoom < minZoom)
		normalised_zoom = minZoom;
	
	return normalised_zoom;
}

- (float) limitFromNormalisedZoom: (float) zoom
{
	return exp2f(zoom);
}

- (RMTile) normaliseTile: (RMTile) tile
{
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

- (RMProjectedPoint) constrainPointHorizontally: (RMProjectedPoint) aPoint
{
	while (aPoint.easting < planetBounds.origin.easting)
		aPoint.easting += planetBounds.size.width;
	while (aPoint.easting > (planetBounds.origin.easting + planetBounds.size.width))
		aPoint.easting -= planetBounds.size.width;
	
	return aPoint;
}

- (RMTilePoint) projectInternal: (RMProjectedPoint)aPoint normalisedZoom:(float)zoom limit:(float) limit
{
	RMTilePoint tile;
	RMProjectedPoint newPoint = [self constrainPointHorizontally:aPoint];
	
    float fMeterPerTile = limit;// * tileSideLength;
    //NSLog(@"limit %f",limit);
    //NSLog(@"tileSideLength %d",tileSideLength);
    //NSLog(@"fmeter %f",fMeterPerTile);
	double x = (newPoint.easting - planetBounds.origin.easting) / fMeterPerTile;
    //NSLog(@"easting %f",newPoint.easting);
    //NSLog(@"planetBounds.origin.easting %f",planetBounds.origin.easting);
    //NSLog(@"x %f",x);
	// Unfortunately, y is indexed from the bottom left.. hence we have to translate it.
	double y = ((planetBounds.origin.northing + planetBounds.size.height - newPoint.northing) / fMeterPerTile);
    //NSLog(@"y %f",y);
	if (y<=-1) {
        tile.tile.y=0;
    }
    else {
        tile.tile.y =(uint32_t)y ;
    }
	tile.tile.x = (uint32_t)x;
	tile.tile.zoom = zoom;
	tile.offset.x = (float)x - tile.tile.x;
	tile.offset.y = (float)y - tile.tile.y;
    //NSLog(@"tile.offset.y :%f",tile.offset.y);

	return tile;
}

- (RMTilePoint) project: (RMProjectedPoint)aPoint atZoom:(float)zoom
{
	float normalised_zoom = [self normaliseZoom:zoom];
	float limit = [self limitFromNormalisedZoom:normalised_zoom];
	
	return [self projectInternal:aPoint normalisedZoom:normalised_zoom limit:limit];
}

- (RMTileRect) projectRect: (RMProjectedRect)aRect atZoom:(float)zoom
{
	/// \bug assignment of float to int, WTF?
	int normalised_zoom = [self normaliseZoom:zoom];
	float limit = [self calculateScaleFromZoom:normalised_zoom] * self.tileSideLength;
    
	RMTileRect tileRect;
	// The origin for projectInternal will have to be the top left instead of the bottom left.
	RMProjectedPoint topLeft = aRect.origin;
	topLeft.northing += aRect.size.height;
	tileRect.origin = [self projectInternal:topLeft normalisedZoom:normalised_zoom limit:limit];
    
    //NSLog(@"width is %f",aRect.size.width);
    //NSLog(@"height is %f",aRect.size.height);
    //NSLog(@"limit is %f",limit);
	tileRect.size.width = aRect.size.width / limit;
	tileRect.size.height = aRect.size.height / limit;
	
	return tileRect;
}

-(RMTilePoint) project: (RMProjectedPoint)aPoint atScale:(float)scale
{
	return [self project:aPoint atZoom:[self calculateZoomFromScale:scale]];
}
-(RMTileRect) projectRect: (RMProjectedRect)aRect atScale:(float)scale
{
	return [self projectRect:aRect atZoom:[self calculateZoomFromScale:scale]];
}

-(RMTileRect) project: (RMMercatorToScreenProjection*)screen;
{
	return [self projectRect:[screen projectedBounds] atScale:[screen metersPerPixel]];
}

-(float) calculateZoomFromScale: (float) scale
{
    int zoom = 0;
    float oldScale;
//    NSLog(@"scale %f",scale);
 //       NSLog(@"%@",m_dResolutions);
    for (id value in m_dResolutions) {
        float fValue = [value floatValue];
//        NSLog(@"fValue %f",fValue);        
        if(zoom == 0)
            oldScale = fValue;
        
        if(fabs(fValue-scale)<0.00000001)
            return zoom;
        
        if(scale>fValue)
        {
            if(zoom == 0)
                return zoom;
            else{
                float d1 = scale - fValue;
                float d2 = oldScale - scale;
                if(d1<d2)
                {
//                    NSLog(@"zoom %d",zoom);
                    return zoom;
                }

                else
                {
//                    NSLog(@"zoom %d",zoom);
                    return zoom;
                }
            }
        }
        zoom++;
        
    }
  //  NSLog(@"zoom %d",zoom);
	return zoom;
}

-(float) calculateNormalisedZoomFromScale: (float) scale
{
	return [self normaliseZoom:[self calculateZoomFromScale:scale]];
}

-(float) calculateScaleFromZoom: (float) zoom
{
    id result = [m_dResolutions objectAtIndex:(int)zoom];
	return [result floatValue];
}

@end
