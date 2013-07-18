//
//  QueryResult.h
//  MapView
//
//  Created by iclient on 13-6-26.
//
//

#import <Foundation/Foundation.h>
#import "Recordset.h"

/**
 * Class: QueryResult
 * 查询结果类。
 * 查询结果类中包含了查询结果记录集（Recordset）或查询结果资源（ResourceInfo)的相关信息。
 */
@interface QueryResult : NSObject

{
    int totalCount;
    int currentCount;
    id customResponse;
    NSMutableArray* recordsets;
}

@property (copy,readwrite) id customResponse;

/**
 * APIProperty: totalCount
 * {int} 符合查询条件的记录的总数。
 */
@property (readwrite) int totalCount;

/**
 * APIProperty: currentCount
 * {int} 当次查询返回的记录数。
 * 如果期望返回的记录条数小于满足查询条件的所有记录，
 * 即 ExpectCount <= TotalCount，则 CurrentCount 就等于 ExpectCount 的值；
 * 如果 ExpectCount > TotalCount，则 CurrentCount 就等于 TotalCount 的值。
 */
@property (readwrite) int currentCount;

/**
 * APIProperty: recordsets
 * {NSMutableArray(<Recordset>)} 查询结果记录集数组。
 * 将查询出来的地物按照图层进行划分，
 * 一个查询记录集存放一个图层的查询结果，即查询出的所有地物要素。
 */
@property (retain,readwrite) NSMutableArray* recordsets;

-(void) fromJson:(NSString*)strJson;

@end
