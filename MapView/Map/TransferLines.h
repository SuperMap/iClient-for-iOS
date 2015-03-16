//
//  TransferLines.h
//  MapView
//
//  Created by supermap on 15-3-4.
//
//

/*
 *  交通换乘分段类：理论了本分段中可乘坐的线路信息
 */

#import <Foundation/Foundation.h>

@interface TransferLines : NSObject


// 本换乘分段内可乘车的线路集合
@property(nonatomic,retain) NSMutableArray* lineItems;

-(id)initWithArr:(NSDictionary *)dict;
-(NSDictionary *)castToDict;
-(NSArray *)castToLinesArr;
@end
