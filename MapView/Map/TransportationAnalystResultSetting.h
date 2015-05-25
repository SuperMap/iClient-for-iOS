//
//  TransportationAnalystResultSetting.h
//  MapView
//
//  Created by iclient on 14-5-28.
//
//

#import <Foundation/Foundation.h>

/**
 * Class: TransportationAnalystResultSetting
 * 交通网络分析结果参数类。
 * 通过该类设置交通网络分析返回的结果，包括是否返行驶引导信息、是否返回弧段空间信息、是否返回结点空间信息等。
 */
@interface TransportationAnalystResultSetting : NSObject
{
    BOOL returnEdgeFeatures;
    BOOL returnEdgeGeometry;
    BOOL returnEdgeIDs;
    BOOL returnNodeFeatures;
    BOOL returnNodeGeometry;
    BOOL returnNodeIDs;
    BOOL returnPathGuides;
  //  BOOL returnRoute;
}

/**
 * APIProperty: returnEdgeFeatures
 * {BOOL} 是否在分析结果中包含弧段要素集合。弧段要素包括弧段的空间信息和属性信息。默认为NO.
 */
@property (readwrite) BOOL returnEdgeFeatures;

/**
 * APIProperty: returnEdgeGeometry
 * {BOOL} 返回的弧段要素集合中是否包含几何对象信息。默认为 NO.
 */
@property (readwrite) BOOL returnEdgeGeometry;

/**
 * APIProperty: returnEdgeIDs
 * {BOOL} 返回结果中是否包含经过弧段 ID 集合。默认为 NO.
 */
@property (readwrite) BOOL returnEdgeIDs;

/**
 * APIProperty: returnNodeGeometry
 * {BOOL} 返回的结点要素集合中是否包含几何对象信息。默认为 NO。
 */
@property (readwrite) BOOL returnNodeGeometry;

/**
 * APIProperty: returnNodeFeatures
 * {BOOL} 是否在分析结果中包含结点要素集合。
 * 结点要素包括结点的空间信息和属性信息。其中返回的结点要素是否包含空间信息可通过 returnNodeGeometry 字段设置。默认为 NO。
 */
@property (readwrite) BOOL returnNodeFeatures;

/**
 * APIProperty: returnNodeIDs
 * {BOOL} 返回结果中是否包含经过结点 ID 集合。默认为 NO。
 */
@property (readwrite) BOOL returnNodeIDs;

/**
 * APIProperty: returnPathGuides
 * {BOOL} 返回分析结果中是否包含行驶导引集合。默认为 YES。
 */
@property (readwrite) BOOL returnPathGuides;

//@property (readwrite) BOOL returnRoute;


-(id) init;

-(NSString *) toString;

@end
