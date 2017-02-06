//
//  RMMapView.m
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

#import "RMMapView.h"
#import "RMMapContents.h"
#import "RMMapViewDelegate.h"
#import "RMMapTap.h"

#import "RMTileLoader.h"

#import "RMMercatorToScreenProjection.h"
#import "RMMarker.h"
#import "RMProjection.h"
#import "RMMarkerManager.h"
#import "RMSMLayerInfo.h"
#import "RMSMTileSource.h"
#import "RMCloudMapSource.h"
#import "RMSMMBTileSource.h"
#import "RMMapRenderer.h"
#import "MapView_Prefix.pch"
#import "RMWebTileImage.h"


@interface RMMapView()
{
    NSUInteger oldZoom;
    CGFloat factor;
    CGPoint _firstTouchPoint;
}
@end
@interface RMMapView (PrivateMethods)
// methods for post-touch deceleration, ala UIScrollView
- (void)startDecelerationWithDelta:(CGSize)delta;
- (void)incrementDeceleration:(NSTimer *)timer;
- (void)stopDeceleration;
@end

@implementation RMMapView
@synthesize contents;

@synthesize decelerationFactor;
@synthesize deceleration;

@synthesize rotation;

@synthesize enableDragging;
@synthesize enableZoom;
@synthesize enableRotate;
@synthesize bZoomOut;
@synthesize bRun;

#pragma mark --- begin constants ----
#define kDefaultDecelerationFactor .88f
#define kMinDecelerationDelta 0.01f
#pragma mark --- end constants ----

- (RMMarkerManager*)markerManager
{
  return self.contents.markerManager;
}

-(void) performInitialSetup
{
	LogMethod();

	enableDragging = YES;
	enableZoom = YES;
	enableRotate = NO;
	decelerationFactor = kDefaultDecelerationFactor;
	deceleration = NO;
	
    screenScale = 0.0;
    lastTime = 0;

    
	//	[self recalculateImageSet];
	
	if (enableZoom || enableRotate)
		[self setMultipleTouchEnabled:TRUE];
	
	self.backgroundColor = [UIColor whiteColor];
	
	_constrainMovement=NO;
    bRun = false;
	
//	[[NSURLCache sharedURLCache] removeAllCachedResponses];
}

- (id)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame screenScale:0.0];
}

- (id)initWithFrame:(CGRect)frame screenScale:(double)theScreenScale
{
	LogMethod();
	if (self = [super initWithFrame:frame]) {
		[self performInitialSetup];
        screenScale = theScreenScale;
        oldZoom = -1;
	}
	return self;
}

/// \deprecated Deprecated any time after 0.5.
- (id)initWithFrame:(CGRect)frame WithLocation:(CLLocationCoordinate2D)latlon
{
	WarnDeprecated();
	LogMethod();
	if (self = [super initWithFrame:frame]) {
		[self performInitialSetup];
	}
	[self moveToLatLong:latlon];
	return self;
}

//===========================================================
//  contents 
//=========================================================== 
- (RMMapContents *)contents
{
    if (!_contentsIsSet) {
        
        //RMMapContents *newContents = [[RMMapContents alloc] initWithView:self screenScale:screenScale];
		//self.contents = newContents;
         //SuperMap iServer
        //NSString *tileThing = @"http://support.supermap.com.cn:8090/iserver/services/map-china400/rest/maps/China";
        /*
        //NSString *tileThing = @"http://support.supermap.com.cn:8090/iserver/services/map-world/rest/maps/World";
        
        NSString *tileThing = @"http://support.supermap.com.cn:8090/iserver/services/map-china400/rest/maps/China";
        
        RMSMLayerInfo* info = [[RMSMLayerInfo alloc] initWithTile:@"China" linkurl:tileThing];
        // 判断获取iServer服务配置信息失败，为NULL时失败
        NSAssert(info != NULL,@"RMSMLayerInfo Connect fail");
        
        RMSMTileSource* smSource = [[RMSMTileSource alloc] initWithInfo:info];
		RMMapContents *newContents = [[RMMapContents alloc] initWithView:self tilesource:smSource];
        */
        
        
        // CloudLayer
        
        RMCloudMapSource* cloud = [[RMCloudMapSource alloc] init];
        RMMapContents *newContents = [[RMMapContents alloc] initWithView:self tilesource:cloud];
        
        newContents.zoom=2;

        
        /*
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *name = @"China.mbtiles";
        //NSString* type = @".mbtiles";
        
        //name = [name stringByAppendingString:type];
        
        NSString *path = [documentsDirectory stringByAppendingPathComponent:name];
        
        RMSMMBTileSource* mbSource = [[RMSMMBTileSource alloc] initWithTileSetURL:path];
        RMMapContents *newContents = [[RMMapContents alloc] initWithView:self tilesource:mbSource];
        [newContents setMaxZoom:[mbSource maxZoom]];
        */
        //RMMapContents *newContents = [[RMMapContents alloc] initWithView:self];
		self.contents = newContents;
		[newContents release];
		_contentsIsSet = YES;
	}
	return contents; 
}
- (void)setContents:(RMMapContents *)theContents
{
    if (contents != theContents) {
        [contents release];
        contents = [theContents retain];
		_contentsIsSet = YES;
		[self performInitialSetup];
    }
}

-(void) dealloc
{
	LogMethod();
	self.contents = nil;
    
    // 当mapView的实例被销毁时，cancel所有的tileIamge请求
    if ([RMWebTileImage getInstanceQueue]) {
        [[RMWebTileImage getInstanceQueue] cancelAllOperations];
    }

	[super dealloc];
}

-(void) drawRect: (CGRect) rect
{
	[self.contents drawRect:rect];
}

-(NSString*) description
{
	CGRect bounds = [self bounds];
	return [NSString stringWithFormat:@"MapView at %.0f,%.0f-%.0f,%.0f", bounds.origin.x, bounds.origin.y, bounds.size.width, bounds.size.height];
}

/// Forward invocations to RMMapContents
- (void)forwardInvocation:(NSInvocation *)invocation
{
    SEL aSelector = [invocation selector];
	
    if ([self.contents respondsToSelector:aSelector])
        [invocation invokeWithTarget:self.contents];
    else
        [self doesNotRecognizeSelector:aSelector];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
	if ([super respondsToSelector:aSelector])
		return [super methodSignatureForSelector:aSelector];
	else
		return [self.contents methodSignatureForSelector:aSelector];
}

#pragma mark Delegate 

@dynamic delegate;

- (void) setDelegate: (id<RMMapViewDelegate>) _delegate
{
	if (delegate == _delegate) return;
	delegate = _delegate;
	
	_delegateHasBeforeMapMove = [(NSObject*) delegate respondsToSelector: @selector(beforeMapMove:)];
	_delegateHasAfterMapMove  = [(NSObject*) delegate respondsToSelector: @selector(afterMapMove:)];
	
	_delegateHasBeforeMapZoomByFactor = [(NSObject*) delegate respondsToSelector: @selector(beforeMapZoom: byFactor: near:)];
	_delegateHasAfterMapZoomByFactor  = [(NSObject*) delegate respondsToSelector: @selector(afterMapZoom: byFactor: near:)];
	
	_delegateHasMapViewRegionDidChange = [delegate respondsToSelector:@selector(mapViewRegionDidChange:)];

	_delegateHasBeforeMapRotate  = [(NSObject*) delegate respondsToSelector: @selector(beforeMapRotate: fromAngle:)];
	_delegateHasAfterMapRotate  = [(NSObject*) delegate respondsToSelector: @selector(afterMapRotate: toAngle:)];

	_delegateHasDoubleTapOnMap = [(NSObject*) delegate respondsToSelector: @selector(doubleTapOnMap:At:)];
	_delegateHasSingleTapOnMap = [(NSObject*) delegate respondsToSelector: @selector(singleTapOnMap:At:)];
	
	_delegateHasTapOnMarker = [(NSObject*) delegate respondsToSelector:@selector(tapOnMarker:onMap:)];
	_delegateHasTapOnLabelForMarker = [(NSObject*) delegate respondsToSelector:@selector(tapOnLabelForMarker:onMap:)];
	_delegateHasTapOnLabelForMarkerOnLayer = [(NSObject*) delegate respondsToSelector:@selector(tapOnLabelForMarker:onMap:onLayer:)];
	
	_delegateHasAfterMapTouch  = [(NSObject*) delegate respondsToSelector: @selector(afterMapTouch:)];
   
   	_delegateHasShouldDragMarker = [(NSObject*) delegate respondsToSelector: @selector(mapView: shouldDragMarker: withEvent:)];
   	_delegateHasDidDragMarker = [(NSObject*) delegate respondsToSelector: @selector(mapView: didDragMarker: withEvent:)];
	
	_delegateHasDragMarkerPosition = [(NSObject*) delegate respondsToSelector: @selector(dragMarkerPosition: onMap: position:)];
    _delegateHasLongTapOnMap = [(NSObject *)delegate respondsToSelector:@selector(longTapOnMap:At:)];
}

- (id<RMMapViewDelegate>) delegate
{
	return delegate;
}

#pragma mark Movement

-(void) moveToProjectedPoint: (RMProjectedPoint) aPoint
{
	if (_delegateHasBeforeMapMove) [delegate beforeMapMove: self];
	[self.contents moveToProjectedPoint:aPoint];
	if (_delegateHasAfterMapMove) [delegate afterMapMove: self];
	if (_delegateHasMapViewRegionDidChange) [delegate mapViewRegionDidChange:self];
}
-(void) moveToLatLong: (CLLocationCoordinate2D) point
{
	if (_delegateHasBeforeMapMove) [delegate beforeMapMove: self];
	[self.contents moveToLatLong:point];
	if (_delegateHasAfterMapMove) [delegate afterMapMove: self];
	if (_delegateHasMapViewRegionDidChange) [delegate mapViewRegionDidChange:self];
}

-(void)setConstraintsSW:(CLLocationCoordinate2D)sw NE:(CLLocationCoordinate2D)ne
{
	//store projections
	RMProjection *proj=self.contents.projection;
	
	RMProjectedPoint projectedNE = [proj latLongToPoint:ne];
	RMProjectedPoint projectedSW = [proj latLongToPoint:sw];
	
	[self setProjectedContraintsSW:projectedSW NE:projectedNE];
}

- (void)setProjectedContraintsSW:(RMProjectedPoint)sw NE:(RMProjectedPoint)ne {
	SWconstraint = sw;
	NEconstraint = ne;
	
	_constrainMovement=YES;
}

-(void)moveBy:(CGSize)delta 
{

	if ( _constrainMovement ) 
	{
		//bounds are
		RMMercatorToScreenProjection *mtsp=self.contents.mercatorToScreenProjection;
		
		//calculate new bounds after move
        ///移动后计算新的范围
		RMProjectedRect pBounds=[mtsp projectedBounds];
		RMProjectedSize XYDelta = [mtsp projectScreenSizeToXY:delta];
        CGSize sizeRatio = CGSizeMake(((delta.width == 0) ? 0 : XYDelta.width / delta.width),
									  ((delta.height == 0) ? 0 : XYDelta.height / delta.height));
		RMProjectedRect newBounds=pBounds;
        
		//move the rect by delta
		newBounds.origin.northing -= XYDelta.height;
		newBounds.origin.easting -= XYDelta.width; 
		
		// see if new bounds are within constrained bounds, and constrain if necessary
        //判断bounds是否需要裁剪，若超出范围则裁剪
        BOOL constrained = NO;
		if ( newBounds.origin.northing < SWconstraint.northing ) { newBounds.origin.northing = SWconstraint.northing; constrained = YES; }
        if ( newBounds.origin.northing+newBounds.size.height > NEconstraint.northing ) { newBounds.origin.northing = NEconstraint.northing - newBounds.size.height; constrained = YES; }
        if ( newBounds.origin.easting < SWconstraint.easting ) { newBounds.origin.easting = SWconstraint.easting; constrained = YES; }
        if ( newBounds.origin.easting+newBounds.size.width > NEconstraint.easting ) { newBounds.origin.easting = NEconstraint.easting - newBounds.size.width; constrained = YES; }
        if ( constrained ) 
        {
            // Adjust delta to match constraint
            XYDelta.height = pBounds.origin.northing - newBounds.origin.northing;
            XYDelta.width = pBounds.origin.easting - newBounds.origin.easting;
            delta = CGSizeMake(((sizeRatio.width == 0) ? 0 : XYDelta.width / sizeRatio.width), 
                               ((sizeRatio.height == 0) ? 0 : XYDelta.height / sizeRatio.height));
        }
	}

	if (_delegateHasBeforeMapMove) [delegate beforeMapMove: self];
	[self.contents moveBy:delta];
	if (_delegateHasAfterMapMove) [delegate afterMapMove: self];
	if (_delegateHasMapViewRegionDidChange) [delegate mapViewRegionDidChange:self];
}
 
- (void)zoomByFactor: (double) zoomFactor near:(CGPoint) center
{
	[self zoomByFactor:zoomFactor near:center animated:NO];
}
- (void)zoomByFactor: (double) zoomFactor near:(CGPoint) center animated:(BOOL)animated
{
	if ( _constrainMovement ) 
	{
		//判断缩放后地图是否超出范围
        //the logic is copued from the method zoomByFactor,
		double _zoomFactor = [self.contents adjustZoomForBoundingMask:zoomFactor];
		double zoomDelta = log2f(_zoomFactor);
		double targetZoom = zoomDelta + [self.contents zoom];
		BOOL canZoom=NO;
		if (targetZoom == [self.contents zoom]){
			//OK... . I could even do a return here.. but it will hamper with future logic..
			canZoom=YES;
		}
		// clamp zoom to remain below or equal to maxZoom after zoomAfter will be applied
		if(targetZoom > [self.contents maxZoom]){
			zoomFactor = exp2f([self.contents maxZoom] - [self.contents zoom]);
		}
		
		// clamp zoom to remain above or equal to minZoom after zoomAfter will be applied
		if(targetZoom < [self.contents minZoom]){
			zoomFactor = 1/exp2f([self.contents zoom] - [self.contents minZoom]);
		}
		
		//bools for syntactical sugar to understand the logic in the if statement below
        //用于判断能否缩放的bools
		BOOL zoomAtMax = ([self.contents  zoom] == [self.contents  maxZoom]);
		BOOL zoomAtMin = ([self.contents  zoom] == [self.contents  minZoom]);
		BOOL zoomGreaterMin = ([self.contents  zoom] > [self.contents  minZoom]);
		BOOL zoomLessMax = ([self.contents  zoom] < [ self.contents maxZoom]);
		
		//zooming in zoomFactor > 1
		//zooming out zoomFactor < 1
		
		if ((zoomGreaterMin && zoomLessMax) || (zoomAtMax && zoomFactor<1) || (zoomAtMin && zoomFactor>1))
		{
			//if I'm here it means I could zoom, now we have to see what will happen after zoom
			RMMercatorToScreenProjection *mtsp= self.contents.mercatorToScreenProjection ;
			
			//get copies of mercatorRoScreenProjection's data
			RMProjectedPoint origin=[mtsp origin];
			double metersPerPixel=mtsp.metersPerPixel;
			CGRect screenBounds=[mtsp screenBounds];
			
			//tjis is copied from [RMMercatorToScreenBounds zoomScreenByFactor]
			// First we move the origin to the pivot...
            //首先把中心点移到原点（左下角点）
			origin.easting += center.x * metersPerPixel;
			origin.northing += (screenBounds.size.height - center.y) * metersPerPixel;
			// Then scale by 1/factor
            // 然后根据_zoomFactor计算新的metersPerPixel
			metersPerPixel /= _zoomFactor;
			// 再用新的metersPerPixel重新计算原点（左下角点）
			origin.easting -= center.x * metersPerPixel;
			origin.northing -= (screenBounds.size.height - center.y) * metersPerPixel;
			
			origin = [mtsp.projection wrapPointHorizontally:origin];
			
			//重新计算bounds
			RMProjectedRect zRect;
			zRect.origin = origin;
			zRect.size.width = screenBounds.size.width * metersPerPixel;
			zRect.size.height = screenBounds.size.height * metersPerPixel;
            
			//can zoom only if within bounds
			canZoom= zoomDelta > 0 || !(zRect.origin.northing < SWconstraint.northing || zRect.origin.northing+zRect.size.height> NEconstraint.northing ||
			  zRect.origin.easting < SWconstraint.easting || zRect.origin.easting+zRect.size.width > NEconstraint.easting);
			
            
		}
		
		if(!canZoom){
			RMLog(@"Zooming will move map out of bounds: no zoom");
			return;
		}
	
	}
	
	if (_delegateHasBeforeMapZoomByFactor) [delegate beforeMapZoom: self byFactor: zoomFactor near: center];

    // 当发送新的地图图片请求时，取消队列中的所有图片请求
    @synchronized(self){
        if ([RMWebTileImage getInstanceQueue]) {
             [[RMWebTileImage getInstanceQueue] cancelAllOperations];
        }
    }
//    NSLog(@"%f====%f=====%f======%f",contents.projectedBounds.origin.easting,contents.projectedBounds.origin.northing,contents.projectedBounds.size.width,contents.projectedBounds.size.height);
	[self.contents zoomByFactor:zoomFactor near:center animated:animated withCallback:(animated && (_delegateHasAfterMapZoomByFactor || _delegateHasMapViewRegionDidChange))?self:nil];
	if (!animated)
	{
		if (_delegateHasAfterMapZoomByFactor) [delegate afterMapZoom: self byFactor: zoomFactor near: center];
		if (_delegateHasMapViewRegionDidChange) [delegate mapViewRegionDidChange:self];
	}
}


#pragma mark RMMapContentsAnimationCallback methods

- (void)animationFinishedWithZoomFactor:(double)zoomFactor near:(CGPoint)p
{
	if (_delegateHasAfterMapZoomByFactor)
		[delegate afterMapZoom: self byFactor: zoomFactor near: p];
}

- (void)animationStepped {
	if (_delegateHasMapViewRegionDidChange) [delegate mapViewRegionDidChange:self];
}

#pragma mark Event handling

- (RMGestureDetails) gestureDetails: (NSSet*) touches
{
	RMGestureDetails gesture;
	gesture.center.x = gesture.center.y = 0;
	gesture.averageDistanceFromCenter = 0;
	gesture.angle = 0.0;
	
	int interestingTouches = 0;
	
	for (UITouch *touch in touches)
	{
		if ([touch phase] != UITouchPhaseBegan
			&& [touch phase] != UITouchPhaseMoved
			&& [touch phase] != UITouchPhaseStationary)
			continue;
		//		RMLog(@"phase = %d", [touch phase]);
		
		interestingTouches++;
		
		CGPoint location = [touch locationInView: self];
		
		gesture.center.x += location.x;
		gesture.center.y += location.y;
	}
	
	if (interestingTouches == 0)
	{
		gesture.center = lastGesture.center;
		gesture.numTouches = 0;
		gesture.averageDistanceFromCenter = 0.0f;
		return gesture;
	}
	
	//	RMLog(@"interestingTouches = %d", interestingTouches);
	
	gesture.center.x /= interestingTouches;
	gesture.center.y /= interestingTouches;
	
	for (UITouch *touch in touches)
	{
		if ([touch phase] != UITouchPhaseBegan
			&& [touch phase] != UITouchPhaseMoved
			&& [touch phase] != UITouchPhaseStationary)
			continue;
		
		CGPoint location = [touch locationInView: self];
		
		//		RMLog(@"For touch at %.0f, %.0f:", location.x, location.y);
		double dx = location.x - gesture.center.x;
		double dy = location.y - gesture.center.y;
		//		RMLog(@"delta = %.0f, %.0f  distance = %f", dx, dy, sqrtf((dx*dx) + (dy*dy)));
		gesture.averageDistanceFromCenter += sqrtf((dx*dx) + (dy*dy));
	}

	gesture.averageDistanceFromCenter /= interestingTouches;
	
	gesture.numTouches = interestingTouches;

	if ([touches count] == 2)  
	{
		CGPoint first = [[[touches allObjects] objectAtIndex:0] locationInView:[self superview]];
		CGPoint second = [[[touches allObjects] objectAtIndex:1] locationInView:[self superview]];
		double height = second.y - first.y;
        double width = first.x - second.x;
        gesture.angle = atan2(height,width);
	}
	
	//RMLog(@"center = %.0f,%.0f dist = %f, angle = %f", gesture.center.x, gesture.center.y, gesture.averageDistanceFromCenter, gesture.angle);
	
	return gesture;
}

- (void)resumeExpensiveOperations
{
	[RMMapContents setPerformExpensiveOperations:YES];
    bRun = false;
}

- (void)delayedResumeExpensiveOperations
{
    if (bRun)
        return;
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(resumeExpensiveOperations) object:nil];
	[self performSelector:@selector(resumeExpensiveOperations) withObject:nil afterDelay:0.4];
    bRun = true;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch *touch = [[touches allObjects] objectAtIndex:0];
    
    if([[self contents] renderers]&&[[self contents] renderers]>0)
    {
        for(RMMapRenderer *pRender in [[self contents] renderers])
            if(pRender.bRemove == false)
            {
                [pRender clear];
                pRender.bRemove = true;
            }
    
    }
   
    _pressTime = touch.timestamp;
    
    _firstTouchPoint = [[touches anyObject] locationInView:self];
	//Check if the touch hit a RMMarker subclass and if so, forward the touch event on
    //判断是否点击了一个marker，如果是，则响应对应的事件
	//so it can be handled there
	id furthestLayerDown = [self.contents.overlay hitTest:[touch locationInView:self]];
	if ([[furthestLayerDown class]isSubclassOfClass: [RMMarker class]]) {
		if ([furthestLayerDown respondsToSelector:@selector(touchesBegan:withEvent:)]) {
			[furthestLayerDown performSelector:@selector(touchesBegan:withEvent:) withObject:touches withObject:event];
			return;
		}
	}
		
	if (lastGesture.numTouches == 0)
	{
		[RMMapContents setPerformExpensiveOperations:NO];
	}
	
	//	RMLog(@"touchesBegan %d", [[event allTouches] count]);
	lastGesture = [self gestureDetails:[event allTouches]];
    factor = 1.0;
    [RMMapTap touch:lastGesture Type:1];
	if(deceleration)
	{
		if (_decelerationTimer != nil) {
			[self stopDeceleration];
		}
	}
	
	[self delayedResumeExpensiveOperations];
    if(oldZoom==-1){
        oldZoom = self.contents.mercatorToTileProjection.curZoom;
    }
}

/// \bug touchesCancelled should clean up, not pass event to markers
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch *touch = [[touches allObjects] objectAtIndex:0];
	
	//Check if the touch hit a RMMarker subclass and if so, forward the touch event on
	//so it can be handled there
	id furthestLayerDown = [self.contents.overlay hitTest:[touch locationInView:self]];
	if ([[furthestLayerDown class]isSubclassOfClass: [RMMarker class]]) {
		if ([furthestLayerDown respondsToSelector:@selector(touchesCancelled:withEvent:)]) {
			[furthestLayerDown performSelector:@selector(touchesCancelled:withEvent:) withObject:touches withObject:event];
			return;
		}
	}

	[self delayedResumeExpensiveOperations];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch *touch = [[touches allObjects] objectAtIndex:0];
	/*
    NSUInteger numTouches = [[event allTouches] count];
    if (numTouches>1) {
        RMMapRenderer * pRender = [[self contents] renderer];
        pRender.bRemove = false;
    }
    */
    
    if (bZoomOut == true) {
        if([[self contents] renderers]&&[[self contents] renderers]>0)
        {
            for(RMMapRenderer *pRender in [[self contents] renderers])
                if(pRender.bRemove == false)
                {
                     pRender.bRemove = false;
                }
            
        }
       
        bZoomOut = false;
    }
    
    lastTime = 0.0;
	//Check if the touch hit a RMMarker subclass and if so, forward the touch event on
	//so it can be handled there
	id furthestLayerDown = [self.contents.overlay hitTest:[touch locationInView:self]];
	if ([[furthestLayerDown class]isSubclassOfClass: [RMMarker class]]) {
		if ([furthestLayerDown respondsToSelector:@selector(touchesEnded:withEvent:)]) {
			[furthestLayerDown performSelector:@selector(touchesEnded:withEvent:) withObject:touches withObject:event];
			return;
		}
	}
	NSInteger lastTouches = lastGesture.numTouches;
	
	// Calculate the gesture.
	lastGesture = [self gestureDetails:[event allTouches]];
    [RMMapTap touch:lastGesture Type:3];
    BOOL decelerating = NO;
	if (touch.tapCount >= 2)
	{
		if (_delegateHasDoubleTapOnMap) {
			[delegate doubleTapOnMap: self At: lastGesture.center];
		} else {
			// Default behaviour matches built in maps.app
			double nextZoomFactor = [self.contents nextNativeZoomFactor];
			if (nextZoomFactor != 0)
				[self zoomByFactor:nextZoomFactor near:[touch locationInView:self] animated:NO];
		}
	} else if (lastTouches == 1 && touch.tapCount != 1) {
		// deceleration
		if(deceleration && enableDragging)
		{
			CGPoint prevLocation = [touch previousLocationInView:self];
			CGPoint currLocation = [touch locationInView:self];
			CGSize touchDelta = CGSizeMake(currLocation.x - prevLocation.x, currLocation.y - prevLocation.y);
			[self startDecelerationWithDelta:touchDelta];
            decelerating = YES;
		}
	}
	
    
	// If there are no more fingers on the screen, resume any slow operations.
	if (lastGesture.numTouches == 0 && !decelerating)
	{
        [self delayedResumeExpensiveOperations];
	}
    
	
	if (touch.tapCount == 1) 
	{
		if(lastGesture.numTouches == 0)
		{
			CALayer* hit = [self.contents.overlay hitTest:[touch locationInView:self]];
			//		RMLog(@"LAYER of type %@",[hit description]);
			
			if (hit != nil) {
				CALayer *superlayer = [hit superlayer]; 
				
				// See if tap was on a marker or marker label and send delegate protocol method
				if ([hit isKindOfClass: [RMMarker class]]) {
					if (_delegateHasTapOnMarker) {
						[delegate tapOnMarker:(RMMarker*)hit onMap:self];
					}
				} else if (superlayer != nil && [superlayer isKindOfClass: [RMMarker class]]) {
					if (_delegateHasTapOnLabelForMarker) {
						[delegate tapOnLabelForMarker:(RMMarker*)superlayer onMap:self];
					}
                    if (_delegateHasTapOnLabelForMarkerOnLayer) {
                        [delegate tapOnLabelForMarker:(RMMarker*)superlayer onMap:self onLayer:hit];
                    }
				} else if ([superlayer superlayer] != nil && [[superlayer superlayer] isKindOfClass: [RMMarker class]]) {
                                        if (_delegateHasTapOnLabelForMarker) {
                                                [delegate tapOnLabelForMarker:(RMMarker*)[superlayer superlayer] onMap:self];
                                        } 
                    if (_delegateHasTapOnLabelForMarkerOnLayer) {
                        [delegate tapOnLabelForMarker:(RMMarker*)[superlayer superlayer] onMap:self onLayer:hit];
                    }
				} else if (_delegateHasSingleTapOnMap) {
                   
                   [delegate singleTapOnMap: self At: [touch locationInView:self]];
                    
                }
			}
		}
		else if(!enableDragging && (lastGesture.numTouches == 1))
		{
			double prevZoomFactor = [self.contents prevNativeZoomFactor];
			if (prevZoomFactor != 0)
				[self zoomByFactor:prevZoomFactor near:[touch locationInView:self] animated:YES];
		}
	}
	
    [self webTapSkip];
    
	if (_delegateHasAfterMapTouch) [delegate afterMapTouch: self];
    if (_delegateHasLongTapOnMap && _pressTime != 0.0 && (touch.timestamp - _pressTime) > 0.5) {
        [delegate longTapOnMap:self At:[touch locationInView:self]];
    }else{
        
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch *touch = [[touches allObjects] objectAtIndex:0];
    CGPoint tmpPoint = [[touches anyObject] locationInView:self];
    
    double dTel = sqrt((_firstTouchPoint.x-tmpPoint.x)*(_firstTouchPoint.x-tmpPoint.x)+(_firstTouchPoint.y-tmpPoint.y)*(_firstTouchPoint.y-tmpPoint.y));
    if(dTel > 5.0)
        _pressTime = 0.0;
	//Check if the touch hit a RMMarker subclass and if so, forward the touch event on
	//so it can be handled there
	id furthestLayerDown = [self.contents.overlay hitTest:[touch locationInView:self]];
	if ([[furthestLayerDown class]isSubclassOfClass: [RMMarker class]]) {
		if ([furthestLayerDown respondsToSelector:@selector(touchesMoved:withEvent:)]) {
			[furthestLayerDown performSelector:@selector(touchesMoved:withEvent:) withObject:touches withObject:event];
			return;
		}
	}
	
	CALayer* hit = [self.contents.overlay hitTest:[touch locationInView:self]];
//	RMLog(@"LAYER of type %@",[hit description]);
	
	if (hit != nil) {
   
      if ([hit isKindOfClass: [RMMarker class]]) {
   
         if (!_delegateHasShouldDragMarker || (_delegateHasShouldDragMarker && [delegate mapView:self shouldDragMarker:(RMMarker*)hit withEvent:event])) {
            if (_delegateHasDidDragMarker) {
               [delegate mapView:self didDragMarker:(RMMarker*)hit withEvent:event];
               return;
            }
         }
      }
	}
	
	RMGestureDetails newGesture = [self gestureDetails:[event allTouches]];
	 [RMMapTap touch:newGesture Type:2];
	if(enableRotate && (newGesture.numTouches == lastGesture.numTouches))
	{
          if(newGesture.numTouches == 2)
          {
		double angleDiff = lastGesture.angle - newGesture.angle;
		double newAngle = self.rotation + angleDiff;
		
		[self setRotation:newAngle];
          }
	}
	
	if (enableDragging && newGesture.numTouches == lastGesture.numTouches)
	{
        
//        double CurrentTime = CACurrentMediaTime();
		CGSize delta;
		delta.width = newGesture.center.x - lastGesture.center.x;
		delta.height = newGesture.center.y - lastGesture.center.y;
        /*
        if(fabs(lastTime)>0.1)
        {
            NSLog(@"1:%f",CurrentTime);
            NSLog(@"2:%f",lastTime);
            NSLog(@"3:%f",sqrt(delta.width*delta.width+delta.height*delta.height));
            double speed = sqrt(delta.width*delta.width+delta.height*delta.height)/(CurrentTime-lastTime)/1000;
            
            NSLog(@"speed:%f",speed);
            
            delta.width = delta.width*(1+speed*0.4);
            delta.height = delta.height*(1+speed*0.4);
        }
        lastTime = CurrentTime;
		*/
		if (enableZoom && newGesture.numTouches > 1)
		{
			NSAssert (lastGesture.averageDistanceFromCenter > 0.0f && newGesture.averageDistanceFromCenter > 0.0f,
					  @"Distance from center is zero despite >1 touches on the screen");
			
			double zoomFactor = newGesture.averageDistanceFromCenter / lastGesture.averageDistanceFromCenter;
            factor+= (zoomFactor-1.0);
			[self moveBy:delta];
			[self zoomByFactor: zoomFactor near: newGesture.center];
            self.contents.zoomCenter = newGesture.center;
            if (zoomFactor>1.0) {
                bZoomOut = true;
            }else{
                [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(resumeExpensiveOperations) object:nil];
                [self performSelector:@selector(resumeExpensiveOperations) withObject:nil afterDelay:0.4];
            }
		}
		else
		{
			[self moveBy:delta];
		}
	}
	
	lastGesture = newGesture;
	if (newGesture.numTouches == 1) {
        [self delayedResumeExpensiveOperations];
    }

}

-(void)webTapSkip{
    static double preTime=0.0,srcTime=0.0;
    if([RMMapTap getCurGestureState]==1)
    {
        double nowtime = [[NSDate date] timeIntervalSince1970]*1000000;
        double dSumCostTime = nowtime-srcTime;
        double dCostTime = nowtime-preTime;
        
        if(dCostTime<200000 && dSumCostTime < 200000*5){
           // NSLog(@"too quick!!!");
            preTime = nowtime;
            return;
        }
        preTime = nowtime;
        srcTime = nowtime;
        
        NSUInteger zoom =  self.contents.mercatorToTileProjection.curZoom;
        
        if(factor>1.0){
            if(zoom > oldZoom){
                [self.contents setZoom2:zoom];
            }else
                [self.contents setZoom2:++zoom];
            
        }else if (factor<1.0){
            if(zoom < oldZoom){
                [self.contents setZoom2:zoom];
            }else
                [self.contents setZoom2:--zoom];
        }else{
            [self.contents setZoom2:oldZoom];
        }
        zoom = (zoom > self.contents.maxZoom) ? self.contents.maxZoom : zoom;
        zoom = (zoom < self.contents.minZoom) ? self.contents.minZoom : zoom;
        oldZoom = zoom;
    }
}

// first responder needed to use UIMenuController
- (BOOL)canBecomeFirstResponder
{
    return YES;
}

#pragma mark Deceleration

- (void)startDecelerationWithDelta:(CGSize)delta {
	if (ABS(delta.width) >= 1.0f && ABS(delta.height) >= 1.0f) {
		_decelerationDelta = delta;
        if ( !_decelerationTimer ) {
            _decelerationTimer = [NSTimer scheduledTimerWithTimeInterval:0.01f 
                                                                 target:self
                                                               selector:@selector(incrementDeceleration:) 
                                                               userInfo:nil 
                                                                repeats:YES];
        }
	}
}

- (void)incrementDeceleration:(NSTimer *)timer {
	if (ABS(_decelerationDelta.width) < kMinDecelerationDelta && ABS(_decelerationDelta.height) < kMinDecelerationDelta) {
		[self stopDeceleration];

        // Resume any slow operations after deceleration completes
        [self delayedResumeExpensiveOperations];
        
		return;
	}

	// avoid calling delegate methods? design call here
	[self.contents moveBy:_decelerationDelta];

	_decelerationDelta.width *= [self decelerationFactor];
	_decelerationDelta.height *= [self decelerationFactor];
}

- (void)stopDeceleration {
	if (_decelerationTimer != nil) {
		[_decelerationTimer invalidate];
		_decelerationTimer = nil;
		_decelerationDelta = CGSizeZero;

		// call delegate methods; design call (see above)
		[self moveBy:CGSizeZero];
	}
}

/// Must be called by higher didReceiveMemoryWarning
- (void)didReceiveMemoryWarning
{
	LogMethod();
	[contents didReceiveMemoryWarning];
}

- (void)setFrame:(CGRect)frame
{
  CGRect r = self.frame;
  [super setFrame:frame];
  // only change if the frame changes AND there is contents
  if (!CGRectEqualToRect(r, frame) && contents) {
    [contents setFrame:frame];
  }
}

- (void)setRotation:(double)angle
{
 	if (_delegateHasBeforeMapRotate) [delegate beforeMapRotate: self fromAngle: rotation];

	[CATransaction begin];
	[CATransaction setValue:[NSNumber numberWithdouble:0.0f] forKey:kCATransactionAnimationDuration];
	[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
	
	rotation = angle;
		
	self.transform = CGAffineTransformMakeRotation(rotation);
	[contents setRotation:rotation];	
	
	[CATransaction commit];

 	if (_delegateHasAfterMapRotate) [delegate afterMapRotate: self toAngle: rotation];
}

@end
