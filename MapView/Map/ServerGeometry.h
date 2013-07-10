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
 *	@brief	服务端几何对象类。
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

@property (copy,readwrite) NSString* id;
@property (retain,readwrite) NSMutableArray* parts;
@property (retain,readwrite) NSMutableArray* points;
@property (copy,readwrite) NSString* type;

@end
