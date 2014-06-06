//
//  FindPathResult.h
//  MapView
//
//  Created by iclient on 14-5-28.
//
//

#import <Foundation/Foundation.h>
#import "Path.h"

@interface FindPathResult : NSObject
{
    NSMutableArray *pathList;
    
}


@property (retain,readonly) NSMutableArray *pathList;

-(id) fromJson:(NSString*)strJson;

@end
