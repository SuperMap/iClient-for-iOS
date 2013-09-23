//
//  TileMapServiceSource.h
//  Images
//
//  Created by Tracy Harton on 02/06/09
//  Copyright 2009 Tracy Harton. All rights reserved.
//

#import "RMAbstractMercatorWebSource.h"
/**
 * Class: RMTileMapServiceSource
 *
 * Inherits from:
 *  - <RMAbstractMercatorWebSource>
 */
@interface RMTileMapServiceSource : RMAbstractMercatorWebSource <RMAbstractMercatorWebSource>
{
  NSString *host, *key;
}
/**
 * Constructor: init
 */
-(id) init: (NSString*) _host uniqueKey: (NSString*) _key minZoom: (float) _minZoom maxZoom: (float) _maxZoom;

@end
