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
    double dpi;
    NSString *strParams;
    NSString * projection;
    NSArray *layerInfoList;
}

@property (nonatomic,retain) NSMutableArray *scales;
/**
 * APIProperty: layerInfoList
 * {NSArray} 图层信息列表。
 */
@property (nonatomic,retain) NSArray  *layerInfoList;

/**
 * APIProperty: isUseDisplayFilter
 * {BOOL} 是否使用图层过滤。
 */
@property (nonatomic) BOOL  isUseDisplayFilter;

/**
 * APIProperty: tempLayerInfo
 * {NSDictionary} 临时图层的json描述。
 */
@property (retain,nonatomic) NSDictionary *tempLayerInfo;

/**
 * APIProperty: tempLayerName
 * {NSString} 临时图层的名称。
 */
@property (retain,nonatomic) NSString *tempLayerName;

/**
 * APIProperty: tempLayers
 * {NSArray} 临时图层的子图层列表。
 */
@property (nonatomic,retain) NSArray *tempLayers;

/**
 * APIProperty: strLayersID
 * {NSString} 需要显示的图层id拼接的字符串。
 */
@property (nonatomic,retain) NSString *strLayersID;

/**
* APIProperty: dWidth
* {double} 当前地图地理范围的宽度。
*/
@property (readwrite) double dWidth;

//缓存路径
@property(nonatomic,strong)NSString* cachePath;


@property (retain,readonly) NSString * projection;

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
@property (retain,readwrite) NSString *strParams;

/**
 * Property: urlParam
 * {NSString} url的可选参数集合字典。
 */
@property (retain,nonatomic) NSMutableDictionary* urlParam;

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


- (id)initWithTile:(NSString *)layerName linkurl:(NSString*)url params:(NSMutableDictionary*)params isUseDisplayFilter:(BOOL) isUseDisplayFilter;

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
- (double)calculateDpi:(double)viewBoundsWidth rvbheight:(double)viewBoundsHeight rvWidth:(int)nWidth rcHeight:(int)nHeight scale:(double)dScale;

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

/**
 * APIMethod: initStrParams
 * 初始化StrParams参数
 *
 * Parameters:
 * params - {NSMutableDictionary} 服务器返回的地图参数字典
 *
 */
- (void) initStrParams:(NSMutableDictionary*) params;

/**
 * APIMethod: createTempLayer
 * 创建临时图层
 *
 *
 * Returns:
 * {<BOOL>}  临时图层创建是否成功。
 */
-(BOOL) createTempLayer;
//-(NSArray *)tempLayerList;

/**
 * APIMethod: deleteTempLayer
 * 根删除临时图层
 *
 * Returns:
 * {<BOOL>}  是否删除成功。
 */
- (BOOL) deleteTempLayer;
/**
 * APIMethod: updateTempLayer
 * 更新临时图层，用于临时图层子图层的内部对象显示控制。
 *
 * Parameters:
 * dict - {NSDictionary} 以临时图层的子图层索引为key，过滤条件为value的字段，用于显示控制
 *
 * Returns:
 * {<BOOL>}  地图信息更新是否成功。
 */

- (BOOL)updateTempLayer:(NSDictionary *)dict;
/**
 * APIMethod: setTempLayer
 * 控制临时图层子图层的显示和隐藏。
 *
 * Parameters:
 * layersID - {NSString} 子图层索引号的字符串
 *
 * Returns:
 * {<BOOL>}  地图信息更新是否成功。
 */

- (BOOL)setTempLayer:(NSString *)layersID;
/**
 * APIMethod: layerInfo
 * 临时图层信息，主要用于初始化tempLayerInfo变量。
 *
 * Returns:
 * {<BOOL>}  获取临时图层信息是否成功。
 */

- (BOOL)layerInfo;
@end
