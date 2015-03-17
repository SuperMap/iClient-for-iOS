//
//  TransferGuide.h
//  MapView
//
//  Created by supermap on 15-3-4.
//
//
/**
 * Class: TransferGuide 
 * 公交换乘引导类:公交换乘引导记录了从换乘分析起始站点到终止站点的公交换乘引导方案。公交换乘引导又公交换乘引导子项(TransferGuideItem 类型对象)构成，每个引导子项可以表示一段换乘或者步行路线，通过本类型可以返回公交换乘引导对象中子项的个数，根据公交换乘引导的子项对象，引导总距离以及总花费等。
 * 
 * Inherits from:
 *  - <NSObject>
 */

@class TransferGuideItem;
#import <Foundation/Foundation.h>

@interface TransferGuide : NSObject

/**
 * APIProperty: count
 * {NSInteger} 公交换乘引导对象中子项的个数。
 */
@property NSInteger count;
/**
 * APIProperty: transferGuideItems
 * {NSMutableArray} 根据指定的序号返回公交换乘引导中的子项对象。
 */
@property(nonatomic,retain) NSMutableArray *transferGuideItems;
/**
 * APIProperty: totalDistance
 * {double} 返回公交换乘引导的总距离，即当前换乘方案的总距离。
 */
@property double totalDistance;
/**
 * APIProperty: transferCount
 * {NSInteger} 返回公交换乘次数，因为中途可能有步行的子项，所以公交换乘次数不能根据换乘引导子项个数来简单计算
 */
@property NSInteger transferCount;
/**
 * Constructor: TransferGuide
 *      公交换乘引导类。
 *
 * Parameters:
 * dict - {NSDictionary} 换乘引导的字典。
 */
-(id)initWithDict:(NSDictionary *)dict;

@end
