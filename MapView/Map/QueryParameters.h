//
//  QueryParameters.h
//  MapView
//
//  Created by iclient on 13-6-25.
//
//

#import <Foundation/Foundation.h>

/**
 *	@brief	查询参数基类。\n
 * 距离查询、SQL 查询、几何地物查询等各自的参数均继承此类。
 */
@interface QueryParameters : NSObject

{
    NSString* customParams;
    int expectCount;
    NSString* networkType;
    NSString* queryOption;
    NSMutableArray* queryParams;
    int startRecord;
    int holdTime;
    BOOL returnCustomResult;
    BOOL returnContent;
}

@property (copy,readwrite) NSString* customParams;
@property (readwrite) int expectCount;
@property (copy,readwrite) NSString* networkType;
@property (copy,readwrite) NSString* queryOption;
@property (copy,readwrite) NSMutableArray* queryParams;
@property (readwrite) int startRecord;
@property (readwrite) int holdTime;
@property (readwrite) BOOL returnContent;
@property (readonly) BOOL returnCustomResult;

- (NSMutableDictionary *)toNSDictionary;

@end
