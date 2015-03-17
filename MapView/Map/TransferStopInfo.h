//
//  TransferStopInfo.h
//  MapView
//
//  Created by supermap on 15-3-5.
//
//
/**
 * Class:  TransferStopInfo 
 * 公交站点信息类。该类用于描述公交站点的信息，包括站点smid，站点id，站点坐标，站点名称以及站点别名
 * 
 * Inherits from:
 *  - <NSObject>
 */
@class Point2D;
#import <Foundation/Foundation.h>

@interface TransferStopInfo : NSObject
/**
 * APIProperty: alias
 * {NSString} 站点别名。
 */
@property(nonatomic,retain) NSString *alias;
/**
 * APIProperty: _id
 * {NSInteger} 站点id。
 */
@property NSInteger _id;
/**
 * APIProperty: name
 * {NSString} 站点名称。
 */
@property(nonatomic,retain) NSString *name;
/**
 * APIProperty: position
 * {Point2D} 站点坐标。
 */
@property(nonatomic,retain) Point2D *position;
/**
 * APIProperty: stopID
 * {long} 站点id,对应服务提供者配置中的stopIDField。
 */
@property long stopID;

/**
 * Constructor: TransferStopInfo 
 * 公交站点信息类
 *
 * Parameters:
 * dict - {NSDictionary} 对象。
 */
-(id)initWithDict:(NSDictionary *)dict;
@end
