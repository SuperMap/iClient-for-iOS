//
//  ServerGeometry.m
//  MapView
//
//  Created by iclient on 13-6-24.
//
//
#import "ServerGeometry.h"

@implementation ServerGeometry

@synthesize id,parts,points,type;

- (id) fromJson:(NSString*)jsonObject
{
    NSData* data = [jsonObject dataUsingEncoding:NSUTF8StringEncoding];
    NSArray *values = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    
    NSDictionary *JSON2 = [values objectAtIndex:0];
    //NSError *error;
    
    //NSDictionary *JSON2 =
    //[NSJSONSerialization JSONObjectWithData: [jsonObject dataUsingEncoding:NSUTF8StringEncoding]
     //                               options: NSJSONReadingMutableContainers
      //                                error: &error];
//    NSLog(@"JSON DIct: %@", JSON2);
    //if([JSON objectForKey:@"type"] != nil)
    
    NSArray* keys;
    keys = [JSON2 allKeys];
 //   NSLog(@"%d",[keys count]);
    NSDictionary* JSON = [[NSDictionary alloc] init];
    JSON = [JSON2 objectForKey:@"geometry"];
  //  NSLog(@"JSON DIct: %@", JSON);
    
    type = [[NSString alloc] initWithString:[JSON objectForKey:@"type"]];
  //  NSLog(@"%@",type);

    smid = [[NSString alloc] initWithFormat:@"%d",[[JSON objectForKey:@"id"] intValue]];
    
  //  NSLog(@"%@&%@",type,smid);
    
    parts = [[NSMutableArray alloc] init];
    parts = [JSON objectForKey: @"parts"];
    
    NSMutableArray *arrayPoints = [[NSMutableArray alloc] init];
    arrayPoints = [JSON objectForKey:@"points"];
    
    points = [[NSMutableArray alloc] init];
    
    int count = [[NSNumber numberWithUnsignedLong:[arrayPoints count]] intValue] ;

    for (int i = 0; i < count; i++)
    {
        NSDictionary* dict = [[NSDictionary alloc] init];
        dict = [arrayPoints objectAtIndex:i];
        
        CGPoint pnt;
        pnt.x = [[dict objectForKey:@"x"] floatValue];
        pnt.y = [[dict objectForKey:@"y"] floatValue];
        [points addObject:[NSValue valueWithCGPoint:pnt]];
    }

    
    //NSString* strParts = [[NSString alloc] initWithString:[JSON objectForKey:@"parts"]];
    return  self;
}
-(CGPoint)getCentroid{
    NSArray* arr = self.points;
    int n=0;
    double dx=0,dy=0;
    for(id i in arr){
       CGPoint point = ((NSValue*)i).CGPointValue;
        dx += point.x;
        dy += point.y;
        n++;
        NSLog(@"%@",i);
    }
    
    dx = dx/n;
    dy = dy/n;
    
    double dLen = 0;
    CGPoint g ;
    for(id i in arr){
        CGPoint point = ((NSValue*)i).CGPointValue;
        double dxTmp = point.x;
        double dyTmp = point.y;
        double dLenTmp = sqrt( (dx-dxTmp)*(dx-dxTmp)+(dy-dyTmp)*(dy-dyTmp) );
        
        if(dLen==0){
            dLen = dLenTmp;
            g = point;
        }
        
        if(dLen>dLenTmp){
            dLen = dLenTmp;
            g = point;
        }
        
       // NSLog(@"%@",i);
    }
    
    return g;
}
- (id) fromRMPath:(RMPath*)path
{
    int nPointsCount = [[NSNumber numberWithUnsignedLong:[path.points count]] intValue];
    //int nPartsCount = [path.parts count];
    BOOL bClosePath = path.bIsClosePath;
    
    if (nPointsCount == 1) {
        type = GeometryType_POINT;
    }else if (bClosePath){
        type = GeometryType_REGION;
    }else{
        type = GeometryType_LINE;
    }
    
    smid = [[NSString alloc] initWithString:@"0"];
    
    parts = [[NSMutableArray alloc] init];
    parts = [NSMutableArray arrayWithArray:path.parts];
    
    points = [[NSMutableArray alloc] init];
    points = [NSMutableArray arrayWithArray:path.points];
    return self;
}

- (id) fromJsonDt:(NSDictionary*)JSON
{
    type = [[NSString alloc] initWithString:[JSON objectForKey:@"type"]];
  //  NSLog(@"%@",type);
    
    smid = [[NSString alloc] initWithFormat:@"%d",[[JSON objectForKey:@"id"] intValue]];
    
   // NSLog(@"%@&%@",type,smid);
    
    parts = [[NSMutableArray alloc] init];
    parts = [JSON objectForKey: @"parts"];
    
    NSMutableArray *arrayPoints = [[NSMutableArray alloc] init];
    arrayPoints = [JSON objectForKey:@"points"];
    
    points = [[NSMutableArray alloc] init];
    
    int count = [[NSNumber numberWithUnsignedLong:[arrayPoints count]] intValue];
//    int countParts = [parts count];
  //  NSLog(@"%d",countParts);
   // NSLog(@"%d",count);
    for (int i = 0; i < count; i++)
    {
        NSDictionary* dict = [[NSDictionary alloc] init];
        dict = [arrayPoints objectAtIndex:i];
        
        CGPoint pnt;
        pnt.x = [[dict objectForKey:@"x"] floatValue];
        pnt.y = [[dict objectForKey:@"y"] floatValue];
        [points addObject:[NSValue valueWithCGPoint:pnt]];
    }
    
    return self;
}

- (NSString*) toJson
{    
    NSMutableArray *arrayOfPoints = [[NSMutableArray alloc] init];
    int nCount = [[NSNumber numberWithUnsignedLong:[points count]] intValue];
    for (int i = 0; i < nCount; i++) {
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSString stringWithFormat:@"%f", [[points objectAtIndex:i] CGPointValue].x], @"x",
                              [NSString stringWithFormat:@"%f", [[points objectAtIndex:i] CGPointValue].y], @"y",
                              nil];
        [arrayOfPoints addObject:dict];
    }
    
    NSDictionary *dictAll = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithInt:0],@"id",

                             parts, @"parts",
                             arrayOfPoints, @"points",
                             type,@"type", nil];
    /*
    NSDictionary *dictResult = [NSDictionary dictionaryWithObjectsAndKeys:
                          dictAll,@"geometry",
                          nil];
     */
    
    //NSMutableArray *arrayResult = [[NSMutableArray alloc] init];
    //[arrayResult addObject:dictResult];
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictAll
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
  //  NSLog(@"%@",jsonString);

    return jsonString;
}

-(RMPath*) toRMPath:(RMMapContents*)aContents
{
    RMPath* path = [[RMPath alloc] initWithContents:aContents];
    int i,j,nCountPoints;
    int nCountParts = [[NSNumber numberWithUnsignedLong:[parts count]] intValue];
    j = nCountPoints = 0;
    CLLocationCoordinate2D coord;
    CGPoint pnt;
    for (i=0; i<nCountParts; i++) {
        BOOL bMoveTo = true;
        nCountPoints += [[parts objectAtIndex:i] intValue];
        for (; j<nCountPoints; j++) {
            pnt = [[points objectAtIndex:j] CGPointValue];
            coord.longitude = pnt.x;
            coord.latitude = pnt.y;
            if (bMoveTo) {
                [path moveToLatLong:coord];
                bMoveTo = false;
            }else{
                [path addLineToLatLong:coord];
            }
        }
        if ([type isEqualToString:GeometryType_REGION]) {
            [path closePath];
        }
    }
    
    return path;
}

@end
