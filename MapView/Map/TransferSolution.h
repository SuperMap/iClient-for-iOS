//
//  TransferSolution.h
//  MapView
//
//  Created by supermap on 15-3-4.
//
//

/**
 * Class: TransferSolution 
 * 交通换乘方案类。在一个换乘方案内的所有乘车线路中换乘次数是相同的
 *
 * Inherits from:
 *  - <NSObject>
 */
#import <Foundation/Foundation.h>

@interface TransferSolution : NSObject

/**
 * APIProperty: transferCount
 * {NSInteger} 换乘方案对应的换成次数。
 */
@property NSInteger transferCount;
/**
 * APIProperty: linesItems
 * {NSMutableArray} 换成分段数组。
 */
@property(nonatomic,retain) NSMutableArray* linesItems;
/**
 * Constructor: TransferSolution
 * 交通换乘方案类
 *
 * Parameters:
 * dict - {NSDictionary}对象。
 */
-(id)initWithDict:(NSDictionary *)dict;
@end
