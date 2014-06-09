//
//  FindPathResult.h
//  MapView
//
//  Created by iclient on 14-5-28.
//
//

#import <Foundation/Foundation.h>
#import "Path.h"


/**
 * Class: FindPathResult
 * 最佳路径分析结果类。
 * 从该类中可以获取一条或多条结果路径。
 */
@interface FindPathResult : NSObject
{
    NSMutableArray *pathList;
    
}

/**
 * APIProperty: pathList
 * {NSMutableArray(<Path>)} 交通网络分析结果路径数组。
 */
@property (retain,readonly) NSMutableArray *pathList;

/**
 * Function: fromJson
 * 将 JSON 对象转换为 FindPathResult 对象。
 *
 * Parameters:
 * strJson - {NSString} JSON 对象表示的最佳路径分析结果。
 *
 * Returns:
 * {<FindPathResult>} 转化后的 FindPathResult 对象。
 */
-(id) fromJson:(NSString*)strJson;

@end
