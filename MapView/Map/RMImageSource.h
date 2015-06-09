//
//  RMImageSource.h
//  MapView
//
//  Created by supermap on 15/6/1.
//
//
#import "RMMapContents.h"
#import <Foundation/Foundation.h>
#import "RMFoundation.h"
/**
 * Class: RMImageSource
 * 图片叠加服务类
 */

@interface RMImageSource :NSObject{
    // 需要叠加的图片
    UIImage *image;
    RMMapContents *contents;
    // 地图的可见地理bounds
    RMProjectedRect mapBounds;
    // 图片的地理bounds
    RMProjectedRect projbounds;
    // 图片可见的地理范围
    RMProjectedRect visionBounds;
}

/**
 * APIProperty: screenBounds
 * {CGRect} 图片可见部分在屏幕中的bounds。
 */
@property (nonatomic) CGRect screenBounds;

/**
 * APIProperty: center
 * {CGRect} 图片可见部分在屏幕上的中心点。
 */
@property (nonatomic) CGPoint center;

/**
 * Constructor: initWithUrl:mapContents:imageBounds
 * 用于初始化,获取网络图片以及设置图片的Bounds
 *
 * Parameters:
 * imageUrl - {NSString}  图片的url。
 * mapContents - {RMMapContents} mapView中的mapcontents
 * imageBounds - {RMProjectedRect} 图片表示的的地理范围
 */
-(id)initWithUrl:(NSString *)imageUrl mapContents:(RMMapContents *)mapContents imageBounds:(RMProjectedRect) imageBounds;
-(UIImage *)image;
@end
