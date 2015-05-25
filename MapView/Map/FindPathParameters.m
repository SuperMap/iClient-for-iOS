//
//  FindPathParameters.m
//  MapView
//
//  Created by iclient on 14-5-27.
//
//

#import "FindPathParameters.h"

@implementation FindPathParameters
@synthesize isAnalystById,hasLeastEdgeCount,nodes,parameter;

-(id) init:(BOOL)bIsAnalystById bHasLeastEdgeCount:(BOOL)bHasLeastEdgeCount nodes:(NSMutableArray *)mNodes parameter:(TransportationAnalystParameter *)tParameter
{
    self.isAnalystById=bIsAnalystById;
    self.hasLeastEdgeCount=bHasLeastEdgeCount;
    self.nodes=mNodes;
    self.parameter=tParameter;
    return self;
}

-(NSString *) toString
{
    NSString *strNodes=[[NSString alloc]initWithString:@"&nodes="];
    int nCount=[self.nodes count]>0?[[NSNumber numberWithUnsignedLong:[self.nodes count]] intValue]:0;
    if (nCount>0) {
        if (!self.isAnalystById) {
            strNodes = [strNodes stringByAppendingString:@"["];
            RMPath *path = [RMPath alloc];
            for (int i=0;i<nCount;i++) {
                //当nodes不是坐标数组时报错
            NSAssert([[self.nodes objectAtIndex:i] isMemberOfClass:[path class]],@"the value of FindPathParameters.isAnalyzeById is NO,but FindPathParameters.nodes is NSMutableArray of nodes's id");
                path=[self.nodes objectAtIndex:i];
                CGPoint point=[[path.points objectAtIndex:0]CGPointValue];
                if(i!=0)
                    strNodes = [strNodes stringByAppendingString:@","];
                NSString* strPoint = [[NSString alloc] initWithFormat:@"{'x':%f,'y':%f}",point.x,point.y];
                strNodes = [strNodes stringByAppendingString:strPoint];
            }
            strNodes=[strNodes stringByAppendingString:@"]"];
            
        }
        else {
            NSError *error;
            NSData *jsonData=[NSJSONSerialization dataWithJSONObject:self.nodes options:NULL error:&error];
            NSString *jsonNodes=[[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
            strNodes=[strNodes stringByAppendingString:jsonNodes];
            
        }
    }
    else
    {
        strNodes=nil;
    }
    
    // NSLog(@"%@",strNodes);
    
    NSString *strParameters=[[NSString alloc]initWithString:self.hasLeastEdgeCount?@"&hasLeastEdgeCount=true":@"&hasLeastEdgeCount=false"];
    strParameters=[strParameters stringByAppendingString:strNodes];
    strParameters=[[strParameters stringByAppendingString:@"&parameter="]stringByAppendingString:[self.parameter toString]];
    return strParameters;
}


@end
