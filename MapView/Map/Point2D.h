//
//  Point2D.h
//  MapView
//
//  Created by supermap on 15-3-4.
//
//

/*
 * 二维地理坐标点：
 *
 */

#import <Foundation/Foundation.h>

@interface Point2D : NSObject

@property double x;
@property double y;

// 传入一个字典，返回一个实例
-(id)initWithDict:(NSDictionary *)dict;
-(id)initWithx:(double)x y:(double)y;

// 返回一个字典，用于转换为json格式数据
-(NSDictionary *)castToDict;


@end
