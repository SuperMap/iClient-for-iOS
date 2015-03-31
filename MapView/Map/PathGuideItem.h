//
//  PathGuideItem.h
//  MapView
//
//  Created by iclient on 14-5-28.
//
//

#import <Foundation/Foundation.h>
#import "RMFoundation.h"
#import "ServerGeometry.h"

/**
 * Class: PathGuideItem
 * 行驶导引子类。
 * 行驶导引由多个行驶导引子项构成，记录了如何一步步从起点行驶到终点，其中每一步就是一个行驶导引子项。
 * 每个分析结果路径 Path 中包含该路径的行驶引导，每个行驶引导子项可以表示一个弧段，一个结点或一个站点，记录了在当前地点转弯情况、行驶方向、耗费等信息。
 */
@interface PathGuideItem : NSObject
{
    RMProjectedRect bounds;
    NSString *directionType;
    float distance;
    long int ID;
    int index;
    BOOL isEdge;
    BOOL isStop;
    double dLength;
    NSString *name;
    NSString *sideType;
    float turnAngle;
    NSString *turnType;
    float weight;
    NSString *description;
    ServerGeometry *geometry;
}

/**
 * APIProperty: bounds
 * {<RMProjectedRect>} 子对象（弧段或结点或站点）的范围。对弧段而言，为弧段的外接矩形；对点而言，为点本身。
 */
@property (readwrite)RMProjectedRect bounds;

/**
 * APIProperty: directionType
 * {<NSString>} 行驶的方向。共有五个方向，即东、南、西、北、无方向。
 * 当该类中字段 isEdge 为 NO 时，即为结点无行驶方向，行驶方向的类型为无方向。
 */
@property(retain,readwrite) NSString *directionType;

/**
 * APIProperty: distance
 * {float} 站点到弧段的距离。该距离是指站点到最近一条弧段的距离。
 */
@property(readwrite)float distance;

/**
 * APIProperty: ID
 * {long} 行驶导引子项的 ID 号，即 edgeID 或 nodeID。当子项为不在网络上的站点时，此值为-1。
 */
@property(readwrite)long int ID;


/**
 * APIProperty: index
 * {int} 行驶导引子项的序号。
 */
@property(readwrite)int index;

/**
 * APIProperty: isEdge
 * {BOOL} 判断本行驶导引子项是否是弧段。true 表示行驶导引子项是弧段，false 表示行驶导引子项不是弧段。
 */
@property(readwrite)BOOL isEdge;

/**
 * APIProperty: isStop
 * {BOOL} 该子项是否为站点。站点为用户指定的用于做路径分析的点，站点可能与网络结点重合，也可能不在网络上。true 表示是站点，false 表示不是站点。
 */
@property(readwrite)BOOL isStop;

/**
 * APIProperty: dLength
 * {double} 当行驶导引子项为弧段时表示弧段的长度。
 */
@property(readwrite)double dLength;

/**
 * APIProperty: name
 * {NSString} 行驶导引子项的名称。
 */
@property(retain,readwrite)NSString *name;

/**
 * APIProperty: sideType
 * {NSString} 站点是在路的左侧、右侧还是在路上的常量。
 * 当该类的字段 isEdge 为 true 时将返回 SideType.None，表示无效值。
 */
@property(retain,readwrite)NSString *sideType;

/**
 * APIProperty: turnAngle
 * {float} 转弯角度。单位为度，精确到0.1度。
 */
@property(readwrite)float turnAngle;

/**
 * APIProperty: turnType
 * {NSString} 转弯方向常量。当该类的字段 isEdge 为 true 时将返回 TurnType.None，表示无效值。
 */
@property(retain,readwrite)NSString *turnType;

/**
 * APIProperty: weight
 * {float} 行驶导引子项的权值，即行使导引对象子项的花费。
 */
@property(readwrite)float weight;

/**
 * APIProperty: description
 * {NSString} 行驶引导描述。
 */
@property(retain,readwrite)NSString *description;


/**
 * APIProperty: geometry
 * {<ServerGeometry>}行驶引导项所对应的地物对象。
 */
@property(retain,readwrite)ServerGeometry *geometry;

-(id) initFromJson:(NSDictionary*)dictJson;

@end
