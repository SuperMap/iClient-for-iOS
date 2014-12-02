//
//  ThemeUnique.h
//  MapView
//
//  Created by iclient on 14/11/24.
//
//

#import <Foundation/Foundation.h>
#import "ServerStytle.h"
#import "ThemeUniqueItem.h"

/**
 * Class: ThemeUnique
 * 单值专题图类。 
 * 单值专题图是利用不同的颜色或符号（线型、填充）表示图层中某一属性信息的不同属性值，属性值相同的要素具有相同的渲染风格。
 * 单值专题图多用于具有分类属性的地图上，比如土壤类型分布图、土地利用图、行政区划图等。单值专题图着重表示现象质的差别，一般不表示数量的特征。尤其是有交叉或重叠现象时，此类不推荐使用，例如：民族分布区等。
 *
 *
 * Inherits from:
 *  - <NSObject>
 */
@interface ThemeUnique : NSObject

/**
 * APIProperty: defaultStyle
 * {<ServerStytle>} 未参与单值专题图制作的对象的显示风格。
 * 通过单值专题图子项数组 （items）可以指定某些要素参与单值专题图制作，对于那些没有被包含的要素，即不参加单值专题表达的要素，使用该风格显示。
 */
@property(assign)ServerStytle* defaultStyle;

/**
 * APIProperty: items
 * {NSMutableArray(<ThemeUniqueItem>)} 单值专题图子项类数组。
 * 单值专题图是将专题值相同的要素归为一类，为每一类设定一种渲染风格，其中每一类就是一个专题图子项。
 * 比如，利用单值专题图制作行政区划图,Name 字段代表省/直辖市名，该字段用来做专题变量，如果该字段的字段值总共有5种不同值，则该行政区划图有5个专题图子项。
 */
@property(assign)NSMutableArray* items;

/**
 * APIProperty: uniqueExpression
 * {NSString} 用于制作单值专题图的字段或字段表达式。 
 * 该字段值的数据类型可以为数值型或字符型,如果设置字段表达式，只能是相同数据类型字段间的运算。必设字段。
 */
@property(assign)NSString* uniqueExpression;


/**
 * Constructor: ThemeUnique
 * 单值专题图对象类构造函数。
 *
 * Parameters:
 * uniqueExpression - {NSString} 用于制作单值专题图的字段或字段表达式。
 * items - {NSMutableArray(<ThemeUniqueItem>)} 单值专题图子项类数组。
 * defaultStyle - {<ServerStytle>} 未参与单值专题图制作的对象的显示风格。
 */
-(instancetype)initWithUniqueExpression:(NSString*)uniqueExpression items:(NSMutableArray*)items defaultStyle:(ServerStytle*) defaultStyle;

-(NSMutableDictionary *)toDictionary;
@end
