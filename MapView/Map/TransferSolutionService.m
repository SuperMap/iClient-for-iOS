//
//  TransferSolutionService.m
//  MapView
//
//  Created by supermap on 15-3-3.
//
//

#import "TransferSolutionService.h"
#import "TransferSolutionResult.h"
#import "TransferSolutionParameter.h"
#import "TransferStopInfo.h"
#import "TransferLines.h"
#import "TransferGuide.h"
#import "TransferLine.h"
#import "Point2D.h"

@implementation TransferSolutionService{
    NSMutableData *_data;
    NSString *_strSolutionUrl;
    NSURL *requestUrl;
    NSOperationQueue *queue;
}

#pragma -mark 根据起始和终止站点的位置，以及分析条件，返回换乘方案
-(void) processAsync4SolutionWithParam:(TransferSolutionParameter *) param finishBlock:(void(^)(TransferSolutionResult * transferSolutionResult))finishBlock failedBlock:(void (^)(NSError * connectionError))failedBlock{
    if (param == nil) {
        NSLog(@"param is null.");
        return;
    }
    
    NSArray *arr = [self castPointsToArr:[param points]];
    
    NSString *strAnalystParameter=[[NSString alloc]initWithData:[NSJSONSerialization dataWithJSONObject:arr options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding];
    NSMutableString *endUrl = [NSMutableString stringWithFormat:@"%@solutions.json?points=%@&walkingRatio=%f&transferTactic=%@&solutionCount=%d&transferPreference=%@",_strSolutionUrl,strAnalystParameter,[param walkingRatio],[param transferTactic],[[NSNumber numberWithUnsignedLong:[param solutionCount]] intValue],[param transferPreference]];
    
    // 设置避让线路
    if ([param evadelLines]) {
        [endUrl appendFormat:@"&evadelLines=%@",[[NSString alloc]initWithData:[NSJSONSerialization dataWithJSONObject:[param evadelLines] options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding]];
    }
    // 设置避让站点
    if ([param evadelStops]) {
        [endUrl appendFormat:@"&evadelStops=%@",[[NSString alloc]initWithData:[NSJSONSerialization dataWithJSONObject:[param evadelStops] options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding]];
    }
    // 设置优先线路
    if ([param priorLines]) {
        [endUrl appendFormat:@"&priorLines=%@",[[NSString alloc]initWithData:[NSJSONSerialization dataWithJSONObject:[param priorLines] options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding]];
    }
    // 设置优先站点
    if ([param priorStops]) {
        [endUrl appendFormat:@"&priorStops=%@",[[NSString alloc]initWithData:[NSJSONSerialization dataWithJSONObject:[param priorStops] options:
                                                                   NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding]];
    }
    
    // 设置出行时间
    if ([param travelTime]) {
        [endUrl appendFormat:@"&travelTime=%@",[param travelTime]];
    }
	
	endUrl=[endUrl stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    endUrl=[endUrl stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    endUrl=[endUrl stringByReplacingOccurrencesOfString:@" " withString:@""];

    //第一步，创建url
    NSURL *url = [NSURL URLWithString:[endUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    //第二步，创建请求
    NSMutableURLRequest *request =
            [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:10];
    [request setHTTPMethod:@"GET"];
    [request addValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    if (!queue) {
        queue = [[NSOperationQueue alloc] init];
    }
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError) {
             NSLog(@"Error:%@   Code:%ld",[connectionError localizedDescription],(long)[connectionError code]);
            dispatch_sync(dispatch_get_main_queue(), ^{
                failedBlock(connectionError);
            });

        }else{
            NSError *e;
            NSDictionary *dict =[NSJSONSerialization JSONObjectWithData: data
                                                                options: NSJSONWritingPrettyPrinted
                                                                  error: &e];
            TransferSolutionResult *transferSolutionResult = [[TransferSolutionResult alloc] initWithDict:dict];
            dispatch_sync(dispatch_get_main_queue(), ^{
                finishBlock(transferSolutionResult);
            });
        }
    }];
}

#pragma -mark 发送换乘方案，返回换乘引导
-(void) processAsync4PathWithPoints:(NSArray *) points transferLines:(NSArray *)transferLines finishBlock:(void(^)(TransferGuide * transferGuide))finishBlock failedBlock:(void (^)(NSError *))failedBlock{
    if (points == nil || transferLines ==nil ) {
        NSLog(@"param is null.");
        return;
    }
    
    NSArray *pointsArr = [self castPointsToArr:points];
    
    NSString *_points=[[NSString alloc]initWithData:[NSJSONSerialization dataWithJSONObject:pointsArr options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding];
    NSMutableString *linesJson =[[NSMutableString alloc] initWithString:@"["];
    
    for (int i=0; i< [transferLines count]; i++) {
        [linesJson appendString:[NSString stringWithFormat:@"%@",[[transferLines objectAtIndex:i] castToJson]]];
        if (i<[transferLines count]-1) {
           [linesJson appendString:@","];
        }
    }
    [linesJson appendString:@"]"];

    
    NSString *endUrl = [NSString stringWithFormat:@"%@path.json?points=%@&transferLines=%@",_strSolutionUrl,_points,linesJson];
    //第一步，创建url
    NSURL *url = [NSURL URLWithString:[endUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    //第二步，创建请求
    NSMutableURLRequest *request =
    [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:10];
    [request setHTTPMethod:@"GET"];
    [request addValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    if (!queue) {
        queue = [[NSOperationQueue alloc] init];
    }
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError) {
            NSLog(@"Error:%@   Code:%ld",[connectionError localizedDescription],(long)[connectionError code]);
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                failedBlock(connectionError);
            });
        }else{
            NSError *e;
            NSDictionary *dict =[NSJSONSerialization JSONObjectWithData: data
                                                                  options: NSJSONWritingPrettyPrinted
                                                                  error: &e];
            TransferGuide *transferGuide = [[TransferGuide alloc] initWithDict:dict];
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                finishBlock(transferGuide);
            });
        }
    }];
}

#pragma -mark 传入关键字，查询符合条件的站点信息列表
-(void)ProcessAsync4StopsWithKeyWord:(NSString *)keyWord returnPosition:(BOOL)returnPosition finishBlock:(void(^)(NSArray * transferStopsInfo))finishBlock failedBlock:(void (^)(NSError * connectionError))failedBlock{
    if (keyWord == nil) {
        NSLog(@"keyWord is null.");
        return;
    }
    
    NSString *endUrl = [NSString stringWithFormat:@"%@stops/keyword/%@.json?returnPosition=%@",_strSolutionUrl,[keyWord stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],returnPosition?@"true":@"false"];
    //第一步，创建url
    NSURL *url = [NSURL URLWithString:endUrl];
    //第二步，创建请求
    NSMutableURLRequest *request =
    [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:10];
    
    [request setHTTPMethod:@"GET"];
    [request addValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    if (!queue) {
        queue = [[NSOperationQueue alloc] init];
    }
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        if (connectionError) {
            NSLog(@"Error:%@   Code:%ld",[connectionError localizedDescription],(long)[connectionError code]);
            dispatch_sync(dispatch_get_main_queue(), ^{
                failedBlock(connectionError);
            });
        }else{
            NSError *e;
            NSArray *arr =[NSJSONSerialization JSONObjectWithData: data
                                                            options: NSJSONWritingPrettyPrinted
                                                              error: &e];
            NSMutableArray *stopsInfo = [[NSMutableArray alloc] init];
            for (int i=0; i<[arr count]; i++) {
                TransferStopInfo *stopInfo = [[TransferStopInfo alloc] initWithDict:[arr objectAtIndex:i]];
                [stopsInfo addObject:stopInfo];
            }
            dispatch_sync(dispatch_get_main_queue(), ^{
                finishBlock(stopsInfo);
            });
        }
    }];
    
}

// 将point2D的数组转换为json数组
-(NSArray *)castPointsToArr:(NSArray *) points{
    if (![[points objectAtIndex:0] isKindOfClass:[Point2D class]]) {
        return points;
    }
    
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    for (int i=0; i<[points count]; i++) {
        Point2D *point =[points objectAtIndex:i];
        [arr addObject:[point castToDict]];
    }
    return arr;
}

-(instancetype)initWithUrl:(NSString *) strUrl{
    [self init];
    
    if (!strUrl) {
        NSLog(@"URL 为空 ！");
    }
    NSString *endString= [strUrl substringFromIndex:[strUrl length]-1];
    if(![endString isEqualToString:@"/"])
    {
        strUrl=[strUrl stringByAppendingString:@"/"];
    }
    _strSolutionUrl = [[NSString alloc] initWithString:strUrl];
    return self;
}

@end
