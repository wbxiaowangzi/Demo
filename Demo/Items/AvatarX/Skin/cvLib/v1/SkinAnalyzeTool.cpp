//
//  SkinAnalyzeTool.cpp
//  Mirage3D
//
//  Created by 影子.zsr on 2018/3/19.
//  Copyright © 2018年 影子. All rights reserved.
//

#include "SkinAnalyzeTool.h"
#include <opencv2/highgui/highgui_c.h>
using namespace cv;
using namespace std;

#define CLIP_RANGE(value, min, max)  ( (value) > (max) ? (max) : (((value) < (min)) ? (min) : (value)) )
#define COLOR_RANGE(value)  CLIP_RANGE((value), 0, 255)
#define HUE_RANGE(value)  ( (value) > (180) ? ((value)-180) : (((value) < (0)) ? (0-(value)) : (value)) )

SkinAnalyzeTool::SkinAnalyzeTool()
{
}


SkinAnalyzeTool::~SkinAnalyzeTool()
{
}
//高反差保留
int SkinAnalyzeTool::HighPass(InputArray src, OutputArray dst, float radius)
{
    Mat input = src.getMat();
    if (input.empty()) {
        return -1;
    }
    
    dst.create(src.size(), src.type());
    Mat output = dst.getMat();
    
    if (radius < 0.1) return -1;
    if (radius > 250) return -1;
    cv::GaussianBlur(input, output, Size(0, 0), radius, radius);
    
    const uchar *in;
    uchar *out;
    int width = input.cols;
    int height = input.rows;
    int channels = input.channels();
    
    for (int y = 0; y < height; ++y) {
        in = input.ptr<uchar>(y);
        out = output.ptr<uchar>(y);
        for (int x = 0; x < width; ++x) {
            for (int i = 0; i < 3; ++i) {
                *out = COLOR_RANGE((*in - *out) + 127);//π´ Ω
                ++out; ++in;
            }
            
            for (int i = 0; i < channels - 3; ++i) {
                *out++ = *in++;
            }
        }
    }
    return 0;
}

//叠加
void SkinAnalyzeTool::Overlay(InputArray src1, InputArray src2, OutputArray dst)
{
    Mat input1 = src1.getMat();
    Mat input2 = src2.getMat();
    Mat output = dst.getMat();
    const uchar *in1, *in2;
    uchar *out;
    int width = input1.cols;
    int height = input1.rows;
    int channels = input1.channels();
    
    for (int y = 0; y < height; ++y) {
        in1 = input1.ptr<uchar>(y);
        in2 = input2.ptr<uchar>(y);
        out = output.ptr<uchar>(y);
        for (int x = 0; x < width; ++x) {
            for (int i = 0; i < 3; ++i) {
                float val1 = *in1/255.0, val2 = *in2/255.0;//π´ Ω
                if(val2 > 0.5)
                    *out= COLOR_RANGE(2 * val1 * val2*255.0);
                else
                    *out = COLOR_RANGE((1 - 2*(1 - val1)*(1 - val2))*255.0);
                ++out; ++in1; ++in2;
            }
            
            for (int i = 0; i < channels - 3; ++i) {
                *out++ = *in1++;
                *in2++;
            }
        }
    }
}

//滤色
void SkinAnalyzeTool::ColorFilter(InputArray src1, InputArray src2, OutputArray dst)
{
    Mat input1 = src1.getMat();
    Mat input2 = src2.getMat();
    Mat output = dst.getMat();
    const uchar *in1, *in2;
    uchar *out;
    int width = input1.cols;
    int height = input1.rows;
    int channels = input1.channels();
    
    for (int y = 0; y < height; ++y) {
        in1 = input1.ptr<uchar>(y);
        in2 = input2.ptr<uchar>(y);
        out = output.ptr<uchar>(y);
        for (int x = 0; x < width; ++x) {
            for (int i = 0; i < 3; ++i) {
                float val1 = *in1 / 255.0, val2 = *in2 / 255.0;//π´ Ω
                *out = COLOR_RANGE((1 - (1 - val1)*(1 - val2))*255.0);
                ++out; ++in1; ++in2;
            }
            
            for (int i = 0; i < channels - 3; ++i) {
                *out++ = *in1++;
                *in2++;
            }
        }
    }
}

//反色
int SkinAnalyzeTool::Inverted(InputArray src, OutputArray dst)
{
    Mat input = src.getMat();
    if (input.empty()) {
        return -1;
    }
    
    Mat output = dst.getMat();
    
    const uchar *in;
    uchar *out;
    int width = input.cols;
    int height = input.rows;
    int channels = input.channels();
    
    for (int y = 0; y < height; ++y) {
        in = input.ptr<uchar>(y);
        out = output.ptr<uchar>(y);
        for (int x = 0; x < width; ++x) {
            for (int i = 0; i < 3; ++i) {
                *out = COLOR_RANGE(255-*in);//π´ Ω
                ++out; ++in;
            }
            
            for (int i = 0; i < channels - 3; ++i) {
                *out++ = *in++;
            }
        }
    }
    return 0;
}

//调整色相
int SkinAnalyzeTool::Hue(InputArray src, OutputArray dst,float val)
{
    Mat input = src.getMat();
    if (input.empty()) {
        return -1;
    }
    
    Mat output = dst.getMat();
    
    const uchar *in;
    uchar *out;
    int width = input.cols;
    int height = input.rows;
    int channels = input.channels();
    
    for (int y = 0; y < height; ++y) {
        in = input.ptr<uchar>(y);
        out = output.ptr<uchar>(y);
        for (int x = 0; x < width; ++x) {
            float temp = *in + val;
            if (temp < 0) temp = 180+temp;
            else if (temp > 180) temp = temp - 180;
            *out = temp;
            out += 3;
            in += 3;
            for (int i = 0; i < channels - 3; ++i) {
                *out++ = *in++;
            }
        }
    }
    return 0;
}

//查找边缘
int SkinAnalyzeTool::Edge(InputArray src, Mat& dst)
{
    Mat input = src.getMat();
    if (input.empty()) {
        return -1;
    }
    
    Mat grad_x, grad_y, abs_grad_x, abs_grad_y;
    
    Sobel(input, grad_x, CV_16S, 1, 0, 3, 1, 1, BORDER_DEFAULT);
    convertScaleAbs(grad_x, abs_grad_x);
    
    Sobel(src, grad_y, CV_16S, 0, 1, 3, 1, 1, BORDER_DEFAULT);
    convertScaleAbs(grad_y, abs_grad_y);
    
    addWeighted(abs_grad_x, 0.5, abs_grad_y,0.5, 0, dst);
    return 0;
}

int SkinAnalyzeTool::wrinkleAnalyze(InputArray src, OutputArray dst)
{
    Mat pic_origin = src.getMat();
    Mat pic1,pic2;
    dst.create(src.size(), src.type());

    Mat pic_output = dst.getMat();
    
    HighPass(pic_origin, pic2, 10);//高反差保留第二张图
    Overlay(pic_output, pic2, pic_output);//将第二张图和第三张图叠加
    
    Inverted(pic_output, pic_output);//将第三张图反色
    cvtColor(pic_output,pic_output, CV_BGR2HSV);//反色后调整色相-180
    Hue(pic_output, pic_output, -180/2);//opencv的色相需要除2
    cvtColor(pic_output, pic_output, CV_HSV2BGR);
    
    Edge(pic_origin, pic1);//sobel查找边缘
    
    ColorFilter(pic_output, pic1, pic_output);//将第一张图和第三张图滤色叠加
    
    return 0;
}

