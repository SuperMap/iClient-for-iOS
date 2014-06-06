//
//  FindPathService.h
//  MapView
//
//  Created by iclient on 14-5-27.
//
//

#import <Foundation/Foundation.h>
#import "FindPathParameters.h"
#import "FindPathResult.h"
@interface FindPathService : NSObject
{
    NSString *strFindPathUrl;
    NSMutableData *data;

}

-(id) init:(NSString*)strUrl;

-(void) processAsync:(FindPathParameters*)parameters;

@end
