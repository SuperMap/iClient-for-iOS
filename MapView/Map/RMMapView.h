//
//  RMMapView.h
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

/*! \mainpage iOS SDK
\image html screenshot1.jpg
 
\section 产品介绍

SuperMap iClient 6R(2012) for iOS是一套基于iOS平台的轻量级地图软件开发包（SDK），提供了针对iPhone以及iPad移动设备的Web地图访问接口，包括地图浏览等基本接口，以及查询、量算、标绘等服务，同时支持离线数据的读取，在无网络条件下仍可便捷的访问地图。通过该产品可以在iOS平台下快速访问SuperMap iServer发布的REST地图服务。
\subsection 特点
 
 - 在iOS平台下访问SuperMap iServer REST地图服务，更加轻便、灵活
 - 不依赖于浏览器
 - 对接SuperMap iServer REST地图服务，提供丰富的地图框架的解决方案，用户更好的专注于自己的业务需求
\subsection 功能
 
 - 地图浏览，如缩放、漫游操作，支持多点触控
 - 地图属性支持设置固定比例尺
 - 地图查询（范围查询、距离查询、几何对象查询以及SQL查询）
 - 地图量算（距离、面积）
 - Marker标注及事件响应
 - 地物标绘及事件响应
\section 产品入门

产品入门在于帮助用户快速地了解 SuperMap iClient for iOS，掌握使用 SuperMap iClient for iOS API 进行开发的方法
SuperMap iClient for iOS完全开源，并不断的维护和开发，所以推荐的使用方式是从Github中直接获取
 \verbatim
 git clone git://github.com/route-me/route-me.git
 \endverbatim
 
下载后，里面有三个子文件夹（MapView、Proj4和samples），Proj4支持进行投影转换，MapView工程包含SuperMap Client for iOS SDK源码以及文档资料，而samples包含一系列基于SuperMap iClient for iOS的范例，可以直接运行和学习
 
\section 技术支持服务
您遇到问题后，在我们的帮助中没有找到理想的答案。我们提供了联系 SuperMap 技术支持的方式，您可以很方便的从技术支持工程师那里获得相应的技术支持与服务。
\subsection 在线支持服务：
 
 - 技术资源中心：<a href="http://support.supermap.com.cn">http://support.supermap.com.cn</a>
 - BBS 在线网址：<a href="http://www.gisforum.net">http://www.gisforum.net</a>
 - 公 司 网 址 ：<a href="http://www.supermap.com.cn">http://www.supermap.com.cn</a>
 
\subsection 电子邮件支持服务：
 
 - 如果您有什么问题，也可以直接发到我们的信箱里我们会及时收取您的信件，并尽快解决您的问题。
 - 技术支持电子邮箱：support@supermap.com
 - 如果您有投诉或建议，可以直接发到我们的客户监督电子邮箱里，我们会及时收取您的信件，并尽快解决您的问题。
 - 客户监督电子邮箱：cs@supermap.com

\section 许可

SuperMap iClient for iOS是一套开源的Objective-C语言的SDK，基于<a href=" https://github.com/route-me/route-me">Route-me</a>库扩展的SuperMap iServer REST服务。
许可的详细内容可参考License.txt
 
 
 
\section 其他

SuperMap iClient for iOS更多内容和更新，可以访问Github项目
 - wiki: https://github.com/route-me/route-me/wiki
 - project email reflector: http://groups.google.com/group/route-me-map
 - list of all project RSS feeds: http://code.google.com/p/route-me/feeds
 - applications using Route-Me: http://code.google.com/p/route-me/wiki/RoutemeApplications
 
 */

#import <UIKit/UIKit.h>
#import <CoreGraphics/CGGeometry.h>

#import "RMNotifications.h"
#import "RMFoundation.h"
#import "RMLatLong.h"
#import "RMMapViewDelegate.h"
#import "RMMapContents.h"
#import "RMSMLayerInfo.h"
#import "RMSMTileSource.h"
#import "MapView_Prefix.pch"

 /**
 * APIProperty: RMGestureDetails
 * {struct} iPhone-specific mapview stuff. Handles event handling, whatnot.
 * 手势的细节信息
 */
typedef struct {
	CGPoint center;
	double angle;
	double averageDistanceFromCenter;
	int numTouches;
} RMGestureDetails;

@class RMMapContents;

 /**
 * Class: RMMapView
 * Wrapper around RMMapContents for the iPhone.
 *
 *It implements event handling; but that's about it. All the interesting map
 *logic is done by RMMapContents. There is exactly one RMMapView instance for each RMMapContents instance.
 *
 *A -forwardInvocation method exists for RMMap, and forwards all unhandled messages to the RMMapContents instance.
 *
 *bug:No accessors for enableDragging, enableZoom, deceleration, decelerationFactor. Changing enableDragging does not change *multitouchEnabled for the view.
 */
@interface RMMapView : UIView <RMMapContentsFacade, RMMapContentsAnimationCallback>
{
	RMMapContents *contents;
	id<RMMapViewDelegate> delegate;
	BOOL enableDragging;
	BOOL enableZoom;
        BOOL enableRotate;
	RMGestureDetails lastGesture;
	double decelerationFactor;
	BOOL deceleration;
        double rotation;
    double screenScale;
    
    RMSMLayerInfo* m_info;
    RMSMTileSource* m_TileSource;
    BOOL bZoomOut;
    BOOL bRun;
    double lastTime;
	
@private
   	BOOL _delegateHasBeforeMapMove;
	BOOL _delegateHasAfterMapMove;
	BOOL _delegateHasBeforeMapZoomByFactor;
	BOOL _delegateHasAfterMapZoomByFactor;
	BOOL _delegateHasMapViewRegionDidChange;
	BOOL _delegateHasBeforeMapRotate;
	BOOL _delegateHasAfterMapRotate;
	BOOL _delegateHasDoubleTapOnMap;
	BOOL _delegateHasSingleTapOnMap;
	BOOL _delegateHasTapOnMarker;
	BOOL _delegateHasTapOnLabelForMarker;
	BOOL _delegateHasTapOnLabelForMarkerOnLayer;
	BOOL _delegateHasAfterMapTouch;
	BOOL _delegateHasShouldDragMarker;
	BOOL _delegateHasDidDragMarker;
	BOOL _delegateHasDragMarkerPosition;
    BOOL _delegateHasLongTapOnMap;
	
	NSTimer *_decelerationTimer;
	CGSize _decelerationDelta;
	
	BOOL _constrainMovement;
	RMProjectedPoint NEconstraint, SWconstraint;
	
	BOOL _contentsIsSet; // "contents" must be set, but is initialized lazily to allow apps to override defaults in -awakeFromNib
}

/// Any other functionality you need to manipulate the map you can access through this
/// property. The RMMapContents class holds the actual map bits.
@property (nonatomic, retain) RMMapContents *contents;

// View properties
@property (readwrite) double pressTime;
@property (readwrite) BOOL enableDragging;
@property (readwrite) BOOL enableZoom;
@property (readwrite) BOOL enableRotate;
@property (readwrite) BOOL bZoomOut;
@property (readwrite) BOOL bRun;
@property (readwrite) double lastTime;

@property (nonatomic, retain, readonly) RMMarkerManager *markerManager;

// do not retain the delegate so you can let the corresponding controller implement the
// delegate without circular references
@property (assign) id<RMMapViewDelegate> delegate;
@property (readwrite) double decelerationFactor;
@property (readwrite) BOOL deceleration;

@property (readonly) double rotation;

- (id)initWithFrame:(CGRect)frame;
- (id)initWithFrame:(CGRect)frame screenScale:(double)screenScale;
- (id)initWithFrame:(CGRect)frame WithLocation:(CLLocationCoordinate2D)latlong;

//recenter the map on #latlong, expressed as CLLocationCoordinate2D (latitude/longitude)
/**
 * APIMethod: moveToLatLong
 * 重置地图的中心点，该中心点为经纬度坐标。
 *
 ** Parameters:
 * latlong - {CLLocationCoordinate2D}  
 */
- (void)moveToLatLong: (CLLocationCoordinate2D)latlong;

/**
 * APIMethod: moveToProjectedPoint
 * 重置地图的中心点，该中心点为平面坐标。
 *
 ** Parameters:
 * aPoint - {RMProjectedPoint}  
 */
- (void)moveToProjectedPoint: (RMProjectedPoint)aPoint;

- (void)moveBy: (CGSize) delta;

-(void)setConstraintsSW:(CLLocationCoordinate2D)sw NE:(CLLocationCoordinate2D)ne;
- (void)setProjectedContraintsSW:(RMProjectedPoint)sw NE:(RMProjectedPoint)ne;

- (void)zoomByFactor: (double) zoomFactor near:(CGPoint) aPoint;
- (void)zoomByFactor: (double) zoomFactor near:(CGPoint) aPoint animated:(BOOL)animated;

- (void)didReceiveMemoryWarning;

- (void)setRotation:(double)angle;


@end
