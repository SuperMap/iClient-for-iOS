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

/**
 * Class: ThemeService
 * 专题图服务类。
 * 该类负责将客户设置的专题图服务参数传递给服务端，并接收服务端返回的专题图服务结果数据。
 * 专题图结果通过该类支持的事件的监听函数获取，获取的结果数据为服务端返回的专题图结果数据result， 保存在ThemeResult 对象中。
 *
 * Inherits from:
 *  - <NSObject>
 */
@interface ThemeService : NSObject


/**
 * Constructor: ThemeService
 * 专题图服务类构造函数。
 *
 * 例如：
 * (start code)
 * //设置专题图子项的stytle
 * ServerStytle* stytle1 =[[ServerStytle alloc]initLineStytleWithFillForeColor:[UIColor colorWithRed:242/255.0 green:48/255.0 blue:48/255.0 alpha:1] lineColor:[UIColor colorWithRed:242/255.0 green:48/255.0 blue:48/255.0 alpha:1] lineWidth:1];
 * //设置专题图子项的stytle
 * ServerStytle* stytle2 =[[ServerStytle alloc]initLineStytleWithFillForeColor:[UIColor colorWithRed:255/255.0 green:159/255.0 blue:25/255.0 alpha:1] lineColor:[UIColor colorWithRed:255/255.0 green:159/255.0 blue:25/255.0 alpha:1] lineWidth:1];
 * ServerStytle* stytle3 =[[ServerStytle alloc]initLineStytleWithFillForeColor:[UIColor colorWithRed:91/255.0 green:195/255.0 blue:69/255.0 alpha:1] lineColor:[UIColor colorWithRed:91/255.0 green:195/255.0 blue:69/255.0 alpha:1] lineWidth:1];
 *
 * //设置专题图默认stytle
 * ServerStytle* defaultStytle =[[ServerStytle alloc]initLineStytleWithFillForeColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1] lineColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1] lineWidth:1];
 * //设置专题图子项
 * ThemeUniqueItem *item1=[[ThemeUniqueItem alloc]initWithUnique:@"拥挤" serverStyle:stytle1];
 * ThemeUniqueItem *item2=[[ThemeUniqueItem alloc]initWithUnique:@"缓行" serverStyle:stytle2];
 * ThemeUniqueItem *item3=[[ThemeUniqueItem alloc]initWithUnique:@"畅通" serverStyle:stytle3];
 * NSMutableArray *items=[[NSMutableArray alloc]initWithObjects:item1,item2,item3,nil];
 * //设置单值专题图
 * ThemeUnique *themeUinque=[[ThemeUnique alloc]initWithUniqueExpression:@"TrafficStatus"items:items defaultStyle:defaultStytle];
 * //设置专题图参数
 * ThemeParameters *param=[[ThemeParameters alloc]initWithDatasetNames:datasetName  dataSourceName:@"Changchun"  themeUnique:themeUinque];
 * //初始化专题图服务
 * ThemeService *service=[[ThemeService alloc]initWithURL:tileThing];
 * //监听专题图回调函数
 * [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(processCompletedTheme:) name:@"themeCompleted" object:nil];
 * //将客户端的专题图参数传递到服务端。
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
 * 负责将客户端的专题图参数传递到服务端。
 * 请求成功通知标识为"themeCompleted"，失败为"themeFailed"
 *
 * Parameters:
 * parameters - {<ThemeParameters>} 专题图参数类。
 */
-(void) processAsync:(ThemeParameters*)parameters;
@end
