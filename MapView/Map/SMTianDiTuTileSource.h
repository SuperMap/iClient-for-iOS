//
//  NSObject+SMTiDiTuTileSource.h
//  MapView
//
//  Created by zhoushibin on 15-4-13.
//
//

#import <Foundation/Foundation.h>
#import "RMTileSource.h"
#import "RMSMLayerInfo.h"
#import "RMSMTileProjection.h"
#import "RMSMLayerInfo.h"

/**
 * Class: SMTianDiTuTileSource
 * 对接天地图接口，用法参照案例sample目录下tianditu范例
 */
@interface SMTianDiTuTileSource:NSObject <RMTileSource>
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
-(id) init;
//-(id) initWithInfo:(RMSMLayerInfo*) info ;
@property (nonatomic,retain) RMSMLayerInfo* m_Info;
//用于判断在加载地图是是否使用本地缓存
@property (nonatomic) BOOL isUseCache;
@property (nonatomic,assign)CGSize redressValue;
@property (nonatomic)BOOL isHidden;
@end
