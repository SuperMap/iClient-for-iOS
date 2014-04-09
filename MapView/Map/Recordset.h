//
//  Recordset.h
//  MapView
//
//  Created by iclient on 13-6-26.
//
//

#import <Foundation/Foundation.h>
#import "ServerFeature.h"

/**
 * Class: Recordset
 * 查询结果记录集
 * 将查询出来的地物按照图层进行划分，一个查询记录集存放一个图层的查询结果，
 * 即查询出的所有地物要素。
 */
@interface Recordset : NSObject

{
    NSString* datasetName;
    NSMutableArray* fieldCaptions;
    NSMutableArray* fields;
    NSMutableArray* fieldTypes;
    NSMutableArray* features;
}

/**
 * APIProperty: datasetName
 * {NSString} 被查数据集或图层的名称。
 */
@property (copy,readwrite) NSString* datasetName;

/**
 * APIProperty: fieldCaptions
 * {NSMutableArray(NSString)} 记录集中所有字段的别名。
 * 例如在属性表中有一个名为 Area 属性字段，在属性表中标题为“面积”，则“面积”即为该字段的别名。
 */
@property (retain,readwrite) NSMutableArray* fieldCaptions;

/**
 * APIProperty: fields
 * {NSMutableArray(NSString)} 记录集中所有字段的名称。
 * 例如在属性表中有一个名为 Area 属性字段，在属性表中标题为“面积”，则 Area 即为该字段的名称。
 */
@property (retain,readwrite) NSMutableArray* fields;

/**
 * APIProperty: fieldTypes
 * {NSMutableArray(NSString)} 记录集中所有字段类型。
 */
@property (retain,readwrite) NSMutableArray* fieldTypes;

/**
 * APIProperty: features
 * {NSMutableArray(<ServerFeature>)} 记录集中所有地物要素。
 */
@property (retain,readwrite) NSMutableArray* features;

-(id) initfromJson:(NSDictionary*)strJson;

@end
