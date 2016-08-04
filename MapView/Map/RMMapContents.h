//
//  RMMapContents.h
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
@class RMSMLayerInfo;
#import <UIKit/UIKit.h>

#import "RMFoundation.h"
#import "RMLatLong.h"
#import "RMTile.h"
#import "RMTileSourcesContainer.h"

#import "RMTilesUpdateDelegate.h"
#import "MapView_Prefix.pch"
// constants for boundingMask
enum {
	// Map can be zoomed out past view limits
	RMMapNoMinBound			= 0,
	// Minimum map height when zooming out restricted to view height
	RMMapMinHeightBound		= 1,
	// Minimum map width when zooming out restricted to view width ( default )
	RMMapMinWidthBound		= 2
};

#define kDefaultInitialLatitude  0//4614406.969325
#define kDefaultInitialLongitude 0//11733502.481499

#define kDefaultMinimumZoomLevel 0.0
#define kDefaultMaximumZoomLevel 25.0
#define kDefaultInitialZoomLevel 0.0

@class RMMarkerManager;
@class RMProjection;
@class RMMercatorToScreenProjection;
@class RMTileImageSet;
@class RMTileLoader;
@class RMMapRenderer;
@class RMMapLayer;
@class RMLayerCollection;
@class RMMarker;
@protocol RMMercatorToTileProjection;
@protocol RMTileSource;


@protocol RMMapContentsAnimationCallback <NSObject>
@optional
- (void)animationFinishedWithZoomFactor:(double)zoomFactor near:(CGPoint)p;
- (void)animationStepped;
@end


/**
 * Class: RMMapContents
 * The cartographic and data components of a map. Do not retain.
 *
 * There is exactly one RMMapContents instance for each RMMapView instance.
 *
 * warning:Do not retain an RMMapContents instance. Instead, ask the RMMapView for its contents
 * when you need it. It is an error for an RMMapContents instance to exist without a view, and
 * if you retain the RMMapContents, it can't go away when the RMMapView is released.
 *
 * At some point, it's likely that RMMapContents and RMMapView will be merged into one class.
 */
@interface RMMapContents : NSObject
{
	/// This is the underlying UIView's layer.
	CALayer *layer;
    
    CALayer *superTileSouceLayer;
	
    RMTileSourcesContainer *tileSourcesContainer;
    NSMutableArray *earlyTileSources;
    
    NSMutableArray *baseLayeScals;
    
	RMMarkerManager *markerManager;
	/// subview for the image displayed while tiles are loading. Set its contents by providing your own "loading.png".
    ///用于加载tiles后显示image的子图层
	RMMapLayer *background;
	/// subview for markers and paths
    ///用于加载markers 和paths的子图层集合
	RMLayerCollection *overlay;
	
	/// (guess) the projection object to convert from latitude/longitude to meters.
	/// Latlong is calculated dynamically from mercatorBounds.
	RMProjection *projection;
	
	id<RMMercatorToTileProjection> mercatorToTileProjection;
//	RMTileRect tileBounds;
	
	/// (guess) converts from projected meters to screen pixel coordinates
	RMMercatorToScreenProjection *mercatorToScreenProjection;
	
	/// controls what images are used. Can be changed while the view is visible, but see http://code.google.com/p/route-me/issues/detail?id=12
	////
    //id<RMTileSource> tileSource;
	
	NSMutableArray *imagesOnScreens;
	NSMutableArray *tileLoaders;
	NSMutableArray *renderers;
	//RMMapRenderer *renderer;
	NSUInteger		boundingMask;
	
    NSMutableArray *baseLayerScales;
	/// minimum zoom number allowed for the view. #minZoom and #maxZoom must be within the limits of #tileSource but can be stricter; they are clamped to tilesource limits if needed.
    ///最小的缩放级别，其值必须在tileSource的缩放级别范围内，即其值必须不小0且不大于最大缩放级别数。
	double minZoom;
	/// maximum zoom number allowed for the view. #minZoom and #maxZoom must be within the limits of #tileSource but can be stricter; they are clamped to tilesource limits if needed.
    ///最大的缩放级别，其值必须在tileSource的缩放级别范围内，即其值必须不小0且不大于最大缩放级别数。
	double maxZoom;
    //设备的屏幕分辨率，屏幕类型（普通或者视网膜屏幕）不一样，相同尺寸的屏幕分辨率不一样
    //以iphone为例，若值为1，代表当前设备是320*480的分辨率（iphone4之前的设备），若值为2，是代表采用了名为Retina的显示技术后的分辨率，为640*960的分辨率。
    double screenScale;

	id<RMTilesUpdateDelegate> tilesUpdateDelegate;
}

@property (readwrite) CLLocationCoordinate2D mapCenter;
@property (readwrite) RMProjectedPoint centerProjectedPoint;
@property (readwrite) CGPoint zoomCenter;
//新增纠偏接口，用户传入纠偏量， 用于纠正底图与叠加层偏移
@property(nonatomic)CGSize redressValue;
/**
 * APIProperty: projectedBounds
 *  视图内地理范围 origin:表示地图左下角的地理坐标，size：表示地图的横向和纵向地理坐标范围
 *
 * Returns:
 * {<RMProjectedRect>}
 */
@property (readwrite) RMProjectedRect projectedBounds;
@property (readonly)  RMTileRect tileBounds;
@property (readonly)  CGRect screenBounds;

@property (readwrite) double metersPerPixel;

@property (readonly)  double scaledMetersPerPixel;
@property (readonly)  NSMutableArray *baseLayerScales;

@property (retain)  NSMutableArray *renderers;
//zoom level is clamped to range (minZoom, maxZoom)
/**
 * APIProperty: zoom
 * {double} 缩放级别，其值必须在tileSource的缩放级别范围内，即其值必须不小0且不大于最大缩放级别数。
 */
@property (readwrite) double zoom;

@property (nonatomic, readwrite) double minZoom, maxZoom;

@property (nonatomic, readonly) double screenScale;

//@property (readonly)  RMTileImageSet *imagesOnScreen;
//@property (readonly)  RMTileLoader *tileLoader;

@property (readonly)  RMProjection *projection;
@property (retain,readonly)  id<RMMercatorToTileProjection> mercatorToTileProjection;
@property (readonly)  RMMercatorToScreenProjection *mercatorToScreenProjection;

//@property (retain, readwrite) id<RMTileSource> tileSource;
//@property (retain, readwrite) RMMapRenderer *renderer;

@property (readonly)  CALayer *layer;

@property (retain, readwrite) RMMapLayer *background;
@property (retain, readwrite) RMLayerCollection *overlay;
@property (retain, readonly)  RMMarkerManager *markerManager;
/// \bug probably shouldn't be retaining this delegate
@property (nonatomic, retain) id<RMTilesUpdateDelegate> tilesUpdateDelegate;
@property (readwrite) NSUInteger boundingMask;

//The denominator in a cartographic scale like 1/24000, 1/50000, 1/2000000.
/**
 * APIProperty: scaleDenominator
 * {double} 比例尺的分母值，其比例尺形如1/24000, 1/50000, 1/2000000。
 */
@property (readonly)double scaleDenominator;

// tileDepth defaults to zero. if tiles have no alpha, set this higher, 3 or so, to make zooming smoother
@property (readwrite, assign) short tileDepth;
@property (readonly, assign) BOOL fullyLoaded;

/**
 * Constructor: initWithView
 * 用于初始化RMMapContents
 *
 * Parameters:
 * view - {UIView}  mapView。
 */
- (id)initWithView: (UIView*) view;


/**
 * Constructor: initWithView
 * 用于初始化RMMapContents
 *
 * Parameters:
 * view - {UIView}  mapView。
 * tilesource - {id<RMTileSource>} 地图服务，底图。
 */
- (id)initWithView: (UIView*) view tilesource:(id<RMTileSource>)newTilesource;

/**
 * Constructor: initWithView
 * 用于初始化RMMapContents
 *
 * Parameters:
 * view - {UIView}  mapView。
 * tilesource - {id<RMTileSource>} 地图服务，底图。
 * screenScale - {double} 设备的屏幕分辨率的属性值
 */
- (id)initWithView: (UIView*) view tilesource:(id<RMTileSource>)newTilesource screenScale:(double)theScreenScale;

/// designated initializer
/**
 * Constructor: initWithView
 * 用于初始化RMMapContents
 *
 * Parameters:
 * view - {UIView}  mapView。
 * tilesource - {id<RMTileSource>} 地图服务，底图。
 * centerLatLon - {CLLocationCoordinate2D} 地图的中心点
 * zoomLevel - {double} 地图初始化时的缩放级别
 * maxZoomLevel - {double} 最大缩放级别
 * minZoomLevel - {double} 最小缩放级别
 * backgroundImage - {UIImage *} 
 * screenScale - {double} 设备的屏幕分辨率的属性值
 */
- (id)initWithView:(UIView*)view
		tilesource:(id<RMTileSource>)tilesource
	  centerLatLon:(CLLocationCoordinate2D)initialCenter
		 zoomLevel:(double)initialZoomLevel
	  maxZoomLevel:(double)maxZoomLevel
	  minZoomLevel:(double)minZoomLevel
   backgroundImage:(UIImage *)backgroundImage
       screenScale:(double)theScreenScale;


/**
 * APIMethod: addTileSource
 * 添加叠加图层
 *
 * Parameters:
 * newTileSource - {id <RMTileSource>} 地图服务，叠加图层
 *
 */
- (void)addTileSource:(id <RMTileSource>)newTileSource;

/**
 * APIMethod: addTileSource
 * 添加叠加图层
 *
 * Parameters:
 * newTileSource - {id <RMTileSource>} 地图服务，叠加图层
 * index - {NSUInteger} 图层的索引值
 */
- (void)addTileSource:(id<RMTileSource>)newTileSource atIndex:(NSUInteger)index;

/**
 * APIMethod: removeTileSource
 * 移除叠加图层
 * 底图不能被移除。
 *
 * Parameters:
 * tileSource - {id <RMTileSource>} 地图服务，所移除的图层
 *
 */
- (void)removeTileSource:(id <RMTileSource>)tileSource;

/**
 * APIMethod: removeTileSource
 * 移除叠加图层
 * 底图不能被移除。
 *
 * Parameters:
 * tileSource - {id <RMTileSource>} 地图服务，所需移除的图层
 * index - {NSUInteger} 图层的索引值
 *
 */
- (void)removeTileSourceAtIndex:(NSUInteger)index;

/**
 * APIMethod: setHidden
 * 隐藏图层
 *
 * Parameters:
 * tileSource - {id <RMTileSource>} 地图服务，所需隐藏的图层
 */
- (void)setHidden:(BOOL)isHidden forTileSource:(id <RMTileSource>)tileSource;

/**
 * APIMethod: setHidden
 * 隐藏图层
 *
 * Parameters:
 * tileSource - {id <RMTileSource>} 地图服务，所需隐藏的图层
 * index - {NSUInteger} 图层的索引值
 */
- (void)setHidden:(BOOL)isHidden forTileSourceAtIndex:(NSUInteger)index;

/**
 * APIMethod: setOpacity
 * 设置图层的透明度
 *
 * Parameters:
 * opacity - {double} 图层的透明度，其中在[0,1]区间内，默认为1，即不透明。
 * tileSource - {id <RMTileSource>} 地图服务，所设置透明度的图层
 */
- (void)setOpacity:(double)opacity forTileSource:(id <RMTileSource>)tileSource;

/**
 * APIMethod: setOpacity
 * 设置图层的透明度
 *
 * Parameters:
 * opacity - {double} 图层的透明度，其中在[0,1]区间内，默认为1，即不透明。
 * index - {NSUInteger} 所设置透明度的图层的索引值
 */
- (void)setOpacity:(double)opacity forTileSourceAtIndex:(NSUInteger)index;

-(void) setZoom2: (NSUInteger) zoom;
/**
 *subject to removal at any moment after 0.5 is released
 *发布了版本0.5后，此方法会被弃用。
 */
- (id) initForView: (UIView*) view;
/// \发布了版本0.5后，此方法会被弃用。
- (id) initForView: (UIView*) view WithLocation:(CLLocationCoordinate2D)latlong;
/// \发布了版本0.5后，此方法会被弃用。
- (id)initForView:(UIView*)view WithTileSource:(id<RMTileSource>)tileSource WithRenderer:(RMMapRenderer*)renderer LookingAt:(CLLocationCoordinate2D)latlong;

- (void)setFrame:(CGRect)frame;

- (void)handleMemoryWarningNotification:(NSNotification *)notification;
- (void)didReceiveMemoryWarning;

- (void)moveToLatLong: (CLLocationCoordinate2D)latlong;
/**
 * APIMethod: moveToProjectedPoint
 * 用于重置地图的中心点
 *
 ** Parameters:
 * aPoint - {RMProjectedPoint}  
 */
- (void)moveToProjectedPoint: (RMProjectedPoint)aPoint;

- (void)moveBy: (CGSize) delta;
- (void)zoomByFactor: (double) zoomFactor near:(CGPoint) center;
- (void)zoomInToNextNativeZoomAt:(CGPoint) pivot animated:(BOOL) animated;
- (void)zoomOutToNextNativeZoomAt:(CGPoint) pivot animated:(BOOL) animated; 
- (void)zoomByFactor: (double) zoomFactor near:(CGPoint) center animated:(BOOL) animated;
- (void)zoomByFactor: (double) zoomFactor near:(CGPoint) center animated:(BOOL) animated withCallback:(id<RMMapContentsAnimationCallback>)callback;

- (void)zoomInToNextNativeZoomAt:(CGPoint) pivot;
- (void)zoomOutToNextNativeZoomAt:(CGPoint) pivot; 
- (double)adjustZoomForBoundingMask:(double)zoomFactor;
- (void)adjustMapPlacementWithScale:(double)aScale;
- (double)nextNativeZoomFactor;
- (double)prevNativeZoomFactor;

- (void) drawRect: (CGRect) rect;

//-(void)addLayer: (id<RMMapLayer>) layer above: (id<RMMapLayer>) other;
//-(void)addLayer: (id<RMMapLayer>) layer below: (id<RMMapLayer>) other;
//-(void)removeLayer: (id<RMMapLayer>) layer;

// During touch and move operations on the iphone its good practice to
// hold off on any particularly expensive operations so the user's 
+ (BOOL) performExpensiveOperations;
+ (void) setPerformExpensiveOperations: (BOOL)p;

- (CGPoint)latLongToPixel:(CLLocationCoordinate2D)latlong;
- (CGPoint)latLongToPixel:(CLLocationCoordinate2D)latlong withMetersPerPixel:(double)aScale;
- (RMTilePoint)latLongToTilePoint:(CLLocationCoordinate2D)latlong withMetersPerPixel:(double)aScale;
- (CLLocationCoordinate2D)pixelToLatLong:(CGPoint)aPixel;
- (CLLocationCoordinate2D)pixelToLatLong:(CGPoint)aPixel withMetersPerPixel:(double)aScale;

/**
 * APIMethod: latLongToProjectedPoint
 * 将经纬度坐标转换为投影坐标
 *
 * Parameters:
 * latlong - {CLLocationCoordinate2D} 所需转换的经纬度坐标
 *
 * Returns:
 * {RMProjectedPoint}
 */
- (RMProjectedPoint)latLongToProjectedPoint:(CLLocationCoordinate2D)latlong;
/**
 * APIMethod: pixelToProjectedPoint
 * 将像素坐标转换为当前地图的地理坐标
 *
 * Parameters:
 * aPixel - {CGPoint} 所需转换的像素坐标
 *
 * Returns:
 * {RMProjectedPoint}
 */
- (RMProjectedPoint)pixelToProjectedPoint:(CGPoint)aPixel;

/**
 * APIMethod: projectedPointToLatLong
 * 将投影坐标转换为经纬度坐标
 *
 * Parameters:
 * projectedPoint - {RMProjectedPoint} 所需转换的投影坐标
 *
 * Returns:
 * {CLLocationCoordinate2D}
 */
- (CLLocationCoordinate2D)projectedPointToLatLong:(RMProjectedPoint)projectedPoint;

/**
 * APIMethod: zoomWithLatLngBoundsNorthEast:SouthWest
 * 将地图缩放至指定经纬度范围内
 *
 * Parameters:
 * ne - {CLLocationCoordinate2D} 缩放后显示范围东北点经纬度坐标
 * sw - {CLLocationCoordinate2D} 缩放后显示范围西南点经纬度坐标
 *
 */
- (void)zoomWithLatLngBoundsNorthEast:(CLLocationCoordinate2D)ne SouthWest:(CLLocationCoordinate2D)sw;

- (void)zoomWithRMMercatorRectBounds:(RMProjectedRect)bounds;

/**
 * APIMethod: refreshMap
 * 刷新瓦片地图
 */
- (void)refreshMap;

/**
 * APIMethod: setLayerID:forTileSource:
 * 控制tileSource图层的可见性
 *
 * Parameters:
 * layerID - {NSString} 图层在tileSource中的索引，如[1,2,3]-表示tileSource中的索引为1，2，3的图层可见
 * tileSource - {id <RMTileSource>} 需要控制的tileSource
 *
 */

- (void)setLayerID:(NSString *) layerID forTileSource:(id <RMTileSource>)tileSource;

/**
 * APIMethod: setLayerID:forTileSourceAtIndex:
 * 控制索引为index的tileSource中各个图层的可见性
 *
 * Parameters:
 * layerID - {NSString} 图层在tileSource中的索引，如[1,2,3]-表示tileSource中的索引为1，2，3的图层可见
 * index - {NSUInteger} tileSource在mapContents中的索引
 *
 */
- (void)setLayerID:(NSString *) layerID forTileSourceAtIndex:(NSUInteger)index;

/**
 * APIMethod: setDisplayFilter:forTileSource:
 * 设置过滤条件，控制图层内部对象显示
 *
 * Parameters:
 * displayFilter - {NSDictionary} 图层显示过滤条件
 * forTileSource - {id<RMTileSource>} 需要控制的tileSource
 *
 */
- (void)setDisplayFilter:(NSDictionary *)displayFilter forTileSource:(id<RMTileSource>)tileSource;

/**
 * APIMethod: setDisplayFilter:forTileSourceAtIndex:
 * 设置过滤条件，控制图层内部对象显示
 *
 * Parameters:
 * displayFilter - {NSDictionary} 图层显示过滤条件
 * index - {NSUInteger} tileSource在mapContents中的索引
 *
 */
- (void)setDIsplayFilter:(NSDictionary *)displayFilter forTileSourceAtIndex:(NSUInteger)index;

/**
 * APIMethod: setTempLayerID:forTileSource:
 * 用于控制临时图层的子图层的显示或隐藏
 *
 * Parameters:
 * layerID - {NSString} 图层在tileSource中的索引，如[1,2,3]-表示tileSource中的索引为1，2，3的图层可见
 * tileSource - {id<RMTileSource>} 需要控制的tileSource
 *
 */
- (void)setTempLayerID:(NSString *) layerID forTileSource:(id<RMTileSource>)tileSource;

//- (void)setTempLayerID:(NSString *) layerID forTileSourceAtIndex:(NSUInteger)index;
/**
 * APIMethod: latitudeLongitudeBoundingBoxFor
 * 返回包含整个屏幕的最小边界框
 * 
 * Returns:
 * {RMSphericalTrapezium}
 */
- (RMSphericalTrapezium) latitudeLongitudeBoundingBoxForScreen;
/**
 * APIMethod: latitudeLongitudeBoundingBoxFor
 * 返回包含所指定矩形的最小边界框。
 *
 * Parameters:
 * rect - {CGRect}  
 *
 * Returns:
 * {RMSphericalTrapezium}
 */
- (RMSphericalTrapezium) latitudeLongitudeBoundingBoxFor:(CGRect) rect;

- (void)setRotation:(double)angle;

- (void) tilesUpdatedRegion:(CGRect)region;

 /**
 * APIMethod: removeAllCachedImages
 * 删除tileSource缓存机制所缓存的所有图片。
 *
 * 可能会有一些图片保存在用户的分享URL缓存中，而所有RMTileSource都是通过NSURLRequest加载tile images ,所以如果用户需要清理这些缓存，可以通过
 * 以下的方式：
 *
 * //code
 *
 * [[NSURLCache sharedURLCache] removeAllCachedResponses];
 *
 * //endcode
 */
-(void)removeAllCachedImages;

@end

/// Appears to be the methods actually implemented by RMMapContents, but generally invoked on RMMapView, and forwarded to the contents object.
@protocol RMMapContentsFacade

@optional
- (void)moveToLatLong: (CLLocationCoordinate2D)latlong;
- (void)moveToProjectedPoint: (RMProjectedPoint)aPoint;

- (void)moveBy: (CGSize) delta;
- (void)zoomByFactor: (double) zoomFactor near:(CGPoint) center;
- (void)zoomInToNextNativeZoomAt:(CGPoint) pivot animated:(BOOL) animated;
- (void)zoomOutToNextNativeZoomAt:(CGPoint) pivot animated:(BOOL) animated; 
- (void)zoomByFactor: (double) zoomFactor near:(CGPoint) center animated:(BOOL) animated;

- (void)zoomInToNextNativeZoomAt:(CGPoint) pivot;
- (void)zoomOutToNextNativeZoomAt:(CGPoint) pivot; 
- (double)adjustZoomForBoundingMask:(double)zoomFactor;
- (void)adjustMapPlacementWithScale:(double)aScale;

- (CGPoint)latLongToPixel:(CLLocationCoordinate2D)latlong;
- (CGPoint)latLongToPixel:(CLLocationCoordinate2D)latlong withMetersPerPixel:(double)aScale;
- (CLLocationCoordinate2D)pixelToLatLong:(CGPoint)aPixel;
- (CLLocationCoordinate2D)pixelToLatLong:(CGPoint)aPixel withMetersPerPixel:(double)aScale;
- (void)zoomWithLatLngBoundsNorthEast:(CLLocationCoordinate2D)ne SouthWest:(CLLocationCoordinate2D)se;
- (void)zoomWithRMMercatorRectBounds:(RMProjectedRect)bounds;

/**
 *APIMethod: latitudeLongitudeBoundingBoxForScreen
 *name change pending after 0.5
 */
- (RMSphericalTrapezium) latitudeLongitudeBoundingBoxForScreen;

/**
 *APIMethod: latitudeLongitudeBoundingBoxFor
 *name change pending after 0.5
 *
 ** Parameters:
 * rect - {CGRect}  
 *
 ** Returns:
 *{RMSphericalTrapezium}
 */
- (RMSphericalTrapezium) latitudeLongitudeBoundingBoxFor:(CGRect) rect;

- (void) tilesUpdatedRegion:(CGRect)region;


@end

