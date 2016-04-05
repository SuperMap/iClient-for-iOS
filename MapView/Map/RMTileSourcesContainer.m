
//  RMTileSourcesContainer.m
//  MapView
//
// Copyright (c) 2008-2013, Route-Me Contributors
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are met:
//
// * Redistributions of source code must retain the above copyright notice, this
//   list of conditions and the following disclaimer.
// * Redistributions in binary form must reproduce the above copyright notice,
//   this list of conditions and the following disclaimer in the documentation
//   and/or other materials provided with the distribution.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
// ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
// LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
// CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
// SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
// INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
// CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
// ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
// POSSIBILITY OF SUCH DAMAGE.

#import "RMTileSourcesContainer.h"

//#import "RMCompositeSource.h"
#import  "RMSMTileSource.h"
@implementation RMTileSourcesContainer
{
    NSMutableArray *_tileSources;
    NSRecursiveLock *_tileSourcesLock;
    
    RMProjection *_projection;
    id<RMMercatorToTileProjection> _mercatorToTileProjection;
    
    RMSphericalTrapezium _latitudeLongitudeBoundingBox;
    
    double _minZoom, _maxZoom;
    int _tileSideLength;
     NSMutableArray *_baseLayerScales;
}

- (id)init
{
    if (!(self = [super init]))
        return nil;
    
    _tileSources = [NSMutableArray new];
    _tileSourcesLock = [NSRecursiveLock new];
    
    _projection = nil;
    _mercatorToTileProjection = nil;
    _baseLayerScales=nil;
    
    _latitudeLongitudeBoundingBox = ((RMSphericalTrapezium) {
        .northeast = {.latitude = 90.0, .longitude = 180.0},
        .southwest = {.latitude = -90.0, .longitude = -180.0}
    });
    
    _minZoom = kRMTileSourcesContainerMaxZoom;
    _maxZoom = kRMTileSourcesContainerMinZoom;
    _tileSideLength = 256;
    
    return self;
}

#pragma mark -

- (void)setBoundingBoxFromTilesources
{
    [_tileSourcesLock lock];
    
    _latitudeLongitudeBoundingBox = ((RMSphericalTrapezium) {
        .northeast = {.latitude = 90.0, .longitude = 180.0},
        .southwest = {.latitude = -90.0, .longitude = -180.0}
    });
    
    for (id <RMTileSource>tileSource in _tileSources)
    {
        RMSphericalTrapezium newLatitudeLongitudeBoundingBox = [tileSource latitudeLongitudeBoundingBox];
        
        _latitudeLongitudeBoundingBox = ((RMSphericalTrapezium) {
            .northeast = {
                .latitude = MIN(_latitudeLongitudeBoundingBox.northeast.latitude, newLatitudeLongitudeBoundingBox.northeast.latitude),
                .longitude = MIN(_latitudeLongitudeBoundingBox.northeast.longitude, newLatitudeLongitudeBoundingBox.northeast.longitude)},
            .southwest = {
                .latitude = MAX(_latitudeLongitudeBoundingBox.southwest.latitude, newLatitudeLongitudeBoundingBox.southwest.latitude),
                .longitude = MAX(_latitudeLongitudeBoundingBox.southwest.longitude, newLatitudeLongitudeBoundingBox.southwest.longitude)
            }
        });
    }
    
    [_tileSourcesLock unlock];
}

#pragma mark -

- (NSArray *)tileSources
{
    NSArray *tileSources = nil;
    
    [_tileSourcesLock lock];
    tileSources = [_tileSources copy];
    [_tileSourcesLock unlock];
    
    return tileSources;
}

//- (id <RMTileSource>)tileSourceForUniqueTilecacheKey:(NSString *)uniqueTilecacheKey
//{
//    if (!uniqueTilecacheKey)
//        return nil;
//
//    id result = nil;
//
//    [_tileSourcesLock lock];
//
//    NSMutableArray *tileSources = [NSMutableArray arrayWithArray:_tileSources];
//
//    while ([tileSources count])
//    {
//        id <RMTileSource> currentTileSource = [tileSources objectAtIndex:0];
//        [tileSources removeObjectAtIndex:0];
//
//        if ([currentTileSource isKindOfClass:[RMCompositeSource class]])
//        {
//            [tileSources addObjectsFromArray:[(RMCompositeSource *)currentTileSource tileSources]];
//        }
//        else if ([[currentTileSource uniqueTilecacheKey] isEqualToString:uniqueTilecacheKey])
//        {
//            result = currentTileSource;
//            break;
//        }
//    }
//
//    [_tileSourcesLock unlock];
//
//    return result;
//}

- (BOOL)setTileSource:(id <RMTileSource>)tileSource
{
    BOOL result;
    
    [_tileSourcesLock lock];
    
    [self removeAllTileSources];
    result = [self addTileSource:tileSource];
    
    [_tileSourcesLock unlock];
    
    return result;
}

- (BOOL)setTileSources:(NSArray *)tileSources
{
    BOOL result = YES;
    
    [_tileSourcesLock lock];
    
    [self removeAllTileSources];
    
    for (id <RMTileSource> tileSource in tileSources)
        result &= [self addTileSource:tileSource];
    
    [_tileSourcesLock unlock];
    
    return result;
}

- (BOOL)addTileSource:(id <RMTileSource>)tileSource
{
    return [self addTileSource:tileSource atIndex:-1];
}

- (BOOL)addTileSource:(id<RMTileSource>)tileSource atIndex:(NSUInteger)index
{
    if ( ! tileSource)
        return NO;
    
    [_tileSourcesLock lock];
    
    RMProjection *newProjection=[tileSource projection];
    ////?
    id<RMMercatorToTileProjection> newMercatorToTileProjection =[tileSource mercatorToTileProjection];
    NSMutableArray *newScales=[tileSource m_dScales];
    
    if (!_baseLayerScales) {
        _baseLayerScales=newScales;
    }
    else{
        [tileSource setM_dScales:_baseLayerScales];
    }
    
    if ( ! _projection)
    {
        _projection = newProjection;
    }
    /*
    else if([_projection bIsSM] && [newProjection bIsSM] )
    {
        
        if (![[_projection epsgCode] isEqualToString: [newProjection epsgCode]]) {
            NSAssert(NO,@"The tilesource '%@' has a different projection than the tilesource container",[tileSource shortName]);
        }
    }
    else if(![_projection isEqual:newProjection])
    {
        
            NSLog(@"The tilesource '%@' has a different projection than the tilesource container", [tileSource shortName]);
            [_tileSourcesLock unlock];
            return NO;
    }
    */
    
    if ( ! _mercatorToTileProjection)
        _mercatorToTileProjection = newMercatorToTileProjection;
    
    // minZoom and maxZoom are the min and max values of all tile sources, so that individual tilesources
    // could have a smaller zoom level range
    self.minZoom = MIN(_minZoom, [tileSource minZoom]);
    self.maxZoom = MAX(_maxZoom, [tileSource maxZoom]);
    
    if (_tileSideLength == 0)
    {
        _tileSideLength = [tileSource tileSideLength];
    }
    else if (_tileSideLength != [tileSource tileSideLength])
    {
        NSLog(@"The tilesource '%@' has a different tile side length than the tilesource container", [tileSource shortName]);
        [_tileSourcesLock unlock];
        return NO;
    }
    
    RMSphericalTrapezium newLatitudeLongitudeBoundingBox = [tileSource latitudeLongitudeBoundingBox];
    
    double minX1 = _latitudeLongitudeBoundingBox.southwest.longitude;
    double minX2 = newLatitudeLongitudeBoundingBox.southwest.longitude;
    double maxX1 = _latitudeLongitudeBoundingBox.northeast.longitude;
    double maxX2 = newLatitudeLongitudeBoundingBox.northeast.longitude;
    
    double minY1 = _latitudeLongitudeBoundingBox.southwest.latitude;
    double minY2 = newLatitudeLongitudeBoundingBox.southwest.latitude;
    double maxY1 = _latitudeLongitudeBoundingBox.northeast.latitude;
    double maxY2 = newLatitudeLongitudeBoundingBox.northeast.latitude;
    ////图层是否在地球范围内（-180，-90，180，90）
    BOOL intersects = (((minX1 <= minX2 && minX2 <= maxX1) || (minX2 <= minX1 && minX1 <= maxX2)) &&
                       ((minY1 <= minY2 && minY2 <= maxY1) || (minY2 <= minY1 && minY1 <= maxY2)));
    
    if ( ! intersects)
    {
        NSLog(@"The bounding box from tilesource '%@' doesn't intersect with the tilesource containers' bounding box", [tileSource shortName]);
        [_tileSourcesLock unlock];
        return NO;
    }
    //相交的范围
    _latitudeLongitudeBoundingBox = ((RMSphericalTrapezium) {
        .northeast = {
            .latitude = MIN(_latitudeLongitudeBoundingBox.northeast.latitude, newLatitudeLongitudeBoundingBox.northeast.latitude),
            .longitude = MIN(_latitudeLongitudeBoundingBox.northeast.longitude, newLatitudeLongitudeBoundingBox.northeast.longitude)},
        .southwest = {
            .latitude = MAX(_latitudeLongitudeBoundingBox.southwest.latitude, newLatitudeLongitudeBoundingBox.southwest.latitude),
            .longitude = MAX(_latitudeLongitudeBoundingBox.southwest.longitude, newLatitudeLongitudeBoundingBox.southwest.longitude)
        }
    });
    
    if (index >= [_tileSources count])
        [_tileSources addObject:tileSource];
    else
        [_tileSources insertObject:tileSource atIndex:index];
    
    [_tileSourcesLock unlock];
    
    RMLog(@"Added the tilesource '%@' to the container", [tileSource shortName]);
    
    return YES;
}

- (void)removeTileSource:(id <RMTileSource>)tileSource
{
    [tileSource removeAllCachedImages];
    
    [_tileSourcesLock lock];
    
    [_tileSources removeObject:tileSource];
    
    RMLog(@"Removed the tilesource '%@' from the container", [tileSource shortName]);
    
    if ([_tileSources count] == 0)
        [self removeAllTileSources]; // cleanup
    else
        [self setBoundingBoxFromTilesources];
    
    [_tileSourcesLock unlock];
}

- (void)removeTileSourceAtIndex:(NSUInteger)index
{
    [_tileSourcesLock lock];
    
    if (index >= [_tileSources count])
    {
        [_tileSourcesLock unlock];
        return;
    }
    
    id <RMTileSource> tileSource = [_tileSources objectAtIndex:index];
    [tileSource removeAllCachedImages];
    [_tileSources removeObject:tileSource];
    
    RMLog(@"Removed the tilesource '%@' from the container", [tileSource shortName]);
    
    if ([_tileSources count] == 0)
        [self removeAllTileSources]; // cleanup
    else
        [self setBoundingBoxFromTilesources];
    
    [_tileSourcesLock unlock];
}

- (void)moveTileSourceAtIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex
{
    if (fromIndex == toIndex)
        return;
    
    [_tileSourcesLock lock];
    
    if (fromIndex >= [_tileSources count])
    {
        [_tileSourcesLock unlock];
        return;
    }
    
    id tileSource = [_tileSources objectAtIndex:fromIndex];
    [_tileSources removeObjectAtIndex:fromIndex];
    
    if (toIndex >= [_tileSources count])
        [_tileSources addObject:tileSource];
    else
        [_tileSources insertObject:tileSource atIndex:toIndex];
    
    [_tileSourcesLock unlock];
}

- (void)removeAllTileSources
{
    [_tileSourcesLock lock];
    
    [self cancelAllDownloads];
    [_tileSources removeAllObjects];
    
    _projection = nil;
    _mercatorToTileProjection = nil;
    
    _latitudeLongitudeBoundingBox = ((RMSphericalTrapezium) {
        .northeast = {.latitude = 90.0, .longitude = 180.0},
        .southwest = {.latitude = -90.0, .longitude = -180.0}
    });
    
    _minZoom = kRMTileSourcesContainerMaxZoom;
    _maxZoom = kRMTileSourcesContainerMinZoom;
    _tileSideLength = 0;
    
    [_tileSourcesLock unlock];
}

- (void)cancelAllDownloads
{
    [_tileSourcesLock lock];
    
    for (id <RMTileSource>tileSource in _tileSources)
        [tileSource removeAllCachedImages];
    
    [_tileSourcesLock unlock];
}

- (id<RMMercatorToTileProjection> )mercatorToTileProjection
{
    return _mercatorToTileProjection;
}

- (RMProjection *)projection
{
    return _projection;
}

- (double)minZoom
{
    return _minZoom;
}

- (void)setMinZoom:(double)minZoom
{
    if (minZoom < kRMTileSourcesContainerMinZoom)
        minZoom = kRMTileSourcesContainerMinZoom;
    
    _minZoom = minZoom;
}

- (double)maxZoom
{
    return _maxZoom;
}

- (void)setMaxZoom:(double)maxZoom
{
    if (maxZoom > kRMTileSourcesContainerMaxZoom)
        maxZoom = kRMTileSourcesContainerMaxZoom;
    
    _maxZoom = maxZoom;
}

- (int)tileSideLength
{
    return _tileSideLength;
}

- (RMSphericalTrapezium)latitudeLongitudeBoundingBox
{
    return _latitudeLongitudeBoundingBox;
}

- (void)didReceiveMemoryWarning
{
    [_tileSourcesLock lock];
    
    for (id <RMTileSource>tileSource in _tileSources)
        [tileSource didReceiveMemoryWarning];
    
    [_tileSourcesLock unlock];
}

@end
