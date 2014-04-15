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
* APIProperty: smurl
* {NSString} 当前地图服务的url地址。
*/
@property (assign,readwrite) NSString *smurl;
 
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
