#pragma once


#include <opencv2/core/core.hpp>
#include <opencv2/features2d/features2d.hpp>
#include <opencv2/imgproc/imgproc.hpp>
#include <opencv2/photo/photo.hpp>
using namespace cv;
class SkinAnalyze
{
public:
	SkinAnalyze();
	~SkinAnalyze();
	int SpotsAnalyze(InputArray src, OutputArray dst);
    int WrinkleAnalyze(InputArray src,OutputArray dst);
    int ColorDistributionAnalyze(InputArray src, OutputArray dst);
    double glcm(const Mat img);

private:
	void HighContrastReserve(cv::Mat inImg, cv::Mat_<uchar>& outImg);
    void HighContrastReserve(cv::Mat inImg, cv::Mat_<uchar>& outImg,int times);
	void StrongLightenSingle(Mat_<uchar>& src1, Mat_<uchar>& src2, Mat_<uchar>& dst);
	int CalcCurve(double *output_y);
	void CreateColorTables(uchar colorTables[][256]);
    int CalGLCM(Mat& bWavelet, int angleDirection, double* featureVector);
    void SkinRoughness(InputArray src, double &score);
};

