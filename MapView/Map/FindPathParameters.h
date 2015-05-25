//
//  FindPathParameters.h
//  MapView
//
//  Created by iclient on 14-5-27.
//
//

#import <Foundation/Foundation.h>

#import "TransportationAnalystParameter.h"
#import "RMPath.h"
#import "ServerGeometry.h"

/**
 * Class: FindPathParameters
 * 最佳路径分析参数类。
 * 最佳路径是在网络数据集中指定一些结点，按照顺序访问结点从而求解起止点之间阻抗最小的路径。
 * 例如如果要顺序访问1、2、3、4四个结点，则需要分别找到1、2结点间的最佳路径 R1—2，2、3间的最佳路径 R2—3和3、4结点间的最佳路径 R3—4，顺序访问1、2、3、4四个结点的最佳路径就是 R= R1—2 + R2—3 + R3—4。
 * 阻抗就是指从一点到另一点的耗费，在实际应用中我们可以将距离、时间、花费等作为阻抗条件。
 * 阻抗最小也就可以理解为从一点到另一点距离最短、时间最少、花费最低等。当两点间距离最短时为最短路径，它是最佳路径问题的一个特例。
 * 阻抗值通过 TransportationAnalystParameter.weightFieldName 设置。
 * 计算最佳路径除了受阻抗影响外，还受转向字段的影响。转向值通过 TransportationAnalystParameter.turnWeightField 设置。
 */
@interface FindPathParameters : NSObject

{
    BOOL isAnalystById;
    BOOL hasLeastEdgeCount;
    NSMutableArray *nodes;
    TransportationAnalystParameter *parameter;
    
}

/**
 * APIProperty: isAnalyzeById
 * {BOOL} 是否通过节点 ID 指定路径分析的结点。
 * 指定路径分析经过的结点或设施点有两种方式：输入结点 ID 号或直接输入点坐标。
 * 当该字段为 YES 时，表示通过结点 ID 指定途经点，即 [[NSMutableArray alloc]initWithObjects:[NSNumber numberWithFloat:ID1],[NSNumber numberWithFloat:ID2],nil];
 * 反之表示通过结点坐标指定途经点，即 [[NSMutableArray alloc]initWithObjects:point1,point2, nil];。
 */
@property (readwrite) BOOL isAnalystById;

/**
 * APIProperty: hasLeastEdgeCount
 * {BOOL} 是否按照弧段数最少的进行最佳路径分析。
 * YES 表示按照弧段数最少进行分析，返回弧段数最少的路径中一个阻抗最小的最佳路径；
 * NO 表示直接返回阻抗最小的路径，而不考虑弧段的多少。
 */
@property (readwrite) BOOL hasLeastEdgeCount;


/**
 * APIProperty: nodes
 * {Array(<RMPath>/Number)} 最佳路径分析经过的结点或设施点数组，必设字段。该字段至少包含两个点。
 * 当 FindPathParameters.isAnalyzeById = YES 时，nodes 应为点的 ID 数组；
 * 当 FindPathParameters.isAnalyzeById = NO 时，nodes 应为点的坐标数组。
 */
@property (retain,readwrite)  NSMutableArray *nodes;

/**
 * APIProperty: parameter
 * {<TransportationAnalystParameter>} 交通网络分析通用参数。
 */
@property (retain,readwrite) TransportationAnalystParameter *parameter;

/**
 * Constructor: FindPathParameters
 * 最佳路径分析参数类构造函数。
 *
 * Parameters:
 * bIsAnalystById - {BOOL} 是否通过节点 ID 指定路径分析的结点。
 * bHasLeastEdgeCount - {BOOL} 是否按照弧段数最少的进行最佳路径分析。
 * mNodes - {Array(<RMPath>/Number)} 最佳路径分析经过的结点或设施点数组，必设字段。该字段至少包含两个点。
 * parameter - {<TransportationAnalystParameter>} 交通网络分析通用参数。
 */
-(id) init:(BOOL)bIsAnalystById bHasLeastEdgeCount:(BOOL)bHasLeastEdgeCount nodes:(NSMutableArray *)mNodes parameter:(TransportationAnalystParameter *)tParameter;

-(NSString *) toString;
@end
