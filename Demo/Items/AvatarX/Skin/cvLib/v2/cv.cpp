#include <opencv2/opencv.hpp>
#include <vector>
#include "frangi.h"
#include "WrinkleAnalyze.h"
using namespace std;
using namespace cv;

WrinkleAnalyze::WrinkleAnalyze()
{
}


WrinkleAnalyze::~WrinkleAnalyze()
{
}

struct node{
    int x1,x2,y1,y2;
    int r;};

bool cmp(node a,node b){
    
    return a.r<b.r;
}


Mat WrinkleAnalyze::func1(vector<Point>&points,Mat &src_color,int &x0,int &y0){
    int low=min((points[77].y+points[7].y)/2,(points[84].y+points[8].y)/2);
    int high=max(points[5].y,points[6].y);
    int left=max(points[77].x,points[5].x);
    int right=min(points[84].x,points[6].x);
    
    Rect rect(left, high, right-left, low-high);
    x0=left;
    y0=high;
    Mat image_roi = src_color(rect);
    return image_roi;
    
}
Mat WrinkleAnalyze::func2(vector<Point>&points,Mat &src_color,int &x0,int &y0){
    Rect rect(points[75].x,points[2].y,points[82].x-points[75].x,points[16].y-points[2].y);
    Mat image_roi =src_color(rect);
    x0=points[75].x;
    y0=points[2].y;
    return image_roi;
}
Mat WrinkleAnalyze::func3(vector<Point>&points,Mat &src_color,int &x0,int &y0){
    Rect rect(points[54].x,points[13].y,points[97].x-points[54].x,points[54].y-points[13].y);
    Mat image_roi =src_color(rect);
    x0=points[54].x;
    y0=points[13].y;
    return image_roi;
}
Mat WrinkleAnalyze::func4(vector<Point>&points,Mat &src_color,int &x0,int &y0){
    Rect rect(points[106].x,points[14].y,points[55].x-points[106].x,points[55].y-points[14].y);
    Mat image_roi = src_color(rect);
    x0=points[106].x;
    y0=points[14].y;
    return image_roi;
}
Mat WrinkleAnalyze::func5(vector<Point>&points,Mat &src_color,int &x0,int &y0){
    double x=(points[28].x+points[107].x)/2;
    Rect rect(x,points[28].y,points[28].x-x,points[37].y-points[28].y);
    Mat image_roi = src_color(rect);
    x0=x;
    y0=points[28].y;
    return image_roi;
}
Mat WrinkleAnalyze::func6(vector<Point>&points,Mat &src_color,int &x0,int &y0){
    double x=(points[29].x+points[109].x)/2;
    Rect rect(points[29].x,points[29].y,x-points[29].x,points[38].y-points[29].y);
    Mat image_roi = src_color(rect);
    x0=points[29].x;
    y0=points[29].y;
    return image_roi;
}

void WrinkleAnalyze::func(Mat src_color,vector<Point>points,Mat &dst,vector<wrinkle>w[]){
    vector<node>vec;
    int (*board)[2048] = new int[4096][2048];
    Mat src_gray;
    cvtColor(src_color,src_gray,CV_BGR2GRAY);
    src_gray.convertTo(src_gray, CV_8UC1);
    
    int x0[6],y0[6];
    Mat image_roi[6];
    image_roi[0]=func1(points,src_gray,x0[0],y0[0]);//额头
    image_roi[1]=func2(points,src_gray,x0[1],y0[1]);//眉间
    image_roi[2]=func3(points,src_gray,x0[2],y0[2]);//左眼角
    image_roi[3]=func4(points,src_gray,x0[3],y0[3]);//右眼角
    image_roi[4]=func5(points,src_gray,x0[4],y0[4]);//左法令纹
    image_roi[5]=func6(points,src_gray,x0[5],y0[5]);//右法令纹
    for(int k=0;k<6;k++){
        Mat input_img=image_roi[k];
        Mat eh;
        equalizeHist(input_img, eh);
        Mat input_img_fl;
        input_img.convertTo(input_img_fl, CV_32FC1);//将图片转换为float型
        Mat img(input_img_fl.size(), CV_32FC1,Scalar(0));//frangi滤波后的图
        Mat  scale, angles;
        frangi2d_opts_t opts;
        frangi2d_createopts(&opts);
        int flag=2;//斜条纹
        if(k==0) flag=1;//横条纹
        else if(k==1)flag=3;//竖条纹
        if(k==4||k==5)opts.sigma_end=30;
        frangi2d(input_img_fl,img, scale, angles, opts,flag);//flag确定检测的是横条纹还是竖条纹
        double maxv = 0.0;
        Mat img1=img.clone();
        maxv=0.0011;
        if(k==0){
            img.setTo(0, img >0.15);//0.15是额头阴影阈值
            maxv=0.15;}
        img=img/maxv;
        img.setTo(1, img >1.0);
        if(k==1 )img.setTo(0, img >=5.0);//眉间过滤眉毛
        img=img*255;
        img.convertTo(img, CV_8UC1);
        double thresh=10;
        if(k==0)thresh=100;
        if(k==4)thresh=80;
        if(k==5)thresh=80;
        threshold(img,img,thresh,255,0);
        
        Mat_<uchar> im=img;
        Mat imgc(img.size(),CV_8U,Scalar(0));
        if(k!=4&&k!=5&&k!=1){//提取横纹轮廓
            for(int y=0;y<im.cols;y++){
                
                for(int x=0;x<im.rows;x++){
                    
                    if((int)im(x,y)==255){
                        int x1=x;
                        int y1=y;
                        int th=(int)eh.at<uchar>(x,y);
                        x++;
                        while(x<im.rows&&(int)im(x,y)==255)
                        {
                            img.at<uchar>(x,y)=0;
                            if((int)eh.at<uchar>(x,y)<th){
                                th=(int)eh.at<uchar>(x,y);
                            }
                            x++;
                        }
                        x--;
                        eh.at<uchar>(x1,y1)=th;
                    }
                    
                }}}
        else{
            for(int x=0;x<im.rows;x++){//提取竖纹轮廓
                for(int y=0;y<im.cols;y++){
                    if((int)im(x,y)==255){
                        int x1=x;
                        int y1=y;
                        int th=(int)eh.at<uchar>(x,y);
                        y++;
                        while(y<im.cols&&(int)im(x,y)==255)
                        {
                            img.at<uchar>(x,y)=0;
                            if((int)eh.at<uchar>(x,y)<th){
                                th=(int)eh.at<uchar>(x,y);
                            }
                            y++;
                        }
                        y--;
                        eh.at<uchar>(x1,y1)=th;
                    }
                }}
        }
        if(k!=4&&k!=5&&k!=1){//提取横纹轮廓
            for(int y=0;y<im.cols;y++){
                for(int x=0;x<im.rows;x++){
                    if((int)im(x,y)==255&&x>0&&src_gray.at<uchar>(x-1,y)<src_gray.at<uchar>(x,y)){
                        img.at<uchar>(x,y)=0;
                    }
                    
                }}}
        else{for(int x=0;x<im.rows;x++)//提取竖纹轮廓
        {
            for(int y=0;y<im.cols;y++){
                if((int)im(x,y)==255&&y>0&&src_gray.at<uchar>(x,y-1)<src_gray.at<uchar>(x,y)){
                    img.at<uchar>(x,y)=0;
                }
                
            }}
            
        }
        
        
        vector<vector<Point>> contours,contour,contour0;
        //findContours的输入是二值图像
        Mat result(img.size(),CV_8U,Scalar(0));
        contours.clear();contour.clear();
        
        findContours(img,contours,CV_RETR_TREE, // retrieve the external contours
                     CHAIN_APPROX_NONE);
        
        vector<vector<Point>>::const_iterator itContours= contours.begin();
        
        for ( ; itContours!=contours.end(); ++itContours) {
            
            //每个轮廓包含的点数
            int max=0;
            int min=img.cols;
            if(k!=1){
                for(int i=0;i<itContours->size();i++)
                {if((*itContours)[i].x>max)max=(*itContours)[i].x;
                    
                    if((*itContours)[i].x<min)min=(*itContours)[i].x;
                    
                }
                int t=4;
                if(k==0)t=35;//额头通过长度过滤汗毛
                
                if(k==2||k==3)t=30;//眼角过滤噪声
                if(  max-min>t){
                    
                    contour.push_back(*itContours);
                }  }
            else {
                for(int i=0;i<itContours->size();i++)
                {if((*itContours)[i].y>max)max=(*itContours)[i].y;
                    
                    if((*itContours)[i].y<min)min=(*itContours)[i].y;
                    
                }
                
                if(  max-min>50){
                    contour.push_back(*itContours);
                }
            }
        }
        drawContours(result,contour,      //画出轮廓
                     -1, // draw all contours
                     Scalar(255), // in black
                     1); // with a thickness of 2
        //****************
        if(k==0||k==2||k==3||k==4||k==5){
            for(int i=0;i<contour.size();i++)
            {
                int x=0;int y;
                for(int j=0;j<contour[i].size();j++)
                    if(x<contour[i][j].x){x=contour[i][j].x;
                        y=contour[i][j].y;}
                
                
                if(x+1<img.cols ){
                    
                    int x0=0,y0=0,r0=1200; //把两条距离小于根号r0的线段连接起来
                    if(k==4||k==5)r0=30;
                    for(int k=0;k<contour.size();k++){
                        if(k!=i){
                            int x1=img.cols,y1;
                            for(int j=0;j<contour[k].size();j++)
                                if(x1>contour[k][j].x ){x1=contour[k][j].x;
                                    y1=contour[k][j].y;}
                            
                            if(board[x1][y1]==0&&x1>x&&(fabs(1.0*(y1-y)/(x1-x))<0.4)&&(x1-x)*(x1-x)+(y1-y)*(y1-y)<r0){
                                x0=x1;
                                y0=y1;
                                r0=(x1-x)*(x1-x)+(y1-y)*(y1-y);
                            }
                        }
                    }
                    
                    if(x0!=0||y0!=0){
                        Point point;//创建一个2D点对象
                        point.x = x0;//初始化x坐标值
                        point.y = y0;
                        Point point1;//创建一个2D点对象
                        point.x = x;//初始化x坐标值
                        point.y = y;
                        node no;
                        no.x1=x0;
                        no.x2=x;
                        no.y1=y0;
                        no.y2=y;
                        no.r=r0;
                        vec.push_back(no);
                    }
                }
            }
            sort(vec.begin(),vec.end(),cmp);//为了防止重复连接，将距离排序，选最小的距离连，并且这个点要没有被连过
            for(int i=0;i<vec.size();i++){
                if(board[vec[i].x1][vec[i].y1]==0){
                    
                    line(result,Point(vec[i].x1,vec[i].y1),Point(vec[i].x2,vec[i].y2), 255,1,8, 0);
                    board[vec[i].x1][vec[i].y1]=1;
                }
            }}
        contours.clear();contour.clear();
        findContours(result.clone(),contours,CV_RETR_TREE, // retrieve the external contours
                     CHAIN_APPROX_NONE);
        
        itContours= contours.begin();
        for ( ; itContours!=contours.end(); ++itContours) {
            //每个轮廓包含的点数
            int max=0,max2=0;
            int min=img.cols,min2=img.rows;
            
            
            for(int i=0;i<itContours->size();i++)
            {if((*itContours)[i].x>max)max=(*itContours)[i].x;
                if((*itContours)[i].y>max2)max2=(*itContours)[i].y;
                
                if((*itContours)[i].y<min2)min2=(*itContours)[i].y;
                if((*itContours)[i].x<min)min=(*itContours)[i].x;
                
            }
            int t=5,t2=0;
            if(k==0)t=50;//额头通过长度过滤汗毛
            if(k==1){t=0;t2=50;}
            //if(k==4||k==5){t=80;t2=30;}//眼角过滤噪声
            if(k==2||k==3){t=5;}
            if(k==4||k==5){t=2;t2=5;}
            if(  max-min>t&&max2-min2>t2){
                contour.push_back(*itContours);
            }
            
            
            
            
            result=Mat(img.size(),CV_8U,Scalar(0));
            drawContours(result,contour,      //画出轮廓
                         -1, // draw all contours
                         Scalar(255), // in black
                         1); // with a thickness of 2
            
        }
        int n=0;
        Mat src_color2=src_color.clone();
        
        im=result;
        contour.clear();contours.clear();contour0.clear();
        findContours(result.clone(),contours,CV_RETR_TREE, // retrieve the external contours
                     CHAIN_APPROX_NONE);
        
        int d=0;
        for(int i1=0;i1<contours.size();i1++){
            d=0;
            
            for(int j=0;j<contours[i1].size();j++){
                
                int x=contours[i1][j].x;
                int y=contours[i1][j].y;
                d+=(int)eh.at<uchar>(y,x);
                
                
            }
            // if(i==6&&contours[i1].size()>0)cout<<contours[i1][0].x<<" "<<contours[i1][0].y<<" "<<(double)d/contours[i1].size()<<endl;
            int t1=60,t2=130;;
            if(k==1)t2=80;
            //else if(k==1){t1=100;t2=255;}
            
            if(contours[i1].size()>100&&(double)d/contours[i1].size()<t1)
            {contour0.push_back(contours[i1]);
                
            }
            
            else if(contours[i1].size()>0&&(double)d/contours[i1].size()<t2)
            {contour.push_back(contours[i1]);
                
            }
        }
        
        result=Mat(img.size(),CV_8U,Scalar(0));
        drawContours(result,contour0,      //画出轮廓
                     -1, // draw all contours
                     Scalar(255), // in black
                     4); // with a thickness of 2
        
        drawContours(result,contour,      //画出轮廓
                     -1, // draw all contours
                     Scalar(120), // in black
                     2); // with a thickness of 2
        
        
        im=result;
        
        for(int y=0;y<im.cols;y++){
            
            for(int x=0;x<im.rows;x++){
                
                if((int)im(x,y)==255){
                    int x1=y+x0[k];
                    int y1=y0[k]+x;
                    if(k==2&&((double)(y0[k]-points[97].y)/(x0[k]-points[97].x)*(x1-points[97].x)+points[97].y>y1||(double)(points[54].y-points[97].y)/(x0[k]-points[97].x)*(x1-points[97].x)+points[97].y<y1))
                    {
                        result.at<uchar>(x,y)=0;
                        continue;}
                    if(k==3&&((double)(points[14].y-points[106].y)/(points[55].x-points[106].x)*(x1-points[106].x)+points[106].y>y1||(double)(points[55].y-points[106].y)/(points[55].x-points[106].x)*(x1-points[55].x)+points[55].y<y1))
                    {result.at<uchar>(x,y)=0;    continue;}
                    if(k==0&&(double)(points[2].y-points[77].y)/(points[2].x-points[77].x)*(x1-points[2].x)+points[2].y<y1&&(double)(points[84].y-points[77].y)/(points[84].x-points[77].x)*(x1-points[84].x)+points[2].y<y1)
                    {result.at<uchar>(x,y)=0;    continue;}
                    if(k==1&&((double)(points[2].y-points[75].y)/(points[2].x-points[75].x)*(x1-points[2].x)+points[2].y>y1||(double)(points[2].y-points[82].y)/(points[2].x-points[82].x)*(x1-points[2].x)+points[2].y>y1||(double)(points[16].y-points[75].y)/(points[16].x-points[75].x)*(x1-points[16].x)+points[16].y<y1||(double)(points[16].y-points[82].y)/(points[16].x-points[82].x)*(x1-points[16].x)+points[16].y<y1))
                    {result.at<uchar>(x,y)=0;continue;}
                    if(k==1&&(x1<points[75].x+50||x1>points[82].x-50))
                    {result.at<uchar>(x,y)=0;continue;}
                    if(k==4&&(double)(points[37].y-points[28].y)/(points[37].x-points[28].x)*(x1-points[28].x)+points[28].y<y1)
                    {result.at<uchar>(x,y)=0;continue;}
                    if(k==4&&(double)points[37].y<y1&&(double)(points[108].y-points[30].y)/(points[108].x-points[30].x)*(x1-points[30].x)+points[30].y<y1)
                    {result.at<uchar>(x,y)=0;continue;}
                    if(k==4&&(double)points[37].x<x1&&(double)points[37].y<y1)
                    {result.at<uchar>(x,y)=0;continue;}
                    if(k==4&&(double)points[37].x>x1&&(double)points[37].y>y1)
                    {result.at<uchar>(x,y)=0;continue;}
                    if(k==5&&(double)(points[29].y-points[38].y)/(points[29].x-points[38].x)*(x1-points[38].x)+points[38].y<y1)
                    {result.at<uchar>(x,y)=0;continue;}
                    if(k==5&&(double)points[110].x>x1&&(double)points[110].y<y1)
                    {result.at<uchar>(x,y)=0;continue;}
                    if(k==5&&(double)points[110].x<x1&&(double)points[110].y>y1)
                    {result.at<uchar>(x,y)=0;continue;}
                    if(k==5&&(double)points[110].y<y1&&(double)(points[110].y-points[51].y)/(points[110].x-points[51].x)*(x1-points[51].x)+points[51].y<y1)
                    {result.at<uchar>(x,y)=0;continue;}
                    src_gray.at<uchar>(y0[k]+x,y+x0[k])=255;
                    src_color.at<Vec4b>(y0[k]+x,y+x0[k])[0]=255;
                    src_color.at<Vec4b>(y0[k]+x,y+x0[k])[1]=0;
                    src_color.at<Vec4b>(y0[k]+x,y+x0[k])[2]=0;
                    n++;
                    
                }
                else if((int)im(x,y)==120){
                    int x1=y+x0[k];
                    int y1=y0[k]+x;
                    if(k==2&&((double)(y0[k]-points[97].y)/(x0[k]-points[97].x)*(x1-points[97].x)+points[97].y>y1||(double)(points[54].y-points[97].y)/(x0[k]-points[97].x)*(x1-points[97].x)+points[97].y<y1))
                    {result.at<uchar>(x,y)=0;continue;}
                    if(k==3&&((double)(points[14].y-points[106].y)/(points[55].x-points[106].x)*(x1-points[106].x)+points[106].y>y1||(double)(points[55].y-points[106].y)/(points[55].x-points[106].x)*(x1-points[55].x)+points[55].y<y1))
                    {result.at<uchar>(x,y)=0;continue;}
                    if(k==0&&((double)(points[2].y-points[77].y)/(points[2].x-points[77].x)*(x1-points[2].x)+points[2].y<y1&&(double)(points[84].y-points[77].y)/(points[84].x-points[77].x)*(x1-points[84].x)+points[2].y<y1))
                    {result.at<uchar>(x,y)=0;continue;}
                    if(k==1&&((double)(points[2].y-points[75].y)/(points[2].x-points[75].x)*(x1-points[2].x)+points[2].y>y1||(double)(points[2].y-points[82].y)/(points[2].x-points[82].x)*(x1-points[2].x)+points[2].y>y1||(double)(points[16].y-points[75].y)/(points[16].x-points[75].x)*(x1-points[16].x)+points[16].y<y1||(double)(points[16].y-points[82].y)/(points[16].x-points[82].x)*(x1-points[16].x)+points[16].y<y1))
                    {result.at<uchar>(x,y)=0;continue;}
                    if(k==1&&(x1<points[75].x+50||x1>points[82].x-50))
                    {result.at<uchar>(x,y)=0;continue;}
                    if(k==4&&(double)points[37].x<x1&&(double)points[37].y<y1)
                    {result.at<uchar>(x,y)=0;continue;}
                    if(k==4&&(double)points[37].x>x1&&(double)points[37].y>y1)
                    {result.at<uchar>(x,y)=0;continue;}
                    if(k==4&&(double)(points[108].y-points[50].y)/(points[108].x-points[50].x)*(x1-points[50].x)+points[50].y<y1)
                    {result.at<uchar>(x,y)=0;continue;}
                    if(k==4&&(double)points[37].y<y1&&(double)(points[108].y-points[30].y)/(points[108].x-points[30].x)*(x1-points[30].x)+points[30].y<y1)
                    {result.at<uchar>(x,y)=0;continue;}
                    
                    if(k==5&&(double)(points[29].y-points[38].y)/(points[29].x-points[38].x)*(x1-points[38].x)+points[38].y<y1)
                    {result.at<uchar>(x,y)=0;continue;}
                    if(k==5&&(double)points[110].x>x1&&(double)points[110].y<y1)
                    {result.at<uchar>(x,y)=0;continue;}
                    if(k==5&&(double)points[110].x<x1&&(double)points[110].y>y1)
                    {result.at<uchar>(x,y)=0;continue;}
                    if(k==5&&(double)points[110].y<y1&&(double)(points[110].y-points[51].y)/(points[110].x-points[51].x)*(x1-points[51].x)+points[51].y<y1)
                    {result.at<uchar>(x,y)=0;continue;}
                    src_gray.at<uchar>(y0[k]+x,y+x0[k])=120;
                    src_color.at<Vec4b>(y0[k]+x,y+x0[k])[0]=0;
                    src_color.at<Vec4b>(y0[k]+x,y+x0[k])[1]=255;
                    src_color.at<Vec4b>(y0[k]+x,y+x0[k])[2]=0;
                    
                    
                    
                    n++;
                    
                }
                
            }}
        
        
        im=result;

        for(int i=0;i<4096;i++)
            for(int j=0;j<2048;j++)
                board[i][j]=0;
        
        for(int y=0;y<im.cols;y++)
        {for(int x=0;x<im.rows;x++){
            
            if(!board[y][x]&&(int)im(x,y)!=0){
                
                wrinkle wr;
                wr.l=1;
                int ss;
                if(im(x,y)==255){wr.s=1;
                    ss=255;    }
                else{wr.s=0;
                    ss=120;}
                
                wr.y=x+y0[k];
                wr.x=y+x0[k];
                queue<Point>q;
                q.push(Point(x,y));
                board[y][x]=1;
                while(!q.empty()){
                    Point p=q.front();q.pop();
                    int x1=p.x;
                    int y1=p.y;
                    for(int dx=-1;dx<=1;dx++){
                        for(int dy=-1;dy<=1;dy++){
                            
                            if(x1+dx>=0&&x1+dx<result.rows&&y1+dy>=0&&y1+dy<result.cols&&!board[y1+dy][x1+dx]&&(int)im(x1+dx,y1+dy)!=0){
                                
                                
                                q.push(Point(x1+dx,y1+dy));
                                board[y1+dy][x1+dx]=1;
                                wr.l++;
                            }
                        }
                    }
                    
                }
                w[k].push_back(wr);
                
                
            }
        }
        }
    }
    delete []board;
    dst=src_color;
}
//int main(int argc, char *argv[]){
//
//    for(int i=1;i<=6;i++){
//
//        string filename="C:\\Users\\jin\\Documents\\wpic\\head\\";
//        src_color=imread(filename+char(i+'0')+".jpg",CV_LOAD_IMAGE_UNCHANGED );
//        vector<wrinkle>w[6];
//
//        string str=filename+char(i+'0')+".txt";
//        ifstream f;
//        f.open(str,ios::in);
//        double x,y;
//        int x1,y1;
//
//        points.clear();
//        char c1,c2,c3;
//        while(f>>c1>>x>>c2>>y>>c3){
//            x1=x*4096;
//            y1=y*2048;
//            points.push_back(Point(x1,y1));
//
//            //circle(src_color,Point(x1,y1),5,Scalar(255));
//        }
//        f.close();
//        func(src_color,points,src_color,w);
//
//        namedWindow("DD",CV_WINDOW_NORMAL);
//        imshow("DD",src_color);
//        waitKey();
//    }
//}

