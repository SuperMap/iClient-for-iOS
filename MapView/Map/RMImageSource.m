
//  RMImageSource.m
//  MapView
//
//  Created by supermap on 15/6/1.
//
//

#import "RMImageSource.h"
#import "RMFoundation.h"
#import "RMMercatorToScreenProjection.h"

@implementation RMImageSource{
    int imageWidth;
    int imageHeight;
}

-(id)initWithUrl:(NSString *)imageUrl mapContents:(RMMapContents *)mapContents imageBounds:(RMProjectedRect) imageBounds{
    if (self = [super init]) {
        contents = mapContents;
        image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]]];
        imageHeight = [[NSNumber  numberWithUnsignedLong:CGImageGetHeight(image.CGImage)] intValue];
        imageWidth = [[NSNumber  numberWithUnsignedLong:CGImageGetWidth(image.CGImage)] intValue];
        projbounds = imageBounds;
        return self;
    }
    return nil;
}

// 计算image的可见Bounds,visionBounds 应当是projBounds与mapBounds的交集，当projBounds与mapBounds相离时，image不可见，visionBounds=（0，0，0，0）
// 当image可见时，返回true，否则返回false
-(BOOL) initVisionBounds{
    // 1. mapBounds和projBounds相交，visionBouns=projBounds交mapBounds
    
    // 假定projBounds和mapBounds相交
    visionBounds.origin.easting = projbounds.origin.easting >= mapBounds.origin.easting?projbounds.origin.easting:mapBounds.origin.easting;
    visionBounds.origin.northing = projbounds.origin.northing >= mapBounds.origin.northing?projbounds.origin.northing:mapBounds.origin.northing;

    visionBounds.size.width = (projbounds.origin.easting+projbounds.size.width)>(mapBounds.origin.easting+mapBounds.size.width)?(mapBounds.origin.easting+mapBounds.size.width-visionBounds.origin.easting):(projbounds.origin.easting+projbounds.size.width-visionBounds.origin.easting);
    
    visionBounds.size.height = (projbounds.origin.northing+projbounds.size.height)>(mapBounds.origin.northing+mapBounds.size.height)?(mapBounds.origin.northing+mapBounds.size.height-visionBounds.origin.northing):(projbounds.origin.northing+projbounds.size.height-visionBounds.origin.northing);
    
    // projBounds与mapBounds不相交
    if (mapBounds.origin.easting+mapBounds.size.width < visionBounds.origin.easting ||
        mapBounds.origin.northing+mapBounds.size.height < visionBounds.origin.northing) {
        visionBounds = RMMakeProjectedRect(0, 0, 0, 0);
        return false;
    }
    return true;
    
}

// 获取图片
-(UIImage *)image
{
    
    mapBounds = [contents projectedBounds];
    mapBounds.origin.northing =mapBounds.origin.northing < -90 ?-90:mapBounds.origin.northing;
    mapBounds.size.height = mapBounds.size.height > 180?180:mapBounds.size.height;
    mapBounds.origin.easting = mapBounds.origin.easting <-180?-180:mapBounds.origin.easting;
    mapBounds.size.width = mapBounds.size.width > 360 ?360:mapBounds.size.width;
   
    // 如果projBounds与mapBounds不相交,则说明当前图片不会显示,返回nil
    BOOL isVision =[self initVisionBounds];
    
    _screenBounds =  [[contents mercatorToScreenProjection] projectXYRect:visionBounds];
    _center = [[contents mercatorToScreenProjection] projectXYPoint:RMMakeProjectedPoint(visionBounds.origin.easting+visionBounds.size.width/2, visionBounds.origin.northing+visionBounds.size.height/2)];
    _screenBounds.origin = _center;
    
    if (!isVision) {
        return nil;
    }
    
    CGRect subImageBounds = CGRectMake((visionBounds.origin.easting-projbounds.origin.easting)*imageWidth/projbounds.size.width, ( projbounds.size.height+projbounds.origin.northing-visionBounds.origin.northing - visionBounds.size.height)*imageHeight/projbounds.size.height, visionBounds.size.width*imageWidth/projbounds.size.width, visionBounds.size.height*imageHeight/projbounds.size.height);
    
    return [self scaleImage:[self getSubImage:subImageBounds] Rect:_screenBounds];
}

#pragma -mark 图片裁剪
-(UIImage*)getSubImage:(CGRect)rect
{
    CGImageRef subImageRef = CGImageCreateWithImageInRect(image.CGImage, rect);
    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
    CGImageRelease(subImageRef);
    return smallImage;
}

#pragma -mark 图片放缩
- (UIImage *)scaleImage:(UIImage*)uiImage Rect:(CGRect)rect{
    
    UIGraphicsBeginImageContext(CGSizeMake(rect.size.width, rect.size.height));
    [uiImage drawInRect:CGRectMake(0, 0, rect.size.width, rect.size.height)];
    uiImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return uiImage;
}
@end
