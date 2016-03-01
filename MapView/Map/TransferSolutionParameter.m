//
//  TransferSolutionParameter.m
//  MapView
//
//  Created by supermap on 15-3-6.
//
//

#import "TransferSolutionParameter.h"

@implementation TransferSolutionParameter
@synthesize travelTime;
-(id)init{
    if (self = [super init]) {
        _points = nil;
        _solutionCount = 5;
        _walkingRatio = 10;
        _transferTactic = nil;
        _transferPreference = nil;
        _evadelLines =nil;
        _evadelStops = nil;
        _priorLines = nil;
        _priorStops = nil;
        self.travelTime = nil;
    }
    return self;
}
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
