//
//  RMSMMBTileSource.m
//  MapView
//
//  Created by iclient on 13-7-11.
//
//

#import "RMSMMBTileSource.h"
#import "RMSMTileProjection.h"
#import "FMDatabase.h"
#import "RMProjection.h"
#import "RMTileImage.h"
#import "MapView_Prefix.pch"
#import "RMSMTileProjection_inner.h"

@interface RMSMMBTileSource()
{
    NSMutableDictionary* mResolutionXY;
}
@end
@implementation RMSMMBTileSource

- (id)initWithTileSetURL:(NSString *)tileSetURL
{
    /*
    NSLog(@"%@",tileSetURL);
    sqlite3* m_database;
    if (sqlite3_open([tileSetURL UTF8String], &m_database) != SQLITE_OK) {
        sqlite3_close(m_database);
        NSLog(@"数据库打开失败");
    }
	
	
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    const char* sqlQuery = "select name,value from metadata";
    sqlite3_stmt * statement;
    
    int nresult = sqlite3_prepare_v2(m_database, sqlQuery, -1, &statement, nil);
    if (nresult==SQLITE_OK)  {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            char *name = (char*)sqlite3_column_text(statement, 0);
            NSString *nsNameStr = [[NSString alloc]initWithUTF8String:name];
            
            char *value = (char*)sqlite3_column_text(statement, 1);
            NSString *nsValueStr = [[NSString alloc]initWithUTF8String:value];
            [dict setObject:nsValueStr forKey:nsNameStr];
        }
    }
    NSLog(@"%d",nresult);
     */
   // mOrinX = mOrinY = 0;
    db = [[FMDatabase databaseWithPath:tileSetURL] retain];
    if([tileSetURL hasSuffix:@".mbtiles"]){
		file_extension = @"mbtiles";
	}
	else if([tileSetURL hasSuffix:@".smtiles"]){
		file_extension = @"smtiles";
	}

    if ( ! [db open])
        return nil;

    
    FMResultSet *results = [db executeQuery:@"select name,value from metadata"];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    while ([results next]){
        [dict setObject:[results stringForColumn:@"value"] forKey:[results stringForColumn:@"name"]];
    }
    //[results next];
    
    //NSLog(@"%@",(NSString*)[dict objectForKey:@"resolutions"]);
    //NSLog(@"%@",[[dict objectForKey:@"resolutions"] stringValue]);
    NSString *resolutions = (NSString*)[dict objectForKey:@"resolutions"];
    //NSLog(@"re is :%@",resolutions);
    NSArray *reArray = [resolutions componentsSeparatedByString: @","];
    m_dResolutions = [[NSMutableArray alloc] init];
    
    mResolutionXY = [[NSMutableDictionary alloc]initWithCapacity:5];
    int key = 0;
    for (NSString* res in reArray)
    {        
        [m_dResolutions addObject:res];
        results = [db executeQuery:[NSString stringWithFormat:@"select tile_column,tile_row from map where resolution == %@ limit 1", res]];
        [results next];
        NSString* column = [results stringForColumn:@"tile_column"];
        NSString* row = [results stringForColumn:@"tile_row"];
        
        [mResolutionXY setObject:@[column,row] forKey:[[NSNumber alloc] initWithInt:key++]];
    }
    //FMResultSet* resultsXY = [db executeQuery:@"select tile_id from map"];
    
    NSString *scales =  (NSString*)[dict objectForKey:@"scales"];
    //NSLog(@"%@",    scales);
    NSArray *saArray = [scales componentsSeparatedByString: @","];
    
    m_dScales = [[NSMutableArray alloc] init];
    for (NSString* scale in saArray)
    {
        double stringFloat = [scale doubleValue];
        NSString *myString = [NSString stringWithFormat:@"%.20f", 1/stringFloat];
        
        [m_dScales addObject:myString];
    }
    
        //NSLog(@"%@",m_dResolutions);
            //NSLog(@"%@",m_dScales);
    NSString* referResolution = [m_dResolutions objectAtIndex:0];
    NSString* referScale = [m_dScales objectAtIndex:0];
    
    NSString *crs_wkt = (NSString*)[dict objectForKey:@"crs_wkt"];
    NSString *unit = @"";// = comfirmUnit(crs_wkt);
    
    if([crs_wkt rangeOfString:@"METER"].location != NSNotFound)
    {
        unit = @"meter";
    }
    else if([crs_wkt rangeOfString:@"DEGREE"].location != NSNotFound)
    {
        unit = @"degree";
    }
    else if([crs_wkt rangeOfString:@"DECIMAL_DEGREE"].location != NSNotFound)
    {
        unit = @"dd";
    }
    
    NSString* dpi;
    int ratio = 10000;
    //系统默认为6378137米，即WGS84参考系的椭球体长半轴。
    int datumAxis = 6378137;
    double stringScale = [referScale doubleValue];
    double stringResolution= [referResolution doubleValue];
    if([unit isEqualToString:@"degree"] || [unit isEqualToString:@"degrees"] ||[unit isEqualToString:@"dd"] )
    {
        
        double result = 0.0254*ratio / stringResolution / stringScale / ((M_PI * 2 * datumAxis) / 360) / ratio;
        
        dpi = [NSString stringWithFormat:@"%f", result];
    }else{
        double result = 0.0254 / stringScale/ stringResolution;
        dpi = [NSString stringWithFormat:@"%f", result];
    }
    
    NSString *bounds = (NSString*)[dict objectForKey:@"bounds"];
    NSArray *bArray = [bounds componentsSeparatedByString: @","];
    
    NSMutableDictionary *boundsArray = [[NSMutableDictionary alloc] init];
    
    [boundsArray setObject:[bArray objectAtIndex:0] forKey:@"left"];
    [boundsArray setObject:[bArray objectAtIndex:1] forKey:@"bottom"];
    [boundsArray setObject:[bArray objectAtIndex:2] forKey:@"right"];
    [boundsArray setObject:[bArray objectAtIndex:3] forKey:@"top"];
    
    NSString *compatible = (NSString*)[dict objectForKey:@"compatible"];
    
    m_config = [[NSMutableDictionary alloc] init];
    
    [m_config setObject:dpi forKey:@"dpi"];
    [m_config setObject:unit forKey:@"unit"];
    [m_config setObject:boundsArray forKey:@"bounds"];
    [m_config setObject:compatible forKey:@"compatible"];
    //NSLog(@"%@",m_config);
    tileProjection = [[RMSMTileProjection alloc] initFromProjection:[self projection] tileSideLength:256 maxZoom:[m_dResolutions count]-1 minZoom:0 info:nil resolutions:m_dResolutions];
    tileProjection.orinXY = mResolutionXY;
    [self setMaxZoom:[m_dResolutions count]-1];
	[self setMinZoom:0];
    _isBaseLayer=NO;
    return self;
    }

-(void) dealloc
{
	[tileProjection release];
    
    [db close];
    [db release];
    
	[super dealloc];
}

-(int)tileSideLength
{
	return [[NSNumber numberWithUnsignedLong:tileProjection.tileSideLength] intValue];
}

- (void) setTileSideLength: (NSUInteger) aTileSideLength
{
	[tileProjection setTileSideLength:aTileSideLength];
}

-(float) minZoom
{
	return (float)tileProjection.minZoom;
}

-(float) maxZoom
{
	return (float)tileProjection.maxZoom;
}

-(void) setMinZoom:(NSUInteger)aMinZoom
{
	[tileProjection setMinZoom:aMinZoom];
}

-(void) setMaxZoom:(NSUInteger)aMaxZoom
{
	[tileProjection setMaxZoom:aMaxZoom];
}

-(RMSphericalTrapezium) latitudeLongitudeBoundingBox;
{
	return ((RMSphericalTrapezium){.northeast = {.latitude = 90, .longitude = 180}, .southwest = {.latitude = -90, .longitude = -180}});
}

-(NSString*) tileFile: (RMTile) tile
{
	return nil;
}

-(NSString*) tilePath
{
	return nil;
}

-(RMTileImage *)tileImage:(RMTile)tile
{	
	tile = [tileProjection normaliseTile:tile];
	
    int x = tile.x;
    int y = tile.y;
    int z = tile.zoom;
	
    NSString *sql=[[NSString alloc]init ];
	if([file_extension isEqualToString:@"mbtiles"] ){
		//MBTiles y对应的图片排列为倒序，所以需再倒序
		y=pow(2, z)-1-y;
		//NSLog(@"x :%d y:%d,z:%d",tile.x,tile.y,tile.zoom);
		//bool bcompatible = [[m_config objectForKey:@"compatible"] boolValue];
		
	    //NSLog(@"%@",m_dResolutions);
		//if(false)
		//{
		//	int y1 = (1 << z) - y - 1;
		//	y = y1;
		//}
		
		//int key = [m_dResolutions count] - 1 - z;		
		
		//NSString* resolution = [m_dResolutions objectAtIndex:z];
		//NSLog(@"x :%d y:%d,res:%@",x,y,resolution);
		
		//NSString *sql = @"select tile_data from tiles where tile_column=%d and tile_row=%d and resolution>%@-0.0000001 and resolution<%@+0.0000001";
		//sql = [NSString stringWithFormat:sql, x,y,resolution,resolution];
		
		sql = @"select tile_data from tiles where tile_column=%d and tile_row=%d and zoom_level=%d";
		sql = [NSString stringWithFormat:sql, x,y,z];
        
        
	}
	else if([file_extension isEqualToString:@"smtiles"]){
		//NSLog(@"x :%d y:%d,z:%d",tile.x,tile.y,tile.zoom);
		
		NSString* resolution = [m_dResolutions objectAtIndex:z];
		//NSLog(@"x :%d y:%d,res:%@",x,y,resolution);
		
		sql = @"select tile_data from tiles where tile_column=%d and tile_row=%d and resolution>%@-0.0000001 and resolution<%@+0.0000001";
		sql = [NSString stringWithFormat:sql, x,y,resolution,resolution];
	}
	else{
		return [RMTileImage dummyTile:tile];
	}
    FMResultSet *results = [db executeQuery:sql];
    
    if ([db hadError])
        return [RMTileImage dummyTile:tile];
    
    [results next];
    
    NSData *data = [results dataForColumn:@"tile_data"];
    
    RMTileImage *image;
    
    if ( ! data)
        image = [RMTileImage dummyTile:tile];
    
    else
        image = [RMTileImage imageForTile:tile withData:data];
    
    [results close];
    
    return image;
}

-(id<RMMercatorToTileProjection>) mercatorToTileProjection
{
	return [[tileProjection retain] autorelease];
}

-(RMProjection*) projection
{
    NSDictionary* bounds = [[NSDictionary alloc] init];
    bounds = [m_config objectForKey:@"bounds"];
    
    double dleft = [[bounds objectForKey:@"left"] doubleValue];
    double dbottom = [[bounds objectForKey:@"bottom"] doubleValue];
    double dright = [[bounds objectForKey:@"right"] doubleValue];
    double dtop = [[bounds objectForKey:@"top"] doubleValue];
    
    double dWidth = dright - dleft;
    double dHeight = dtop - dbottom;
    
//        NSLog(@"%f,%f,%f,%f",dleft,dbottom,dWidth,dHeight);
    RMProjectedRect theBounds = RMMakeProjectedRect(dleft,dbottom,dWidth,dHeight);
    
    return [RMProjection smProjection:theBounds];
}

-(void) didReceiveMemoryWarning
{
	LogMethod();
}

-(NSString*) tileURL: (RMTile) tile
{
	return nil;
}


-(float) numberZoomLevels
{
    return [m_dScales count]-1;
}

-(NSString*) uniqueTilecacheKey
{
	return @"SuperMap";
}

-(NSString *)shortName
{
	return @"SM";
}
-(NSString *)longDescription
{
	return @"Su";
}
-(NSString *)shortAttribution
{
	return @"SuperMap iServer REST Map";
}
-(NSString *)longAttribution
{
	return @"SuperMap iServer REST Map";
}
-(void) removeAllCachedImages
{
}
-(NSMutableArray*) m_dScales
{
    return m_dScales;
}
-(void) setM_dScales:(NSMutableArray*) scales
{
    [m_dScales release];
    m_dScales=scales;
}
-(void) setIsBaseLayer:(BOOL)isBaseLayer
{
    _isBaseLayer=isBaseLayer;
}
@end
