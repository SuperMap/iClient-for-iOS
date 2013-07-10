//
//  RMCloudMapSource.m
//  MapView
//
//  Created by iclient on 13-7-4.
//
//

#import "RMCloudMapSource.h"

@implementation RMCloudMapSource

-(id) init
{
	if(self = [super init])
	{
		//http://wiki.openstreetmap.org/index.php/FAQ#What_is_the_map_scale_for_a_particular_zoom_level_of_the_map.3F
		[self setMaxZoom:18];
		[self setMinZoom:0];
	}
	return self;
}

-(NSString*) tileURL: (RMTile) tile
{
	NSAssert4(((tile.zoom >= self.minZoom) && (tile.zoom <= self.maxZoom)),
			  @"%@ tried to retrieve tile with zoomLevel %d, outside source's defined range %f to %f",
			  self, tile.zoom, self.minZoom, self.maxZoom);
	return [NSString stringWithFormat:@"http://t0.supermapcloud.com/FileService/image?map=quanguo&type=web&x=%d&y=%d&z=%d",tile.x, tile.y,tile.zoom];
}

-(NSString*) uniqueTilecacheKey
{
	return @"OpenStreetMap";
}

-(NSString *)shortName
{
	return @"Open Street Map";
}
-(NSString *)longDescription
{
	return @"Open Street Map, the free wiki world map, provides freely usable map data for all parts of the world, under the Creative Commons Attribution-Share Alike 2.0 license.";
}
-(NSString *)shortAttribution
{
	return @"© OpenStreetMap CC-BY-SA";
}
-(NSString *)longAttribution
{
	return @"Map data © OpenStreetMap, licensed under Creative Commons Share Alike By Attribution.";
}

@end
