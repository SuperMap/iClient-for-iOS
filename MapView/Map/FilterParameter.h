//
//  FilterParameter.h
//  MapView
//
//  Created by iclient on 13-6-25.
//
//

#import <Foundation/Foundation.h>
#import "JoinItem.h"
#import "LinkItem.h"

/**
 *	@brief	查询过滤条件参数类。 \n
 * 该类用于设置查询数据集的查询过滤参数。
 */
@interface FilterParameter : NSObject

{
    NSString* attributeFilter;
    NSString* name;
    NSMutableArray* joinItems;
    NSMutableArray* linkItems;
    NSMutableArray* ids;
    NSString* orderBy;    
    NSString* groupBy;
    NSMutableArray* fields;
}

@property (copy,readwrite) NSString* attributeFilter;
@property (copy,readwrite) NSString* name;
@property (retain,readwrite) NSMutableArray* joinItems;
@property (retain,readwrite) NSMutableArray* linkItems;
@property (retain,readwrite) NSMutableArray* ids;
@property (copy,readwrite) NSString* orderBy;
@property (copy,readwrite) NSString* groupBy;
@property (retain,readwrite) NSMutableArray* fields;

- (NSMutableDictionary *)toNSDictionary;
@end
