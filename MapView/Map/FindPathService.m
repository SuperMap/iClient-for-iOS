//
//  FindPathService.m
//  MapView
//
//  Created by iclient on 14-5-27.
//
//

#import "FindPathService.h"

@implementation FindPathService
@synthesize lastResult;

-(id)init:(NSString *)strUrl
{
    BOOL bAscii = true;
    for(int i=0; i< [strUrl length];i++){
        int a = [strUrl characterAtIndex:i];
        if( a > 0x4e00 && a < 0x9fff)
        {
            bAscii = false;
            break;
        }
    }
    
    if (bAscii == false) {
        strUrl =  [strUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
    
    strFindPathUrl = [[NSString alloc] initWithString:strUrl];
    
    NSString *strEnd = [strFindPathUrl substringFromIndex:[strFindPathUrl length]-1];
    strFindPathUrl = [strFindPathUrl stringByAppendingString:[strEnd isEqualToString:@"/"]?@"path.json?":@"/path.json?"];
    
    return self;
    
}

-(void) processAsync:(FindPathParameters*)parameters
{
    if (parameters == NULL) {
        return;
    }
    
    NSString* strJsonParameters = [self getJsonParameters:parameters];
    
    NSString* strHttpUrl = [[NSString alloc]init];
    strHttpUrl=[strFindPathUrl stringByAppendingString:strJsonParameters];
//    NSLog(@"%@",strHttpUrl);
//    strHttpUrl=[strHttpUrl stringByAddingPercentEscapesUsingEncoding:CFStringConvertEncodingToNSStringEncoding(NSASCIIStringEncoding)];
    
    //第一步，创建url
    NSURL *url = [NSURL URLWithString:[strHttpUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    //第二步，创建请求
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:10];
    [request setHTTPMethod:@"GET"];
    [request addValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [[NSURLConnection alloc]initWithRequest:request delegate:self];}

-(NSString *) getJsonParameters:(FindPathParameters *)params
{
    FindPathParameters *parameters=[[FindPathParameters alloc]init];
    parameters=params;
    NSString *strJsonParameters=[[NSString alloc]initWithString:[parameters toString]];
    //NSLog(@"%@",strJsonParameters);
    
    return strJsonParameters;
    
}

//接收到服务器回应的时候调用此方法
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    
//    NSHTTPURLResponse *res = (NSHTTPURLResponse *)response;
    
    data = [[NSMutableData alloc] initWithCapacity:0];
}
//接收到服务器传输数据的时候调用，此方法根据数据大小执行若干次
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)smdata
{
    [data appendData:smdata];
}
//数据传完之后调用此方法
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSString *strReceive = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    
    FindPathResult *findPathResult=[[FindPathResult alloc]init];
    findPathResult=[findPathResult fromJson:strReceive];
    lastResult =findPathResult;
    NSMutableDictionary* dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setValue:findPathResult forKey:@"FindPathResult"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"findPathCompleted" object:nil userInfo:dictionary];
    
}
//网络请求过程中，出现任何错误（断网，连接超时等）会进入此方法
-(void)connection:(NSURLConnection *)connection
 didFailWithError:(NSError *)error
{
    NSLog(@"%@",[error localizedDescription]);
}

@end

