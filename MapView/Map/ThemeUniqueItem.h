//
//  ThemeUniqueItem.h
//  MapView
//
//  Created by iclient on 14/11/24.
//
//

#import <Foundation/Foundation.h>
#import "ServerStytle.h"

/**
 * Class: ThemeUniqueItem
 * 单值专题图子项类。 
 * 单值专题图是将专题值相同的要素归为一类，为每一类设定一种渲染风格，其中每一类就是一个专题图子项。比如，利用单值专题图制作行政区划图，Name 字段代表 省/直辖市名，该字段用来做专题变量，如果该字段的字段值总共有5种不同值，则该行政区划图有5个专题图子项
 *
 * Inherits from:
 *  - <NSObject>
 */
@interface ThemeUniqueItem : NSObject


/**
 * APIProperty: caption
 * {NSString} 单值专题图子项的标题。
 */
@property (assign) NSString *caption;

/**
 * APIProperty: unique
 * {NSString} 单值专题图子项的值，可以为数字（转化为字符串）、字符串等。
 */
@property (assign) NSString *unique;
/**
 * APIProperty: visible
 * {BOOL} 单值专题图子项的可见性。默认为 YES，表示可见
 */
@property (assign) BOOL *visible;
/**
 * APIProperty: style
 * {<ServerStytle>} 单值专题图子项的显示风格。
 */
@property (assign) ServerStytle *style;

/**
 * Constructor: ThemeUniqueItem
 * 单值专题图子项类构造函数。
 */
-(instancetype)init;

/**
 * Constructor: ThemeUniqueItem
 * 单值专题图子项类构造函数。
 *
 * Parameters:
 * unique - {NSString} 用于制作单值专题图的字段或字段表达式。
 * serverStyle - {<ServerStytle>} 单值专题图子项的显示风格。
 */
-(instancetype)initWithUnique:(NSString*)unique serverStyle:(ServerStytle *)style;

/**
 * Constructor: ThemeUniqueItem
 * 单值专题图子项类构造函数。
 *
 * Parameters:
 * unique - {NSString} 用于制作单值专题图的字段或字段表达式。
 * serverStyle - {<ServerStytle>} 单值专题图子项的显示风格。
 * caption - {NSString} 单值专题图子项的标题。
 */
-(instancetype)initWithUnique:(NSString*)unique serverStyle:(ServerStytle *)style caption:(NSString*)caption;

/**
 * Constructor: ThemeUniqueItem
 * 单值专题图子项类构造函数。
 *
 * Parameters:
 * unique - {NSString} 用于制作单值专题图的字段或字段表达式。
 * serverStyle - {<ServerStytle>} 单值专题图子项的显示风格。
 * caption - {NSString} 单值专题图子项的标题。
 * visible - {BOOL} 单值专题图子项的可见性。
 */
-(instancetype)initWithUnique:(NSString*)unique serverStyle:(ServerStytle *)style caption:(NSString*)caption visible:(BOOL)visible;

-(NSMutableDictionary*)toDictionary;


@end
