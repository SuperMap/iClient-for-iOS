//
//  NSObject+SMTianDiTu_cva_c_TileSource.m
//  MapView
//
//  Created by zhoushibin on 15-4-20.
//
//

#import "SMTianDiTu_cva_c_TileSource.h"
#import "RMNotifications.h"
#import "RMSMLayerInfo.h"
#import "RMSMTileProjection.h"
#import "RMProjection.h"
@implementation SMTianDiTu_cva_c_TileSource
-(NSString *) tileURL: (RMTile) tile
{
    ///天地图url
    url = @"http://t2.tianditu.com/DataServer?T=cva_c";//cva_c  vec_c
    NSString* strUrl;
    strUrl = [NSString stringWithFormat:@"%@&X=%d&Y=%d&L=%d",url,tile.x,tile.y,(int)tile.zoom+1];
    return strUrl;
}
@end
