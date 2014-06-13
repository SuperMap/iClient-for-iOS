//
//  RMMarkerManager.h
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

#import <UIKit/UIKit.h>

#import "RMMapContents.h"
#import "RMMarker.h"

@class RMProjection;
/**
 * Class: RMMarkerManager
 * Marker管理图层类
 * 用于添加、删除、显示Marker
 *
 */
@interface RMMarkerManager : NSObject {
	RMMapContents *contents;
        CGAffineTransform rotationTransform;
}

@property (assign, readwrite)  RMMapContents *contents;

/**
 * Constructor: initWithContents
 * Marker管理图层类构造函数。
 *
 * Parameters:
 * mapContents - {RMMapContents} 
 *
 */
- (id)initWithContents:(RMMapContents *)mapContents;

/**
 * APIMethod: addMarker
 * 在一地理坐标上添加Marker
 *
 ** Parameters:
 * marker - {RMMarker} 需要添加的marker
 * projectedPoint - {RMProjectedPoint} 当前所添加marker的地理坐标
 */
- (void)addMarker:(RMMarker *)marker atProjectedPoint:(RMProjectedPoint)projectedPoint;

/**
 * APIMethod: addMarker
 * 在一经纬度坐标上添加Marker
 *
 ** Parameters:
 * marker - {RMMarker} 需要添加的marker
 * point - {CLLocationCoordinate2D} 当前所添加marker的经纬度坐标
 */
- (void) addMarker: (RMMarker*)marker AtLatLong:(CLLocationCoordinate2D)point;

/**
 * APIMethod: removeMarkers
 * 移除所有的Marker
 *
 */
- (void) removeMarkers;

/**
 * APIMethod: hideAllMarkers
 * 隐藏所有的Marker
 *
 */
- (void) hideAllMarkers;

/**
 * APIMethod: hideAllMarkers
 * 显示所有的Marker
 *
 */
- (void) unhideAllMarkers;

/**
 * APIMethod: markers
 * 获取所有的Marker
 *
 * Returns:
 * {NSArray}  获取所有的Marker
 */
- (NSArray *)markers;

/**
 * APIMethod: removeMarker
 * 移除marker
 *
 ** Parameters:
 * marker - {RMMarker} 需要移除的marker
 */
- (void) removeMarker:(RMMarker *)marker;

/**
 * APIMethod: removeMarkers
 * 移除marker列表
 *
 ** Parameters:
 * markers - {NSArray} 需要移除的marker列表
 */
- (void) removeMarkers:(NSArray *)markers;

/**
 * APIMethod: screenCoordinatesForMarker
 * 获取marker所在的屏幕坐标
 *
 ** Parameters:
 * marker - {RMMarker} marker
 */
- (CGPoint) screenCoordinatesForMarker: (RMMarker *)marker;

- (CLLocationCoordinate2D) latitudeLongitudeForMarker: (RMMarker *) marker;
- (NSArray *) markersWithinScreenBounds;
- (BOOL) isMarkerWithinScreenBounds:(RMMarker*)marker;
- (BOOL) isMarker:(RMMarker*)marker withinBounds:(CGRect)rect;
- (BOOL) managingMarker:(RMMarker*)marker;
- (void) moveMarker:(RMMarker *)marker AtLatLon:(RMLatLong)point;
- (void) moveMarker:(RMMarker *)marker AtXY:(CGPoint)point;
- (void)setRotation:(float)angle;



@end
