//
//  Point2D.h
//  MapView
//
//  Created by supermap on 15-3-4.
//
//

/**
 * Class: Point2D
 * 地理坐标类，用于描述一个地理坐标。
 *
 * Inherits from:
 *  - <NSObject>
 */

#import <Foundation/Foundation.h>

@interface Point2D : NSObject
/**
 * APIProperty:x
 * {double} x坐标值。
 */
@property double x;
/**
 * APIProperty:y
 * {double} y坐标值。
 */
@property double y;
/**
 * Constructor: Point2D
 *  地理坐标类
 * Parameters:
 *
 * dict - {NSDictionary} 地理坐标组成的字典。
 *
 */
-(id)initWithDict:(NSDictionary *)dict;
/**
 * Constructor: Point2D
 *      地理坐标类
 * Parameters:
 *
 *      x - {double} 地理坐标的x值。
 *      y - {double} 地理坐标的y值。
 */
-(id)initWithx:(double)x y:(double)y;
/**
 * APIMethod: castToDict
 * 返回一个字典，用于转换为json格式数据。
 *
 */
-(NSDictionary *)castToDict;


@end
