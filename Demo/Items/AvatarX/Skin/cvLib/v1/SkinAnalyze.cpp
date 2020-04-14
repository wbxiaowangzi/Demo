#include "SkinAnalyze.h"
#include <opencv2/core/core.hpp>
#include <opencv2/features2d/features2d.hpp>
#include <opencv2/imgproc/imgproc.hpp>
#include <opencv2/photo/photo.hpp>
#include<iostream>
using namespace cv;
using namespace std;

#define CLIP_RANGE(value, min, max)  ( (value) > (max) ? (max) : (((value) < (min)) ? (min) : (value)) )
#define COLOR_RANGE(value)  CLIP_RANGE((value), 0, 255)
#define HUE_RANGE(value)  ( (value) > (180) ? ((value)-180) : (((value) < (0)) ? (0-(value)) : (value)) )
SkinAnalyze::SkinAnalyze()
{
}


SkinAnalyze::~SkinAnalyze()
{
}


//高反差保留
int HighPass(InputArray src, OutputArray dst, float radius)
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
				*out = COLOR_RANGE((*in - *out) + 127);//公式
				++out; ++in;
			}

			for (int i = 0; i < channels - 3; ++i) {
				*out++ = *in++;
			}
		}
	}
	return 0;
}

void Overlay(InputArray src1, InputArray src2, OutputArray dst)
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
                float val1 = *in1 / 255.0, val2 = *in2 / 255.0;//公式
                if (val2 > 0.5)
                    *out = COLOR_RANGE(2 * val1 * val2*255.0);
                else
                    *out = COLOR_RANGE((1 - 2 * (1 - val1)*(1 - val2))*255.0);
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
void ColorFilter(InputArray src1, InputArray src2, OutputArray dst)
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
				float val1 = *in1 / 255.0, val2 = *in2 / 255.0;//公式
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
int Inverted(InputArray src, OutputArray dst)
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
				*out = COLOR_RANGE(255 - *in);//公式
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
int Hue(InputArray src, OutputArray dst, float val)
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
			if (temp < 0) temp = 180 + temp;
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
void SkinAnalyze::StrongLightenSingle(Mat_<uchar>& src1, Mat_<uchar>& src2, Mat_<uchar>& dst)
{
	float a = 0;
	float b = 0;
	/*imshow("src1",src1);
	waitKey(0);*/
	int index = 0;
	uchar *ptr1 = src1.data;
	uchar *ptr2 = src2.data;
	uchar *ptrDst = dst.data;
	for (int index_row = 0; index_row < src1.rows; index_row++)
	{
		for (int index_col = 0; index_col < src1.cols; index_col++, index++)
		{
			a = (float)ptr1[index] / 255;
			b = (float)ptr2[index] / 255;
			if (a <= 0.3)
			{
				ptrDst[index] = 2 * a*b * 255;
			}
			else
			{
				ptrDst[index] = 1 - 2 * (1 - a)*(1 - b) * 255;
			}
		}
	}
}
void SkinAnalyze::HighContrastReserve(cv::Mat inImg, cv::Mat_<uchar>& outImg)
{
	cv::Mat gray, avg;
	if (inImg.channels()==3)
	{
		cvtColor(inImg, gray, CV_BGR2GRAY);
	}
	else {
		gray = inImg.clone();
	}
	int width = gray.cols;
	int heigh = gray.rows;
	int R = 25;
	GaussianBlur(gray, avg, cv::Size(R, R), 0.0);
	outImg = cv::Mat::zeros(gray.size(), CV_8UC1);

	float tmp;

	float alpha = 0.5;
	int index=0;
	uchar* imgP = gray.data;
	uchar* avgP = avg.data;
	uchar* dstP = outImg.data;
	for (int y = 0; y < heigh; y++)
	{
		
		for (int x = 0; x < width; x++, index++)
		{
			tmp = alpha*imgP[index] + alpha*(255 - avgP[index]);
			dstP[index] = (uchar)(tmp);
		}
	}
	StrongLightenSingle(outImg, outImg, outImg);
	StrongLightenSingle(outImg, outImg, outImg);
	StrongLightenSingle(outImg, outImg, outImg);
	//StrongLightenSingle(outImg, outImg, outImg);
	//StrongLightenSingle(outImg, outImg, outImg);
	//StrongLightenSingle(outImg, outImg, outImg);
}
static double spline(double *x, double *y, int n, double *t, int m, double *z)
{
	double* dy = new double[n];
	memset(dy, 0, sizeof(double)*n);
	dy[0] = -0.5;

	double* ddy = new double[n];
	memset(ddy, 0, sizeof(double)*n);

	double h1;
	double* s = new double[n];
	double h0 = x[1] - x[0];

	s[0] = 3.0 * (y[1] - y[0]) / (2.0 * h0) - ddy[0] * h0 / 4.0;
	for (int j = 1; j <= n - 2; ++j)
	{
		h1 = x[j + 1] - x[j];
		double alpha = h0 / (h0 + h1);
		double beta = (1.0 - alpha) * (y[j] - y[j - 1]) / h0;
		beta = 3.0 * (beta + alpha * (y[j + 1] - y[j]) / h1);
		dy[j] = -alpha / (2.0 + (1.0 - alpha) * dy[j - 1]);
		s[j] = (beta - (1.0 - alpha) * s[j - 1]);
		s[j] = s[j] / (2.0 + (1.0 - alpha) * dy[j - 1]);
		h0 = h1;
	}
	dy[n - 1] = (3.0*(y[n - 1] - y[n - 2]) / h1 + ddy[n - 1] * h1 / 2.0 - s[n - 2]) / (2.0 + dy[n - 2]);

	for (int j = n - 2; j >= 0; --j)
	{
		dy[j] = dy[j] * dy[j + 1] + s[j];
	}

	for (int j = 0; j <= n - 2; ++j)
	{
		s[j] = x[j + 1] - x[j];
	}

	for (int j = 0; j <= n - 2; ++j)
	{
		h1 = s[j] * s[j];
		ddy[j] = 6.0 * (y[j + 1] - y[j]) / h1 - 2.0 * (2.0 * dy[j] + dy[j + 1]) / s[j];
	}

	h1 = s[n - 2] * s[n - 2];
	ddy[n - 1] = 6.0 * (y[n - 2] - y[n - 1]) / h1 + 2.0 * (2.0 * dy[n - 1] + dy[n - 2]) / s[n - 2];
	double g = 0.0;
	for (int i = 0; i <= n - 2; i++)
	{
		h1 = 0.5 * s[i] * (y[i] + y[i + 1]);
		h1 = h1 - s[i] * s[i] * s[i] * (ddy[i] + ddy[i + 1]) / 24.0;
		g = g + h1;
	}

	for (int j = 0; j <= m - 1; j++)
	{
		int i;
		if (t[j] >= x[n - 1]) {
			i = n - 2;
		}
		else {
			i = 0;
			while (t[j] > x[i + 1]) {
				i = i + 1;
			}
		}
		h1 = (x[i + 1] - t[j]) / s[i];
		h0 = h1 * h1;
		z[j] = (3.0 * h0 - 2.0 * h0 * h1) * y[i];
		z[j] = z[j] + s[i] * (h0 - h0 * h1) * dy[i];
		h1 = (t[j] - x[i]) / s[i];
		h0 = h1 * h1;
		z[j] = z[j] + (3.0 * h0 - 2.0 * h0 * h1) * y[i + 1];
		z[j] = z[j] - s[i] * (h0 - h0 * h1) * dy[i + 1];
	}

	delete[] s;
	delete[] dy;
	delete[] ddy;

	return(g);
}
int SkinAnalyze::CalcCurve(double *output_y)
{
	

	int n = 3;  //count of points

							//create array of x-coordinate and y-coordinate of control points
	double *x = new double[n];
	double *y = new double[n];
	x[0] = 0;
	x[1] = 128;
	x[2] = 255;
	y[0] = 0;
	y[1] = 0;
	y[2] = 255;

	
	

	//create array of x-coordinate of output points
	int m = 255;
	double *t = new double[m];  //array of x-coordinate of output points
	double *z = new double[m];  //array of y-coordinate of output points
								//initialize array of x-coordinate
	for (int i = 0; i< m; ++i) {
		t[i] = i;
	}

	//perform spline, output y-coordinate is stored in array z
	spline(x, y, n, t, m, z);

	//create output
	for (int i = 0; i < 256; ++i) {
		if (i < x[0]) {
			output_y[i] = y[0];
		}
		else if (i >= x[0] && i < x[2]) {
			output_y[i] = CLIP_RANGE(z[i], 0, 255);
		}
		else {
			output_y[i] = y[2];
		}
	}

	return 0;
}
void SkinAnalyze::CreateColorTables(uchar colorTables[][256])
{
	double z[256];
	CalcCurve(z);
	for (int i = 0; i < 256; ++i) {
		colorTables[0][i] = z[i];
	}

	
	for (int i = 0; i < 256; ++i)
		colorTables[1][i] = z[i];

	
	for (int i = 0; i < 256; ++i) {
		colorTables[2][i] = z[i];
	}
	
	/*for (int i = 0; i < 256; ++i) {
		for (int c = 0; c < 3; c++) {
			
			colorTables[c][i] = z[colorTables[c][i]];
		}
	}*/
}
int SkinAnalyze::SpotsAnalyze(InputArray src, OutputArray dst)
{

	Mat input = src.getMat();
	if (input.empty()) {
		return -1;
	}

	dst.create(src.size(), src.type());
	Mat output = dst.getMat();

	bool hasMask = true;
	Mat_<uchar> msk;
	HighContrastReserve(input,msk);

	if (msk.empty())
		hasMask = false;

	const uchar *in;
	const uchar *pmask;
	uchar *out;
	int width = input.cols;
	int height = input.rows;
	int channels = input.channels();

	uchar colorTables[3][256];

	//create color tables
	CreateColorTables(colorTables);

	//adjust each pixel
	//imshow("mask",mask);
	//waitKey(0);
	if (hasMask) {
#ifdef HAVE_OPENMP
#pragma omp parallel for
#endif
		for (int y = 0; y < height; y++) {
			in = input.ptr<uchar>(y);
			out = output.ptr<uchar>(y);
			pmask = msk.ptr<uchar>(y);
			for (int x = 0; x < width; x++) {
				for (int c = 0; c < 3; c++) {
					*out = (colorTables[c][*in] * (255 - pmask[x]) / 255.0)
						+ (*in) * pmask[x] / 255.0;
					out++; in++;
				}
				for (int c = 0; c < channels - 3; c++) {
					*out++ = *in++;
				}
			}
		}
	}
	else {
#ifdef HAVE_OPENMP
#pragma omp parallel for
#endif
		for (int y = 0; y < height; y++) {
			in = input.ptr<uchar>(y);
			out = output.ptr<uchar>(y);
			for (int x = 0; x < width; x++) {
				for (int c = 0; c < 3; c++) {
					*out++ = colorTables[c][*in++];
				}
				for (int c = 0; c < channels - 3; c++) {
					*out++ = *in++;
				}
			}
		}
	}

	return 0;
}


int SkinAnalyze::WrinkleAnalyze(InputArray src, OutputArray dst)
{
	/*Sobel(src, dst, CV_8U, 0, 1);
	
	Canny(src, dst, 50, 100);*/
	//取蓝色通道，进行高反差保留
	vector<cv::Mat_<uchar>> mats;
	split(src.getMat(),mats);
	Mat_<uchar> blueMat = mats[0];
	//pyrDown(blueMat,blueMat);
	HighContrastReserve(blueMat,blueMat);
	Mat overlayImg;
    Mat oriImg;
    cvtColor(src, oriImg, CV_BGRA2BGR);
	
	/*dst = Mat_<Vec3b>::zeros(src.size());*/
	//HighPass(pic_origin, pic2, 10);//高反差保留第二张图
	Mat colorImg;
	cvtColor(blueMat,colorImg,CV_GRAY2BGR);
    cout<<colorImg.channels()<<" "<<src.channels()<<" "<<dst.channels();
	Overlay(oriImg, colorImg, dst);//将第二张图和第三张图叠加

	Inverted(dst, dst);//将第三张图反色
	cvtColor(dst, dst, CV_BGR2HSV);//反色后调整色相-180
	Hue(dst, dst, -180 / 2);//opencv的色相需要除2
	cvtColor(dst, dst, CV_HSV2BGR);
	
	//Edge(pic_origin, pic1);//sobel查找边缘
	//ColorFilter(pic3, pic1, pic3);//将第一张图和第三张图滤色叠加
	//pyrDown(pic3,pic3);
	


	return 0;
}

#define GLCM_DIS 10 //灰度共生矩阵的统计距离

#define GLCM_CLASS 16 //计算灰度共生矩阵的图像灰度值等级化

#define GLCM_ANGLE_HORIZATION 0 //水平

#define GLCM_ANGLE_VERTICAL 1 //垂直

#define GLCM_ANGLE_DIGONAL 2 //对角

//int calGLCM(IplImage* bWavelet,int angleDirection,double* featureVector)

int SkinAnalyze::ColorDistributionAnalyze(InputArray src, OutputArray dst)
{
    dst.getMatRef() = src.getMat().clone();
    blur(dst, dst, cv::Size(10,10));
    vector<cv::Mat_<uchar>> mats;
    split(src.getMat(), mats);
    Mat_<uchar> blueMat = mats[2];

    HighContrastReserve(blueMat, blueMat,1);
    Mat overlayImg;

    Mat colorImg;
    cvtColor(blueMat, colorImg, CV_GRAY2BGRA);
    
//    dst.getMatRef() = colorImg;
//    return 0;
    
    Overlay(src, colorImg, dst);
//    Mat input = dst.getMat();
    Mat output = dst.getMat();

    return 0;
}

void SkinAnalyze::HighContrastReserve(cv::Mat inImg, cv::Mat_<uchar>& outImg,int times)
{
    cv::Mat gray, avg;
    if (inImg.channels()==3)
    {
        cvtColor(inImg, gray, CV_BGR2GRAY);
    }
    else {
        gray = inImg.clone();
    }
    int width = gray.cols;
    int heigh = gray.rows;
    int R = 35;
    GaussianBlur(gray, avg, cv::Size(R, R), 0.0);
    outImg = cv::Mat::zeros(gray.size(), CV_8UC1);
    
    float tmp;
    
    float alpha = 0.5;
    int index=0;
    uchar* imgP = gray.data;
    uchar* avgP = avg.data;
    uchar* dstP = outImg.data;
    for (int y = 0; y < heigh; y++)
    {
        
        for (int x = 0; x < width; x++, index++)
        {
            tmp = alpha*imgP[index] + alpha*(255 - avgP[index]);
            dstP[index] = (uchar)(tmp);
        }
    }
    for (size_t i = 0; i < times; i++)
    {
        
    }
    StrongLightenSingle(outImg, outImg, outImg);
    
    StrongLightenSingle(outImg, outImg, outImg);
    StrongLightenSingle(outImg, outImg, outImg);
    //StrongLightenSingle(outImg, outImg, outImg);
}

int SkinAnalyze::CalGLCM(Mat& bWavelet, int angleDirection, double* featureVector)

{

	int i, j;

	int width, height;

	if (bWavelet.empty())
		return 1;

	width = bWavelet.cols;
	height = bWavelet.rows;

	int * glcm = new int[GLCM_CLASS * GLCM_CLASS];
	int * histImage = new int[width * height];

	if (NULL == glcm || NULL == histImage)
		return 2;

	//灰度等级化---分GLCM_CLASS个等级  

	for (i = 0; i < height; i++) {
		uchar *data = bWavelet.ptr<uchar>(i);
		for (j = 0; j < width; j++) {
			histImage[i * width + j] = (int)(data[j] * GLCM_CLASS / 256);
		}
	}

	//初始化共生矩阵  
	for (i = 0; i < GLCM_CLASS; i++)
		for (j = 0; j < GLCM_CLASS; j++)
			glcm[i * GLCM_CLASS + j] = 0;

	//计算灰度共生矩阵  
	int w, k, l;
	//水平方向  
	if (angleDirection == GLCM_ANGLE_HORIZATION)
	{
		for (i = 0; i < height; i++)
		{
			for (j = 0; j < width; j++)
			{
				l = histImage[i * width + j];
				if (j + GLCM_DIS >= 0 && j + GLCM_DIS < width)
				{
					k = histImage[i * width + j + GLCM_DIS];
					glcm[l * GLCM_CLASS + k]++;
				}
				if (j - GLCM_DIS >= 0 && j - GLCM_DIS < width)
				{
					k = histImage[i * width + j - GLCM_DIS];
					glcm[l * GLCM_CLASS + k]++;
				}
			}
		}
	}
	//垂直方向  
	else if (angleDirection == GLCM_ANGLE_VERTICAL)
	{
		for (i = 0; i < height; i++)
		{
			for (j = 0; j < width; j++)
			{
				l = histImage[i * width + j];
				if (i + GLCM_DIS >= 0 && i + GLCM_DIS < height)
				{
					k = histImage[(i + GLCM_DIS) * width + j];
					glcm[l * GLCM_CLASS + k]++;
				}
				if (i - GLCM_DIS >= 0 && i - GLCM_DIS < height)
				{
					k = histImage[(i - GLCM_DIS) * width + j];
					glcm[l * GLCM_CLASS + k]++;
				}
			}
		}
	}
	//对角方向  
	else if (angleDirection == GLCM_ANGLE_DIGONAL)
	{
		for (i = 0; i < height; i++)
		{
			for (j = 0; j < width; j++)
			{
				l = histImage[i * width + j];

				if (j + GLCM_DIS >= 0 && j + GLCM_DIS < width && i + GLCM_DIS >= 0 && i + GLCM_DIS < height)
				{
					k = histImage[(i + GLCM_DIS) * width + j + GLCM_DIS];
					glcm[l * GLCM_CLASS + k]++;
				}
				if (j - GLCM_DIS >= 0 && j - GLCM_DIS < width && i - GLCM_DIS >= 0 && i - GLCM_DIS < height)
				{
					k = histImage[(i - GLCM_DIS) * width + j - GLCM_DIS];
					glcm[l * GLCM_CLASS + k]++;
				}
			}
		}
	}

	//计算特征值  
	double entropy = 0, energy = 0, contrast = 0, homogenity = 0;
	for (i = 0; i < GLCM_CLASS; i++)
	{
		for (j = 0; j < GLCM_CLASS; j++)
		{
			//if(i==j&&i==10)cout<<glcm[i * GLCM_CLASS + j]<<endl;
			//熵  
			if (glcm[i * GLCM_CLASS + j] > 0)
				entropy -= glcm[i * GLCM_CLASS + j] * log10(double(glcm[i * GLCM_CLASS + j]));
			//能量  
			energy += glcm[i * GLCM_CLASS + j] * glcm[i * GLCM_CLASS + j];
			//对比度  
			contrast += (i - j) * (i - j) * glcm[i * GLCM_CLASS + j];
			//一致性  
			homogenity += 1.0 / (1 + (i - j) * (i - j)) * glcm[i * GLCM_CLASS + j];
		}
	}
	//返回特征值  
	i = 0;
	featureVector[i++] = entropy;
	featureVector[i++] = energy;
	featureVector[i++] = contrast;
	featureVector[i++] = homogenity;
	//cout << entropy << "," << energy << "," << endl;
	delete[] glcm;
	delete[] histImage;
	return 0;
}

void SkinAnalyze::SkinRoughness(InputArray src, double &score)
{
	double features[4];
	Mat input = src.getMat();
	CalGLCM(input, GLCM_ANGLE_VERTICAL,features);
	for (size_t i = 0; i < 4; i++)
	{
		cout << features[i] << endl;
	}
}


double SkinAnalyze::glcm(const Mat img)
{
    std::vector<double> vec_energy = *new std::vector<double>[5]();
    
	float energy = 0, contrast = 0, homogenity = 0, IDM = 0, entropy = 0, mean1 = 0;
	int row = img.rows, col = img.cols;
	cv::Mat gl = cv::Mat::zeros(256, 256, CV_32FC1);

	//creating glcm matrix with 256 levels,radius=1 and in the horizontal direction
	for (int i = 0; i<row; i++)
		for (int j = 0; j<col - 1; j++)
			gl.at<float>(img.at<uchar>(i, j), img.at<uchar>(i, j + 1)) = gl.at<float>(img.at<uchar>(i, j), img.at<uchar>(i, j + 1)) + 1;

	// normalizing glcm matrix for parameter determination
	gl = gl + gl.t();
	gl = gl / sum(gl)[0];


	for (int i = 0; i<256; i++)
		for (int j = 0; j<256; j++)
		{
			energy += gl.at<float>(i, j)*gl.at<float>(i, j);
			vec_energy.push_back(energy);

			//finding parameters
			contrast = contrast + (i - j)*(i - j)*gl.at<float>(i, j);
			homogenity = homogenity + gl.at<float>(i, j) / (1 + abs(i - j));
			if (i != j)
				IDM = IDM + gl.at<float>(i, j) / ((i - j)*(i - j));                      //Taking k=2;
			if (gl.at<float>(i, j) != 0)
				entropy = entropy - gl.at<float>(i, j)*log10(gl.at<float>(i, j));
			mean1 = mean1 + 0.5*(i*gl.at<float>(i, j) + j*gl.at<float>(i, j));
		}

	/*  for (int i = 0; i<256; i++)
	{
	for (int j = 0; j<256; j++)
	cout << a[i][j] << "\t";
	cout << endl;
	}*/

	 return entropy;
}


//int main(int argc, char** argv)
//{
//
//
//	Mat img = cv::imread(argv[1], CV_LOAD_IMAGE_UNCHANGED);
//
//	if (img.empty())
//	{
//		cout << "can not load " << argv[1];
//		return 1;
//	}
//	imshow("Image", img);
//
//	vector<double> vec_energy;
//	glcm(img, vec_energy);   //call to glcm function
//
//	Mat mat_energy = Mat(vec_energy);
//
//	Mat plot_result;
//
//	Ptr<plot::Plot2d> plot = plot::Plot2d::create(mat_energy);
//	plot->setShowGrid(false);
//	plot->setShowText(false);
//	plot->render(plot_result);
//
//	imshow("plot", plot_result);
//	cv::waitKey(0);
//	return 0;
//}
