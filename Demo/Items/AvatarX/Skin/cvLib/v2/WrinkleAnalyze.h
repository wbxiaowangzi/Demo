//
//  WrinkleAnalyze.h
//  Mirage3D
//
//  Created by 影子.zsr on 2018/7/11.
//  Copyright © 2018年 影子. All rights reserved.
//

#ifndef WrinkleAnalyze_h
#define WrinkleAnalyze_h

#include <opencv2/core/core.hpp>
#include <opencv2/features2d/features2d.hpp>
#include <opencv2/imgproc/imgproc.hpp>
#include <opencv2/photo/photo.hpp>
#include <vector>
using namespace cv;


struct wrinkle{
    int x,y,l,s;//(x,y)该条皱纹起始点，l皱纹长度，s是否是红色
};

class WrinkleAnalyze
{
public:
    
    WrinkleAnalyze();
    ~WrinkleAnalyze();
    void func(Mat src_color,std::vector<cv::Point>points,Mat &dst,std::vector<wrinkle>w[]);

    
private:
    Mat func1(std::vector<cv::Point>&points,Mat &src_color,int &x0,int &y0);
    Mat func2(std::vector<cv::Point>&points,Mat &src_color,int &x0,int &y0);
    Mat func3(std::vector<cv::Point>&points,Mat &src_color,int &x0,int &y0);
    Mat func4(std::vector<cv::Point>&points,Mat &src_color,int &x0,int &y0);
    Mat func5(std::vector<cv::Point>&points,Mat &src_color,int &x0,int &y0);
    Mat func6(std::vector<cv::Point>&points,Mat &src_color,int &x0,int &y0);
};

#endif /* WrinkleAnalyze_h */
