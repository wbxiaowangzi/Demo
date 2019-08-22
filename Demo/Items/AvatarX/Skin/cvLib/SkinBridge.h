//
//  SkinBridge.h
//  Mirage3D
//
//  Created by 影子.zsr on 2018/1/24.
//  Copyright © 2018年 影子. All rights reserved.
//



#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "PGSkinPrettifyEngine.h"
@interface wrinkleInfo : NSObject
@property int x;
@property int y;
@property int lenght;
@property int isRough;
@end


@interface WrinkleModel : NSObject
@property UIImage * image;
@property NSArray * info;
@end
    
@interface BlobInfoModel : NSObject
@property UIImage * image;
@property float ratio;
@end



@interface SkinBridge: NSObject
+(UIImage *)test:(UIImage *)image;
+(double)glcm:(UIImage *)image;
+(UIImage *)wrinkleAnalyze:(UIImage *)image;
+(UIImage *)addAlphaPass:(UIImage *)image;
+(UIImage*) imageBlackToTransparent:(UIImage*)image value1:(float)top value2:(float)left value3:(float)bottom value4:(float)right value5:(float)Top;
+(UIImage*) imageBlackToTransparent:(UIImage*)image;
+(WrinkleModel *)wrinkleMultAnalyze:(UIImage *)image value2:(NSArray *)ps;
+(UIImage *)colorDistributionAnalyze:(UIImage *)image;
+(BlobInfoModel *)blobSkinAnalyze:(UIImage *)image value2:(NSArray *)ps;

+(UIImage *)changeMeimao:(UIImage *)image roi:(UIImage *)roiImage value3:(NSArray *)ps value4:(NSString *)path;
+(UIImage*)skinWhiting:(UIImage *)image;
+(UIImage*)cameraOutput:(PGSkinPrettifyEngine *)engine;
+(CVPixelBufferRef)pixelBufferFromCGImage: (CGImageRef) image;
+(UIImage *)imageFromPixelBuffer:(CVPixelBufferRef)pixelBufferRef;
    
@end

