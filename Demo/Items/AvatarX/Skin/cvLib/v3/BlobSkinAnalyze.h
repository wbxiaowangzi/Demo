//
//  BlobSkinAnalyze.h
//  Mirage3D
//
//  Created by 影子.zsr on 2018/7/26.
//  Copyright © 2018年 影子. All rights reserved.
//

#ifndef BlobSkinAnalyze_h
#define BlobSkinAnalyze_h

#include <opencv2/features2d/features2d.hpp>
#include <opencv2/imgproc/imgproc.hpp>

#include <vector>
using namespace cv;

enum {
    CONTOUR_ALL =1,
    CONTOUR_INNER=2,
    CONTOUR_NO_CHILD=3,
};


class BlobSkinAnalyze
{
    public:
    
    BlobSkinAnalyze();
    ~BlobSkinAnalyze();
    void blobContourDetect(Mat& src,float& ratio, std::vector<cv::Point>points);
    
    private:
    int otsu(Mat& src);
    void imageProcess(Mat& src, Mat& result);
    std::vector<std::vector<cv::Point>> contourDetect(Mat& src,int contourType);
    void drawBlob(Mat& src, std::vector<std::vector<cv::Point>> contours);
    double areaCalculate(std::vector<std::vector<cv::Point>> contours);
    void spotDetect(Mat& src, float& blobArea, float& faceArea, int contourType);
};


#endif /* BlobSkinAnalyze_h */
