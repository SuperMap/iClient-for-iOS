//
//  ThemeParameters.h
//  MapView
//
//  Created by iclient on 14/11/24.
//
//

#import <Foundation/Foundation.h>
#import "ThemeUnique.h"

/**
 * Class: ThemeParameters
 * 专题图参数类。
 * 该类存储了制作专题所需的参数，包括数据源、数据集名称和专题图对象。
 *
 * Inherits from:
 *  - <NSObject>
 */
@interface ThemeParameters : NSObject



/**
 * APIProperty: datasetName
 * {NSString} 要制作专题图的数据集名称。
 */
@property (assign) NSString *datasetName;

/**
 * APIProperty: dataSourceName
 * {NSString} 要制作专题图的数据集所在的数据源。
 */
@property (assign) NSString *dataSourceName;

/**
 * APIProperty: theme
 * {<ThemeUnique>} 单值专题图对象
 */
@property (assign) ThemeUnique *theme;

/**
 * Constructor: ThemeParameters
 * 单值专题图参数类构造函数。
 *
 * Parameters:
 * datasetName - {NSString} 要制作专题图的数据集名称。
 * dataSourceName - {NSString} 是否按照弧段数最少的进行最佳路径分析。
 * themeUnique - {<ThemeUnique>} 单值专题图对象。
 */
-(instancetype)initWithDatasetNames:(NSString *)datasetName dataSourceName:(NSString *)dataSourceName themeUnique:(ThemeUnique *)theme;

-(NSString*) toJsonParameters;

@end
