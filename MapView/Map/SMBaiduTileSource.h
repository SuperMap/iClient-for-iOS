//
//  NSObject+SMBaiduTileSource.h
//  MapView
//
//  Created by smSupport on 16/5/25.
//
//

#import <Foundation/Foundation.h>
#import "SMTianDiTuTileSource.h"
@interface SMBaiduTileSource:NSObject <RMTileSource>
{
    NSString *url;
    RMProjection *smProjection;
    RMSMTileProjection *tileProjection;
    
    BOOL networkOperations;
    NSMutableArray* m_dResolutions;
    NSMutableArray* m_dScales;
    
    RMTileImageSet* _imagesOnScreen;
    RMTileLoader* _tileLoader;
    RMMapRenderer* _renderer;
    BOOL _isBaseLayer;
    BOOL _isUseCache;

}
@property (nonatomic,retain) RMSMLayerInfo* m_Info;
//用于判断在加载地图是是否使用本地缓存
@property (nonatomic) BOOL isUseCache;
@property (nonatomic,assign)CGSize redressValue;
@end
