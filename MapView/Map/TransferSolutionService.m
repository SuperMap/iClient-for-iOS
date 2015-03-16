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
-(void) processAsync4SolutionWithParam:(TransferSolutionParameter *) param finishBlock:(void(^)(TransferSolutionResult * transferSolutionResult))finishBlock{
    
    NSArray *arr = [self castPointsToArr:[param points]];
    
    NSString *strAnalystParameter=[[NSString alloc]initWithData:[NSJSONSerialization dataWithJSONObject:arr options:NULL error:nil] encoding:NSUTF8StringEncoding];
    
    NSString *endUrl = [NSString stringWithFormat:@"%@solutions.json?points=%@&walkingRatio=%f&transferTactic=%@&solutionCount=%d&transferPreference=%@",_strSolutionUrl,strAnalystParameter,[param walkingRatio],[param transferTactic],[param solutionCount],[param transferPreference]];
    
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
             NSLog(@"Error:%@   Code:%d",[connectionError localizedDescription],[connectionError code]);
        }else{
            NSError *e;
            NSDictionary *dict =[NSJSONSerialization JSONObjectWithData: data
                                                                options: NSJSONReadingMutableContainers
                                                                  error: &e];
            TransferSolutionResult *transferSolutionResult = [[TransferSolutionResult alloc] initWithDict:dict];
            finishBlock(transferSolutionResult);
        }
    }];
}

#pragma -mark 发送换乘方案，返回换乘引导
-(void) processAsync4PathWithPoints:(NSArray *) points transferLines:(NSArray *)transferLines finishBlock:(void(^)(TransferGuide * transferGuide))finishBlock{

    NSArray *pointsArr = [self castPointsToArr:points];
    
    NSString *_points=[[NSString alloc]initWithData:[NSJSONSerialization dataWithJSONObject:pointsArr options:NULL error:nil] encoding:NSUTF8StringEncoding];
    NSMutableString *linesJson =[[NSMutableString alloc] initWithString:@"["];
    
    for (int i=0; i< [transferLines count]; i++) {
        [linesJson appendString:[NSString stringWithFormat:@"%@",[[transferLines objectAtIndex:i] castToJson]]];
        if (i<[transferLines count]-1) {
           [linesJson appendString:@","];
        }
    }
    [linesJson appendString:@"]"];
//    NSString *strTransferLines =[[NSString alloc]initWithData:[NSJSONSerialization dataWithJSONObject:dd options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding];
    
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
            NSLog(@"Error:%@   Code:%d",[connectionError localizedDescription],[connectionError code]);
        }else{
            NSError *e;
            NSDictionary *dict =[NSJSONSerialization JSONObjectWithData: data
                                                                  options: NSJSONReadingMutableContainers
                                                                  error: &e];
            TransferGuide *transferGuide = [[TransferGuide alloc] initWithDict:dict];
            finishBlock(transferGuide);
        }
    }];
}

#pragma -mark 传入关键字，查询符合条件的站点信息列表
-(void)ProcessAsync4StopsWithKeyWord:(NSString *)keyWord returnPosition:(BOOL)returnPosition finishBlock:(void(^)(NSArray * transferStopsInfo))finishBlock{
    
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
            NSLog(@"Error:%@   Code:%d",[connectionError localizedDescription],[connectionError code]);
        }else{
            NSError *e;
            NSArray *arr =[NSJSONSerialization JSONObjectWithData: data
                                                            options: NSJSONReadingMutableContainers
                                                              error: &e];
            NSMutableArray *stopsInfo = [[NSMutableArray alloc] init];
            for (int i=0; i<[arr count]; i++) {
                TransferStopInfo *stopInfo = [[TransferStopInfo alloc] initWithDict:[arr objectAtIndex:i]];
                [stopsInfo addObject:stopInfo];
            }
                finishBlock(stopsInfo);
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
