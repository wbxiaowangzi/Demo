//
//  SkinBridge.m
//  Mirage3D
//
//  Created by 影子.zsr on 2018/1/24.
//  Copyright © 2018年 影子. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "SkinAnalyze.h"
#import <opencv2/core/core.hpp>
#import <opencv2/imgcodecs/ios.h>
#import "SkinBridge.h"
#import "SkinAnalyzeTool.h"
#import "WrinkleAnalyze.h"
#import "BlobSkinAnalyze.h"
#import "SkinDesignAnalyze.h"

@implementation wrinkleInfo : NSObject

@end

@implementation WrinkleModel : NSObject

@end

@implementation BlobInfoModel : NSObject
    
@end



@implementation SkinBridge : NSObject
+(UIImage*)test:(UIImage*)image
{
    SkinAnalyze *a = new SkinAnalyze();
    NSLog(@"testestest");
    cv::Mat in = *new cv::Mat();
    cv::Mat out = *new cv::Mat();
    UIImageToMat(image, in);
    a->SpotsAnalyze(in, out);
    return MatToUIImage(out);
    //return [self UIImageFromCVMat:out];
}

+(double)glcm:(UIImage*)image{
    SkinAnalyze *a = new SkinAnalyze();
    cv::Mat in = *new cv::Mat();
    UIImageToMat(image, in);
    return a->glcm(in);
}

+(UIImage *)wrinkleAnalyze:(UIImage *)image{
    SkinAnalyze *b = new SkinAnalyze();
    cv::Mat in = *new cv::Mat();
    cv::Mat out = *new cv::Mat();
    UIImageToMat(image, in,true);
    b->WrinkleAnalyze(in, out);
    return MatToUIImage(out);
}


/**
 肤色不均

 @param image texture
 @return texture
 */
+(UIImage *)colorDistributionAnalyze:(UIImage *)image{
    SkinAnalyze *b = new SkinAnalyze();
    cv::Mat in = *new cv::Mat();
    cv::Mat out = *new cv::Mat();
    UIImageToMat(image, in,true);
    b->ColorDistributionAnalyze(in, out);
    return MatToUIImage(out);
}


/**
 斑点

 @param image texture
 @param ps points
 @return blobModel
 */
+(BlobInfoModel *)blobSkinAnalyze:(UIImage *)image value2:(NSArray *)ps{
    BlobSkinAnalyze *a = new BlobSkinAnalyze();
    std::vector<cv::Point> points = *new std::vector<cv::Point>;
    for (int i = 0; i < ps.count; i++) {
        CGPoint uvp = [ps[i] CGPointValue];
        float x = uvp.x;
        float y = uvp.y;
        cv::Point p = *new cv::Point();
        p.x = x * image.size.width;
        p.y = y * image.size.height;
        points.push_back(p);
    }
    
    cv::Mat in = *new cv::Mat();
    UIImageToMat(image, in, true);
    float quan = 0.0;
    a->blobContourDetect(in, quan, points);
    
    BlobInfoModel *model = [[BlobInfoModel alloc] init];
    model.image = MatToUIImage(in);
    model.ratio = quan;
    return model;
}


/**
 新版皱纹

 @param image texture
 @param ps points
 @return texture
 */
+(WrinkleModel *)wrinkleMultAnalyze:(UIImage *)image value2:(NSArray *)ps{
    std::vector<cv::Point> points = *new std::vector<cv::Point>;
    std::vector<wrinkle> w[6];
    cv::Mat in = *new cv::Mat();
    cv::Mat out = *new cv::Mat();
    UIImageToMat(image, in,true);
    for (int i = 0; i < ps.count; i++) {
        CGPoint uvp = [ps[i] CGPointValue];
        float x = uvp.x;
        float y = uvp.y;
        cv::Point p = *new cv::Point();
        p.x = x * 4096;
        p.y = y * 2048;
        points.push_back(p);
    }
    
    WrinkleAnalyze a = *new WrinkleAnalyze();
    a.func(in, points, out, w);
    
    WrinkleModel *model = [[WrinkleModel alloc] init];
    NSMutableArray *cells = [NSMutableArray array];
    for (int i = 0; i < 6; i++) {
        std::vector<wrinkle> vInfo = w[i];
        std::vector<wrinkle>::iterator iter;
        NSMutableArray *cell = [NSMutableArray array];
        for (iter=vInfo.begin();iter!=vInfo.end();iter++){
            wrinkleInfo *info = [[wrinkleInfo alloc] init];
            info.lenght = iter->l;
            info.isRough = iter->s;
            info.x = iter->x;
            info.y = iter->y;
            [cell addObject:info];
        }
        [cells addObject:cell];
        
    }
    model.info = cells;
    model.image = MatToUIImage(out);
    return model;
}


/**
 纹眉

 @param image texture
 @param roiImage 皮肤蒙版
 @param ps 特征点
 @return image
 */
+(UIImage *)changeMeimao:(UIImage *)image roi:(UIImage *)roiImage value3:(NSArray *)ps value4:(NSString *)path{

    
    SkinDesignAnalyze a = *new SkinDesignAnalyze();
    cv::Mat in = *new cv::Mat();
    cv::Mat roi = *new cv::Mat();
    UIImageToMat(image, in);
    UIImageToMat(roiImage, roi);
    
    std::vector<cv::Point> points = *new std::vector<cv::Point>;
    for (int i = 0; i < ps.count; i++) {
        CGPoint uvp = [ps[i] CGPointValue];
        float x = uvp.x;
        float y = uvp.y;
        cv::Point p = *new cv::Point();
        p.x = x * 4096;
        p.y = y * 2048;
        points.push_back(p);
    }
    
    //左：81 (79) 77 75 76 78 (80),括号点向左移动克隆两个点
    //右：88 (86) 84 82 83 85 (87),括号点向右移动克隆两个点
    int lIndex[] = {81,1,79,77,75,76,78,80,0};
    int rIndex[] = {88,1,86,84,82,83,85,87,0};
    
    cv::Point* pl = new cv::Point[9];
    cv::Point* pr = new cv::Point[9];
    
    for (int i=0; i<9; i++) {
        if(lIndex[i] == 0){
            pl[i] = (points[lIndex[0]] + points[lIndex[i-1]])/2;
            pr[i] = (points[rIndex[0]] + points[rIndex[i-1]])/2;
        }else if(lIndex[i] == 1){
            pl[i] = (points[lIndex[0]] + points[lIndex[i+1]])/2;
            pr[i] = (points[rIndex[0]] + points[rIndex[i+1]])/2;
        }else{
            pl[i] = points[lIndex[i]];
            pr[i] = points[rIndex[i]];
        }
    }
    
//    int x0=4096,y0=2048,x1=0,y1=0;
//    cv::Mat out = a.RemoveEyebrow(pl, in, 0, roi, x0, y0, x1, y1);
    int x20=4096,y20=2048,x21=0,y21=0;
    cv::String oriPath = path.UTF8String;
    cv::Mat out = a.RemoveEyebrow(pr, in, 1, roi, x20, y20, x21, y21);
    
    return MatToUIImage(out);
}


+(UIImage*)skinWhiting:(UIImage *)image{
    cv::Mat in = *new cv::Mat();
    UIImageToMat(image, in);
    SkinDesignAnalyze a = *new SkinDesignAnalyze();
    cv::Mat out = a.ChangeFacecolor(in);
    return MatToUIImage(out);
}

+(UIImage*)cameraOutput:(PGSkinPrettifyEngine *)engine{
     CVImageBufferRef imageBuffer = nil;
    // [_pPGSkinPrettifyEngine GetSkinPrettifyResult:&__imageBuffer];
    [engine GetSkinPrettifyResult:&imageBuffer];
    
    return [self changeCVImageBufferToUImage:imageBuffer];
}
    
//    +(UIImage*)cvBufferToUIImage:(CVBufferRef)pixelBuffer{
//        size_t w = CVPixelBufferGetWidth(pixelBuffer);
//        size_t h = CVPixelBufferGetHeight(pixelBuffer);
//        size_t r = CVPixelBufferGetBytesPerRow(pixelBuffer);
//        size_t bytesPerPixel = r/w;
//
//        UIGraphicsBeginImageContext(CGSizeMake(w, h));
//
//        CGContextRef c = UIGraphicsGetCurrentContext();
//
//        void *ctxData = CGBitmapContextGetData(c);
//
//        // MUST READ-WRITE LOCK THE PIXEL BUFFER!!!!
//        CVPixelBufferLockBaseAddress(pixelBuffer, 0);
//        void *pxData = CVPixelBufferGetBaseAddress(pixelBuffer);
//        memcpy(ctxData, pxData, 4 * w * h);
//        CVPixelBufferUnlockBaseAddress(pixelBuffer, 0);
//
//    }
    
+(UIImage*)changeCVImageBufferToUImage:(CVImageBufferRef)imageBuffer{
    CVPixelBufferLockBaseAddress(imageBuffer, 0);
    void *baseAddress = CVPixelBufferGetBaseAddress(imageBuffer);
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);
    size_t bufferSize = CVPixelBufferGetDataSize(imageBuffer);
    size_t bytesPerRow = CVPixelBufferGetBytesPerRowOfPlane(imageBuffer, 0);
    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, baseAddress, bufferSize, NULL);
    
    CGImageRef cgImage = CGImageCreate(width, height, 8, 32, bytesPerRow, rgbColorSpace, kCGImageAlphaNoneSkipFirst|kCGBitmapByteOrder32Little, provider, NULL, true, kCGRenderingIntentDefault);
    UIImage *image = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
    CGDataProviderRelease(provider);
    CGColorSpaceRelease(rgbColorSpace);
    
    NSData* imageData = UIImageJPEGRepresentation(image, 1.0);
    image = [UIImage imageWithData:imageData];
    CVPixelBufferUnlockBaseAddress(imageBuffer, 0);
    return image;
}
    
+(UIImage *)imageFromPixelBuffer:(CVPixelBufferRef)pixelBufferRef {
    CVImageBufferRef imageBuffer =  pixelBufferRef;
    
    CVPixelBufferLockBaseAddress(imageBuffer, 0);
    void *baseAddress = CVPixelBufferGetBaseAddress(imageBuffer);
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);
    size_t bufferSize = CVPixelBufferGetDataSize(imageBuffer);
    size_t bytesPerRow = CVPixelBufferGetBytesPerRowOfPlane(imageBuffer, 0);
    
    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, baseAddress, bufferSize, NULL);
    
    CGImageRef cgImage = CGImageCreate(width, height, 8, 32, bytesPerRow, rgbColorSpace, kCGImageAlphaNoneSkipFirst | kCGBitmapByteOrderDefault, provider, NULL, true, kCGRenderingIntentDefault);
    UIImage *image = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
    CGDataProviderRelease(provider);
    CGColorSpaceRelease(rgbColorSpace);
    
    CVPixelBufferUnlockBaseAddress(imageBuffer, 0);
    return image;
}
    
    
/**
 纹理透明度处理

 @param image texture
 @param top top
 @param left left
 @param bottom bottom
 @param right right
 @param Top top head
 @return texture
 */
+(UIImage*) imageBlackToTransparent:(UIImage*)image value1:(float)top value2:(float)left value3:(float)bottom value4:(float)right value5:(float)Top
{
    // 分配内存
    const int imageWidth = image.size.width;
    const int imageHeight = image.size.height;
    size_t    bytesPerRow = imageWidth * 4;
    uint32_t* rgbImageBuf = (uint32_t*)malloc(bytesPerRow * imageHeight);
    
    // 创建context
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(rgbImageBuf, imageWidth, imageHeight, 8, bytesPerRow, colorSpace,kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
    CGContextDrawImage(context, CGRectMake(0, 0, imageWidth, imageHeight), image.CGImage);
    
    uint32_t* pCurPtr = rgbImageBuf;
    
    //top 、 bottom反向
    int y_max = bottom * imageHeight;
    int y_min = top * imageHeight;
    int x_min = left * imageWidth;
    int x_max = right * imageWidth;
    
    for (int i = 0; i < imageHeight; i++){
        for (int j = 0; j < imageWidth; j++ , pCurPtr++) {

            if (i < y_max && i > y_min && j < x_max && j > x_min){
                continue;
            }
            uint8_t* ptr = (uint8_t*)pCurPtr;
            
            int value = ptr[1] + ptr[2] + ptr[3];
            if (value < 5){
                ptr[0] = 0;
                continue;
            }

            float min = Top * imageHeight * 0.8;
            if (i < min){
                ptr[0] = 0;
                continue;
            }
            
            if ((*pCurPtr & 0xFFFFFF00) == 0)    // 将黑色变成透明
            {
                ptr[0] = 0;
                continue;
            }

        }
    }
    
    // 将内存转成image
    CGDataProviderRef dataProvider = CGDataProviderCreateWithData(NULL, rgbImageBuf, bytesPerRow * imageHeight,ProviderReleaseData);
    CGImageRef imageRef = CGImageCreate(imageWidth, imageHeight, 8, 32, bytesPerRow, colorSpace,kCGImageAlphaLast | kCGBitmapByteOrder32Little, dataProvider,NULL, true, kCGRenderingIntentDefault);
    
    CGDataProviderRelease(dataProvider);
    
    UIImage* resultUIImage = [UIImage imageWithCGImage:imageRef];
    
    // 释放
    CGImageRelease(imageRef);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    // free(rgbImageBuf) 创建dataProvider时已提供释放函数，这里不用free
    return resultUIImage;
}


/**
 纹理透明度处理

 @param image texture
 @return texture
 */
+(UIImage*) imageBlackToTransparent:(UIImage*)image{
    // 分配内存
    const int imageWidth = image.size.width;
    const int imageHeight = image.size.height;
    size_t    bytesPerRow = imageWidth * 4;
    uint32_t* rgbImageBuf = (uint32_t*)malloc(bytesPerRow * imageHeight);
    
    // 创建context
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(rgbImageBuf, imageWidth, imageHeight, 8, bytesPerRow, colorSpace,kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
    CGContextDrawImage(context, CGRectMake(0, 0, imageWidth, imageHeight), image.CGImage);
    
    // 遍历像素
    int pixelNum = imageWidth * imageHeight;
    
    uint32_t* pCurPtr = rgbImageBuf;
    
    for (int i = 0; i < pixelNum; i++, pCurPtr++)
    {
        
        uint8_t* ptr = (uint8_t*)pCurPtr;
        
        int value = ptr[1] + ptr[2] + ptr[3];
        if (value < 5){
            ptr[0] = 0;
            ptr[1] = 0;
            ptr[2] = 0;
            ptr[3] = 0;
            continue;
        }
        
        if ((*pCurPtr & 0xFFFFFF00) == 0)    // 将黑色变成透明
        {
            
            ptr[0] = 0;
            ptr[1] = 0;
            ptr[2] = 0;
            ptr[3] = 0;
            continue;
        }
    }
    
    
    
    // 将内存转成image
    CGDataProviderRef dataProvider = CGDataProviderCreateWithData(NULL, rgbImageBuf, bytesPerRow * imageHeight,ProviderReleaseData);
    CGImageRef imageRef = CGImageCreate(imageWidth, imageHeight, 8, 32, bytesPerRow, colorSpace,kCGImageAlphaLast | kCGBitmapByteOrder32Little, dataProvider,NULL, true, kCGRenderingIntentDefault);
    
    CGDataProviderRelease(dataProvider);
    
    UIImage* resultUIImage = [UIImage imageWithCGImage:imageRef];
    
    // 释放
    CGImageRelease(imageRef);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    // free(rgbImageBuf) 创建dataProvider时已提供释放函数，这里不用free
    return resultUIImage;
}
    
+(CVPixelBufferRef)pixelBufferFromCGImage: (CGImageRef) image
{
    CVPixelBufferRef pxbuffer = NULL;
    NSCParameterAssert(NULL != image);
    size_t originalWidth = CGImageGetWidth(image);
    size_t originalHeight = CGImageGetHeight(image);
    
    NSMutableData *imageData = [NSMutableData dataWithLength:originalWidth*originalHeight*4];
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef cgContext = CGBitmapContextCreate([imageData mutableBytes], originalWidth, originalHeight, 8, 4*originalWidth, colorSpace, kCGImageAlphaPremultipliedLast);
    CGColorSpaceRelease(colorSpace);
    CGContextDrawImage(cgContext, CGRectMake(0, 0, originalWidth, originalHeight), image);
    CGContextRelease(cgContext);
    CGImageRelease(image);
    unsigned char *pImageData = (unsigned char *)[imageData bytes];
    
    
    CFDictionaryRef empty;
    empty = CFDictionaryCreate(kCFAllocatorDefault, NULL, NULL,
                               0,
                               &kCFTypeDictionaryKeyCallBacks,
                               &kCFTypeDictionaryValueCallBacks);
    
    CFMutableDictionaryRef m_pPixelBufferAttribs = CFDictionaryCreateMutable(kCFAllocatorDefault,
                                                                             3,
                                                                             &kCFTypeDictionaryKeyCallBacks,
                                                                             &kCFTypeDictionaryValueCallBacks);
    
    CFDictionarySetValue(m_pPixelBufferAttribs, kCVPixelBufferIOSurfacePropertiesKey, empty);
    CFDictionarySetValue(m_pPixelBufferAttribs, kCVPixelBufferOpenGLCompatibilityKey, empty);
    CFDictionarySetValue(m_pPixelBufferAttribs, kCVPixelBufferCGBitmapContextCompatibilityKey, empty);
    
    CVPixelBufferCreateWithBytes(kCFAllocatorDefault, originalWidth, originalHeight, kCVPixelFormatType_32BGRA, pImageData, originalWidth * 4, NULL, NULL, m_pPixelBufferAttribs, &pxbuffer);
    CFRelease(empty);
    CFRelease(m_pPixelBufferAttribs);
    
    
    return pxbuffer;
}
    

void ProviderReleaseData (void *info, const void *data, size_t size)
{
    free((void*)data);
}



+(UIImage *)UIImageFromCVMat:(cv::Mat)cvMat
{
    NSData *data = [NSData dataWithBytes:cvMat.data length:cvMat.elemSize()*cvMat.total()];

    CGColorSpaceRef colorSpace;
    CGBitmapInfo bitmapInfo;

    if (cvMat.elemSize() == 1) {
        colorSpace = CGColorSpaceCreateDeviceGray();
        bitmapInfo = kCGImageAlphaNone | kCGBitmapByteOrderDefault;
    } else {
        colorSpace = CGColorSpaceCreateDeviceRGB();
        bitmapInfo = kCGBitmapByteOrder32Little | (
                                                   cvMat.elemSize() == 3? kCGImageAlphaNone : kCGImageAlphaNoneSkipFirst
                                                   );
    }

    CGDataProviderRef provider = CGDataProviderCreateWithCFData((__bridge CFDataRef)data);

    // Creating CGImage from cv::Mat
    CGImageRef imageRef = CGImageCreate(
                                        cvMat.cols,                 //width
                                        cvMat.rows,                 //height
                                        8,                          //bits per component
                                        8 * cvMat.elemSize(),       //bits per pixel
                                        cvMat.step[0],              //bytesPerRow
                                        colorSpace,                 //colorspace
                                        bitmapInfo,                 // bitmap info
                                        provider,                   //CGDataProviderRef
                                        NULL,                       //decode
                                        false,                      //should interpolate
                                        kCGRenderingIntentDefault   //intent
                                        );

    // Getting UIImage from CGImage
    UIImage *finalImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    CGDataProviderRelease(provider);
    CGColorSpaceRelease(colorSpace);

    return finalImage;
}

+ (cv::Mat)cvMatWithImage:(UIImage *)image
{
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(image.CGImage);
    size_t numberOfComponents = CGColorSpaceGetNumberOfComponents(colorSpace);
    CGFloat cols = image.size.width;
    CGFloat rows = image.size.height;

    cv::Mat cvMat(rows, cols, CV_8UC4); // 8 bits per component, 4 channels
    CGBitmapInfo bitmapInfo = kCGImageAlphaNoneSkipLast | kCGBitmapByteOrderDefault;

    // check whether the UIImage is greyscale already
    if (numberOfComponents == 1){
        cvMat = cv::Mat(rows, cols, CV_8UC1); // 8 bits per component, 1 channels
        bitmapInfo = kCGImageAlphaNone | kCGBitmapByteOrderDefault;
    }

    CGContextRef contextRef = CGBitmapContextCreate(cvMat.data,             // Pointer to backing data
                                                    cols,                       // Width of bitmap
                                                    rows,                       // Height of bitmap
                                                    8,                          // Bits per component
                                                    cvMat.step[0],              // Bytes per row
                                                    colorSpace,                 // Colorspace
                                                    bitmapInfo);              // Bitmap info flags

    CGContextDrawImage(contextRef, CGRectMake(0, 0, cols, rows), image.CGImage);
    CGContextRelease(contextRef);

    return cvMat;
}

@end
