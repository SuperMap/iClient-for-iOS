//
//  TransferSolutionResult.m
//  MapView
//
//  Created by supermap on 15-3-3.
//
//

#import "TransferSolutionResult.h"
#import "TransferGuide.h"
#import "TransferSolution.h"
#import "TransferLines.h"

@implementation TransferSolutionResult

-(instancetype)initWithDict:(NSDictionary *)dict{
    [self init];
    
    _suggestWalking = [[dict objectForKey:@"suggestWalking"]  boolValue];
    if (_suggestWalking) {
        _defaultGuide = nil;
        _transferSolution = nil;
    }else{
        _defaultGuide  =  [[TransferGuide alloc] initWithDict:[dict objectForKey:@"defaultGuide"]];
        _transferSolution = [[NSMutableArray alloc] init];
    
        NSArray *solutionsStr = [dict objectForKey:@"solutionItems"];
        for (int i=0; i<[solutionsStr count]; i++) {
            TransferSolution *solution = [[TransferSolution alloc] initWithDict:[solutionsStr objectAtIndex:i]];
            [_transferSolution addObject:solution];
        }
    }
    return self;
}

@end
