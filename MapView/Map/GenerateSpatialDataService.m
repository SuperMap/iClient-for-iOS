//
//  GenerateSpatialDataService.m
//  MapView
//
//  Created by iclient on 14/11/26.
//
//

#import "GenerateSpatialDataService.h"

@implementation GenerateSpatialDataService
{
    NSString *_strGenerateSpatialDataServiceUrl;
    NSMutableData *_data;
}

-(instancetype)initWithURL:(NSString *) strUrl
{
    NSString *endString=[strUrl substringFromIndex:[strUrl length]-1];
    if(![endString isEqualToString:@"/"])
    {
        
        strUrl=[strUrl stringByAppendingString:@"/"];
    }
    
    _strGenerateSpatialDataServiceUrl = [[NSString alloc] initWithString:strUrl];
    
    return self;
    
}
-(instancetype)getServiceURL:(NSString *) strUrlEnd
{
    
    NSString  *serviceUrl=[_strGenerateSpatialDataServiceUrl stringByAppendingString:strUrlEnd];
    BOOL bAscii = true;
    for(int i=0; i< [serviceUrl length];i++){
        int a = [serviceUrl characterAtIndex:i];
        if( a > 0x4e00 && a < 0x9fff)
        {
            bAscii = false;
            break;
        }
    }
    
    if (bAscii == false) {
        serviceUrl =  [serviceUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
    
    _strGenerateSpatialDataServiceUrl = serviceUrl;
    
    return self;
    
}

-(void) processAsync:(GenerateSpatialDataParameters*)parameters
{
    
    NSString *strURLEnd=[NSString stringWithFormat:@"datasets/%@/linearreferencing/generatespatialdata.json?returnContent=true",[parameters routeTable]];
    [self getServiceURL:strURLEnd];
    
    NSString *strJsonParams=[[NSString alloc]initWithString:[self getStrJsonParam:parameters]];
    
    //第一步，创建url
    NSURL *url = [NSURL URLWithString:_strGenerateSpatialDataServiceUrl];
    //第二步，创建请求
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:10];
    
    [request setHTTPMethod:@"POST"];
    
    NSData *data = [strJsonParams dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    [request addValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    //第三步，连接服务器
    [[NSURLConnection alloc]initWithRequest:request delegate:self];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    
//    NSHTTPURLResponse *res = (NSHTTPURLResponse *)response;
    
    _data = [[NSMutableData alloc] initWithCapacity:0];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)smdata
{
    [_data appendData:smdata];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSString *receiveStr = [[NSString alloc]initWithData:_data encoding:NSUTF8StringEncoding];
    //NSLog(@"%@",receiveStr);
    
    GenerateSpatialDataResult *result=[[GenerateSpatialDataResult alloc]initWithJson:receiveStr];
    
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    [dict setObject:result forKey:@"GenerateSpatialDataResult"];
    if (result.succeed) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"generateSpatialCompleted" object:nil userInfo:dict];
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"generateSpatialFailed" object:nil userInfo:dict];
      
    }
    
}

-(void)connection:(NSURLConnection *)connection
 didFailWithError:(NSError *)error
{
    NSLog(@"%@",[error localizedDescription]);
    
}

-(NSString *)getStrJsonParam:(GenerateSpatialDataParameters*)param
{
    NSError *e;
    NSData *jsonData=[NSJSONSerialization dataWithJSONObject:[param toDictionary] options:NULL error:&e];
    NSString *strJson=[[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    return strJson;
}


@end
