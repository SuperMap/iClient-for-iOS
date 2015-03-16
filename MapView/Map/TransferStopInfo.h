//
//  TransferStopInfo.h
//  MapView
//
//  Created by supermap on 15-3-5.
//
//

/*
 *  该类用于描述公交站点的信息，包括站点smid，站点id，站点坐标，站点名称以及站点别名
 */
@class Point2D;
#import <Foundation/Foundation.h>

@interface TransferStopInfo : NSObject

// 站点别名
@property(nonatomic,retain) NSString *alias;
// 站点id
@property NSInteger _id;
// 站点名称
@property(nonatomic,retain) NSString *name;
// 站点坐标
@property(nonatomic,retain) Point2D *position;
// 站点id,对应服务提供者配置中的stopIDField
@property long stopID;

-(id)initWithDict:(NSDictionary *)dict;
@end
