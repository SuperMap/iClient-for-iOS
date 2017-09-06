//
//  ServerGeometry.h
//  MapView
//
//  Created by iclient on 13-6-24.
//
//

#import <Foundation/Foundation.h>
#import "RMPath.h"
#import "RMURLConnectionOperation.h"
#import "RMMapContents.h"

/**
 * Class: ServerGeometry
 * 服务端几何对象类。
 * 该类描述几何对象（矢量）的特征数据（坐标点对、几何对象的类型等）。
 * 基于服务端的空间分析、空间关系运算、查询等 GIS 服务功能使用服务端几何对象。
 */
@interface ServerGeometry : NSObject{
    NSString* smid;
    NSMutableArray* parts;
    NSMutableArray* points;
    NSString* type;
}


- (id) fromJson:(NSString*)jsonObject;

- (id) fromJsonDt:(NSDictionary*)jsonObject;

- (id) fromRMPath:(RMPath*)path;


- (NSString*) toJson;
-(RMPath*) toRMPath:(RMMapContents*)aContents;

/**
 * APIProperty: id
 * {NSString} 服务端几何对象唯一标识符。
 */
@property (copy,readwrite) NSString* id;

/**
 * APIProperty: parts
 * {NSMutableArray} 服务端几何对象中各个子对象所包含的节点个数。
 * 1.几何对象从结构上可以分为简单几何对象和复杂几何对象。
 * 简单几何对象与复杂几何对象的区别：简单的几何对象一般为单一对象，
 * 而复杂的几何对象由多个简单对象组成或经过一定的空间运算之后产生，
 * 如：矩形为简单的区域对象，而中空的矩形为复杂的区域对象。
 * 2.通常情况，一个简单几何对象的子对象就是它本身，
 * 因此对于简单对象来说的该字段为长度为1的整型数组，
 * 该字段的值就是这个简单对象节点的个数。
 * 如果一个几何对象是由几个简单对象组合而成的，
 * 例如，一个岛状几何对象由3个简单的多边形组成而成，
 * 那么这个岛状的几何对象的 Parts 字段值就是一个长度为3的整型数组，
 * 数组中每个成员的值分别代表这三个多边形所包含的节点个数。
 */
@property (retain,readwrite) NSMutableArray* parts;

/**
 * APIProperty: points
 * {NSMutableArray} 组成几何对象的节点的坐标对数组。
 * 1.所有几何对象（点、线、面）都是由一些简单的点坐标组成的，
 * 该字段存放了组成几何对象的点坐标的数组。
 * 对于简单的面对象，他的起点和终点的坐标点相同。
 * 2.对于复杂的几何对象，根据 Parts 属性来确定每一个组成复杂几何对象的简单对象所对应的节点的个数，
 * 从而确定 Points 字段中坐标对的分配归属问题。
 */
@property (retain,readwrite) NSMutableArray* points;

/**
 * APIProperty: type
 * {NSString} 几何对象的类型(GeometryType)。
 */
@property (copy,readwrite) NSString* type;

//获取中心点
-(CGPoint)getCentroid;
@end
