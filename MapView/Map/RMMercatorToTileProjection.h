//
//  RMMercatorToTileProjection.h
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
#import "RMFoundation.h"
#import "RMTile.h"
#import "RMMercatorToTileProjection.h"

@class RMMercatorToScreenProjection;

/**
 * Class: RMMercatorToTileProjection
 * A tile projection is a projection which turns mercators into tile coordinates.
 * At time of writing, read RMFractalTileProjection to see the implementation of this.
 */
@protocol RMMercatorToTileProjection<NSObject>

-(RMTilePoint) project: (RMProjectedPoint)aPoint atZoom:(double)zoom;
-(RMTileRect) projectRect: (RMProjectedRect)aRect atZoom:(double)zoom;

-(RMTilePoint) project: (RMProjectedPoint)aPoint atScale:(double)scale;
-(RMTileRect) projectRect: (RMProjectedRect)aRect atScale:(double)scale;
- (void) setIsBaseLayer:(BOOL)bIsBaseLayer;
/// This is a helper for projectRect above. Much simpler for the caller.
-(RMTileRect) project: (RMMercatorToScreenProjection*)screen;

-(RMTile) normaliseTile: (RMTile) tile;

-(double) normaliseZoom: (double) zoom;

-(double) calculateZoomFromScale: (double) scale;
-(double) calculateNormalisedZoomFromScale: (double) scale;
-(double) calculateScaleFromZoom: (double) zoom;

/**
 * APIProperty: planetBounds
 * {RMProjectedRect} bounds of the earth, in projected units (meters).
 */
@property(readonly, nonatomic) RMProjectedRect planetBounds;

/**
 * APIProperty: maxZoom
 * {NSUInteger} Maximum zoom for which we have tile images
 */ 
@property(readonly, nonatomic) NSUInteger maxZoom;
/**
 * APIProperty: minZoom
 * {NSUInteger} Minimum zoom for which we have tile images 
 */ 
@property(readonly, nonatomic) NSUInteger minZoom;
@property(readonly, nonatomic) NSUInteger curZoom;
@property(readonly, nonatomic) CGFloat curScale;
/**
 * APIProperty: tileSideLength
 * {NSUInteger} Tile side length in pixels
 */ 
@property(readonly, nonatomic) NSUInteger tileSideLength;

@end
