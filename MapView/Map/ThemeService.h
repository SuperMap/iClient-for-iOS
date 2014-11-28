//
//  ThemeService.h
//  MapView
//
//  Created by iclient on 14/11/24.
//
//

#import <Foundation/Foundation.h>
#import "ThemeParameters.h"
#import "ThemeResult.h"

@interface ThemeService : NSObject


/**
 * Constructor: ThemeService
 * 专题图服务类构造函数。
 *
 * 例如：
 * (start code)
 * ServerStytle* stytle1 =[[ServerStytle alloc]initLineStytleWithFillForeColor:[UIColor colorWithRed:242/255.0 green:48/255.0 blue:48/255.0 alpha:1] lineColor:[UIColor colorWithRed:242/255.0 green:48/255.0 blue:48/255.0 alpha:1] lineWidth:1];
 * ServerStytle* stytle2 =[[ServerStytle alloc]initLineStytleWithFillForeColor:[UIColor colorWithRed:255/255.0 green:159/255.0 blue:25/255.0 alpha:1] lineColor:[UIColor colorWithRed:255/255.0 green:159/255.0 blue:25/255.0 alpha:1] lineWidth:1];
 * ServerStytle* stytle3 =[[ServerStytle alloc]initLineStytleWithFillForeColor:[UIColor colorWithRed:91/255.0 green:195/255.0 blue:69/255.0 alpha:1] lineColor:[UIColor colorWithRed:91/255.0 green:195/255.0 blue:69/255.0 alpha:1] lineWidth:1];
 * ServerStytle* defaultStytle =[[ServerStytle alloc]initLineStytleWithFillForeColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1] lineColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1] lineWidth:1];
 *
 * ThemeUniqueItem *item1=[[ThemeUniqueItem alloc]initWithUnique:@"AAAA" serverStyle:stytle1];
 * ThemeUniqueItem *item2=[[ThemeUniqueItem alloc]initWithUnique:@"BBBB" serverStyle:stytle2];
 * ThemeUniqueItem *item3=[[ThemeUniqueItem alloc]initWithUnique:@"CCCC" serverStyle:stytle3];
 * NSMutableArray *items=[[NSMutableArray alloc]initWithObjects:item1,item2,item3,nil];
 *
 * ThemeUnique *themeUinque=[[ThemeUnique alloc]initWithUniqueExpression:@"TrafficStatusT"items:items defaultStyle:defaultStytle];
 *
 * ThemeParameters *param=[[ThemeParameters alloc]initWithDatasetNames:datasetName  dataSourceName:@"Changchun"  themeUnique:themeUinque];
 * ThemeService *service=[[ThemeService alloc]initWithURL:tileThing];
 *
 * [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(processCompletedTheme:) name:@"processCompleted" object:nil];
 *
 * [service processAsync:param];
 * (end)
 *
 * Parameters:
 * strUrl - {NSString} 专题图服务地址。请求网络分析服务，URL应为：
 * 例如:@"http://192.168.1.24:8090/iserver/services/map-china400/rest/maps/China"。
 */

-(instancetype)initWithURL:(NSString *) strUrl;

/**
 * APIMethod: processAsync
 * 负责将客户端的查询参数传递到服务端。
 *
 * Parameters:
 * parameters - {<ThemeParameters>} 专题图参数类。
 */
-(void) processAsync:(ThemeParameters*)parameters;
@end
