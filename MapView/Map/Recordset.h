//
//  Recordset.h
//  MapView
//
//  Created by iclient on 13-6-26.
//
//

#import <Foundation/Foundation.h>
#import "ServerFeature.h"

/**
 *	@brief	查询结果记录集 \n
 * 将查询出来的地物按照图层进行划分，一个查询记录集存放一个图层的查询结果，
 * 即查询出的所有地物要素。
 */
@interface Recordset : NSObject

{
    NSString* datasetName;
    NSMutableArray* fieldCaptions;
    NSMutableArray* fields;
    NSMutableArray* fieldTypes;
    NSMutableArray* features;
}

@property (copy,readwrite) NSString* datasetName;
@property (retain,readwrite) NSMutableArray* fieldCaptions;
@property (retain,readwrite) NSMutableArray* fields;
@property (retain,readwrite) NSMutableArray* fieldTypes;
@property (retain,readwrite) NSMutableArray* features;

-(id) initfromJson:(NSDictionary*)strJson;

@end
