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
- (void) initialize
{
    
}

- (id) initWithTile:(NSString *)layerName linkurl:(NSString*)url;
{
    
    //设置到url请求上的参数
    NSMutableDictionary* paramsDefault=[[NSMutableDictionary alloc] init];
  
    return [self initWithTile:layerName linkurl:url params:paramsDefault];
    
}


- (id)initWithTile:(NSString *)layerName linkurl:(NSString*)url params:(NSMutableDictionary*)params;
{
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
                                                       timeoutInterval:3];
    
    
    [request setHTTPMethod:@"GET"];
    
    
    
    NSHTTPURLResponse* urlResponse = nil;
    
    NSError *error = nil;//[[NSError alloc] init];
    
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    
    //NSLog(@"%@",error);
    if(error)
        return NULL;
    
    NSMutableString *result = [[NSMutableString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    
    //NSLog(@"The result string is :%@",result);
    
    
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
    fbottom = [bottom floatValue];
    left = (NSString *)[viewbounds objectForKey: @"left"];
    fleft = [left floatValue];
    right = (NSString *)[viewbounds objectForKey: @"right"];
    fright = [right floatValue];
    top = (NSString *)[viewbounds objectForKey: @"top"];
    ftop = [top floatValue];
    
    //NSLog(@"The dWidth is :%f",fright-fleft);
    //NSLog(@"The dHeight is :%f",ftop-fbottom);
    
    NSString* strScale;
    strScale = (NSString*)[json objectForKey:@"scale"];
    //NSLog(@"%@",strScale);
    double dScale = [strScale doubleValue];
    //NSLog(@"The scale is :%.20f",dScale);
    
    NSString* height,*width;
    
    viewSize = [json objectForKey: @"viewer"];
    height = (NSString *)[viewSize objectForKey: @"height"];
    width = (NSString *)[viewSize objectForKey: @"width"];
    
    //NSLog(@"The Width is :%@",width);
    //NSLog(@"The Height is :%@",height);
    
    dpi = [self calculateDpi:fright-fleft rvbheight:ftop-fbottom rvWidth:[width intValue] rcHeight:[height intValue] scale:dScale];
   // NSLog(@"The result string is :%f",dpi);
    
    
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
    
    if(layersID !=nil && [layersID length]>0)
    {
        NSString *strLayersID=[NSString stringWithFormat:@"&layersID=%@",layersID];
        aParams=[aParams stringByAppendingString:strLayersID];
    }
    
    strParams=[[NSString alloc]initWithString:aParams];;
    return self;

}

- (float)calculateDpi:(double)viewBoundsWidth rvbheight:(double)viewBoundsHeight rvWidth:(int)nWidth rcHeight:(int)nHeight scale:(double)dScale;
{
    //NSLog(@"%.20f",dScale);

    //用户自定义地图的Options时，若未指定该参数的值，则系统默认为6378137米，即WGS84参考系的椭球体长半轴。
    //nDatumAxis = nDatumAxis || 6378137;
    if ([unit isEqualToString:@"degree"] || [unit isEqualToString:@"degrees"] || [unit isEqualToString:@"dd"]) {
        double num1 = viewBoundsWidth / (float)nWidth;
        double num2 = viewBoundsHeight / (float)nHeight;
        double resolution = num1 > num2 ? num1 : num2;
       // NSLog(@"resolution:::%f",resolution);
        //10000是0.1毫米与1米的转换,用以提高精度
        int ratio=10000;
        //float nDpi = (float)(0.0254 * ratio / resolution / dScale/ ((M_PI * 2 * datumAxis) / 360)) / ratio;
        double dTemp1 = 0.0254 * ratio / resolution;
        double dTemp2 = (M_PI * 2 * datumAxis) / 360;
        double dTemp = dTemp1 / dTemp2;
                         
     //   NSLog(@"dTemp1: %.20f",dTemp1);
      //  NSLog(@"dTemp2: %.20f",dTemp2);
     //   NSLog(@"dTemp: %.20f",dTemp);
        float nDpi = dTemp / dScale /ratio;
        
//        NSLog(@"%f",viewBoundsWidth);
//        NSLog(@"%f",viewBoundsHeight);
//        NSLog(@"%d",nWidth);
//        NSLog(@"%d",nHeight);
//        NSLog(@"%f",resolution);
//        NSLog(@"nDpi:::::::%f",nDpi);
        
        return nDpi;
    } else {
        double resolution = viewBoundsWidth / (float)nWidth;
        float nDpi = 0.0254 / resolution / dScale;
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
            NSString* strResolution = [NSString stringWithFormat:@"%e",resolution];
            //NSLog(@"%@",strResolution);
            return strResolution;
        } else {
            resolution = 0.0254 / dpi / dScale ;
            NSString* strResolution = [NSString stringWithFormat:@"%e",resolution];
            return strResolution;
        }
    }
    NSString* strResolution = @"0.0";
    return strResolution;
}


@end
