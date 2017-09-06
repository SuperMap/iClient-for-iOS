//
//  RMPath.h
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

#import "RMFoundation.h"
#import "RMLatLong.h"
#import "RMMapLayer.h"

@class RMMapContents;
@class RMMapView;
/**
 * Class: RMPath
 * 几何对象图层类，主要用于绘制点、线、多边形。
 *
 * Inherits from:
 *  - <RMMapLayer>
 */
@interface RMPath : RMMapLayer <RMMovingMapLayer> {
    BOOL bIsClosePath;
    
    NSMutableArray* parts;
    NSMutableArray* points;
    int nTempParts;
}

/**
 * Constructor: initWithContents
 * RMPath类构造函数。
 *
 * Parameters:
 * aContents - {RMMapContents}
 *
 */
- (id) initWithContents: (RMMapContents*)aContents;

/**
 * Constructor: initForMap
 * RMPath类构造函数。
 *
 * Parameters:
 * map - {RMMapView}
 *
 */
- (id) initForMap: (RMMapView*)map;

/**
 * Constructor: initForMap
 * RMPath类构造函数。
 *
 * Parameters:
 * map - {RMMapView}
 * coordinates - {CLLocationCoordinate2D}
 * aContents - {NSInteger}
 *
 */
- (id) initForMap: (RMMapView*)map withCoordinates:(const CLLocationCoordinate2D*)coordinates count:(NSInteger)count;

/**
 * APIMethod: moveToXY
 * 设置点，或设置线、多边形的起点。此点为RMProjectedPoint。
 *
 ** Parameters:
 * point - {RMProjectedPoint} 点，或线、多边形的起点
 */
- (void) moveToXY: (RMProjectedPoint) point;

/**
 * APIMethod: moveToScreenPoint
 * 设置点，或设置线、多边形的起点。此点为CGPoint。
 *
 ** Parameters:
 * point - {CGPoint} 点，或线、多边形的起点
 */
- (void) moveToScreenPoint: (CGPoint) point;

/**
 * APIMethod: moveToLatLong
 * 设置点，或设置线、多边形的起点。此点为RMLatLong。
 *
 ** Parameters:
 * point - {RMLatLong} 点，或线、多边形的起点
 */
- (void) moveToLatLong: (RMLatLong) point;

/**
 * APIMethod: addLineToXY
 * 设置线段的终点，创建了一条线段，起点是设置的起点或所创建的前一条线段的终点。此终点为RMProjectedPoint。
 *
 ** Parameters:
 * point - {RMProjectedPoint} 线段的终点
 */
- (void) addLineToXY: (RMProjectedPoint) point;

/**
 * APIMethod: addLineToScreenPoint
 * 设置线段的终点，创建了一条线段，起点是设置的起点或所创建的前一条线段的终点。此终点为CGPoint。
 *
 ** Parameters:
 * point - {CGPoint} 线段的终点
 */
- (void) addLineToScreenPoint: (CGPoint) point;

/**
 * APIMethod: addLineToLatLong
 * 设置线段的终点，创建了一条线段，起点是设置的起点或所创建的前一条线段的终点。此终点为RMLatLong。
 *
 ** Parameters:
 * point - {RMLatLong} 线段的终点
 */
- (void) addLineToLatLong: (RMLatLong) point;

/**
 * APIMethod: closePath
 * 闭合多边形，连接多边形的起点和最后一个点为一条线段。
 *
 */
- (void) closePath;

//获取中心
-(RMProjectedPoint)getCentroid;
/**
 * APIProperty: lineCap
 * {<CGLineCap>} 线的端点显示类型
 */
@property (nonatomic, assign) CGLineCap lineCap;

/**
 * APIProperty: lineJoin
 * {<CGLineJoin>} 线的拐角显示类型
 */
@property (nonatomic, assign) CGLineJoin lineJoin;

/**
 * APIProperty: lineWidth
 * {float} 线宽
 */
@property (nonatomic, assign) float lineWidth;

/**
 * APIProperty: scaleLineWidth
 * {BOOL} 是否随地图缩放
 */
@property (nonatomic, assign) BOOL	scaleLineWidth;

/**
 * APIProperty: shadowBlur
 * {CGFloat} 阴影模糊级别
 *
 */
@property (nonatomic, assign) CGFloat shadowBlur;

/**
 * APIProperty: shadowOffset
 * {CGSize} 阴影偏移
 *
 */
@property (nonatomic, assign) CGSize shadowOffset;

/**
 * APIProperty: shadowColor
 * {UIColor} 阴影的颜色
 *
 */
@property (nonatomic, retain) UIColor *shadowColor;
////////////////////////////////
/**
 *APIProperty: lineDashLengths
 *{NSArray} 线的类型编码
 *
 */
@property (nonatomic, assign) NSArray *lineDashLengths;
////////////////////////////////
/**
 *APIProperty: lineDashPhase
 *{CGFloat}
 *
 */
@property (nonatomic, assign) CGFloat lineDashPhase;
////////////////////////////////
/**
 *APIProperty: scaleLineDash
 *{BOOL}
 *
 */
@property (nonatomic, assign) BOOL scaleLineDash;
//起点
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
 * {UIColor} 线的颜色
 *
 */
@property (nonatomic, readwrite, assign) UIColor *lineColor;

/**
 * APIProperty: fillColor
 * {UIColor} 多边形的填充色
 *
 */
@property (nonatomic, readwrite, assign) UIColor *fillColor;

/**
 * APIProperty: CGPath
 * {<CGPathRef>} 阴影偏移
 *
 */
@property (nonatomic, readonly) CGPathRef CGPath;

@property (nonatomic, readonly) RMProjectedRect projectedBounds;

/**
 * APIProperty: bIsClosePath
 * {BOOL} 是否闭合，即是否为多边形。
 *
 */
@property (readonly) BOOL bIsClosePath;

/**
 * APIProperty: parts
 * {NSMutableArray} 组成多边形的子对象集合
 *
 */
@property (retain,readwrite) NSMutableArray* parts;

/**
 * APIProperty: points
 * {NSMutableArray} 组成线、多边形的点集合
 *
 */
@property (retain,readwrite) NSMutableArray* points;

@end

