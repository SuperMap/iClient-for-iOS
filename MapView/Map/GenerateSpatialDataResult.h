//
//  GenerateSpatialDataResult.h
//  MapView
//
//  Created by iclient on 14/11/26.
//
//

#import <Foundation/Foundation.h>
#import "Recordset.h"

/**
 * Class: GenerateSpatialDataResult
 * 动态分段结果类
 *
 * Inherits from:
 *  - <NSObject>
 */
@interface GenerateSpatialDataResult : NSObject

/**
 * APIProperty: dataset
 * {NSString} 数据集标识。
 */
@property (assign) NSString *dataset;

/**
 * APIProperty: recordset
 * {<Recordset>} 查询结果记录集，返回 GenerateSpatialDataResult 类型的结果。
 */
@property (assign) Recordset *recordset;
/**
 * APIProperty: succeed
 * {BOOL} 是否成功返回结果。YES 表示成功返回结果。
 */
@property (assign)BOOL succeed;

@property (assign) NSString *message;

-(instancetype)initWithJson:(NSString *)strJson;

@end
