//
//  ServerStytle.h
//  MapView
//
//  Created by iclient on 14/11/24.
//
//

#import <Foundation/Foundation.h>

/**
 * Class: ServerStytle
 *
 * 服务端矢量要素风格类。该类用于定义线状符号及其相关属性。
 *
 * Inherits from:
 *  - <NSObject>
 */
@interface ServerStytle : NSObject

/**
 * APIProperty: fillForeColor
 * {UIColor} 填充颜色
 */
@property (assign) UIColor* fillForeColor;
/**
 * APIProperty: lineColor
 * {UIColor} 矢量要素线的颜色
 */
@property (assign) UIColor* lineColor;
/**
 * APIProperty: lineWidth
 * {float} 线宽
 */
@property (assign) CGFloat lineWidth;
/**
 * APIProperty: fillOpaqueRate
 * {float} 填充不透明度
 */
@property (assign) CGFloat fillOpaqueRate;
/**
 * APIProperty: lineSymbolID
 * {NSInteger} 线状符号的编码
 */
@property (assign) NSInteger* lineSymbolID;

-(instancetype)init;

-(instancetype)initLineStytleWithFillForeColor:(UIColor *)aFillForeColor lineColor:(UIColor *)alineColor lineWidth:(CGFloat)alineWidth;

-(instancetype)initLineStytleWithFillForeColor:(UIColor *)aFillForeColor lineColor:(UIColor *)alineColor lineWidth:(CGFloat)alineWidth :(CGFloat)fillOpaqueRate;
-(NSMutableDictionary*)toDictionary;

-(NSString *)strRBGWithColor:(UIColor*)color;
-(CGFloat)getFillForeColorAlpha:(UIColor*)color;



@end
