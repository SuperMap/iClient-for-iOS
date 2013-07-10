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
 *	@brief	查询结果类。\n
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
@property (readwrite) int totalCount;
@property (readwrite) int currentCount;
@property (retain,readwrite) NSMutableArray* recordsets;

-(void) fromJson:(NSString*)strJson;

@end
