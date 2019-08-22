//#include<imgproc/imgproc.hpp>
#include<opencv2/opencv.hpp>
//#include<stdio.h>
//#include<stdlib.h>
//#include<math.h>
//#include<iostream>
#include "BlobSkinAnalyze.h"


using namespace std;
using namespace cv;


BlobSkinAnalyze::BlobSkinAnalyze()
{
}


BlobSkinAnalyze::~BlobSkinAnalyze()
{
}

int BlobSkinAnalyze::otsu(Mat& src)
{
    int height = src.rows;
    int width = src.cols;
    float histogram[256] = { 0 };
    for (int i = 0;i < height;i++)
    {
        unsigned char* p = (unsigned char*)src.data + src.step*i;
        for (int j = 0;j < width;j++)
        {
            histogram[*p++]++;
        }
    }
    
    int size = height*width;
    for (int i = 0;i < 256;i++)
    {
        histogram[i] = histogram[i] / size;
    }
    float avgValue = 0;
    for (int i = 0;i < 256;i++)
    {
        avgValue += i*histogram[i];
    }
    
    int threshold;
    float maxVariance = 0;
    float w = 0, u = 0;
    for (int i = 0;i < 256;i++)
    {
        w += histogram[i];
        u += i*histogram[i];
        float t = avgValue*w - u;
        float variance = t*t / (w*(1 - w));
        if (variance > maxVariance)
        {
            maxVariance = variance;
            threshold = i;
        }
    }
    
    return threshold;
}
//图片处理，灰度，开运算，直方均衡，高斯模糊，二值化
void BlobSkinAnalyze::imageProcess(Mat& src, Mat& result)
{
    vector<Mat> rgb_planes;
    split(src, rgb_planes);
    //imshow("src", src);
    Mat image_gaussian;
    Mat image_equalize;
    Mat image_gray;
    cvtColor(src, image_gray, CV_BGR2GRAY);
    //imshow("gray", image_gray);
    Mat element = getStructuringElement(MORPH_RECT, Size(5, 5));
    morphologyEx(image_gray, image_gaussian, MORPH_OPEN, element);
    //imshow("open", image_gaussian);
    
    equalizeHist(image_gaussian, image_equalize);
    //imshow("equ", image_equalize);
    
    GaussianBlur(image_equalize, image_gaussian, Size(5, 5), 0);
    //imshow("gau", image_gaussian);
    
    double thresholdVale = otsu(image_gaussian);
    
    threshold(image_gaussian, result, thresholdVale, 255, CV_THRESH_BINARY);
    
    //imshow("bin", result);
    return;
}

//边缘检测
vector<vector<Point>> BlobSkinAnalyze::contourDetect(Mat& src,int contourType=CONTOUR_ALL)
{
    vector<vector<Point>> contours;
    vector<Vec4i>hierarchy;
    
    
    findContours(src, contours, hierarchy, RETR_CCOMP, CHAIN_APPROX_SIMPLE, Point());
    switch (contourType)
    {
        case CONTOUR_ALL:
            return contours;
        case CONTOUR_NO_CHILD: {
            vector<vector<Point>> in_contours;
            
            for (int i = 0;i < contours.size();i++)
            {
                if (hierarchy[i][2] >= 0 && hierarchy[i][3] == -1)
                {
                    continue;
                }
                in_contours.push_back(contours[i]);
            }
            
            return in_contours;
        }
        case CONTOUR_INNER: {
            vector<vector<Point>> in_contours;
            
            for (int i = 0;i < contours.size();i++)
            {
                if (hierarchy[i][3] == -1)
                {
                    continue;
                }
                in_contours.push_back(contours[i]);
            }
            
            return in_contours;
        }
    }
    
    return contours;
}

//斑点边缘绘制
void BlobSkinAnalyze::drawBlob(Mat& src, vector<vector<Point>> contours)
{
    for (int i = 0;i < contours.size();i++)
    {
        drawContours(src, contours, i, Scalar(255,69,0,255), 1, 8);
        //break;
    }
}

//斑点面积计算
double BlobSkinAnalyze::areaCalculate(vector<vector<Point>> contours)
{
    double total_area = 0;
    for (int i = 0;i < contours.size();i++)
    {
        double g_area = contourArea(contours[i]);
        total_area += g_area;
        //cout << i << "th contour area: " << g_area << endl;
    }
    
    return total_area;
}

//斑点检测 src 输入图片, blobArea 斑点面积,
//faceArea 检测区域面积, contourType 边缘检测模式
void BlobSkinAnalyze::spotDetect(Mat& src, float& blobArea, float& faceArea, int contourType=CONTOUR_ALL)
{
    Mat result;
    imageProcess(src, result);
    vector<vector<Point>> contours = contourDetect(result,contourType);
    
    drawBlob(src, contours);
    
    blobArea = areaCalculate(contours);
    faceArea = src.rows*src.cols;
    return;
}



void BlobSkinAnalyze::blobContourDetect(Mat& src,float& ratio, vector<Point> points)
{
    int faceContour[][11] = {
        106,53,55,57,59,61,63,51,110,69,65,
        97,52,54,56,58,60,62,50,108,68,64 };
    
    float blobAreaTotal = 0.0;
    float faceAreaTotal = 0.0;
    
    for (int c_index = 0;c_index<2;c_index++)
    {
        float blobArea = 0.0;
        float faceArea = 0.0;
        
        vector<Point> contour;
        for (int i = 0;i < 11;i++)
        {
            contour.push_back(points[faceContour[c_index][i]]);
        }
        
        int left = contour[0].x;
        int top = contour[0].y;
        int right = contour[0].x;
        int down = contour[0].y;
        //寻找外包矩形，斑点检测区域
        for (int i = 1;i < contour.size();i++)
        {
            int now_x = contour[i].x;
            int now_y = contour[i].y;
            
            left = left > now_x ? now_x : left;
            top = top > now_y ? now_y : top;
            right = right < now_x ? now_x : right;
            down = down < now_y ? now_y : down;
            
        }
        
        //斑点检测区域切割
        Rect roiRect = Rect(left, top, right - left, down - top);
        Mat roi(src, roiRect);
        
        //斑点检测
        spotDetect(roi, blobArea, faceArea, CONTOUR_INNER);
        roi.copyTo(src(roiRect));
        
        blobAreaTotal += blobArea;
        faceAreaTotal += faceArea;
        
    }
    
    ratio = blobAreaTotal / faceAreaTotal;
    
    return;
    
}


//int main()
//{
//    Mat imageSource = imread("D:/blob/blob/blob/1165/head3d.jpg");
//    string uvsPath = "D:/blob/blob/blob/1165/uvs.txt";
//
//    float ratio;
//
//    blobContourDetect(imageSource, ratio, uvsPath);
//
//    imwrite("head9.jpg", imageSource);
//
//    return 0;
//}
