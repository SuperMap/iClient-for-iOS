//
//  TransferLine.h
//  MapView
//
//  Created by supermap on 15-3-4.
//
//

/*
 *  换乘线路信息类
 */
#import <Foundation/Foundation.h>

@interface TransferLine : NSObject


// 下车站点在本公交线路中的索引
@property NSInteger endStopIndex;
// 下车站点名称
@property(nonatomic,retain) NSString *endStopName;
// 乘车线路id
@property long lineID;
// 乘车线路名称
@property(nonatomic,retain) NSString *lineName;
// 上车站点在本公交线路中的索引
@property NSInteger startStopIndex;
// 上车站点名称
@property(nonatomic,retain) NSString *startStopName;

-(id)initWithDict:(NSDictionary *)dict;
// 转换为字典，只返回endStopIndex，lineID，startStopIndex三个键值对，用做Path服务请求参数
-(NSMutableDictionary *)castToDict;
-(NSString *)castToJson;
@end
