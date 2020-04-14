//
//  SkinAnalyzeTool.hpp
//  Mirage3D
//
//  Created by 影子.zsr on 2018/3/19.
//  Copyright © 2018年 影子. All rights reserved.
//
#include <opencv2/core/core.hpp>

#include <opencv2/features2d/features2d.hpp>
#include <opencv2/imgproc/imgproc.hpp>
#include <opencv2/photo/photo.hpp>

using namespace cv;
class SkinAnalyzeTool
{
public:
    SkinAnalyzeTool();
    ~SkinAnalyzeTool();
    int wrinkleAnalyze(InputArray src, OutputArray dst);
private:
    int HighPass(InputArray src, OutputArray dst, float radius);
    void Overlay(InputArray src1, InputArray src2, OutputArray dst);
    void ColorFilter(InputArray src1, InputArray src2, OutputArray dst);
    int Inverted(InputArray src, OutputArray dst);
    int Hue(InputArray src, OutputArray dst,float val);
    int Edge(InputArray src, Mat& dst);
};
