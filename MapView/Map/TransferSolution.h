//
//  TransferSolution.h
//  MapView
//
//  Created by supermap on 15-3-4.
//
//


/*
 * 交通换乘方案类。在一个换乘方案内的所有乘车线路中换乘次数是相同的
 */


#import <Foundation/Foundation.h>

@interface TransferSolution : NSObject


//换乘方案对应的换成次数
@property NSInteger transferCount;
// 换成分段数组
@property(nonatomic,retain) NSMutableArray* linesItems;

-(id)initWithDict:(NSDictionary *)dict;
@end
