//
//  RMMercatorToScreenProjection.h
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

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

#import "RMFoundation.h"

@class RMProjection;

/**
 * Class: RMMercatorToScreenProjection
 * This is a stateful projection. As the screen moves around, so too do projections change.
 */
@interface RMMercatorToScreenProjection : NSObject
{
	/// What the screen is currently looking at.
	RMProjectedPoint origin;

	/// The mercator -or-whatever- projection that the map is in.
	/// This projection move linearly with the screen.
	RMProjection *projection;
	
	/// Bounds of the screen in pixels
	/// \bug name is "screenBounds" but is probably the view, not the whole screen?
	CGRect screenBounds;

	/// \brief meters per pixel
	float metersPerPixel;}

- (id) initFromProjection: (RMProjection*) projection ToScreenBounds: (CGRect)aScreenBounds;

/**
 * APIMethod: movePoint: by:
 * Deltas in screen coordinates.
 *
 * Parameters:
 * aPoint - {<RMProjectedPoint>} 
 * delta - {<CGSize>}
 *
 * Returns:
 * {<RMProjectedPoint>}
 */
- (RMProjectedPoint)movePoint: (RMProjectedPoint)aPoint by:(CGSize) delta;

/**
 * APIMethod: moveRect by:
 * Deltas in screen coordinates.
 *
 * Parameters:
 * aRect - {<RMProjectedRect>} 
 * delta - {<CGSize>}
 *
 * Returns:
 * {<RMProjectedRect>}
 */
- (RMProjectedRect)moveRect: (RMProjectedRect)aRect by:(CGSize) delta;

/**
 * APIMethod: zoomPoint: byFactor: near:
 * pivot given in screen coordinates.
 *
 * Parameters:
 * aPoint - {<RMProjectedPoint>} 
 * factor - {float}
 * pivot - {CGPoint}
 *
 * Returns:
 * {<RMProjectedPoint>}
 */
- (RMProjectedPoint)zoomPoint: (RMProjectedPoint)aPoint byFactor: (float)factor near:(CGPoint) pivot;
 
/**
 * APIMethod: zoomRect:byFactor:near:
 * pivot given in screen coordinates.
 *
 * Parameters:
 * aRect - {<RMProjectedRect>}
 * factor - {float}
 * pivot - {CGPoint}
 *
 * Returns:
 * {<RMProjectedRect>}
 */
- (RMProjectedRect)zoomRect: (RMProjectedRect)aRect byFactor: (float)factor near:(CGPoint) pivot;

/**
 * APIMethod: moveScreenBy:
 * Move the screen.
 *
 * Parameters:
 * delta - {<CGSize>} 
 */
- (void) moveScreenBy: (CGSize) delta;
- (void) zoomScreenByFactor: (float) factor near:(CGPoint) aPoint;

/**
 * APIMethod: projectXYPoint: withMetersPerPixel:
 * Project -> screen coordinates.
 *
 * Parameters:
 * aPoint - {<RMProjectedPoint>} 
 * aScale - {float}
 *
 * Returns:
 * {<CGPoint>}
 */
- (CGPoint)projectXYPoint:(RMProjectedPoint)aPoint withMetersPerPixel:(float)aScale;

/// Project -> screen coordinates.
- (CGPoint) projectXYPoint: (RMProjectedPoint) aPoint;

/**
 * APIMethod: projectXYRect:
 * Project -> screen coordinates.
 *
 * Parameters:
 * aRect - {<RMProjectedRect>} 
 *
 * Returns:
 * {<CGRect>}
 */
- (CGRect) projectXYRect: (RMProjectedRect) aRect;

- (RMProjectedPoint) projectScreenPointToXY: (CGPoint) aPoint;
- (RMProjectedRect) projectScreenRectToXY: (CGRect) aRect;
- (RMProjectedSize)projectScreenSizeToXY: (CGSize) aSize;
- (RMProjectedPoint)projectScreenPointToXY: (CGPoint) aPixelPoint withMetersPerPixel:(float)aScale;

- (RMProjectedRect) projectedBounds;
- (void) setProjectedBounds: (RMProjectedRect) bounds;
- (RMProjectedPoint) projectedCenter;
- (void) setProjectedCenter: (RMProjectedPoint) aPoint;
- (void) setScreenBounds:(CGRect)rect;
- (CGRect) screenBounds;

@property (assign, readwrite) float metersPerPixel;
@property (assign, readwrite) RMProjectedPoint origin;
@property (nonatomic,readonly) RMProjection *projection;
-(void)deepCopy:(RMMercatorToScreenProjection *)copy;

@end
