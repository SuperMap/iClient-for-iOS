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
 *@brief	地图服务属性类
 * RMSMLayerInfo仅针对SuperMap iServer发布的服务，通过RMSMLayerInfo，可以方便的验证该地图服务是否可链接，获取该地图服务所需要的基本属性信息（该地图的地理范围，坐标单位，地球半径，dpi） \n
 * 使用范例如下：
 * @code 
 * //字符串为SuperMap iServer地图服务的url链接
 * NSString *mapUrl = @"http://support.supermap.com.cn:8090/iserver/services/map-china400/rest/maps/China";
 * //创建地图服务配置信息，参数为地图名和链接地址
 * RMSMLayerInfo* info = [[RMSMLayerInfo alloc] initWithTile:@"China" linkurl:mapUrl];
 * @endcode
 * 通过如上的方法，你可以获取该地图服务的配置信息，方便地图服务的创建和加载
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
 *	@brief	当前地图地理范围的宽度
 */
@property (readwrite) double dWidth;

/**
 *	@brief	当前地图地理范围的高度
 */
@property (readwrite) double dHeight;
/**
 *	@brief	当前地图左上角点坐标位置
 */
@property (readwrite) CLLocationCoordinate2D m_pntOrg;

/**
 *	@brief	当前地图服务的url地址
 */
@property (assign,readwrite) NSString *smurl;


/**
 *	@brief	初始化地图服务
 *
 *	@param 	layerName 	地图名称
 *	@param 	url 	地图服务的url地址
 *
 *	@return	返回地图服务属性类
 */
- (id)initWithTile:(NSString *)layerName linkurl:(NSString*)url;

/**
 *	@brief	计算当前地图服务DPI
 *
 *	@param 	viewBoundsWidth 	视口地理宽度
 *	@param 	viewBoundsHeight 	视口地理高度
 *	@param 	nWidth 	视口像素宽度
 *	@param 	nHeight 	视口像素高度
 *	@param 	dScale 	对应的比例尺
 *
 *	@return	当前地图DPI
 */
- (int)calculateDpi:(double)viewBoundsWidth rvbheight:(double)viewBoundsHeight rvWidth:(int)nWidth rcHeight:(int)nHeight scale:(double)dScale;


/**
 *	@brief	通过当前DPI和分辨率获取比例尺
 *
 *	@param 	dResolution 	分辨率
 *
 *	@return	当前比例尺
 */
-(NSString*) getScaleFromResolutionDpi:(double)dResolution;


@end
