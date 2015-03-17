//
//  TransferGuideItem.h
//  MapView
//
//  Created by supermap on 15-3-3.
//
//
/**
 * Class: TransferGuideItem 
 * 公交换乘引导子项类：公交换乘引导记录了从换乘分析起始站点到终止站点换乘或者步行的线路，其中每一换乘或步行线路就是一个交通换乘引导子项，利用该类可以返回交通换乘引导对象的子项信息，诸如交通换乘引导子项的起始站点信息，终止站点信息，公交线路信息等。
 * 
 * Inherits from:
 *  - <NSObject>
 */
@class Point2D;
@class RMPath;
@class ServerGeometry;
#import <Foundation/Foundation.h>

@interface TransferGuideItem : NSObject
/**
 * APIProperty: distance
 * {double} 一段换乘或者步行路线的距离。
 */
@property double distance;
/**
 * APIProperty: endIndex
 * {NSInteger} 一段换乘路线的终止站点在其完整的公交线路中处在第几个站点位置。
 */
@property NSInteger endIndex;
/**
 * APIProperty: endPosition
 * {Point2D} 换乘或者步行线路的终止站点位置坐标。
 */
@property(nonatomic,retain) Point2D* endPosition;
/**
 * APIProperty: endStopName
 * {NSString} 一段换乘线路的终止站点的名称。
 */
@property(nonatomic,retain) NSString* endStopName;
/**
 * APIProperty: isWalking
 * {BOOL} 当前线路是步行还是乘车线路。
 */
@property BOOL isWalking;
/**
 * APIProperty: lineName
 * {NSString} 换乘线路名称。
 */
@property(nonatomic,retain) NSString* lineName;
/**
 * APIProperty: lineType
 * {NSInteger} 换乘线路的类型。
 */
@property NSInteger lineType;
/**
 * APIProperty: passStopCount
 * {NSInteger} 换乘线路所经过的站点个数。
 */
@property NSInteger passStopCount;
/**
 * APIProperty: route
 * {ServerGeometry} 换乘或者步行的线路的线对象。
 */
@property(nonatomic,retain) ServerGeometry* route;
/**
 * APIProperty: startIndex
 * {NSInteger} 换乘线路的起始站点在其完整的公交线路中处在第几个站点位置。
 */
@property NSInteger startIndex;
/**
 * APIProperty: startPosition
 * {Point2D} 换乘或者步行线路的起始站点的位置坐标。
 */
@property(nonatomic,retain) Point2D* startPosition;
/**
 * APIProperty: startStopName
 * {NSString} 一段换乘线路的起始站点的名称。
 */
@property(nonatomic,retain) NSString* startStopName;
/**
 * Constructor: TransferGuideItem
 * 公交换乘引导子项类。
 *  
 * Parameters:
 * dict - {NSDictionary} 类型
 */

-(id)initWithDict:(NSDictionary *)dict;

@end
