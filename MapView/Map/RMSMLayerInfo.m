//
//  RMSMLayerInfo.m
//  MapView
//
//  Created by iclient on 13-6-7.
//
//

#import "RMSMLayerInfo.h"

@implementation RMSMLayerInfo

@synthesize dWidth,dHeight;
@synthesize m_pntOrg;
@synthesize smurl;
@synthesize strParams;
@synthesize projection;
@synthesize layerInfoList;
- (void) initialize
{
    
}

- (id) initWithTile:(NSString *)layerName linkurl:(NSString*)url;
{
    
    //设置到url请求上的参数
    NSMutableDictionary* paramsDefault=[[NSMutableDictionary alloc] init];
    
    return [self initWithTile:layerName linkurl:url params:paramsDefault];
    
}

- (id)initWithTile:(NSString *)layerName linkurl:(NSString*)url params:(NSMutableDictionary*)params{
    
    return [self initWithTile:layerName linkurl:url params:params isUseDisplayFilter:NO];
}
- (id)initWithTile:(NSString *)layerName linkurl:(NSString*)url params:(NSMutableDictionary*)params isUseDisplayFilter:(BOOL) isUseDisplayFilter
{
    self.tempLayerName = nil;
    self.tempLayerInfo = nil;
    self.isUseDisplayFilter = isUseDisplayFilter;
    // 判断url中是否有汉字
    BOOL bAscii = true;
    for(int i=0; i< [url length];i++){
        int a = [url characterAtIndex:i];
        if( a > 0x4e00 && a < 0x9fff)
        {
            bAscii = false;
            break;
        }
    }
    
    if (bAscii == false) {
        url =  [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
    
    smurl = [[NSString alloc] initWithString:url];
    
    
    
    name = [[NSString alloc] initWithString:layerName];
    //[smurl initWithString:url];
    //NSLog(@"%@",smurl);
    NSString *urlString =[NSString stringWithFormat:@"%@.json",smurl];
    
    
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                       timeoutInterval:30];
    
    
    [request setHTTPMethod:@"GET"];
    
    
    
    NSHTTPURLResponse* urlResponse = nil;
    
    NSError *error = nil;//[[NSError alloc] init];
    
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    
//    NSLog(@"%@",error);
    if(error)
        return NULL;
    
    NSMutableString *result = [[NSMutableString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    
//    NSLog(@"The result string is :%@",result);
    
    
    NSString *immutableString = [NSString stringWithString:result];
    
    NSData* aData = [immutableString dataUsingEncoding: NSUTF8StringEncoding];
    
    NSDictionary* json =[NSJSONSerialization
                         JSONObjectWithData:aData //1
                         options:kNilOptions
                         error:nil];
    
    //NSLog(@"The result string is :%@",json);
    id bounds,viewbounds,viewSize;
    NSString *bottom,*left,*right,*top;
    double fbottom,fleft,fright,ftop;
    
    bounds = [json objectForKey: @"bounds"];
    bottom = (NSString *)[bounds objectForKey: @"bottom"];
    fbottom = [bottom floatValue];
    left = (NSString *)[bounds objectForKey: @"left"];
    fleft = [left floatValue];
    right = (NSString *)[bounds objectForKey: @"right"];
    fright = [right floatValue];
    top = (NSString *)[bounds objectForKey: @"top"];
    ftop = [top floatValue];
    
    m_pntOrg.latitude = ftop;
    m_pntOrg.longitude = fleft;
    dWidth = fright - fleft;
    dHeight = ftop - fbottom;
    
    NSString* strDatumAxis;
    strDatumAxis = (NSString*)[json objectForKey: @"datumAxis"];
    if(strDatumAxis == NULL)
        datumAxis = 6378137;
    else
        datumAxis = [strDatumAxis intValue];
    
    //NSLog(@"The datumAxis is :%d",datumAxis);
    
    unit = (NSString*)[json objectForKey: @"coordUnit"];
    unit = [unit lowercaseString];
    
    //NSLog(@"unit: %@",unit);
    
    id prjCoordSys=[json objectForKey: @"prjCoordSys"];
    projection=@"EPSG:";
    
    NSString* epsgCode=[[[NSNumberFormatter alloc] init] stringFromNumber:(NSNumber*)[prjCoordSys objectForKey: @"epsgCode"]];
    projection=[projection stringByAppendingString:epsgCode];
    //NSLog(@"%@",projection);
    
    viewbounds = [json objectForKey: @"viewBounds"];
    bottom = (NSString *)[viewbounds objectForKey: @"bottom"];
    fbottom = [bottom doubleValue];
    left = (NSString *)[viewbounds objectForKey: @"left"];
    fleft = [left doubleValue];
    right = (NSString *)[viewbounds objectForKey: @"right"];
    fright = [right doubleValue];
    top = (NSString *)[viewbounds objectForKey: @"top"];
    ftop = [top doubleValue];
    
    //NSLog(@"The dWidth is :%f",fright-fleft);
    //NSLog(@"The dHeight is :%f",ftop-fbottom);
   
    self.scales = [json objectForKey:@"visibleScales"];
    
    double dScale = [[json objectForKey:@"scale"] doubleValue];
    //NSLog(@"The scale is :%.20f",dScale);
    
    NSString* height,*width;
    
    viewSize = [json objectForKey: @"viewer"];
    height = (NSString *)[viewSize objectForKey: @"height"];
    width = (NSString *)[viewSize objectForKey: @"width"];
    
    
    dpi = [self calculateDpi:fright-fleft rvbheight:ftop-fbottom rvWidth:[width intValue] rcHeight:[height intValue] scale:dScale];    
    
    if (self.isUseDisplayFilter == true) {
        if (![self createTempLayer] || ![self layerInfo] ) {
            return nil;
        }
    }
    
    [self initStrParams:params];
    return self;
}

- (void) initStrParams:(NSMutableDictionary*) params{
    [self setUrlParam:params];
    
    //获取params的所有有效参数并返回url请求参数的字符串
    NSString *strTransparent=@"true",*strCacheEnabled=@"true",*strRedirect=@"false";
    NSNumber *nTransparent=[params objectForKey:@"transparent"];
    NSNumber *nCacheEnabled=[params objectForKey:@"cacheEnabled"];
    NSNumber *nRedirect=[params objectForKey:@"redirect"];
    NSString *layersID=[params objectForKey:@"layersID"];
    
    if (nTransparent!=nil) {
        BOOL bTransparent=[nTransparent boolValue];
        if (!bTransparent) {strTransparent=@"false";}
    }
    if (nCacheEnabled!=nil) {
        BOOL bCacheEnabled=[nCacheEnabled boolValue];
        if (!bCacheEnabled) {strCacheEnabled=@"false";}
    }
    if (nRedirect!=nil) {
        BOOL bRedirect=[nRedirect boolValue];
        if (bRedirect) {strRedirect=@"true";}
    }
    
    NSString *aParams=[[NSString alloc] initWithFormat:@"transparent=%@&cacheEnabled=%@&redirect=%@",strTransparent,strCacheEnabled,strRedirect];
    self.strLayersID = nil;
    if(layersID !=nil && [layersID length]>0)
    {
        self.strLayersID=[NSString stringWithFormat:@"&layersID=%@",layersID];
        aParams=[aParams stringByAppendingString:self.strLayersID];
    }
    
    strParams=[[NSString alloc]initWithString:aParams];
}


- (double)calculateDpi:(double)viewBoundsWidth rvbheight:(double)viewBoundsHeight rvWidth:(int)nWidth rcHeight:(int)nHeight scale:(double)dScale;
{
    //NSLog(@"%.20f",dScale);

    //用户自定义地图的Options时，若未指定该参数的值，则系统默认为6378137米，即WGS84参考系的椭球体长半轴。
    //nDatumAxis = nDatumAxis || 6378137;
    if ([unit isEqualToString:@"degree"] || [unit isEqualToString:@"degrees"] || [unit isEqualToString:@"dd"]) {
        double num1 = viewBoundsWidth / (double)nWidth;
        double num2 = viewBoundsHeight / (double)nHeight;
        double resolution = num1 > num2 ? num1 : num2;
       // NSLog(@"resolution:::%f",resolution);
        //10000是0.1毫米与1米的转换,用以提高精度
        int ratio=10000;
        //float nDpi = (float)(0.0254 * ratio / resolution / dScale/ ((M_PI * 2 * datumAxis) / 360)) / ratio;
        double dTemp1 = 0.0254 * ratio / resolution;
        double dTemp2 = (M_PI * 2 * datumAxis) / 360;
        double dTemp = dTemp1 / dTemp2;
        
        double nDpi = dTemp / dScale /ratio;
        return nDpi;
    } else {
        double resolution = viewBoundsWidth / (double)nWidth;
        double nDpi = 0.0254 / resolution / dScale;
        return nDpi;
    }
}

-(NSString*) getScaleFromResolutionDpi:(double)dResolution
{
    double scale;
    //NSLog(@"unit :%@",unit);
    //用户自定义地图的Options时，若未指定该参数的值，则系统默认为6378137米，即WGS84参考系的椭球体长半轴。
    //datumAxis = datumAxis || 6378137;
    //coordUnit = coordUnit || "";
    if (dResolution > 0 && dpi > 0) {
        
        if ([unit isEqualToString:@"degree"] || [unit isEqualToString:@"degrees"] || [unit isEqualToString:@"dd"])
        {
            //NSLog(@"unit degree");
            
            scale = 0.0254 / dpi / dResolution / ((M_PI * 2 * datumAxis) / 360);
            NSString* strScale = [NSString stringWithFormat:@"%.20f",scale];
            //NSLog(@"%@",strScale);
            return strScale;
        } else {
            scale = 0.0254 / dpi / dResolution ;
            NSString* strScale = [NSString stringWithFormat:@"%.20f",scale];
            return strScale;
        }
    }
    NSString* strScale = @"0.0";
    return strScale;
}

-(NSString*) getResolutionFromScaleDpi:(double)dScale
{
    double resolution;
    //NSLog(@"unit :%@",unit);
    //用户自定义地图的Options时，若未指定该参数的值，则系统默认为6378137米，即WGS84参考系的椭球体长半轴。
    //datumAxis = datumAxis || 6378137;
    //coordUnit = coordUnit || "";
    if (dScale > 0 && dpi > 0) {
       
        if ([unit isEqualToString:@"degree"] || [unit isEqualToString:@"degrees"] || [unit isEqualToString:@"dd"])
        {
            //NSLog(@"unit degree");
            
            resolution = 0.0254 / dpi / dScale / ((M_PI * 2 * datumAxis) / 360);
            NSString* strResolution = [NSString stringWithFormat:@"%.20f",resolution];
            //NSLog(@"%@",strResolution);
            return strResolution;
        } else {
            resolution = 0.0254 / dpi / dScale ;
            NSString* strResolution = [NSString stringWithFormat:@"%.20f",resolution];
            return strResolution;
        }
    }
    NSString* strResolution = @"0.0";
    return strResolution;
}

// 创建临时图层
-(BOOL) createTempLayer{
    // 如果tempLayer已存在，则不创建新的tempLayer
    if (self.tempLayerName) {
        return true;
    }
    
    NSString *endUrl = [[[NSString alloc] init] stringByAppendingFormat:@"%@/tempLayersSet.json?returnPostAction=true&getMethodForm=true",smurl];
    //第一步，创建url
    NSURL *url = [NSURL URLWithString:endUrl];
    //第二步，创建请求
    NSMutableURLRequest *request =
    [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:10];
    [request setHTTPMethod:@"post"];
    [request addValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    NSURLResponse *response;
    NSError *error = nil;
    NSError *err = nil;
    NSData *data =  [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data  options:NSJSONWritingPrettyPrinted error:&err];
    if (err || error) {
        NSLog(@"%@,%@",error,err);
        return false;
    }
    
    self.tempLayerName = [dict objectForKey:@"newResourceID"];
    
    return true;
}

// 获取临时图层列表
- (NSArray *)tempLayers{
    if (self.tempLayers) {
        return self.tempLayers;
    }
    NSString *endUrl = [[[NSString alloc] init] stringByAppendingFormat:@"%@/tempLayersSet.json?returnPostAction=true&getMethodForm=true",smurl];
    //第一步，创建url
    NSURL *url = [NSURL URLWithString:endUrl];
    //第二步，创建请求
    NSMutableURLRequest *request =
    [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:10];
    [request setHTTPMethod:@"get"];
    [request addValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    NSURLResponse *response;
    NSError *error;
    NSData *data =  [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSArray *arr = [NSJSONSerialization JSONObjectWithData:data  options:NSJSONWritingPrettyPrinted error:nil];
    NSMutableArray *tempLayer = [[NSMutableArray alloc] init];
    for (int i=0; i < [arr count]; i++) {
        [tempLayer addObject:[arr objectAtIndex:i]];
    }
//    NSLog(@"%@",tempLayer);
    self.tempLayers = tempLayer;
    return self.tempLayers;
}
/*
// 删除临时图层
- (BOOL) deleteTempLayer{
    NSString *endUrl = [[[NSString alloc] init] stringByAppendingFormat:@"%@/tempLayersSet/%@.json?returnPostAction=true&getMethodForm=true",smurl,self.tempLayerName];
    //第一步，创建url
    NSURL *url = [NSURL URLWithString:endUrl];
    //第二步，创建请求
    NSMutableURLRequest *request =
    [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:10];
    [request setHTTPMethod:@"delete"];
    [request addValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    NSURLResponse *response;
    NSError *error;
    NSData *data =  [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data  options:NSJSONWritingPrettyPrinted error:nil];
    if ([[dict objectForKey:@"succeed"] intValue] == 1) {
        return true;
    }else{
        NSLog(@"%@",[dict objectForKey:@"error"]);
        return false;
    }
}
 */
// 更新临时图层--{内部图层内对象显示控制}
// dict:obj-displayFilter  key-index
- (BOOL)updateTempLayer:(NSDictionary *)dict{
    
    // 如果没有启用DisplayFilter，则请求创建临时图层并获取临时图层信息
    if (!self.tempLayerName || !self.tempLayerInfo ) {
        [self setIsUseDisplayFilter:YES];
        if (![self createTempLayer] || ![self layerInfo] ) {
            return false;
        }else if(self.strLayersID){
            NSArray *arr =  [[self.strLayersID substringWithRange:NSMakeRange(1, [self.strLayersID length]-2)] componentsSeparatedByString:@","];
            NSArray *layers = [[self.tempLayerInfo objectForKey:@"subLayers"] objectForKey:@"layers"];
            for (int i=0; i<[layers count]; i++) {
                if ([arr containsObject:[NSString stringWithFormat:@"%d",i]]) {
                    [[layers objectAtIndex:i] setObject:@"true" forKey:@"visible"];
                }else{
                    [[layers objectAtIndex:i] setObject:@"false" forKey:@"visible"];
                }
            }
        }
    }
    // 备份数据
    NSMutableDictionary *lastDict = [[NSMutableDictionary alloc] init];
    
    NSArray *layers = [[self.tempLayerInfo objectForKey:@"subLayers"] objectForKey:@"layers"];

    // 清除displayFilter的条件，要求每次输入完全形态的查询条件
    for (int i=0; i<[layers count]; i++) {
        [[layers objectAtIndex:i] setValue:@"null" forKey:@"displayFilter"];
    }
    NSArray *keys = [dict allKeys];
    for (int i=0;i<[keys count];i++) {
        NSString *displayFilter  = [dict objectForKey:[keys objectAtIndex:i]];
        [lastDict setObject:[[layers objectAtIndex:[[keys objectAtIndex:i] intValue]] objectForKey:@"displayFilter"] forKey:[keys objectAtIndex:i]];
        [[layers objectAtIndex:[[keys objectAtIndex:i] intValue]] setObject:displayFilter forKey:@"displayFilter"];
    }
    
//    NSLog(@"%@",self.tempLayerInfo);
    
    NSString *endUrl = [[[NSString alloc] init] stringByAppendingFormat:@"%@/tempLayersSet/%@.json?returnPutAction=true",smurl,self.tempLayerName];
    //第一步，创建url
    NSURL *url = [NSURL URLWithString:endUrl];
    //第二步，创建请求
    NSMutableURLRequest *request =
    [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:10];
    [request setHTTPMethod:@"put"];
    // 将tempLayerInfo对象转换为json字符串，并替换掉其中的"null" 为null
    NSString *datas = [[[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:self.tempLayerInfo options:nil error:nil] encoding:NSUTF8StringEncoding] stringByReplacingOccurrencesOfString:@"\"null\"" withString:@"null"];
//    NSLog(@"%@",[NSString stringWithFormat:@"[%@]",datas]);
   
    [request setHTTPBody:[[NSString stringWithFormat:@"[%@]", datas] dataUsingEncoding:NSUTF8StringEncoding]];
    [request addValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    NSURLResponse *response;
    NSError *error = nil;
    NSError *err = nil;
    NSData *data =  [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSDictionary *dictof = [NSJSONSerialization JSONObjectWithData:data  options:NSJSONWritingPrettyPrinted error:&err];
    if (!error && !err && [[dictof objectForKey:@"succeed"] intValue] == 1) {
        return true;
    }else{
        NSLog(@"%@",[dictof objectForKey:@"error"]);
        // 还原数据
        for (int i=0; i<[lastDict count]; i++) {
            NSString *displayFilter  = [lastDict objectForKey:[keys objectAtIndex:i]];
            [[layers objectAtIndex:[[keys objectAtIndex:i] intValue]] setObject:displayFilter forKey:@"displayFilter"];
        }
        return false;
    }
    
}

-(BOOL)layerInfo{
    NSString *endUrl = [[[NSString alloc] init] stringByAppendingFormat:@"%@/tempLayersSet/%@.json?returnPostAction=true&getMethodForm=true",smurl,self.tempLayerName];
    //第一步，创建url
    NSURL *url = [NSURL URLWithString:endUrl];
    //第二步，创建请求
    NSMutableURLRequest *request =
    [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:10];
    [request setHTTPMethod:@"get"];
    [request addValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    NSURLResponse *response;
    NSError *error = nil;
    NSError *err = nil;
    NSData *data =  [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSArray *arr = [NSJSONSerialization JSONObjectWithData:data  options:NSJSONWritingPrettyPrinted error:&err];
    if (!err && !error) {
        self.tempLayerInfo = [arr objectAtIndex:0];
        return true;
    }else{
        NSLog(@"get TempLayerInfo failed...");
        return false;
    }
}

- (BOOL)setTempLayer:(NSString *)layersID{
    NSArray *arr =  [[layersID substringWithRange:NSMakeRange(1, [layersID length]-2)] componentsSeparatedByString:@","];
    NSArray *layers = [[self.tempLayerInfo objectForKey:@"subLayers"] objectForKey:@"layers"];
    // 数据备份
    NSMutableDictionary *lastDict = [[NSMutableDictionary alloc] init];
    
    for (int i=0; i<[layers count]; i++) {
        [lastDict setValue:[[layers objectAtIndex:i] objectForKey:@"visible"] forKey:[NSString stringWithFormat:@"%d",i]];
        if ([arr containsObject:[NSString stringWithFormat:@"%d",i]]) {
            [[layers objectAtIndex:i] setObject:@"true" forKey:@"visible"];
        }else{
            [[layers objectAtIndex:i] setObject:@"false" forKey:@"visible"];
        }
    }
    
//    NSString *subLayerName = [[layers objectAtIndex:index] objectForKey:@"name"];
//    NSString *endUrl = [[[NSString alloc] init] stringByAppendingFormat:@"%@/tempLayersSet/%@/%@@@%@.json?returnPutAction=true",smurl,self.tempLayerName,subLayerName,[self.tempLayerInfo objectForKey:@"name"]];
    NSString *endUrl = [[[NSString alloc] init] stringByAppendingFormat:@"%@/tempLayersSet/%@.json?returnPutAction=true",smurl,self.tempLayerName];

    //第一步，创建url
    NSURL *url = [NSURL URLWithString:endUrl];
    //第二步，创建请求
    NSMutableURLRequest *request =
    [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:10];
    [request setHTTPMethod:@"put"];
//    NSString *datas = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:[layers objectAtIndex:index] options:nil error:nil] encoding:NSUTF8StringEncoding];
    // 传入数据为tempLayer的json数据，若之传入当前图层的json数据，图层显示控制请求成功后，瓦片地图请求不能及时刷新，仍然显示原来的瓦片地图，需要过一段时间才能反应过来
    NSString *datas = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:[self tempLayerInfo] options:nil error:nil] encoding:NSUTF8StringEncoding];
    
    [request setHTTPBody:[[NSString stringWithFormat:@"[%@]", datas] dataUsingEncoding:NSUTF8StringEncoding]];
    [request addValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    NSURLResponse *response;
    NSError *error = nil;
    NSError *err = nil;
    NSData *data =  [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data  options:NSJSONWritingPrettyPrinted error:&err];
    
    if (!err && !error && [[dict objectForKey:@"succeed"] intValue] == 1) {
        return true;
    }else{
        NSLog(@"%@",[dict objectForKey:@"error"]);
        for (int i=0; i<[layers count]; i++) {
            [[layers objectAtIndex: i] setValue:[lastDict objectForKey:[NSString stringWithFormat:@"%d",i]] forKey:@"visible"];
        }
        return false;
    }
}

-(NSArray *)layerInfoList{
    if(layerInfoList){
        return layerInfoList;
    }
    
    NSString *name = [smurl substringFromIndex:[smurl rangeOfString:@"/" options:NSBackwardsSearch].location+1];
    NSString *endUrl = [[[NSString alloc] init] stringByAppendingFormat:@"%@/layers/%@.json",smurl,name];
    //第一步，创建url
    NSURL *url = [NSURL URLWithString:endUrl];
    //第二步，创建请求
    NSMutableURLRequest *request =
    [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:10];
    [request setHTTPMethod:@"get"];
    [request addValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    NSURLResponse *response;
    NSError *error = nil;
    NSError *err = nil;
    NSData *data =  [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data  options:NSJSONWritingPrettyPrinted error:&err];
    if (!err && !error) {
        self.layerInfoList = [[dict objectForKey:@"subLayers"] objectForKey:@"layers"];
        return layerInfoList;
    }else{
        NSLog(@"get layerInfo failed...");
        return nil;
    }
}

@end
