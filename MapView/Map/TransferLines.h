//
//  TransferLines.h
//  MapView
//
//  Created by supermap on 15-3-4.
//
//

/**
 * Class: TransferLines 
 * 交通换乘分段类：记录了本分段中可乘坐的线路信息。
 *
 * Inherits from:
 *  - <NSObject>
 */

#import <Foundation/Foundation.h>

@interface TransferLines : NSObject

/**
 * APIProperty: lineItems
 * {NSMutableArray} 本换乘分段内可乘车的线路集合。
 */
@property(nonatomic,retain) NSMutableArray* lineItems;

/**
 * Constructor: TransferLines
 * 交通换乘分段类
 *
 * Parameters:
 * dict - {NSDictionary} 对象。
 */
-(id)initWithArr:(NSDictionary *)dict;
/**
 * APIMethod: castToDict
 * 将对象转换为一个字典，用于转换为json格式数据。
 */
-(NSDictionary *)castToDict;

@end
