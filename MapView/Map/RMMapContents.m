//
//  RMMapContents.m
//
// Copyright (c) 2008-2009, Route-Me Contributors
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are met:
//
// * Redistributions of source code must retain the above copyright notice, this
//   list of conditions and the following disclaimer.
// * Redistributions in binary form must reproduce the above copyright notice,
//   this list of conditions and the following disclaimer in the documentation
//   and/or other materials provided with the distribution.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
// ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
// LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
// CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
// SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
// INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
// CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
// ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
// POSSIBILITY OF SUCH DAMAGE.
#import "RMGlobalConstants.h"
#import "RMMapContents.h"

#import "RMMapView.h"

#import "RMFoundation.h"
#import "RMProjection.h"
#import "RMMercatorToScreenProjection.h"
#import "RMMercatorToTileProjection.h"

#import "RMTileSource.h"
#import "RMTileLoader.h"
#import "RMTileImageSet.h"

#import "RMOpenStreetMapSource.h"
#import "RMCoreAnimationRenderer.h"
#import "RMCachedTileSource.h"

#import "RMLayerCollection.h"
#import "RMMarkerManager.h"
#import "SMTianDiTuTileSource.h"

#import "RMMarker.h"

#import "MapView_Prefix.pch"
#import "RMWebTileImage.h"



@interface RMMapContents (PrivateMethods)
- (void)animatedZoomStep:(NSTimer *)timer;
@end

@interface RMMapContents()
{
    BOOL m_bDatasource;
    double m_dTheScreenScale;
    UIView* m_view;
}
@end
@implementation RMMapContents (Internal)
BOOL delegateHasRegionUpdate;
@end

@implementation RMMapContents

@synthesize boundingMask;
@synthesize minZoom;
@synthesize maxZoom;
@synthesize screenScale;
@synthesize markerManager;
@synthesize renderers;
@synthesize redressValue;
@synthesize zoomCenter;
#pragma mark --- begin constants ----
#define kZoomAnimationStepTime 0.03f
#define kZoomAnimationAnimationTime 0.1f
#define kiPhoneMilimeteresPerPixel .1543
#define kZoomRectPixelBuffer 50
#pragma mark --- end constants ----

#pragma mark Initialisation


- (id)initWithView: (UIView*) view
{
    LogMethod();
    
    if(self=[super init]){
        m_bDatasource = NO;
        m_view = view;
    }

    return self;
}


- (id)initWithView: (UIView*) view
        tilesource:(id<RMTileSource>)newTilesource
{
    if(newTilesource){
        m_bDatasource = YES;
    }
    double deviceScale = [UIScreen mainScreen].scale;
    if(deviceScale==3.0)
        m_dTheScreenScale=1.0;
    else
        m_dTheScreenScale=0.85;
    return [self initWithView:view tilesource:newTilesource screenScale:m_dTheScreenScale];
}

-(id)initWithView:(UIView *)view tilesource:(id<RMTileSource>)newTilesource screenScale:(double)theScreenScale
{
    LogMethod();
    if(newTilesource){
        m_bDatasource = YES;
    }
    m_dTheScreenScale = theScreenScale;
    double maximumZoomLevel=[newTilesource numberZoomLevels];
    
    CLLocationCoordinate2D here;
    here.latitude = kDefaultInitialLatitude;
    here.longitude = kDefaultInitialLongitude;
    return [self initWithView:view
                   tilesource:newTilesource
                 centerLatLon:here
                    zoomLevel:kDefaultInitialZoomLevel
                 maxZoomLevel:maximumZoomLevel
                 minZoomLevel:kDefaultMinimumZoomLevel
              backgroundImage:nil
                  screenScale:theScreenScale];
}


- (id)initWithView:(UIView*)newView
        tilesource:(id<RMTileSource>)newTilesource
      centerLatLon:(CLLocationCoordinate2D)initialCenter  ///地图的中心点
         zoomLevel:(double)initialZoomLevel                ///地图初始化时的缩放级别
      maxZoomLevel:(double)maxZoomLevel
      minZoomLevel:(double)minZoomLevel
   backgroundImage:(UIImage *)backgroundImage
       screenScale:(double)theScreenScale                  ///设备的屏幕分辨率的属性值
{
    LogMethod();
    if(newTilesource){
        m_bDatasource = YES;
    }
    if (!newTilesource || ![super init]){
        return nil;
    }
    NSAssert1([newView isKindOfClass:[RMMapView class]], @"view %@ must be a subclass of RMMapView", newView);
    [(RMMapView *)newView setContents:self];
    
    layer = [[newView layer] retain];
    
    earlyTileSources = [NSMutableArray array];
    
    [self performInitializationWithTilesource:newTilesource
                                      mapView:(RMMapView *)newView
                                 centerLatLon:initialCenter
                                    zoomLevel:initialZoomLevel
                                 maxZoomLevel:maxZoomLevel
                                 minZoomLevel:minZoomLevel
                              backgroundImage:backgroundImage
                                  screenScale:(double)theScreenScale];
    return self;
    
    
    
    
}

- (void)performInitializationWithTilesource:(id<RMTileSource>)newTilesource
                                    mapView:(RMMapView*)newView
                               centerLatLon:(CLLocationCoordinate2D)initialCenter  ///地图的中心点
                                  zoomLevel:(double)initialZoomLevel                ///地图初始化时的缩放级别
                               maxZoomLevel:(double)maxZoomLevel
                               minZoomLevel:(double)minZoomLevel
                            backgroundImage:(UIImage *)backgroundImage
                                screenScale:(double)theScreenScale                  ///设备的屏幕分辨率的属性值
{
    
    
    
    ///创建RMTileSourcesContainer
    tileSourcesContainer = [RMTileSourcesContainer new];
    superTileSouceLayer = nil;
    
    projection = nil;
    mercatorToTileProjection = nil;
    
    imagesOnScreens=nil;
    tileLoaders=nil;
    renderers=nil;
    
    screenScale = (theScreenScale == 0.0 ? 1.0 : theScreenScale);
    
    boundingMask = RMMapMinWidthBound;

    
    if ([earlyTileSources count])
    {
        for (id<RMTileSource>earlyTileSource in earlyTileSources)
        {
            if (minZoomLevel < earlyTileSource.minZoom) minZoomLevel = earlyTileSource.minZoom;
            if (maxZoomLevel > earlyTileSource.maxZoom) maxZoomLevel = earlyTileSource.maxZoom;
        }
    }
    else
    {
        if (minZoomLevel < newTilesource.minZoom) minZoomLevel = newTilesource.minZoom;
        if (maxZoomLevel > newTilesource.maxZoom) maxZoomLevel = newTilesource.maxZoom;
    }
    
    [self setMinZoom:minZoomLevel];
    [self setMaxZoom:maxZoomLevel];
    
    
    mercatorToScreenProjection = [[RMMercatorToScreenProjection alloc] initFromProjection:[newTilesource projection] ToScreenBounds:[newView bounds]];
    baseLayeScals=[newTilesource m_dScales];
    [newTilesource setIsBaseLayer:YES];
    
    [self setTileSource:newTilesource];
    projection = [[tileSourcesContainer projection] retain];
    mercatorToTileProjection = [[tileSourcesContainer mercatorToTileProjection] retain];
    
    [mercatorToTileProjection setIsBaseLayer:YES];
    [self setZoom:initialZoomLevel];
    [self moveToLatLong:initialCenter];
    
    [[newTilesource tileLoader]setSuppressLoading:NO];
    
    RMMapLayer *theBackground = [[RMMapLayer alloc] init];
    [self setBackground:theBackground];
    [theBackground release];
    
    RMLayerCollection *theOverlay = [[RMLayerCollection alloc] initForContents:self];
    [self setOverlay:theOverlay];
    [theOverlay release];
    
    markerManager = [[RMMarkerManager alloc] initWithContents:self];
    
    [newView setNeedsDisplay];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleMemoryWarningNotification:)
                                                 name:UIApplicationDidReceiveMemoryWarningNotification
                                               object:nil];
    
    
    
    RMLog(@"Map contents initialised. view: %@ tileSource %@", newView, newTilesource);
    
}


/// deprecated at any moment after release 0.5
/// 发布了版本0.5后，此方法会被弃用
- (id) initForView: (UIView*) view
{
    WarnDeprecated();
    return [self initWithView:view];
}

/// 发布了版本0.5后，此方法会被弃用。
- (id) initForView: (UIView*) view WithLocation:(CLLocationCoordinate2D)latlong
{
    WarnDeprecated();
    LogMethod();
    id<RMTileSource> _tileSource = [[RMOpenStreetMapSource alloc] init];
    RMMapRenderer *_renderer = [[RMCoreAnimationRenderer alloc] initWithContent:self];
    
    id mapContents = [self initForView:view WithTileSource:_tileSource WithRenderer:_renderer LookingAt:latlong];
    [_tileSource release];
    [_renderer release];
    
    return mapContents;
}


///// 发布了版本0.5后，此方法会被弃用。
//- (id) initForView: (UIView*) view WithTileSource: (id<RMTileSource>)_tileSource WithRenderer: (RMMapRenderer*)_renderer LookingAt:(CLLocationCoordinate2D)latlong
//{
//	WarnDeprecated();
//	LogMethod();
//	if (![super init])
//		return nil;
//
//	NSAssert1([view isKindOfClass:[RMMapView class]], @"view %@ must be a subclass of RMMapView", view);
//
//	self.boundingMask = RMMapMinWidthBound;
////	targetView = view;
//	mercatorToScreenProjection = [[RMMercatorToScreenProjection alloc] initFromProjection:[_tileSource projection] ToScreenBounds:[view bounds]];
//
//	tileSource = nil;
//	projection = nil;
//	mercatorToTileProjection = nil;
//
//	renderer = nil;
//	imagesOnScreen = nil;
//	tileLoader = nil;
//
//	layer = [[view layer] retain];
//
//	[self setTileSource:_tileSource];
//	[self setRenderer:_renderer];
//
//	imagesOnScreen = [[RMTileImageSet alloc] initWithDelegate:renderer];
//	[imagesOnScreen setTileSource:tileSource];
//
//	tileLoader = [[RMTileLoader alloc] initWithContent:self];
//	[tileLoader setSuppressLoading:YES];
//
//	[self setMinZoom:kDefaultMinimumZoomLevel];
//	[self setMaxZoom:kDefaultMaximumZoomLevel];
//	[self setZoom:kDefaultInitialZoomLevel];
//
//	[self moveToLatLong:latlong];
//
//	[tileLoader setSuppressLoading:NO];
//
//	/// \bug TODO: Make a nice background class
//	RMMapLayer *theBackground = [[RMMapLayer alloc] init];
//	[self setBackground:theBackground];
//	[theBackground release];
//
//	RMLayerCollection *theOverlay = [[RMLayerCollection alloc] initForContents:self];
//	[self setOverlay:theOverlay];
//	[theOverlay release];
//
//	markerManager = [[RMMarkerManager alloc] initWithContents:self];
//
//	[view setNeedsDisplay];
//	[[NSNotificationCenter defaultCenter] addObserver:self
//											 selector:@selector(handleMemoryWarningNotification:)
//												 name:UIApplicationDidReceiveMemoryWarningNotification
//											   object:nil];
//
//	RMLog(@"Map contents initialised. view: %@ tileSource %@ renderer %@", view, tileSource, renderer);
//
//	return self;
//}

- (void)setFrame:(CGRect)frame
{
    CGRect bounds = CGRectMake(0, 0, frame.size.width, frame.size.height);
    [mercatorToScreenProjection setScreenBounds:bounds];
    background.frame = bounds;
    layer.frame = frame;
    overlay.frame = bounds;
    
    if (tileLoaders&&[tileLoaders count]>0) {
        for(RMTileLoader* tileLoader in tileLoaders)
        {
            [tileLoader clearLoadedBounds];
            [tileLoader updateLoadedImages];
        }
    }
    
    if (renderers&&[renderers count]>0) {
        for(RMMapRenderer* renderer in renderers)
        {
            [renderer setFrame:frame];
        }
    }
    
    [overlay correctPositionOfAllSublayers];
}

-(void) dealloc
{
    LogMethod();
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    if (imagesOnScreens&&[imagesOnScreens count]>0) {
        for(RMTileImageSet* imagesOnScreen in imagesOnScreens)
        {
            [imagesOnScreen cancelLoading];
        }
    }
    
    [renderers release];
    [imagesOnScreens release];
    [tileLoaders release];
    [projection release];
    [mercatorToTileProjection release];
    [mercatorToScreenProjection release];
    [[tileSourcesContainer tileSources] release];
    [self setOverlay:nil];
    [self setBackground:nil];
    [layer release];
    [markerManager release];
    [super dealloc];
}

- (void)handleMemoryWarningNotification:(NSNotification *)notification
{
    [self didReceiveMemoryWarning];
}

//- (void) didReceiveMemoryWarning
//{
//	LogMethod();
//	[tileSource didReceiveMemoryWarning];
//}


#pragma mark Forwarded Events

- (void)moveToLatLong: (CLLocationCoordinate2D)latlong
{
    //RMProjectedPoint aPoint;
    //aPoint.easting = latlong.longitude;
    //aPoint.northing = latlong.latitude;
    RMProjectedPoint aPoint = [[self projection] latLongToPoint:latlong];
    
    
    
    [self moveToProjectedPoint: aPoint];
}
- (void)moveToProjectedPoint: (RMProjectedPoint)aPoint
{
    self.centerProjectedPoint = aPoint;
}

- (void)moveBy: (CGSize) delta
{
    [mercatorToScreenProjection moveScreenBy:delta];
    
    if (imagesOnScreens&&[imagesOnScreens count]>0) {
        for(RMTileImageSet* imagesOnScreen in imagesOnScreens)
        {
            [imagesOnScreen moveBy:delta];
        }
    }
    if (tileLoaders&&[tileLoaders count]>0) {
//        for(int i=0;i<1;i++){
//            [tileLoaders[i] moveBy:delta];
//        }
        for(RMTileLoader* tileLoader in tileLoaders)
        {
            [tileLoader moveBy:delta];
        }
    }
    
    
    [overlay moveBy:delta];
    [overlay correctPositionOfAllSublayers];
    if (renderers&&[renderers count]>0) {
        for(RMMapRenderer* renderer in renderers)
        {
            [renderer setNeedsDisplay];
        }
    }
    
}

/// \bug doesn't really adjust anything, just makes a computation. CLANG flags some dead assignments (write-only variables)
- (double)adjustZoomForBoundingMask:(double)zoomFactor
{
    if ( boundingMask ==  RMMapNoMinBound )
        return zoomFactor;
    
    double newMPP = self.metersPerPixel / zoomFactor;
    
    RMProjectedRect mercatorBounds = [[tileSourcesContainer projection] planetBounds];
    
    // Check for MinWidthBound
    if ( boundingMask & RMMapMinWidthBound )
    {
        double newMapContentsWidth = mercatorBounds.size.width / newMPP;
        double screenBoundsWidth = [self screenBounds].size.width;
        double mapContentWidth;
        
        if ( newMapContentsWidth < screenBoundsWidth )
        {
            // Calculate new zoom facter so that it does not shrink the map any further.
            mapContentWidth = mercatorBounds.size.width / self.metersPerPixel;
            zoomFactor = screenBoundsWidth / mapContentWidth;
            
            //newMPP = self.metersPerPixel / zoomFactor;
            //newMapContentsWidth = mercatorBounds.size.width / newMPP;
        }
        
    }
    
    // Check for MinHeightBound
    if ( boundingMask & RMMapMinHeightBound )
    {
        double newMapContentsHeight = mercatorBounds.size.height / newMPP;
        double screenBoundsHeight = [self screenBounds].size.height;
        double mapContentHeight;
        
        if ( newMapContentsHeight < screenBoundsHeight )
        {
            // Calculate new zoom facter so that it does not shrink the map any further.
            mapContentHeight = mercatorBounds.size.height / self.metersPerPixel;
            zoomFactor = screenBoundsHeight / mapContentHeight;
            
            //newMPP = self.metersPerPixel / zoomFactor;
            //newMapContentsHeight = mercatorBounds.size.height / newMPP;
        }
        
    }
    
    //[self adjustMapPlacementWithScale:newMPP];
    
    return zoomFactor;
}

/// This currently is not called because it does not handle the case when the map is continous or not continous.  At a certain scale
/// you can continuously move to the west or east until you get to a certain scale level that simply shows the entire world.
/// 此方法目前未真正实现
- (void)adjustMapPlacementWithScale:(double)aScale
{
    CGSize		adjustmentDelta = {0.0, 0.0};
    RMLatLong	rightEdgeLatLong = {0, kMaxLong};
    RMLatLong	leftEdgeLatLong = {0,- kMaxLong};
    
    CGPoint		rightEdge = [self latLongToPixel:rightEdgeLatLong withMetersPerPixel:aScale];
    CGPoint		leftEdge = [self latLongToPixel:leftEdgeLatLong withMetersPerPixel:aScale];
    //CGPoint		topEdge = [self latLongToPixel:myLatLong withMetersPerPixel:aScale];
    //CGPoint		bottomEdge = [self latLongToPixel:myLatLong withMetersPerPixel:aScale];
    
    CGRect		containerBounds = [self screenBounds];
    
    if ( rightEdge.x < containerBounds.size.width )
    {
        adjustmentDelta.width = containerBounds.size.width - rightEdge.x;
        [self moveBy:adjustmentDelta];
    }
    
    if ( leftEdge.x > containerBounds.origin.x )
    {
        adjustmentDelta.width = containerBounds.origin.x - leftEdge.x;
        [self moveBy:adjustmentDelta];
    }
    
    
}

/// \bug this is a no-op, not a clamp, if new zoom would be outside of minzoom/maxzoom range
- (void)zoomByFactor: (double) zoomFactor near:(CGPoint) pivot
{
    //[self zoomByFactor:zoomFactor near:pivot animated:NO];
    
    zoomFactor = [self adjustZoomForBoundingMask:zoomFactor];
    //RMLog(@"Zoom Factor: %lf for Zoom:%f", zoomFactor, [self zoom]);
    
    // pre-calculate zoom so we can tell if we want to perform it
    double newZoom = [mercatorToTileProjection
                     calculateZoomFromScale:self.metersPerPixel/zoomFactor];
    
    if ((newZoom > minZoom) && (newZoom < maxZoom))
    {
        [mercatorToScreenProjection zoomScreenByFactor:zoomFactor near:pivot];
        if (imagesOnScreens&&[imagesOnScreens count]>0) {
            for(RMTileImageSet* imagesOnScreen in imagesOnScreens)
            {
                [imagesOnScreen zoomByFactor:zoomFactor near:pivot];
            }
        }
        if (tileLoaders&&[tileLoaders count]>0) {
            for(RMTileLoader* tileLoader in tileLoaders)
            {
                [tileLoader zoomByFactor:zoomFactor near:pivot];
            }
        }
        
        [overlay zoomByFactor:zoomFactor near:pivot];
        [overlay correctPositionOfAllSublayers];
        
        if (renderers&&[renderers count]>0) {
            for(RMMapRenderer* renderer in renderers)
            {
                [renderer setNeedsDisplay];            }
        }
        
    }
}


- (void)zoomByFactor: (double) zoomFactor near:(CGPoint) pivot animated:(BOOL) animated
{
    [self zoomByFactor:zoomFactor near:pivot animated:animated withCallback:nil];
}

- (BOOL)shouldZoomToTargetZoom:(double)targetZoom withZoomFactor:(double)zoomFactor {
    //bools for syntactical sugar to understand the logic in the if statement below
    BOOL zoomAtMax = ([self zoom] == [self maxZoom]);
    BOOL zoomAtMin = ([self zoom] == [self minZoom]);
    BOOL zoomGreaterMin = ([self zoom] > [self minZoom]);
    BOOL zoomLessMax = ([self zoom] < [self maxZoom]);
    
    //zooming in zoomFactor > 1
    //zooming out zoomFactor < 1
    
    if ((zoomGreaterMin && zoomLessMax) || (zoomAtMax && zoomFactor<1) || (zoomAtMin && zoomFactor>1))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

- (void)zoomByFactor: (double) zoomFactor near:(CGPoint) pivot animated:(BOOL) animated withCallback:(id<RMMapContentsAnimationCallback>)callback
{
    zoomFactor = [self adjustZoomForBoundingMask:zoomFactor];
    double zoomDelta = log2f(zoomFactor);
    double targetZoom = zoomDelta + [self zoom];
    
    //NSLog(@"zoomdelta:%f,zoom:%f,target:%f",zoomDelta,[self zoom],targetZoom);
    if (targetZoom == [self zoom]){
        return;
    }
    // clamp zoom to remain below or equal to maxZoom after zoomAfter will be applied
    // Set targetZoom to maxZoom so the map zooms to its maximum
    if(targetZoom > [self maxZoom]){
        zoomFactor = exp2f([self maxZoom] - [self zoom]);
        targetZoom = [self maxZoom];
    }
    
    //NSLog(@"zoomdelta:%f,zoom:%f,target:%f",zoomDelta,[self zoom],targetZoom);
    
    // clamp zoom to remain above or equal to minZoom after zoomAfter will be applied
    // Set targetZoom to minZoom so the map zooms to its maximum
    if(targetZoom < [self minZoom]){
        zoomFactor = 1/exp2f([self zoom] - [self minZoom]);
        targetZoom = [self minZoom];
    }
    
    //NSLog(@"zoomdelta:%f,zoom:%f,target:%f",zoomDelta,[self zoom],targetZoom);
    
    if ([self shouldZoomToTargetZoom:targetZoom withZoomFactor:zoomFactor])
    {
        if (animated)
        {
            // goal is to complete the animation in animTime seconds
            double nSteps = round(kZoomAnimationAnimationTime / kZoomAnimationStepTime);
            double zoomIncr = zoomDelta / nSteps;
            
            NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                                      [NSNumber numberWithDouble:zoomIncr], @"zoomIncr",
                                      [NSNumber numberWithDouble:targetZoom], @"targetZoom",
                                      [NSValue valueWithCGPoint:pivot], @"pivot",
                                      [NSNumber numberWithDouble:zoomFactor], @"factor",
                                      callback, @"callback", nil];
            [NSTimer scheduledTimerWithTimeInterval:kZoomAnimationStepTime
                                             target:self
                                           selector:@selector(animatedZoomStep:)
                                           userInfo:userInfo
                                            repeats:YES];
        }
        else
        {
            [mercatorToScreenProjection zoomScreenByFactor:zoomFactor near:pivot];
            if (imagesOnScreens&&[imagesOnScreens count]>0) {
                for(RMTileImageSet* imagesOnScreen in imagesOnScreens)
                {
                    [imagesOnScreen zoomByFactor:zoomFactor near:pivot];
                }
            }
            if (tileLoaders&&[tileLoaders count]>0) {
                for(RMTileLoader* tileLoader in tileLoaders)
                {
                    [tileLoader zoomByFactor:zoomFactor near:pivot];
                }
            }
            
            [overlay zoomByFactor:zoomFactor near:pivot];
            [overlay correctPositionOfAllSublayers];
            
            if (renderers&&[renderers count]>0) {
                for(RMMapRenderer* renderer in renderers)
                {
                    [renderer setNeedsDisplay];
                }
            }
        }
    }
    else
    {
        if([self zoom] > [self maxZoom])
            [self setZoom:[self maxZoom]];
        if([self zoom] < [self minZoom])
            [self setZoom:[self minZoom]];
    }
}

/// \bug magic strings embedded in code
- (void)animatedZoomStep:(NSTimer *)timer
{
    double zoomIncr = [[[timer userInfo] objectForKey:@"zoomIncr"] doubleValue];
    double targetZoom = [[[timer userInfo] objectForKey:@"targetZoom"] doubleValue];
    
    NSDictionary *userInfo = [[[timer userInfo] retain] autorelease];
    id<RMMapContentsAnimationCallback> callback = [userInfo objectForKey:@"callback"];
    
    //NSLog(@"zoomIncr:%f,zoom:%f,targetzoom:%f\n",zoomIncr,[self zoom],targetZoom);
    
    if ((zoomIncr > 0 && [self zoom] >= targetZoom-1.0e-6) || (zoomIncr < 0 && [self zoom] <= targetZoom+1.0e-6))
    {
        if ( [self zoom] != targetZoom ) [self setZoom:targetZoom];
        [timer invalidate];	// ASAP
        if ([callback respondsToSelector:@selector(animationFinishedWithZoomFactor:near:)])
        {
            [callback animationFinishedWithZoomFactor:[[userInfo objectForKey:@"factor"] doubleValue] near:[[userInfo objectForKey:@"pivot"] CGPointValue]];
        }
    }
    else
    {
        double zoomFactorStep = exp2f(zoomIncr);
        [self zoomByFactor:zoomFactorStep near:[[[timer userInfo] objectForKey:@"pivot"] CGPointValue] animated:NO];
        if ([callback respondsToSelector:@selector(animationStepped)])
        {
            [callback animationStepped];
        }
    }
}


- (void)zoomInToNextNativeZoomAt:(CGPoint) pivot
{
    [self zoomInToNextNativeZoomAt:pivot animated:NO];
}

- (double)nextNativeZoomFactor
{
    double newZoom = fmin(floorf([self zoom] + 1.0), [self maxZoom]);
    return exp2f(newZoom - [self zoom]);
}

- (double)prevNativeZoomFactor
{
    double newZoom = fmax(floorf([self zoom] - 1.0), [self minZoom]);
    return exp2f(newZoom - [self zoom]);
}

/// \deprecated appears to be unused
- (void)zoomInToNextNativeZoomAt:(CGPoint) pivot animated:(BOOL) animated
{
    // Calculate rounded zoom
    double newZoom = fmin(floorf([self zoom] + 1.0), [self maxZoom]);
//    RMLog(@"[self minZoom] %f [self zoom] %f [self maxZoom] %f newzoom %f", [self minZoom], [self zoom], [self maxZoom], newZoom);
    
    double factor = exp2f(newZoom - [self zoom]);
    [self zoomByFactor:factor near:pivot animated:animated];
}

/// \deprecated appears to be unused except by zoomOutToNextNativeZoomAt:
- (void)zoomOutToNextNativeZoomAt:(CGPoint) pivot animated:(BOOL) animated {
    // Calculate rounded zoom
    double newZoom = fmax(ceilf([self zoom] - 1.0), [self minZoom]);
//    RMLog(@"[self minZoom] %f [self zoom] %f [self maxZoom] %f newzoom %f", [self minZoom], [self zoom], [self maxZoom], newZoom);
    
    double factor = exp2f(newZoom - [self zoom]);
    [self zoomByFactor:factor near:pivot animated:animated];
}

/// \deprecated appears to be unused
- (void)zoomOutToNextNativeZoomAt:(CGPoint) pivot {
    [self zoomOutToNextNativeZoomAt: pivot animated: FALSE];
}


- (void) drawRect: (CGRect) aRect
{
    if (renderers&&[renderers count]>0) {
        for(RMMapRenderer* renderer in renderers)
        {
            [renderer drawRect:aRect];
        }
    }
    
}
//
//-(void)removeAllCachedImages
//{
//	[tileSource removeAllCachedImages];
//}


#pragma mark Properties

//- (id<RMTileSource>) tileSource
//{
//	return [[tileSource retain] autorelease];
//}

- (void) setRenderer: (RMMapRenderer*) newRenderer withTileSource:(id<RMTileSource>) tileSource atIndex:(NSInteger)index
{
    
    RMTileImageSet *imagesOnScreen=[[RMTileImageSet alloc] initWithDelegate:newRenderer];
    [imagesOnScreen setTileSource:tileSource];
    
    RMTileLoader *tileLoader=[[RMTileLoader alloc] initWithContent:self tileSouce:tileSource];
    [tileLoader reset];
    [tileLoader reload];
    
    
    [[newRenderer layer] removeFromSuperlayer];
    
    if (newRenderer == nil)
        return;
    [tileSource setImagesOnScreen:imagesOnScreen];
    [tileSource setTileLoader:tileLoader];
    [tileSource setRenderer:newRenderer];
    
    [imagesOnScreens insertObject:imagesOnScreen atIndex:index];
    [tileLoaders insertObject:tileLoader atIndex:index];
    [renderers insertObject:newRenderer atIndex:index];
    //	CGRect rect = [self screenBounds];
    //	RMLog(@"%f %f %f %f", rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);
    // [[newRenderer layer] setFrame:[self screenBounds]];
   // [superTileSouceLayer addSublayer:[newRenderer layer]];
    [superTileSouceLayer insertSublayer:[newRenderer layer] atIndex:index];
    [tileLoader setSuppressLoading:YES];
}

//- (RMMapRenderer *)renderer
//{
//    //return [[renderer retain] autorelease];
//}

- (void) setBackground: (RMMapLayer*) aLayer
{
    if (background == aLayer) return;
    
    if (background != nil)
    {
        [background release];
        [background removeFromSuperlayer];
    }
    
    background = [aLayer retain];
    
    if (background == nil)
        return;
    
    background.frame = [self screenBounds];
    
    if (superTileSouceLayer != nil)
        [layer insertSublayer:background below:superTileSouceLayer];
    else if (overlay != nil)
        [layer insertSublayer:background below:overlay];
    else
        [layer insertSublayer:superTileSouceLayer atIndex: 0];
}

- (RMMapLayer *)background
{
    return [[background retain] autorelease];
}

- (void) setOverlay: (RMLayerCollection*) aLayer
{
    if (overlay == aLayer) return;
    
    if (overlay != nil)
    {
        [overlay release];
        [overlay removeFromSuperlayer];
    }
    
    overlay = [aLayer retain];
    
    if (overlay == nil)
        return;
    
    overlay.frame = [self screenBounds];
    
    if (superTileSouceLayer != nil)
        [layer insertSublayer:overlay above:superTileSouceLayer];
    else if (background != nil)
        [layer insertSublayer:overlay above:background];
    else
        [layer insertSublayer:superTileSouceLayer atIndex: 0];
    
    /* Test to make sure the overlay is working.
     CALayer *testLayer = [[CALayer alloc] init];
     
     [testLayer setFrame:CGRectMake(100, 100, 200, 200)];
     [testLayer setBackgroundColor:[[UIColor brownColor] CGColor]];
     
     RMLog(@"added test layer");
     [overlay addSublayer:testLayer];*/
}

- (RMLayerCollection *)overlay
{
    return [[overlay retain] autorelease];
}

- (CLLocationCoordinate2D) mapCenter
{
    RMProjectedPoint aPoint = [mercatorToScreenProjection projectedCenter];
    return [projection pointToLatLong:aPoint];
}

-(void) setMapCenter: (CLLocationCoordinate2D) center
{
    [self moveToLatLong:center];
}

- (RMProjectedPoint)centerProjectedPoint
{
    return [mercatorToScreenProjection projectedCenter];
}

- (void)setCenterProjectedPoint:(RMProjectedPoint)projectedPoint
{
    [[RMWebTileImage getInstanceQueue] cancelAllOperations];
    [mercatorToScreenProjection setProjectedCenter:projectedPoint];
    [overlay correctPositionOfAllSublayers];
    
    if (tileLoaders&&[tileLoaders count]>0) {
        for(RMTileLoader* tileLoader in tileLoaders)
        {
            [tileLoader reload];
        }
    }
    if (renderers&&[renderers count]>0) {
        for(RMMapRenderer* renderer in renderers)
        {
            [renderer setNeedsDisplay];
        }
    }
    [overlay setNeedsDisplay];
}

-(RMProjectedRect) projectedBounds
{
    return [mercatorToScreenProjection projectedBounds];
}
-(void) setProjectedBounds: (RMProjectedRect) boundsRect
{
    [mercatorToScreenProjection setProjectedBounds:boundsRect];
}

-(RMTileRect) tileBounds
{   //返回当前级别下地图的地理原点及切片x,y的个数 ，但对于叠加图层planetBounds 范围有错
    return [mercatorToTileProjection projectRect:[mercatorToScreenProjection projectedBounds]
                                         atScale:[self scaledMetersPerPixel]];
}

-(CGRect) screenBounds
{
    if (mercatorToScreenProjection != nil)
        return [mercatorToScreenProjection screenBounds];
    else
        return CGRectZero;
}

-(double) metersPerPixel
{
    return [mercatorToScreenProjection metersPerPixel];
}

-(void) setMetersPerPixel: (double) newMPP povot:(CGPoint)pivot{
    double zoomFactor = self.metersPerPixel / newMPP;
    // 缩放等级发生改变，清空请求队列
    [[RMWebTileImage getInstanceQueue] cancelAllOperations];
    [mercatorToScreenProjection setMetersPerPixel:newMPP];
    
    if (imagesOnScreens&&[imagesOnScreens count]>0) {
        for(RMTileImageSet* imagesOnScreen in imagesOnScreens)
        {
            [imagesOnScreen zoomByFactor:zoomFactor near:pivot];
        }
    }
    //return;
    if (tileLoaders&&[tileLoaders count]>0) {
        for(RMTileLoader* tileLoader in tileLoaders)
        {
            [tileLoader zoomByFactor:zoomFactor near:pivot];
        }
    }
    
    [overlay zoomByFactor:zoomFactor near:pivot];
    [overlay correctPositionOfAllSublayers];
    
    if (renderers&&[renderers count]>0) {
        for(RMMapRenderer* renderer in renderers)
        {
            [renderer setNeedsDisplay];
        }
    }
}
-(void) setMetersPerPixel: (double) newMPP
{
    CGPoint pivot = CGPointZero;
    [self setMetersPerPixel:newMPP povot:pivot];
}

-(double) scaledMetersPerPixel
{
    return [mercatorToScreenProjection metersPerPixel] / screenScale;
}

- (void)setScaledMetersPerPixel:(double)newMPP {
    [self setMetersPerPixel:newMPP * screenScale];
}

-(void)setMaxZoom:(double)newMaxZoom
{
    maxZoom = newMaxZoom;
}

-(void)setMinZoom:(double)newMinZoom
{
    minZoom = newMinZoom;
    ////
    // NSAssert(!tileSource || (([tileSource minZoom] - minZoom) <= 1.0), @"Graphics & memory are overly taxed if [contents minZoom] is more than 1.5 smaller than [tileSource minZoom]");
}

-(double) zoom
{
    return [mercatorToTileProjection calculateZoomFromScale:[self scaledMetersPerPixel]];
}
/*
 -(double) numberZoomLevel
 {
 // NSLog(@"OK");
 return [tileSource numberZoomLevel];
 }
 
 */
/// if #zoom is outside of range #minZoom to #maxZoom, zoom level is clamped to that range.
-(void) setZoom: (double) zoom
{
    zoom = (zoom > maxZoom) ? maxZoom : zoom;
    zoom = (zoom < minZoom) ? minZoom : zoom;
    
    double scale = [mercatorToTileProjection calculateScaleFromZoom:zoom];
   
    [self setScaledMetersPerPixel:scale];
}

static NSUInteger oldZoom;
-(void) setZoom2: (NSUInteger) zoom{
    
   
   
    
    if(oldZoom==zoom)
        return;
    zoom = (zoom > maxZoom) ? maxZoom : zoom;
    zoom = (zoom < minZoom) ? minZoom : zoom;
    oldZoom = zoom;
   // NSLog(@"~~~~~zoom %i",zoom);
    double scale = [mercatorToTileProjection calculateScaleFromZoom:zoom];
    [self setMetersPerPixel:scale*screenScale povot:self.zoomCenter];
    
}
//-(RMTileImageSet*) imagesOnScreen
//{
//	return [[imagesOnScreen retain] autorelease];
//}
//
//-(RMTileLoader*) tileLoader
//{
//	return [[tileLoader retain] autorelease];
//}

-(RMProjection*) projection
{
    return [[projection retain] autorelease];
}
-(id<RMMercatorToTileProjection>) mercatorToTileProjection
{
    return [[mercatorToTileProjection retain] autorelease];
}
-(RMMercatorToScreenProjection*) mercatorToScreenProjection
{
    return [[mercatorToScreenProjection retain] autorelease];
}

- (CALayer *)layer
{
    return [[layer retain] autorelease];
}

static BOOL _performExpensiveOperations = YES;
+ (BOOL) performExpensiveOperations
{
    return _performExpensiveOperations;
}
+ (void) setPerformExpensiveOperations: (BOOL)p
{
    if (p == _performExpensiveOperations)
        return;
    
    _performExpensiveOperations = p;
    
    if (p)
        [[NSNotificationCenter defaultCenter] postNotificationName:RMResumeExpensiveOperations object:self];
    else
        [[NSNotificationCenter defaultCenter] postNotificationName:RMSuspendExpensiveOperations object:self];
}

#pragma mark LatLng/Pixel translation functions

- (CGPoint)latLongToPixel:(CLLocationCoordinate2D)latlong
{
    return [mercatorToScreenProjection projectXYPoint:[projection latLongToPoint:latlong]];
}


- (RMProjectedPoint)latLongToProjectedPoint:(CLLocationCoordinate2D)latlong
{
    return [projection latLongToPoint:latlong];
}

- (CLLocationCoordinate2D)projectedPointToLatLong:(RMProjectedPoint)projectedPoint
{
    return [projection pointToLatLong:projectedPoint];
}

- (CGPoint)latLongToPixel:(CLLocationCoordinate2D)latlong withMetersPerPixel:(double)aScale
{
    return [mercatorToScreenProjection projectXYPoint:[projection latLongToPoint:latlong] withMetersPerPixel:aScale];
}

- (RMTilePoint)latLongToTilePoint:(CLLocationCoordinate2D)latlong withMetersPerPixel:(double)aScale
{
    return [mercatorToTileProjection project:[projection latLongToPoint:latlong] atZoom:aScale];
}

- (CLLocationCoordinate2D)pixelToLatLong:(CGPoint)aPixel
{
    return [projection pointToLatLong:[mercatorToScreenProjection projectScreenPointToXY:aPixel]];
}

- (RMProjectedPoint)pixelToProjectedPoint:(CGPoint)aPixel
{
    return [mercatorToScreenProjection projectScreenPointToXY:aPixel];
}

- (CLLocationCoordinate2D)pixelToLatLong:(CGPoint)aPixel withMetersPerPixel:(double)aScale
{
    return [projection pointToLatLong:[mercatorToScreenProjection projectScreenPointToXY:aPixel withMetersPerPixel:aScale]];
}

- (double)scaleDenominator {
    double routemeMetersPerPixel = [self metersPerPixel];
    double iphoneMillimetersPerPixel = kiPhoneMilimeteresPerPixel;
    double truescaleDenominator =  routemeMetersPerPixel / (0.001 * iphoneMillimetersPerPixel) ;
    return truescaleDenominator;
}

#pragma mark Zoom With Bounds
- (void)zoomWithLatLngBoundsNorthEast:(CLLocationCoordinate2D)ne SouthWest:(CLLocationCoordinate2D)sw
{
    if(ne.latitude == sw.latitude && ne.longitude == sw.longitude)//There are no bounds, probably only one marker.
    {
        RMProjectedRect zoomRect;
        RMProjectedPoint myOrigin = [projection latLongToPoint:sw];
        //Default is with scale = 2.0 mercators/pixel
        
        zoomRect.size.width = [self screenBounds].size.width * 2.0;
        zoomRect.size.height = [self screenBounds].size.height * 2.0;
        
        
        
        myOrigin.easting = myOrigin.easting - (zoomRect.size.width / 2);
        myOrigin.northing = myOrigin.northing - (zoomRect.size.height / 2);
        
        zoomRect.origin = myOrigin;
        [self zoomWithRMMercatorRectBounds:zoomRect];
    }
    else
    {
        //convert ne/sw into RMMercatorRect and call zoomWithBounds
        double pixelBuffer = kZoomRectPixelBuffer;
        CLLocationCoordinate2D midpoint = {
            .latitude = (ne.latitude + sw.latitude) / 2,
            .longitude = (ne.longitude + sw.longitude) / 2
        };
        RMProjectedPoint myOrigin = [projection latLongToPoint:midpoint];
        RMProjectedPoint nePoint = [projection latLongToPoint:ne];
        RMProjectedPoint swPoint = [projection latLongToPoint:sw];
        RMProjectedPoint myPoint = {.easting = nePoint.easting - swPoint.easting, .northing = nePoint.northing - swPoint.northing};
        //Create the new zoom layout
        RMProjectedRect zoomRect;
        //Default is with scale = 2.0 mercators/pixel
        zoomRect.size.width = [self screenBounds].size.width * 2.0;
        zoomRect.size.height = [self screenBounds].size.height * 2.0;
        if((myPoint.easting / ([self screenBounds].size.width)) < (myPoint.northing / ([self screenBounds].size.height)))
        {
            if((myPoint.northing / ([self screenBounds].size.height - pixelBuffer)) > 1)
            {
                zoomRect.size.width = [self screenBounds].size.width * (myPoint.northing / ([self screenBounds].size.height - pixelBuffer));
                zoomRect.size.height = [self screenBounds].size.height * (myPoint.northing / ([self screenBounds].size.height - pixelBuffer));
            }
        }
        else
        {
            if((myPoint.easting / ([self screenBounds].size.width - pixelBuffer)) > 1)
            {
                zoomRect.size.width = [self screenBounds].size.width * (myPoint.easting / ([self screenBounds].size.width - pixelBuffer));
                zoomRect.size.height = [self screenBounds].size.height * (myPoint.easting / ([self screenBounds].size.width - pixelBuffer));
            }
        }

        /*It gets all messed up if our origin is lower than the lowest place on the map, so we check.
         if(myOrigin.northing < -19971868.880409)
         {
         myOrigin.northing = -19971868.880409;
         }*/

        zoomRect.origin = myOrigin;

        double scaleX = myPoint.easting / [self screenBounds].size.width;
        double scaleY = myPoint.northing / [self screenBounds].size.height;
        
        // 平均比例尺.
        double fixScale = (scaleX + scaleY) /2;
//        [self setScaledMetersPerPixel:fixScale * self.metersPerPixel];
//        [self setScaledMetersPerPixel:fixScale ];
//        [self setCenterProjectedPoint:zoomRect.origin];
        
        // 设置地图的中心的
        [mercatorToScreenProjection setProjectedCenter:zoomRect.origin];
        [self setMetersPerPixel:fixScale];
    }
}

- (void)zoomWithRMMercatorRectBounds:(RMProjectedRect)bounds
{
//    [self setProjectedBounds:bounds];
    
    
    double scaleX = bounds.size.width / [self screenBounds].size.width;
    double scaleY = bounds.size.height / [self screenBounds].size.height;
   
    // I will pick a scale in between those two.
  
    [self setScaledMetersPerPixel:(scaleX + scaleY) / 2];
    bounds.origin.easting = -116;
    bounds.origin.northing = 39;
    [self setCenterProjectedPoint:bounds.origin];
    
    
    [overlay correctPositionOfAllSublayers];
    
    // 地图刷新
    if (tileLoaders&&[tileLoaders count]>0) {
        for(RMTileLoader* tileLoader in tileLoaders)
        {
            [tileLoader clearLoadedBounds];
            [tileLoader updateLoadedImages];
        }
    }
    
    if (renderers&&[renderers count]>0) {
        for(RMMapRenderer* renderer in renderers)
        {
            [renderer setNeedsDisplay];
        }
    }
    
    
}
-(void)refreshMap{
    
    for (id<RMTileSource> tileSources in [tileSourcesContainer tileSources]) {
        [tileSources setIsUseCache:NO];
    }
    [overlay correctPositionOfAllSublayers];
    
    // 地图刷新TILE
    if (tileLoaders&&[tileLoaders count]>0) {
        for(RMTileLoader* tileLoader in tileLoaders)
        {
            [tileLoader clearLoadedBounds];
            [tileLoader updateLoadedImages];
        }
    }
    
    if (renderers&&[renderers count]>0) {
        for(RMMapRenderer* renderer in renderers)
        {
            [renderer setNeedsDisplay];
        }
    }
}

- (void)setLayerID:(NSString *) layerID forTileSource:(id <RMTileSource>)tileSource{
    RMSMTileSource *smTileSource = tileSource;
    // 如果启用tempLayer，则必须通过修改tempLayer的属性来控制图层的显示和隐藏
    if ([smTileSource.m_Info isUseDisplayFilter]) {
        [self setTempLayerID:layerID forTileSource:smTileSource];
        return;
    }
    // 设置为不使用本地缓存
    [smTileSource setIsUseCache:NO];
    
    [smTileSource.m_Info.urlParam setObject:[NSString stringWithFormat:@"%@",layerID] forKey:@"layersID"];
    [smTileSource.m_Info initStrParams:smTileSource.m_Info.urlParam];
    
    //    delegateHasRegionUpdate = true;
    [[tileSource tileLoader] updateLoadedImages];
}
 ///  [1,2,3]
- (void)setLayerID:(NSString *) layerID forTileSourceAtIndex:(NSUInteger)index{
    if (index >= [[tileSourcesContainer tileSources] count]){
        NSLog(@"Index is out of bounds...");
        return;
    }
    [self setLayerID:layerID forTileSource:[[tileSourcesContainer tileSources] objectAtIndex:index]];
}

- (void)setTempLayerID:(NSString *) layerID  forTileSource:(id<RMTileSource>)tileSource{
    RMSMTileSource *smTileSource =tileSource;
    // 后台执行图层控制请求
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        BOOL result = [smTileSource.m_Info setTempLayer:layerID];
        if (result) {
            dispatch_async(dispatch_get_main_queue(), ^{
                // 设置为不使用本地缓存
                [smTileSource setIsUseCache:NO];
                [[tileSource tileLoader] updateLoadedImages];
            });
        }
    });
}
/*
- (void)setTempLayerID:(NSString *) layerID forTileSourceAtIndex:(NSUInteger)index{
    if (index >= [[tileSourcesContainer tileSources] count]){
        NSLog(@"Index is out of bounds...");
        return;
    }
    [self setTempLayerID:layerID  forTileSource:[[tileSourcesContainer tileSources] objectAtIndex:index]];
}
*/
#pragma mark Markers and overlays

// Move overlays stuff here - at the moment overlay stuff is above...

- (RMSphericalTrapezium) latitudeLongitudeBoundingBoxForScreen
{
    CGRect rect = [mercatorToScreenProjection screenBounds];
    
    return [self latitudeLongitudeBoundingBoxFor:rect];
}

- (RMSphericalTrapezium) latitudeLongitudeBoundingBoxFor:(CGRect) rect
{
    RMSphericalTrapezium boundingBox;
    CGPoint northwestScreen = rect.origin;
    
    CGPoint southeastScreen;
    southeastScreen.x = rect.origin.x + rect.size.width;
    southeastScreen.y = rect.origin.y + rect.size.height;
    
    CGPoint northeastScreen, southwestScreen;
    northeastScreen.x = southeastScreen.x;
    northeastScreen.y = northwestScreen.y;
    southwestScreen.x = northwestScreen.x;
    southwestScreen.y = southeastScreen.y;
    
    CLLocationCoordinate2D northeastLL, northwestLL, southeastLL, southwestLL;
    northeastLL = [self pixelToLatLong:northeastScreen];
    northwestLL = [self pixelToLatLong:northwestScreen];
    southeastLL = [self pixelToLatLong:southeastScreen];
    southwestLL = [self pixelToLatLong:southwestScreen];
    
    boundingBox.northeast.latitude = fmax(northeastLL.latitude, northwestLL.latitude);
    boundingBox.southwest.latitude = fmin(southeastLL.latitude, southwestLL.latitude);
    
    // westerly computations:
    // -179, -178 -> -179 (min)
    // -179, 179  -> 179 (max)
    if (fabs(northwestLL.longitude - southwestLL.longitude) <= kMaxLong)
        boundingBox.southwest.longitude = fmin(northwestLL.longitude, southwestLL.longitude);
    else
        boundingBox.southwest.longitude = fmax(northwestLL.longitude, southwestLL.longitude);
    
    if (fabs(northeastLL.longitude - southeastLL.longitude) <= kMaxLong)
        boundingBox.northeast.longitude = fmax(northeastLL.longitude, southeastLL.longitude);
    else
        boundingBox.northeast.longitude = fmin(northeastLL.longitude, southeastLL.longitude);
    
    return boundingBox;
}

- (void) tilesUpdatedRegion:(CGRect)region
{
    if(delegateHasRegionUpdate)
    {
        RMSphericalTrapezium locationBounds  = [self latitudeLongitudeBoundingBoxFor:region];
        [tilesUpdateDelegate regionUpdate:locationBounds];
    }
}
- (void) printDebuggingInformation
{
    if (imagesOnScreens&&[imagesOnScreens count]>0) {
        for(RMTileImageSet* imagesOnScreen in imagesOnScreens)
        {
            [imagesOnScreen printDebuggingInformation];
        }
    }
    
}

@dynamic tilesUpdateDelegate;

- (void) setTilesUpdateDelegate: (id<RMTilesUpdateDelegate>) _tilesUpdateDelegate
{
    if (tilesUpdateDelegate == _tilesUpdateDelegate) return;
    tilesUpdateDelegate= _tilesUpdateDelegate;
    //RMLog(@"Delegate type:%@",[(NSObject *) tilesUpdateDelegate description]);
    delegateHasRegionUpdate  = [(NSObject*) tilesUpdateDelegate respondsToSelector: @selector(regionUpdate:)];
}

- (id<RMTilesUpdateDelegate>) tilesUpdateDelegate
{
    return tilesUpdateDelegate;
}

- (void)setRotation:(double)angle
{
    [overlay setRotationOfAllSublayers:(-angle)]; // rotate back markers and paths if theirs allowRotate=NO
}

//- (short)tileDepth {
//
//    return imagesOnScreen.tileDepth;
//}

//- (void)setTileDepth:(short)value {
//	imagesOnScreen.tileDepth = value;
//}

//- (BOOL)fullyLoaded {
//	return imagesOnScreen.fullyLoaded;
//}



- (void)createMapView
{
    [tileSourcesContainer cancelAllDownloads];
    
    
    for (__strong  CALayer* tiledLayer in superTileSouceLayer.sublayers)
    {
        tiledLayer.contents = nil;
        [tiledLayer removeFromSuperlayer];  tiledLayer = nil;
    }
    
    [superTileSouceLayer removeFromSuperlayer];
    superTileSouceLayer = nil;
    
    int count = layer.sublayers.count;
    for(int i=0;i<count;i++){
        CALayer* tiledLayer = layer.sublayers[i];
        tiledLayer.contents = nil;
        [tiledLayer removeFromSuperlayer];
        tiledLayer = nil;
    }
    
    //    NSUInteger tileSideLength = [tileSourcesContainer tileSideLength];
    //    CGSize contentSize = CGSizeMake(tileSideLength, tileSideLength); // zoom level 1
    
    superTileSouceLayer=[CALayer layer];
    superTileSouceLayer.frame = [self screenBounds];
    superTileSouceLayer.anchorPoint = CGPointZero;
    superTileSouceLayer.masksToBounds = YES;
    superTileSouceLayer.position=CGPointZero;
    
    if (background != nil)
        [layer insertSublayer:superTileSouceLayer above:background];
    else if (overlay != nil)
        [layer insertSublayer:superTileSouceLayer below:overlay];
    else
        [layer insertSublayer:superTileSouceLayer atIndex: 0];
    
    imagesOnScreens=[NSMutableArray new];
    tileLoaders=[NSMutableArray new];
    renderers=[NSMutableArray new];
    
    for (id <RMTileSource> tileSource in tileSourcesContainer.tileSources)
    {
        [self setRenderer: [[RMCoreAnimationRenderer alloc] initWithContent:self] withTileSource:tileSource atIndex:0];
        
    }
    
    
    
}

- (void)addTileSource:(id<RMTileSource>)newTileSource atIndex:(NSUInteger)index
{
    
    if(!m_bDatasource){
        if(![self initWithView:m_view tilesource:newTileSource])
            return;
    }
    
    if ( ! tileSourcesContainer)
    {
        // If we've reached this point, it's because our scroll view etc.
        // aren't yet setup. So let's remember the tile source(s) set so that
        // we can apply them later on once we're properly initialized.
        //
        [earlyTileSources insertObject:newTileSource atIndex:(index > [earlyTileSources count] ? 0 : index)];
        return;
    }
    
    if ([tileSourcesContainer.tileSources containsObject:newTileSource])
        return;
    
    RMCachedTileSource *newCachedTileSource = [RMCachedTileSource cachedTileSourceWithSource:newTileSource];
    id<RMTileSource> tileSource = [newCachedTileSource tileSource];
    
    float minZoomTmp= [tileSource minZoom];
    NSAssert((minZoomTmp - minZoom) <= 1.0, @"Graphics & memory are overly taxed if [contents minZoom] is more than 1.5 smaller than [tileSource minZoom]");
    
    
    ////加入并调整tileSourcesContainer
    if ( ! [tileSourcesContainer addTileSource:tileSource atIndex:index])
        return;
    
    
    
    // Recreate the map layer
    NSUInteger tileSourcesContainerSize = [[tileSourcesContainer tileSources] count];
    
    if (tileSourcesContainerSize == 1)
    {
        [self createMapView];
    }
    else
    {
        // NSLog(@"index:%lu",(unsigned long)index);
        if (index >= tileSourcesContainerSize)
        {
            [self setRenderer: [[RMCoreAnimationRenderer alloc] initWithContent:self] withTileSource:tileSource atIndex:tileSourcesContainerSize];
        }
        
        else
        {
            [self setRenderer: [[RMCoreAnimationRenderer alloc] initWithContent:self] withTileSource:tileSource atIndex:index];
        }
        [[tileSource tileLoader]setSuppressLoading:NO];
    }
    
}

- (void)addTileSource:(id <RMTileSource>)newTileSource
{
    [self addTileSource:newTileSource atIndex:-1];
}

- (void) setTileSource: (id<RMTileSource>)newTileSource
{
    
    if (newTileSource)
    {
        [tileSourcesContainer removeAllTileSources];
        [self addTileSource:newTileSource];
    }
}



-(NSMutableArray*)baseLayerScales
{
    return baseLayeScals;
}

- (void)removeTileSource:(id <RMTileSource>)tileSource
{
    NSInteger index=[[tileSourcesContainer tileSources]indexOfObject:tileSource];
    [self removeTileSourceAtIndex:index];
}

- (void)removeTileSourceAtIndex:(NSUInteger)index
{
    
    if (index>=[[tileSourcesContainer tileSources]count]) {
        NSLog(@"the removeTileSource is't in tileSourcesContainer!!");
    }
    else
    {
        RMProjectedPoint centerPoint = [self centerProjectedPoint];
        id <RMTileSource>tileSource=[[tileSourcesContainer tileSources]objectAtIndex:index];
       
        [tileSourcesContainer removeTileSource:tileSource];
        
        CALayer* tileSourceLayer=[[tileSource renderer]layer];
        
        tileSourceLayer.contents=nil;
        [tileSourceLayer removeFromSuperlayer];
        tileSourceLayer=nil;
        
        [renderers removeObject:[tileSource renderer]];
        [imagesOnScreens removeObject:[tileSource imagesOnScreen]];
        [tileLoaders removeObject:[tileSource tileLoader]];
        
        [self setCenterProjectedPoint:centerPoint];
    }
 
    
}


- (void)setHidden:(BOOL)isHidden forTileSource:(id <RMTileSource>)tileSource
{
    NSArray *tileSources = [tileSourcesContainer tileSources];
    
    [tileSources enumerateObjectsUsingBlock:^(id <RMTileSource> currentTileSource, NSUInteger index, BOOL *stop)
     {
         if (tileSource == currentTileSource)
         {
             currentTileSource.isHidden = isHidden;
             [self setHidden:isHidden forTileSourceAtIndex:index];
             *stop = YES;
         }
     }];
    
    
    
}

- (void)setHidden:(BOOL)isHidden forTileSourceAtIndex:(NSUInteger)index
{
    if (index >= [superTileSouceLayer.sublayers count])
        return;
    NSArray *tileSources = [tileSourcesContainer tileSources];
    id <RMTileSource> currentTileSource = tileSources[index];
    currentTileSource.isHidden = isHidden;
    ((CALayer *)[superTileSouceLayer.sublayers objectAtIndex:index]).hidden = isHidden;
    
}

- (void)setOpacity:(double)opacity forTileSource:(id <RMTileSource>)tileSource
{
    NSArray *tileSources = [tileSourcesContainer tileSources];
    
    [tileSources enumerateObjectsUsingBlock:^(id <RMTileSource> currentTileSource, NSUInteger index, BOOL *stop)
     {
         if (tileSource == currentTileSource)
         {
             [self setOpacity:opacity forTileSourceAtIndex:index];
             *stop = YES;
         }
     }];
    
    
    
}

- (void)setOpacity:(double)opacity forTileSourceAtIndex:(NSUInteger)index
{
    if (index >= [superTileSouceLayer.sublayers count])
        return;
    
     ((CALayer *)[superTileSouceLayer.sublayers objectAtIndex:index]).opacity = opacity;
  
}

-(void)setDisplayFilter:(NSDictionary *)displayFilter forTileSource:(id<RMTileSource>)tileSource{
    
    RMSMTileSource *smTileSource = tileSource;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        BOOL result = [[smTileSource m_Info] updateTempLayer:displayFilter];
        if (result) {
            dispatch_async(dispatch_get_main_queue(), ^{
                // 设置为不使用本地缓存
                [smTileSource setIsUseCache:NO];
                [[tileSource tileLoader] updateLoadedImages];
            });
        }
    });
}

- (void)setDIsplayFilter:(NSDictionary *)displayFilter forTileSourceAtIndex:(NSUInteger)index{
    if (index >= [[tileSourcesContainer tileSources] count]){
        NSLog(@"Index is out of bounds...");
        return;
    }
    [self setDisplayFilter:displayFilter forTileSource:[[tileSourcesContainer tileSources] objectAtIndex:index]];
}
@end
