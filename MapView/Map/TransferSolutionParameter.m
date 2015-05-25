//
//  TransferSolutionParameter.m
//  MapView
//
//  Created by supermap on 15-3-6.
//
//

#import "TransferSolutionParameter.h"

@implementation TransferSolutionParameter
-(id)initWithPoints:(NSMutableArray *) points solutionCount:(NSInteger *) solutionCount walkingRatio:(double) walkingRatio transferTactic:(NSString *) transferTactic transferPreference:(NSString *)transferPreference{
    [self init];
    _points = points;
    _solutionCount = solutionCount;
    _walkingRatio = walkingRatio;
    _transferTactic = transferTactic;
    _transferPreference = transferPreference;
    return self;
}
@end
