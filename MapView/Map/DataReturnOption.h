//
//  DataReturnOption.h
//  MapView
//
//  Created by iclient on 14/11/26.
//
//

#import <Foundation/Foundation.h>

/**
 * Class: DataReturnOption
 * 数据返回设置类
 *
 * Inherits from:
 *  - <NSObject>
 */
@interface DataReturnOption : NSObject


/**
* APIProperty: expectCount
* {NSInteger}  设置返回的最大记录数，小于或者等于0时表示返回所有记录数。默认值为 1000 。
*/
@property (assign) NSInteger expectCount;
/**
 * APIProperty: dataset
 * {NSString} 设置结果数据集标识，当dataReturnMode为 DATASET_ONLY
 * 或 DATASET_AND_RECORDSET 时有效，
 * 作为返回数据集的名称。该名称用形如"数据集名称@数据源别名"形式来表示。
 */

@property (assign) NSString* dataset;

/**
 * APIProperty: dataReturnMode
 * {NSString} 数据返回模式，提供三种返回模式：DATASET_ONLY,DATASET_AND_RECORDSET,RECORDSET_ONLY。
 * 默认为 DATASET_ONLY ，即只返回结果数据集。
 */

@property (assign) NSString* dataReturnMode;

/**
 * APIProperty: deleteExistResultDataset
 * {BOOL} 如果用户命名的结果数据集名称与已有的数据集重名，是否删除已有的数据集。默认为 YES .
 */
@property (assign) BOOL deleteExistResultDataset;


/**
 * Constructor: DataReturnOption
 * 数据返回设置类
 *
 * Parameters:
 *
 * dataset - {NSString} 设置结果数据集标识。其他参数为默认值。
 *
 */
-(instancetype)initWithDataset:(NSString*)dataset;

/**
 * Constructor: DataReturnOption
 * 数据返回设置类构造函数
 *
 * Parameters:
 * expectCount - {NSInteger} 设置返回的最大记录数，小于或者等于0时表示返回所有记录数。
 * dataset - {NSString} 设置结果数据集标识。
 * deleteExistResultDataset - {BOOL} 如果用户命名的结果数据集名称与已有的数据集重名，是否删除已有的数据集。
 * dataReturnMode - {NSString} 数据返回模式。
 */
-(instancetype)initWithExpectCount:(NSInteger)expectCount dataset:(NSString*)dataset deleteExistResultDataset:(BOOL) deleteExistResultDataset dataReturnMode:(NSString*) dataReturnMode;

-(NSMutableDictionary*)toDictionary;
@end
