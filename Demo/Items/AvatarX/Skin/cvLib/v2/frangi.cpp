
#include "frangi.h"
//#include <iostream>
//#include <fstream>
#include <stdio.h>
#include<math.h>
using namespace std;
using namespace cv;
double round(double v)
{
    return int(v+0.5);
    
}

void gradient2D(Mat &Ix, Mat &Iy, Mat input){
    //typedef BOOST_TYPEOF(input.data) ElementType;
    
    for (int ncol = 0; ncol < input.cols; ncol++)
    {
        for (int nrow = 0; nrow < input.rows; nrow++)
        {
            if (ncol == 0){
                
                Ix.at<float>(nrow, ncol) = input.at<float>(nrow, 1) - input.at<float>(nrow, 0);
                
            }
            else if (ncol == input.cols - 1){
                Ix.at<float>(nrow, ncol) = input.at<float>(nrow, ncol) - input.at<float>(nrow, ncol - 1);
                
            }
            else
                Ix.at<float>(nrow, ncol) = (input.at<float>(nrow, ncol + 1) - input.at<float>(nrow, ncol - 1)) / 2;
            //cout << Ix.at<float>(nrow, ncol)<<endl;
        }
    }
    
    for (int nrow = 0; nrow < input.rows; nrow++)
    {
        for (int ncol = 0; ncol < input.cols; ncol++)
        {
            if (nrow == 0){
                Iy.at<float>(nrow, ncol) = input.at<float>(1, ncol) - input.at<float>(0, ncol);
            }
            else if (nrow == input.rows - 1){
                Iy.at<float>(nrow, ncol) = input.at<float>(nrow, ncol) - input.at<float>(nrow - 1, ncol);
            }
            else
                Iy.at<float>(nrow, ncol) = (input.at<float>(nrow + 1, ncol) - input.at<float>(nrow - 1, ncol)) / 2;
            //cout << Ix.at<float>(nrow, ncol)<<endl;
        }
        
    }
    
}



void frangi2d_hessian(const Mat &src, Mat &Dxx, Mat &Dxy, Mat &Dyy, float sigma){
    //construct Hessian kernels
    Mat img=src/255.0f;
    GaussianBlur(img,img,Size(sigma,sigma),BORDER_CONSTANT);
    Mat Ix(img.size(),CV_32FC1,Scalar(0));
    Mat Iy(img.size(),CV_32FC1,Scalar(0));
    img.convertTo(img, CV_32FC1);
    gradient2D(Ix, Iy, img);
    Mat Ixx(img.size(),CV_32FC1,Scalar(0));
    Mat Ixy(img.size(),CV_32FC1,Scalar(0));
    gradient2D(Ixx, Ixy, Ix);
    Mat Iyy(img.size(),CV_32FC1,Scalar(0));
    Mat Iyx(img.size(),CV_32FC1,Scalar(0));
    gradient2D(Iyx, Iyy, Iy);
    
    Dxy=Ixy;
    
    Dxx=Iyy;
    Dyy=Ixx;
}

void frangi2d_createopts(frangi2d_opts_t *opts){
    //these parameters depend on the scale of the vessel, depending ultimately on the image size...
    opts->sigma_start = DEFAULT_SIGMA_START;
    opts->sigma_end = DEFAULT_SIGMA_END;
    opts->sigma_step = DEFAULT_SIGMA_STEP;
    
    opts->BetaOne = DEFAULT_BETA_ONE; //ignore blob-like structures?
    opts->BetaTwo = DEFAULT_BETA_TWO; //appropriate background suppression for this specific image, but can change.
    
    opts->BlackWhite = DEFAULT_BLACKWHITE;
}

void frangi2_eig2image(const Mat &Dxx, const Mat &Dxy, const Mat &Dyy, Mat &lambda1, Mat &lambda2, Mat &Ix, Mat &Iy){
    //calculate eigenvectors of J, v1 and v2
    Mat tmp, tmp2;
    tmp2 = Dxx - Dyy;
    
    sqrt(tmp2.mul(tmp2) + 4*Dxy.mul(Dxy), tmp);
    
    Mat v2x = 2*Dxy;
    Mat v2y = Dyy - Dxx + tmp;
    
    //normalize
    Mat mag;
    sqrt((v2x.mul(v2x) + v2y.mul(v2y)), mag);
    Mat v2xtmp = v2x.mul(1.0f/mag);
    v2xtmp.copyTo(v2x, mag != 0);
    Mat v2ytmp = v2y.mul(1.0f/mag);
    v2ytmp.copyTo(v2y, mag != 0);
    
    //eigenvectors are orthogonal
    Mat v1x, v1y;
    v2y.copyTo(v1x);
    v1x = -1*v1x;
    v2x.copyTo(v1y);
    
    //compute eigenvalues
    Mat mu1 = 0.5*(Dxx + Dyy + tmp);
    Mat mu2 = 0.5*(Dxx + Dyy - tmp);
    lambda1=mu1;
    lambda2=mu2;
    v1x.copyTo(Ix);
    v1y.copyTo(Iy);
    
    
}


void frangi2d(const Mat &src, Mat &maxVals, Mat &whatScale, Mat &outAngles, frangi2d_opts_t opts,int flag){
    vector<Mat> ALLfiltered;
    vector<Mat> ALLangles;
    float beta = 2*opts.BetaOne*opts.BetaOne;
    float c = 2*opts.BetaTwo*opts.BetaTwo;
    
    for (float sigma = opts.sigma_start; sigma <= opts.sigma_end; sigma += opts.sigma_step){
        //create 2D hessians
        Mat Dxx, Dyy, Dxy;
        frangi2d_hessian(src, Dxx, Dxy, Dyy, sigma);
        if(flag==1)Dyy=Dxx;
        else if(flag==3)Dxx=Dyy;
        //correct for scale
        Dxx = Dxx*sigma*sigma;
        Dyy = Dyy*sigma*sigma;
        Dxy = Dxy*sigma*sigma;
        
        //calculate (abs sorted) eigenvalues and vectors
        Mat lambda1, lambda2, Ix, Iy;
        frangi2_eig2image(Dxx, Dxy, Dyy, lambda1, lambda2, Ix, Iy);
        
        
        //compute direction of the minor eigenvector
        
        
        //compute some similarity measures
        // Mat angles;
        //phase(Ix, Iy, angles);
        //ALLangles.push_back(angles);
        lambda1.setTo(1.11022302e-16, lambda1 == 0);
        Mat Rb = lambda2.mul(1.0/lambda1);
        Rb = Rb.mul(Rb);
        Mat S2 = lambda1.mul(lambda1) + lambda2.mul(lambda2);
        
        //compute output image
        Mat tmp1, tmp2;
        exp(-Rb/beta, tmp1);
        exp(-S2/c, tmp2);
        
        
        Mat Ifiltered = tmp1.mul(Mat::ones(src.rows, src.cols, src.type()) - tmp2);
        /*cout<<"a"<<endl;
         cout<<tmp1<<endl;
         cout<<"b"<<endl;
         cout<<1-tmp2<<endl;
         cout<<"a*b"<<endl;
         cout<<Ifiltered<<endl;*/
        if (opts.BlackWhite){
            Ifiltered.setTo(0, lambda1 < 0);
        } else {
            Ifiltered.setTo(0, lambda1 > 0);
        }
        
        //store results
        ALLfiltered.push_back(Ifiltered);
        
        
    }
    
    float sigma = opts.sigma_start;
    ALLfiltered[0].copyTo(maxVals);
    ALLfiltered[0].copyTo(whatScale);
    ALLfiltered[0].copyTo(outAngles);
    whatScale.setTo(sigma);
    
    //find element-wise maximum across all accumulated filter results
    for (int i=1; i < ALLfiltered.size(); i++){
        maxVals = max(maxVals, ALLfiltered[i]);
        whatScale.setTo(sigma, ALLfiltered[i] == maxVals);
        //ALLangles[i].copyTo(outAngles, ALLfiltered[i] == maxVals);
        sigma += opts.sigma_step;
    }
    
}
