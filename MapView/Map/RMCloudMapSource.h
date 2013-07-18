//
//  RMCloudMapSource.h
//  MapView
//
//  Created by iclient on 13-7-4.
//
//

#import "RMAbstractMercatorWebSource.h"

/**
 * Class: RMCloudMapSource
 * SuperMap云地图服务
 */
@interface RMCloudMapSource : RMAbstractMercatorWebSource <RMAbstractMercatorWebSource>{
}

/**
 * Constructor: init
 * RMCloudMapSource用于在iOS上加载云地图服务，方便的将iServer发布的地图服务显示在地图框架中
 * (start code)
 * RMCloudMapSource* cloud = [[RMCloudMapSource alloc] init];
 * RMMapContents *newContents = [[RMMapContents alloc] initWithView:self tilesource:cloud];
 * (end)
 */
-(id) init;

@end

