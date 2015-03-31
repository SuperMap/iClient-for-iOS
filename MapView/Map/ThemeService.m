//
//  ThemeService.m
//  MapView
//
//  Created by iclient on 14/11/24.
//
//

#import "ThemeService.h"
#import "ThemeResult.h"
#import "GenerateSpatialDataResult.h"

@implementation ThemeService
{
    NSString *_strThemeServiceUrl;
    NSMutableData *_data;
}
-(instancetype)initWithURL:(NSString *) strUrl
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
    
    _strThemeServiceUrl = [[NSString alloc] initWithString:strUrl];
    
    NSString *strEnd = [_strThemeServiceUrl substringFromIndex:[_strThemeServiceUrl length]-1];
    _strThemeServiceUrl = [_strThemeServiceUrl stringByAppendingString:[strEnd isEqualToString:@"/"]?@"tempLayersSet.json?":@"/tempLayersSet.json?"];
    
    return self;
    
}

-(void) processAsync:(ThemeParameters*)parameters
{
    
    NSString* strJsonParamsA = [parameters toJsonParameters];
    NSString* strJsonParams=[self strJsonParamsWitMapName:strJsonParamsA];
    
    //第一步，创建url
    NSURL *url = [NSURL URLWithString:_strThemeServiceUrl];
    //第二步，创建请求
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:10];
    
    [request setHTTPMethod:@"POST"];
    
    NSData *data = [strJsonParams dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
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
//    NSLog(@"%@",receiveStr);
    
    ThemeResult *themeResult=[[ThemeResult alloc]initWithJson:receiveStr];
    
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    
    [dict setObject:themeResult forKey:@"ThemeResult"];
    
    if (themeResult.resourceInfo.isSucceed) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"themeCompleted" object:nil userInfo:dict];
    
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"themeFailed" object:nil userInfo:dict];

    }
}

-(void)connection:(NSURLConnection *)connection
 didFailWithError:(NSError *)error
{
    NSLog(@"%@",[error localizedDescription]);
    
}

-(NSString *)strJsonParamsWitMapName:(NSString *)strJsonParams
{
    
    NSArray *URLSplit=[_strThemeServiceUrl componentsSeparatedByString:@"/"];
    NSString *mapName=[URLSplit objectAtIndex:[URLSplit count]-2];
    
    NSString *urlMapName=[NSString stringWithFormat:@"'name':'%@'}]",mapName];
    strJsonParams=[strJsonParams stringByAppendingString:urlMapName];
    return strJsonParams;
}

@end

