//
//  SkinDesignAnalyze.h
//  Mirage3D
//
//  Created by 影子 on 2018/10/16.
//  Copyright © 2018年 影子. All rights reserved.
//

#ifndef SkinDesignAnalyze_h
#define SkinDesignAnalyze_h

#include <opencv2/features2d/features2d.hpp>
#include <opencv2/imgproc/imgproc.hpp>

#include <vector>

class SkinDesignAnalyze
{
    public:
    
    /**
     肤色检测

     @param img oriTexture
     @param poi 特征点
     @param s 位置
     @return 颜色区间
     */
    std::string DetectSkinColor(cv::Mat img, std::vector<cv::Point> poi,cv::Scalar s[][11]);
    
    /**
     美白

     @param img oriTexture
     @return whiteTexture
     */
    cv::Mat ChangeFacecolor(cv::Mat img);
    
    
    /**
     擦除眉毛

     @param ppt 眉毛的9个特征点
     @param img oriTexture
     @param f f=0左眉;f=1右眉，以我的角度
     @param image_roi 皮肤蒙版
     @param x0 最左边
     @param y0 最上
     @param x1 最右边
     @param y1 最下
     @return image
     */
    cv::Mat RemoveEyebrow(cv::Point ppt[],cv::Mat image,int f,cv::Mat image_roi,int &x0,int &y0,int &x1,int &y1);
    
    
    /**
     添加眉毛

     @param output 输入图
     @param f f=0左眉;f=1右眉，以我的角度
     @param eyebrow 假眉毛矩阵
     @param p1 假眉毛外接矩形的左上角贴在原图的（p1,p2）位置。
     @param p2 假眉毛外接矩形的左上角贴在原图的（p1,p2）位置。
     @param s 表示眉毛外接矩形的长度，控制眉毛的大小
     @param angle 控制眉毛的角度，用15度之类的表示
     @return image
     */
    cv::Mat ChangeEyebrow(cv::Mat output,int f,cv::Mat eyebrow,int p1,int p2,int s,double angle);
    
    
    /**
     唇彩

     @param ppt 表示嘴巴的12个特征点
     @param img 原彩色图
     @param m 唇彩的颜色
     @return image
     */
    cv::Mat ChangeMouthcolor(cv::Point ppt[],cv::Mat img,cv::Scalar m);
    
    private:
    int cal(int x);
    std::vector<cv::Point> setPoint(std::string uvsPath);
    
};

#endif /* SkinDesignAnalyze_h */
