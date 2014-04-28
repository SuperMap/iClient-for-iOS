/**
 * @file    RMSMLayerInfo.h
 * @brief   SuperMap iServer MapService地图服务属性类
 * @author  Guowei Lu
 * @version 1.0
 * @date    2013.6.7
 * @bug     It has not been implemented yet
 * @warning No
 */

#import <Foundation/Foundation.h>
#import "RMTile.h"
#import "RMLatLong.h"

/**
 * Class: RMSMLayerInfo
 * 地图服务属性类
 */
@interface RMSMLayerInfo : NSObject {
    NSString *smurl;
    NSString* name;
    CLLocationCoordinate2D m_pntOrg;
    double dWidth;
    double dHeight;
    NSString*  unit;
    int datumAxis;
    int dpi;
    NSString *strParams;
}

/**
* APIProperty: dWidth
* {double} 当前地图地理范围的宽度。
*/
@property (readwrite) double dWidth;

/**
* APIProperty: dHeight
* {double} 当前地图地理范围的高度。
*/
@property (readwrite) double dHeight;

/**
* APIProperty: m_pntOrg
* {CLLocationCoordinate2D} 当前地图左上角点坐标位置。
*/
@property (readwrite) CLLocationCoordinate2D m_pntOrg;

/**
* Property: smurl
* {NSString} 当前地图服务的url地址。
*/
@property (assign,readwrite) NSString *smurl;

/**
 * Property: strParams
 * {NSString} url的可选参数字符串。
 */
@property (assign,readwrite) NSString *strParams;
 /**
 * Constructor: initWithTile
 * 所有SuperMap iServer 6R 分块动态 REST 图层。
 * (start code)  
 * //字符串为SuperMap iServer地图服务的url链接
 * NSString *mapUrl = @"http://support.supermap.com.cn:8090/iserver/services/map-china400/rest/maps/China";
 * //创建地图服务配置信息，参数为地图名和链接地址
 * RMSMLayerInfo* info = [[RMSMLayerInfo alloc] initWithTile:@"China" linkurl:mapUrl];
 * (end)
 * 
 * Parameters:
 * layerName - {NSString}  图层名称。
 * url - {NSString} 图层的服务地址。     
 */
- (id)initWithTile:(NSString *)layerName linkurl:(NSString*)url;

/**
 * Constructor: initWithTile
 * 所有SuperMap iServer 6R 分块动态 REST 图层。
 * (start code)
 * //字符串为SuperMap iServer地图服务的url链接
 * NSString *mapUrl = @"http://support.supermap.com.cn:8090/iserver/services/map-china400/rest/maps/China";
 * //将BOOL值转为NSNumber类型，用以作为可选参数NSMutableDictionary的value值
 * NSNumber *yesNum=[NSNumber numberWithBool:YES];   
 * NSNumber *noNum=[NSNumber numberWithBool:NO];
 * NSMutableDictionary存储url的可选参数，包括redirect、cacheEnabled、transparent。
 * NSMutableDictionary *parmas=[[NSMutableDictionary alloc] initWithObjectsAndKeys:noNum,@"redirect",yesNum,@"transparent",yesNum,@"cacheEnabled",nil];
 * //创建地图服务配置信息，参数为地图名、链接地址和可选参数NSMutableDictionary
 * RMSMLayerInfo* info = [[RMSMLayerInfo alloc] initWithTile:@"China" linkurl:mapUrl params:parmas];
 * (end)
 *
 * Parameters:
 * layerName - {NSString}  图层名称。
 * url - {NSString} 图层的服务地址。
 * params - {NSMutableDictionary} 设置到url上的可选参数，目前可选参数包括：
 * transparent: {BOOL} 图层是否透明，默认为 NO，即不透明。
 * cacheEnabled: {BOOL} 是否使用服务端的缓存，默认为 YES，即使用服务端的缓存。
 * redirect: {BOOL} 是否重定向，HTTP 传输中的一个概念。如果为 YES，则将请求重定向到图片的真实地址；
 * 如果为 NO，则响应体中是图片的字节流。默认为 NO，不进行重定向。
 */

- (id)initWithTile:(NSString *)layerName linkurl:(NSString*)url params:(NSMutableDictionary*)params;

/**
* APIMethod: calculateDpi
* 计算当前地图服务DPI。
*
* Parameters:
* viewBoundsWidth - {double} 视口地理宽度
* viewBoundsHeight - {double} 视口地理高度
* nWidth - {double} 视口像素宽度
* nHeight - {double} 视口像素宽度
* dScale - {double} 对应比例尺 
*
* Returns:
* {<int>}  当前地图DPI。
*/
- (int)calculateDpi:(double)viewBoundsWidth rvbheight:(double)viewBoundsHeight rvWidth:(int)nWidth rcHeight:(int)nHeight scale:(double)dScale;

/**
* APIMethod: getScaleFromResolutionDpi
* 根据指定的分辨率，返回对应的比例尺。
*
* Parameters:
* dResolution - {double} 分辨率
*
* Returns:
* {<NSString>}  当前地图比例尺。
*/
-(NSString*) getScaleFromResolutionDpi:(double)dResolution;

/**
 * APIMethod: getResolutionFromScaleDpi
 * 根据指定的比例尺，返回对应的分辨率。
 *
 * Parameters:
 * dScale - {double} 比例尺
 *
 * Returns:
 * {<NSString>}  当前地图分辨率。
 */

-(NSString*) getResolutionFromScaleDpi:(double)dScale;

@end
