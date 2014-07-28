//
//  QueryService.h
//  MapView
//
//  Created by iclient on 13-6-25.
//
//

#import <Foundation/Foundation.h>
#import "QueryParameters.h"
#import "QueryResult.h"
/**
 * Class: QueryService
 * 查询服务基类。
 */
@protocol QueryService

-(NSString*) getJsonParameters:(QueryParameters*)params;
@end

@interface QueryService : NSObject
{
    NSString* strQueryUrl;
    NSMutableData *data;
    QueryResult* lastResult;
}

@property (retain,atomic) QueryResult* lastResult;
-(id) init:(NSString*)strUrl;

-(void) processAsync:(QueryParameters*)params;

-(QueryParameters*) getQueryParameters:(QueryParameters*)params;

@end
