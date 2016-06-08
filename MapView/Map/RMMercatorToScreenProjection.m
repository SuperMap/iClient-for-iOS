//
//  RMMercatorToScreenProjection.m
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
#import "RMMercatorToScreenProjection.h"
#include "RMProjection.h"
#import "MapView_Prefix.pch"

@implementation RMMercatorToScreenProjection

@synthesize projection;
@synthesize origin;

-(void)deepCopy:(RMMercatorToScreenProjection *)copy{
	screenBounds=copy.screenBounds;
	projection=copy.projection;
	metersPerPixel=copy.metersPerPixel;
	origin=copy.origin;
}

- (id) initFromProjection: (RMProjection*) aProjection ToScreenBounds: (CGRect)aScreenBounds;
{
	if (![super init])
		return nil;
	screenBounds = aScreenBounds;
	projection = [aProjection retain];
	metersPerPixel = 1;
	return self;
}

- (void) dealloc
{
	[projection release];
	[super dealloc];
}

// Deltas in screen coordinates.
- (RMProjectedPoint)movePoint: (RMProjectedPoint)aPoint by:(CGSize) delta
{
	RMProjectedSize XYDelta = [self projectScreenSizeToXY:delta];
	aPoint.easting += XYDelta.width;
	aPoint.northing += XYDelta.height;
	aPoint = [projection wrapPointHorizontally:aPoint];
	return aPoint; 
}

- (RMProjectedRect)moveRect: (RMProjectedRect)aRect by:(CGSize) delta
{
	aRect.origin = [self movePoint:aRect.origin by:delta];
	return aRect;
}

- (RMProjectedPoint)zoomPoint: (RMProjectedPoint)aPoint byFactor: (double)factor near:(CGPoint) aPixelPoint
{
	RMProjectedPoint XYPivot = [self projectScreenPointToXY:aPixelPoint];
	RMProjectedPoint result = RMScaleProjectedPointAboutPoint(aPoint, factor, XYPivot);
	result = [projection wrapPointHorizontally:result];
//	RMLog(@"RMScaleMercatorPointAboutPoint %f %f about %f %f to %f %f", point.x, point.y, mercatorPivot.x, mercatorPivot.y, result.x, result.y);
	return result;
}

- (RMProjectedRect)zoomRect: (RMProjectedRect)aRect byFactor: (double)factor near:(CGPoint) aPixelPoint
{
	RMProjectedPoint XYPivot = [self projectScreenPointToXY:aPixelPoint];
	RMProjectedRect result = RMScaleProjectedRectAboutPoint(aRect, factor, XYPivot);
	result.origin = [projection wrapPointHorizontally:result.origin];
	return result;
}

-(void) moveScreenBy: (CGSize)delta
{
//	RMLog(@"move screen from %f %f", origin.easting, origin.y);

//	origin.easting -= delta.width * scale;
//	origin.y += delta.height * scale;

	// Reverse the delta - if the screen's contents moves left, the origin moves right.
	// It makes sense if you think about it long enough and squint your eyes a bit.

	delta.width = -delta.width;
	delta.height = -delta.height;
	origin = [self movePoint:origin by:delta];
	
//	RMLog(@"to %f %f", origin.easting, origin.y);
}

- (void) zoomScreenByFactor: (double) factor near:(CGPoint) aPixelPoint;
{
	// The result of this function should be the same as this:
	//RMMercatorPoint test = [self zoomPoint:origin ByFactor:1.0f / factor Near:pivot];

	// First we move the origin to the pivot...
    //NSLog(@"scale %f",factor);
	origin.easting += aPixelPoint.x * metersPerPixel;
	origin.northing += (screenBounds.size.height - aPixelPoint.y) * metersPerPixel;
	// Then scale by 1/factor
	metersPerPixel /= factor;
	// Then translate back
	origin.easting -= aPixelPoint.x * metersPerPixel;
	origin.northing -= (screenBounds.size.height - aPixelPoint.y) * metersPerPixel;

	origin = [projection wrapPointHorizontally:origin];
	
	//RMLog(@"test: %f %f", test.x, test.y);
	//RMLog(@"correct: %f %f", origin.easting, origin.y);
	
//	CGPoint p = [self projectMercatorPoint:[self projectScreenPointToMercator:CGPointZero]];
//	RMLog(@"origin at %f %f", p.x, p.y);
//	CGPoint q = [self projectMercatorPoint:[self projectScreenPointToMercator:CGPointMake(100,100)]];
//	RMLog(@"100 100 at %f %f", q.x, q.y);

}

- (void)zoomBy: (double) factor
{
	metersPerPixel *= factor;
}

/*
 This method returns the pixel point based on the currently displayed map view converted from a RMProjectedPoint.
 此方法用于将RMProjectedPoint转化为像素坐标
 origin是视图内的地理左下角点
 origin is the bottom left projected point currently displayed in the view.  The range of this value is based
 on the planetBounds.  planetBounds in turn is based on an RMProjection.  For example 
 look at +(RMProjection*)googleProjection to see range of values for planetBounds/origin.
 
 The tricky part is when the current map view contains the divider for horizontally wrapping maps.  
 
 Note: tested only with googleProjection
 */
- (CGPoint) projectXYPoint:(RMProjectedPoint)aPoint withMetersPerPixel:(double)aScale
{
	CGPoint	aPixelPoint = { 0, 0 };

    //视图内地理范围
	RMProjectedRect projectedScreenBounds;
	projectedScreenBounds.origin = origin;
	projectedScreenBounds.size.width = screenBounds.size.width * aScale;
	projectedScreenBounds.size.height = screenBounds.size.height * aScale;
	
	RMProjectedRect planetBounds = [projection planetBounds];
    //地图右上角
	RMProjectedPoint planetEndPoint = {planetBounds.origin.easting + planetBounds.size.width,
		planetBounds.origin.northing + planetBounds.size.height};
	
	
	// Normalize coordinate system so there is no negative values
    //正常化坐标系，没有负值
	RMProjectedRect normalizedProjectedScreenBounds;
	normalizedProjectedScreenBounds.origin.easting = projectedScreenBounds.origin.easting + planetEndPoint.easting;
	normalizedProjectedScreenBounds.origin.northing = projectedScreenBounds.origin.northing + planetEndPoint.northing;
	normalizedProjectedScreenBounds.size = projectedScreenBounds.size;
	
	RMProjectedPoint normalizedProjectedPoint;
	normalizedProjectedPoint.easting = aPoint.easting + planetEndPoint.easting;
	normalizedProjectedPoint.northing = aPoint.northing + planetEndPoint.northing;

	double rightMostViewableEasting;
	
	// check if world wrap divider is contained in view
	if (( normalizedProjectedScreenBounds.origin.easting + normalizedProjectedScreenBounds.size.width ) > planetBounds.size.width ) {
		rightMostViewableEasting = projectedScreenBounds.size.width - ( planetBounds.size.width - normalizedProjectedScreenBounds.origin.easting );
		// Check if Right of divider but on screen still
		if ( normalizedProjectedPoint.easting <= rightMostViewableEasting ) {
			aPixelPoint.x = ( planetBounds.size.width + normalizedProjectedPoint.easting - normalizedProjectedScreenBounds.origin.easting ) / aScale;
		} else {
			// everywhere else is left of divider
			aPixelPoint.x = ( normalizedProjectedPoint.easting - normalizedProjectedScreenBounds.origin.easting ) / aScale;
		}
		
	}
	else {
		// Divider not contained in view
		aPixelPoint.x = ( normalizedProjectedPoint.easting - normalizedProjectedScreenBounds.origin.easting ) / aScale;
	}
	
	aPixelPoint.y = screenBounds.size.height - ( normalizedProjectedPoint.northing - normalizedProjectedScreenBounds.origin.northing ) / aScale;
	return aPixelPoint;
}

/*
 - (CGPoint) projectXYPoint:(RMProjectedPoint)aPoint withMetersPerPixel:(double)aScale
 {
 CGPoint	aPixelPoint;
 CGdouble originX = origin.easting;
 CGdouble boundsWidth = [projection planetBounds].size.width;
 CGdouble pointX = aPoint.easting - boundsWidth/2;
 CGdouble left = sqrt((pointX - (originX - boundsWidth))*(pointX - (originX - boundsWidth)));
 CGdouble middle = sqrt((pointX - originX)*(pointX - originX));
 CGdouble right = sqrt((pointX - (originX + boundsWidth))*(pointX - (originX + boundsWidth)));
 
 //RMLog(@"left:%f middle:%f right:%f x:%f width:%f", left, middle, right, pointX, boundsWidth);//LK
 
 if(middle <= left && middle <= right){
 aPixelPoint.x = (aPoint.easting - originX) / aScale;
 } else if(left <= middle && left <= right){
 //RMLog(@"warning: projectXYPoint middle..");//LK
 aPixelPoint.x = (aPoint.easting - (originX)) / aScale;
 } else{ //right
 aPixelPoint.x = (aPoint.easting - (originX+boundsWidth)) / aScale;
 }
 
 aPixelPoint.y = screenBounds.size.height - (aPoint.northing - origin.northing) / aScale;
 return aPixelPoint;
 }
 */

- (CGPoint) projectXYPoint: (RMProjectedPoint)aPoint
{

	return [self projectXYPoint:aPoint withMetersPerPixel:metersPerPixel];
}

- (CGRect) projectXYRect: (RMProjectedRect) aRect
{
	CGRect aPixelRect;
	aPixelRect.origin = [self projectXYPoint: aRect.origin];
	aPixelRect.size.width = aRect.size.width / metersPerPixel;
	aPixelRect.size.height = aRect.size.height / metersPerPixel;
	return aPixelRect;
}

- (RMProjectedPoint)projectScreenPointToXY: (CGPoint) aPixelPoint withMetersPerPixel:(double)aScale
{
	RMProjectedPoint aPoint;
	aPoint.easting = origin.easting + aPixelPoint.x * aScale;
	aPoint.northing = origin.northing + (screenBounds.size.height - aPixelPoint.y) * aScale;
    origin = [projection wrapPointHorizontally:origin];
	return aPoint;
}

- (RMProjectedPoint) projectScreenPointToXY: (CGPoint) aPixelPoint
{
	// I will assume the point is within the screenbounds rectangle.
	
	return [projection wrapPointHorizontally:[self projectScreenPointToXY:aPixelPoint withMetersPerPixel:metersPerPixel]];
}

- (RMProjectedRect) projectScreenRectToXY: (CGRect) aPixelRect
{
	RMProjectedRect aRect;
	aRect.origin = [self projectScreenPointToXY: aPixelRect.origin];
	aRect.size.width = aPixelRect.size.width * metersPerPixel;
	aRect.size.height = aPixelRect.size.height * metersPerPixel;
	return aRect;
}

- (RMProjectedSize)projectScreenSizeToXY: (CGSize) aPixelSize
{
	RMProjectedSize aSize;
	aSize.width = aPixelSize.width * metersPerPixel;
	aSize.height = -aPixelSize.height * metersPerPixel;
	return aSize;
}
//视图内地理范围
- (RMProjectedRect) projectedBounds
{
	RMProjectedRect aRect;
	aRect.origin = origin;
	aRect.size.width = screenBounds.size.width * metersPerPixel;
	aRect.size.height = screenBounds.size.height * metersPerPixel;
    //NSLog(@"%.12f&&&&&&&&",metersPerPixel);
	return aRect;
}

-(void) setProjectedBounds: (RMProjectedRect) aRect
{
	double scaleX = aRect.size.width / screenBounds.size.width;
	double scaleY = aRect.size.height / screenBounds.size.height;
	
	// I will pick a scale in between those two.
	metersPerPixel = (scaleX + scaleY) / 2;
	origin = [projection wrapPointHorizontally:aRect.origin];
}

//新加方法设置经纬度
-(void) setProjectedBounds2: (RMProjectedRect) aRect
{
    double scaleX = aRect.size.width / screenBounds.size.width;
    double scaleY = aRect.size.height / screenBounds.size.height;
    // I will pick a scale in between those two.
    metersPerPixel = (scaleX + scaleY) / 2;
    origin = aRect.origin;
}

- (RMProjectedPoint) projectedCenter
{
	RMProjectedPoint aPoint;
	aPoint.easting = origin.easting + screenBounds.size.width * metersPerPixel / 2;
	aPoint.northing = origin.northing + screenBounds.size.height * metersPerPixel / 2;
	aPoint = [projection wrapPointHorizontally:aPoint];
	return aPoint;
}

- (void) setProjectedCenter: (RMProjectedPoint) aPoint
{
    
    origin = [projection wrapPointHorizontally:aPoint];

    //NSLog(@"x:%f,y:%f",origin.easting,origin.northing);
	origin.easting -= screenBounds.size.width * metersPerPixel / 2;
	origin.northing -= screenBounds.size.height * metersPerPixel / 2;
    //NSLog(@"x:%f,y:%f",origin.easting,origin.northing);
}

- (void) setScreenBounds:(CGRect)rect;
{
  screenBounds = rect;
}

-(CGRect) screenBounds
{
	return screenBounds;
}

-(double) metersPerPixel
{
	return metersPerPixel;
}

-(void) setMetersPerPixel: (double) newMPP
{
	// We need to adjust the origin - since the origin
	// is in the corner, it will change when we change the scale.
	
	RMProjectedPoint center = [self projectedCenter];
	metersPerPixel = newMPP;
	[self setProjectedCenter:center];
}

@end
