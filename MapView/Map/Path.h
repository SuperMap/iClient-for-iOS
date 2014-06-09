//
//  Path.h
//  MapView
//
//  Created by iclient on 14-5-28.
//
//

#import <Foundation/Foundation.h>
#import "ServerFeature.h"
#import "PathGuideItem.h"

/**
 * Class: Path
 * 交通网络分析结果路径类。
 * 从该类中可以获取交通网络分析结果路径的信息，包括当前路径经过的结点、弧段、该路径的路由、行驶引导、耗费等信息，
 * 所要获取的信息通过TransportationAnalystResultSetting类设置。
 */
@interface Path : NSObject
{
    NSMutableArray *edgeFeatures;
    NSMutableArray *edgeIDs;
    NSMutableArray *nodeFeatures;
    NSMutableArray *nodeIDs;
    NSMutableArray *pathGuideItems;
    NSMutableArray *stopWeights;
    float weight;
    
}

/**
 * APIProperty: edgeFeatures
 * {NSMutableArray(<ServerFeature>)} 分析结果的途经的弧段要素的集合。
 */
@property (readonly) NSMutableArray *edgeFeatures;

/**
 * APIProperty: edgeIDs
 * {NSMutableArray} 分析结果的途经弧段 ID 的集合。
 */
@property (readonly) NSMutableArray *edgeIDs;

/**
 * APIProperty: nodeFeatures
 * {NSMutableArray(<ServerFeature>)} 分析结果的途经的结点要素的集合。
 * 数组中的各元素可能指向同一个Feature的实例，也可能为null。
 */
@property (readonly) NSMutableArray *nodeFeatures;

/**
 * APIProperty: nodeIDs
 * {NSMutableArray} 分析结果的途经结点 ID 的集合。
 */
@property (readonly) NSMutableArray *nodeIDs;

/**
 * APIProperty: pathGuideItems
 * {NSMutableArray(<PathGuideItem>)} 分析结果对应的行驶导引子项集合。
 */
@property (readonly) NSMutableArray *pathGuideItems;

/**
 * APIProperty: stopWeights
 * {NSMutableArray} 分析结果经过站点的权值。
 */
@property (readonly) NSMutableArray *stopWeights;

/**
 * APIProperty: weight
 * {Number} 路径的花费。
 */
@property (readonly) float weight;

//未加属性：rout

-(id) initFromJson:(NSDictionary*)dictJson;
@end
