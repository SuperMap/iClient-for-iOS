//
//  ServerFeature.h
//  MapView
//
//  Created by iclient on 13-6-26.
//
//

#import <Foundation/Foundation.h>
#import "ServerGeometry.h"

/**
 * Class: ServerFeature
 * 服务端矢量要素类。
 * 该类描述了服务端返回的矢量要素的相关信息，包括字段和几何信息。
 */
@interface ServerFeature : NSObject
{
    NSMutableArray* fieldNames;
    NSMutableArray* fieldValues;
    ServerGeometry* geometry;
}

@property (retain,readwrite) NSMutableArray* fieldNames;

@property (retain,readwrite) NSMutableArray* fieldValues;
@property (retain,readwrite) ServerGeometry* geometry;

-(id) initfromJson:(NSDictionary*)strJson;


@end
