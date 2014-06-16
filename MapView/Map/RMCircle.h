//
//  RMCircle.h
//
// Copyright (c) 2008-2010, Route-Me Contributors
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
#import "RMLatLong.h"
#import "RMMapLayer.h"

@class RMMapContents;

/**
 * Class: RMCircle
 * 几何对象图层类，主要用于绘制圆。
 *
 * Inherits from:
 *  - <RMMapLayer>
 */
@interface RMCircle : RMMapLayer <RMMovingMapLayer> {
@private
	RMMapContents* mapContents;
	CAShapeLayer* shapeLayer;
	
	RMLatLong latLong;
	RMProjectedPoint projectedLocation;
	BOOL enableDragging;
	BOOL enableRotation;
	
	UIColor* lineColor;
	UIColor* fillColor;
	CGFloat radiusInMeters;
	CGFloat lineWidthInPixels;
	BOOL scaleLineWidth;
	
	CGMutablePathRef circlePath;
}

//画圆的图层
@property (nonatomic, retain) CAShapeLayer* shapeLayer;
/**
 * APIProperty: projectedLocation
 * {<RMProjectedPoint>} 圆心
 *
 */
@property (nonatomic, assign) RMProjectedPoint projectedLocation;

/**
 * APIProperty: enableDragging
 * {BOOL} 是否随地图移动
 *
 */
@property (assign) BOOL enableDragging;

/**
 * APIProperty: enableRotation
 * {BOOL} 是否随地图旋转
 *
 */
@property (assign) BOOL enableRotation;

/**
 * APIProperty: lineColor
 * {UIColor} 边缘线的颜色
 *
 */
@property (nonatomic, retain) UIColor* lineColor;

/**
 * APIProperty: fillColor
 * {UIColor} 填充色
 *
 */
@property (nonatomic, retain) UIColor* fillColor;

/**
 * APIProperty: radiusInMeters
 * {CGFloat} 半径
 */
@property (nonatomic, assign) CGFloat radiusInMeters;

/**
 * APIProperty: lineWidthInPixels
 * {CGFloat} 线宽
 */
@property (nonatomic, assign) CGFloat lineWidthInPixels;


/**
 * Constructor: initWithContents
 * RMCircle类构造函数。
 *
 ** Parameters:
 * aContents - {RMMapContents}
 * newRadiusInMeters - {CGFloat} 半径,单位：米。
 * newLatLong - {RMLatLong} 圆心
 * 
 */
- (id)initWithContents:(RMMapContents*)aContents radiusInMeters:(CGFloat)newRadiusInMeters latLong:(RMLatLong)newLatLong;
- (void)moveToLatLong:(RMLatLong)newLatLong;

@end
