//
//  RMSMMeasureService.m
//  MapView
//
//  Created by iclient on 13-6-19.
//
//

#import "RMSMMeasureService.h"

@implementation RMSMMeasureService

static void saveApplier(void* info, const CGPathElement* element)
{
	NSMutableArray* a = (NSMutableArray*) info;
    
	int nPoints;
	switch (element->type)
	{
		case kCGPathElementMoveToPoint:
			nPoints = 1;
			break;
		case kCGPathElementAddLineToPoint:
			nPoints = 1;
			break;
		case kCGPathElementAddQuadCurveToPoint:
			nPoints = 2;
			break;
		case kCGPathElementAddCurveToPoint:
			nPoints = 3;
			break;
		case kCGPathElementCloseSubpath:
			nPoints = 0;
			break;
		default:
			[a replaceObjectAtIndex:0 withObject:[NSNumber numberWithBool:NO]];
			return;
	}
    
	//NSNumber* type = [NSNumber numberWithInt:element->type];
	//NSData* points = [NSData dataWithBytes:element->points length:nPoints*sizeof(CGPoint)];
    //NSLog(@"num is %d",nPoints);
	//[a addObject:element->points];
    [a addObject:[NSNumber numberWithDouble:element->points[0].x]];
    [a addObject:[NSNumber numberWithDouble:element->points[0].y]];
}

- (void)initialize {
    
}

- (id)init:(NSString*)mapurl {
    
    BOOL bAscii = true;
    for(int i=0; i< [mapurl length];i++){
        int a = [mapurl characterAtIndex:i];
        if( a > 0x4e00 && a < 0x9fff)
        {
            bAscii = false;
            break;
        }
    }
    
    if (bAscii == false) {
        mapurl =  [mapurl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }

    
    strUrl = [[NSString alloc] initWithString:mapurl];
    return self;
}

- (void) processAsync:(RMSMMeasureParameters*)para {
    RMPath* pPath = para.m_Path;
    if(pPath.bIsClosePath)
        m_Mode = AREA;
    else
        m_Mode = DISTANCE;
    
    NSString *strEnd = [strUrl substringFromIndex:[strUrl length]-1];
    if (m_Mode == AREA) {
        strUrl = [strUrl stringByAppendingString:[strEnd isEqualToString:@"/"]?@"area.jsonp?":@"/area.json?"];
    }else{
        strUrl = [strUrl stringByAppendingString:[strEnd isEqualToString:@"/"]?@"distance.jsonp?":@"/distance.json?"];
    }
    
    int nCount =[[NSNumber numberWithUnsignedLong:[pPath.points count]] intValue];
    NSString* strJson = [[NSString alloc] initWithString:@"point2Ds=["];
    for (int i=0;i<nCount; i++) {
        if(i!=0)
            strJson = [strJson stringByAppendingString:@","];
        CGPoint pp;// = [[a objectAtIndex:i] CGPointValue];
        pp = [[pPath.points objectAtIndex:i] CGPointValue];
        NSString* strPoint = [[NSString alloc] initWithFormat:@"{'x':%f,'y':%f}",pp.x,pp.y];
        strJson = [strJson stringByAppendingString:strPoint];
        //NSLog(@"json:%@",strPoint);
    }
    strJson = [strJson stringByAppendingString:@"]&unit="];
    strJson =[strJson stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    strJson = [strJson stringByAppendingString:para.m_Unit];
    
    
    strUrl = [strUrl stringByAppendingString:strJson];
        
    url = [[NSURL alloc] initWithString:strUrl];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"GET"];
    [request addValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    [[NSURLConnection alloc]initWithRequest:request delegate:self];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{

//    NSHTTPURLResponse *res = (NSHTTPURLResponse *)response;

    data = [[NSMutableData alloc] initWithCapacity:0];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)smdata
{
    [data appendData:smdata];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSString *receiveStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    //NSLog(@"%@",receiveStr);
    NSError *e;
    
    NSDictionary *JSON =
    [NSJSONSerialization JSONObjectWithData: [receiveStr dataUsingEncoding:NSUTF8StringEncoding]
                                    options: NSJSONReadingMutableContainers
                                      error: &e];
    
    if ([JSON objectForKey:@"succeed"]) {
       [[NSNotificationCenter defaultCenter] postNotificationName:@"measureError" object:nil userInfo:JSON]; 
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"measureComplete" object:nil userInfo:JSON];
    }
}

-(void)connection:(NSURLConnection *)connection
didFailWithError:(NSError *)error
{
    NSLog(@"%@",[error localizedDescription]);
}

@end
