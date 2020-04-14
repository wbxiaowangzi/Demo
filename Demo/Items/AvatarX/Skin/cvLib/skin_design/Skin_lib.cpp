// cv.cpp : 定义控制台应用程序的入口点。
//yuechi

#include <opencv2/opencv.hpp>  
#include<string>
#include "SkinDesignAnalyze.h"
#include<fstream>
using namespace cv;  
using namespace std;  


//string s1="C:\\Users\\jin\\pictures\\eyebrow\\";
//string s2=".jpg";
//ppt表示嘴巴的12个特征点
//img原彩色图
//m唇彩的颜色
Mat SkinDesignAnalyze::ChangeMouthcolor(Point ppt[],Mat img,Scalar m){
	const Point* pts[] = {ppt};//ppt类型为Point*，pts类型为Point**，需定义成const类型
	int npt[] ={9};  //npt的类型即为int*
	//填充多边形
	int x0=4096,y0=2048,x1=0,y1=0;
	for(int i=0;i<9;i++){
		Point p=ppt[i];
		if(x0>p.x)x0=p.x;
		if(y0>p.y)y0=p.y;
		if(y1<p.y)y1=p.y;
		if(x1<p.x)x1=p.x;
	}

	
	
	Mat mask(img.size(),CV_8U,Scalar(0));
	fillPoly(mask, pts, npt,1,Scalar(255)); //嘴唇蒙版	

	Mat image_roi(Size(x1-x0,y1-y0),CV_8UC3,m);
	Rect rect2(x0,y0,x1-x0,y1-y0);	
	mask=mask(rect2);	
	Point center((int)(x0+x1)/2,(int)(y0+y1)/2);

	Mat output=img;		
	cvtColor(output, output, CV_BGR2BGRA);

	int p2=y0,p1=x0;
	for(int i=0;i<mask.rows;i++)
		for(int j=0;j<mask.cols;j++){
			if((int)mask.at<uchar>(i,j)==255){//唇彩颜色和嘴唇透明度叠加
			double alpha=0.3;
			output.at<Vec4b>(p2+i,p1+j)[0]=int(m[0]*alpha+output.at<Vec4b>(p2+i,p1+j)[0]*(1-alpha));
			output.at<Vec4b>(p2+i,p1+j)[1]=int(m[1]*alpha+output.at<Vec4b>(p2+i,p1+j)[1]*(1-alpha));
			output.at<Vec4b>(p2+i,p1+j)[2]=int(m[2]*alpha+output.at<Vec4b>(p2+i,p1+j)[2]*(1-alpha));
		
	}
}
		Mat mask2(img.size(),CV_8U,Scalar(0));

		polylines(mask2,pts,npt,1,1,Scalar(255),10);
	    Mat output1;
		medianBlur(output, output1,5);
	
	    for(int x=x0;x<x1;x++)
		for(int y=y0;y<y1;y++)
		{  if((int)mask2.at<uchar>(y,x)==255){//对嘴唇的边缘进行模糊处理
		
			output.at<Vec4b>(y,x)=output1.at<Vec4b>(y,x);
		}	
		}
	return output;
}







//int main()
//{
//
//    Mat  img = imread(s1+"left.jpg",1);//读取原彩色图
//
//    //读取嘴唇特征点.
//    ifstream fin(s1+"mouth2.txt",ios::in);
//    Point ppt[12];
//    float a, b;char c;
//    for(int i=0;i<12;i++){
//        fin>>c>>a>>c>>b>>c>>c;
//        ppt[i]=Point((int)a,(int)b);
//
//
//    }
//
//        Scalar m=Scalar(177,156,242);//选定唇彩颜色
//        Mat output=ChangeMouthcolor(ppt,img,m);
//
//        imwrite(s1+"mouth2.png",output);
//        waitKey();
//
//
//}



//RemoveEyebrow擦除眉毛的函数
//ppt 眉毛的9个特征点
//img整张图
//f=0左眉;f=1右眉，以我的角度
//image_roi skin.jpg那张图
//x0,y0,x1,y1分别表示眉毛的外接矩形的最左边，最右边，最上，最下
Mat SkinDesignAnalyze::RemoveEyebrow(Point ppt[],Mat image,int f,Mat image_roi,int &x0,int &y0,int &x1,int &y1){
    
    Mat  img = image;// imread(path,1);//读取原彩色图
    cvtColor(img,img,CV_RGBA2RGB);
    
    printf("%d",image_roi.channels());
    const Point* pts[] = {ppt};//ppt类型为Point*，pts类型为Point**，需定义成const类型
    int npt[] ={9};  //npt的类型即为int*
    //填充多边形

    for(int i=0;i<9;i++){
        Point p=ppt[i];
        if(x0>p.x)x0=p.x;
        if(y0>p.y)y0=p.y;
        if(y1<p.y)y1=p.y;
        if(x1<p.x)x1=p.x;
    }

    
    Mat mask(img.size(),CV_8U,Scalar(0));
    fillPoly(mask, pts, npt,1,Scalar(255));
    Vec3b up,down;int flag=1,u,d;
    for(int x=x0+1;x<x1;x++){
        
        for(int y=y0;y<=y1;y++)
        {  if((int)mask.at<uchar>(y,x)==255){
            if(flag){
                
                up=img.at<Vec3b>(y,x);
                flag=0;
                u=y;
                
            }}
            else if(!flag){
                down=img.at<Vec3b>(y-1,x);
                flag=1;
                d=y-1;
                
                
                
                
            }    }
        for(int y=0;y<=1*(d-u)/5;y++){
            
            img.at<Vec3b>(d-y,x)=img.at<Vec3b>(d+y,x);
            
            
            
        }
        for(int y=0;y<=1*(d-u)/5;y++){
            img.at<Vec3b>(u+y,x)=img.at<Vec3b>(u-y,x);
        }
        int u1=u+(d-u)/5;
        for(int y=0;y<=1*(d-u)/5;y++){
            img.at<Vec3b>(u1+y,x)=img.at<Vec3b>(u1-y,x);
        }
        
        
        
        int s=(d-u)/5;
        int l=(d-u)/5+(d-u)/5;
        int m=(d-u)/5+(d-u)/5+3;
        for(int y=0;y<=(d-u)/5+(d-u)/5+3;y++){
            
            img.at<Vec3b>(y+u+l,x)[0]=(1.0-1.0*y/m)*img.at<Vec3b>(u+l-y,x)[0]+1.0*y/m*img.at<Vec3b>(d-s+m-y,x)[0];
            img.at<Vec3b>(y+u+l,x)[1]=(1.0-1.0*y/m)*img.at<Vec3b>(u+l-y,x)[1]+1.0*y/m*img.at<Vec3b>(d-s+m-y,x)[1];
            img.at<Vec3b>(y+u+l,x)[2]=(1.0-1.0*y/m)*img.at<Vec3b>(u+l-y,x)[2]+1.0*y/m*img.at<Vec3b>(d-s+m-y,x)[2];
            
        }
        
        
    }
    
    Rect rt(0,0,x1-x0,y1-y0);
    
    image_roi=image_roi(rt);
    Rect rect2(x0,y0,x1-x0,y1-y0);
    if(f==1){
        for(int x=x0;x<(x1+x0)/2;x++){
            for(int y=y0;y<y1;y++){
                if((int)mask.at<uchar>(y,x)==0){
                    mask.at<uchar>(y,x)=255;
                }
                else break;
            }
        }}
    else{
        for(int x=x1;x>=(x1+x0)/2;x--){
            for(int y=y0;y<y1;y++){
                if((int)mask.at<uchar>(y,x)==0){
                    mask.at<uchar>(y,x)=255;
                }
                else break;
            }
        }
        
        
        
    }
    mask=mask(rect2);
    
    
    Point center((int)(x0+x1)/2,(int)(y0+y1)/2);
    
    // Seamlessly clone src into dst and put the results in output
    Mat output;
    seamlessClone(image_roi, img, mask, center, output, NORMAL_CLONE);
    
    Mat mask2(img.size(),CV_8U,Scalar(0));
    Mat output1;
    medianBlur(output, output1,5);
    
    for(int x=x0;x<x1;x++)
    for(int y=y0;y<y1;y++)
    {  if((int)mask.at<uchar>(y-y0,x-x0)==255){
        
        output.at<Vec3b>(y,x)=output1.at<Vec3b>(y,x);
    }
        
    }
    
//    Mat output2(img.rows,img.cols, CV_8UC4,Scalar(255,255,255,255));
//
//    uchar *pCurPtr = (uchar*)output.data;
//    uchar *pOut = (uchar*)output2.data;
//    for (int i=0; i<2048; i++) {
//        for (int j=0; j<4096; j++) {
//
//            pOut++;
//            for (int x=0; x<3; x++,pCurPtr++,pOut++) {
//                pOut[0] = pCurPtr[0];
//            }
//
//        }
//    }
    
    return output;
    
    
    
    
}


//ChangeEyebrow 贴上假眉毛函数
//output 擦除了眉毛的整张图
//f=0左眉;f=1右眉，以我的角度
//eyebrow 假眉毛矩阵
//p1,p2 假眉毛外接矩形的左上角贴在原图的（p1,p2）位置。
//s表示眉毛外接矩形的长度，控制眉毛的大小
//angle控制眉毛的角度，用15度之类的表示
Mat SkinDesignAnalyze::ChangeEyebrow(Mat output,int f,Mat eyebrow,int p1,int p2,int s,double angle){
    
    if(f) flip(  eyebrow,eyebrow,1);
    resize(eyebrow, eyebrow, Size(s,int(1.0*eyebrow.rows/eyebrow.cols*(s))));
    cvtColor(output, output, CV_BGR2BGRA);
    Mat dst;
    int top,bottom,left,right;
    top=bottom=eyebrow.cols/2;
    left=right=eyebrow.rows/2;
    copyMakeBorder(eyebrow, eyebrow, eyebrow.cols/2, eyebrow.cols/2, eyebrow.rows/2, eyebrow.rows/2, 0);
    
    Size src_sz = eyebrow.size();
    Size dst_sz(eyebrow.cols,eyebrow.rows);
    int len = std::max(eyebrow.cols, eyebrow.rows);
    
    //指定旋转中心
    cv::Point2f center(eyebrow.cols/2,eyebrow.rows/2);
    
    
    //获取旋转矩阵（2x3矩阵）
    cv::Mat rot_mat = cv::getRotationMatrix2D(center, angle, 1.0);
    
    //根据旋转矩阵进行仿射变换
    cv::warpAffine(eyebrow,eyebrow, rot_mat, dst_sz);
    
    for(int i= 0;i<eyebrow.rows;i++)
    for(int j=0;j<eyebrow.cols;j++){
        if(eyebrow.at<Vec4b>(i,j)[3]!=0){
            double alpha=1.0*eyebrow.at<Vec4b>(i,j)[3]/255;
            int x=p1+j-left;
            int y=p2+i-top;
            output.at<Vec4b>(y,x)[0]=int(eyebrow.at<Vec4b>(i,j)[0]*alpha+output.at<Vec4b>(y,x)[0]*(1-alpha));
            output.at<Vec4b>(y,x)[1]=int(eyebrow.at<Vec4b>(i,j)[1]*alpha+output.at<Vec4b>(y,x)[1]*(1-alpha));
            output.at<Vec4b>(y,x)[2]=int(eyebrow.at<Vec4b>(i,j)[2]*alpha+output.at<Vec4b>(y,x)[2]*(1-alpha));
            
        }
    }
    
    return output;
    
    
    
    
}



//int main()
//{
//
//    Mat  img = imread(s1+"left.jpg",1);//读取原彩色图
//
//    //读取眉毛特征点.
//    ifstream fin(s1+"test3.txt",ios::in);
//    Point ppt[9];
//    float a, b;char c;
//    for(int i=0;i<9;i++){
//        fin>>c>>a>>c>>b>>c>>c;
//        ppt[i]=Point((int)a,(int)b);
//
//
//    }
//        for(int i=0;i<11;i++){
//            cout<<i<<endl;
//        int a=(i>=9?'A'-9:'1');
//        Mat eyebrow=imread(s1+"data\\ZHF\\"+char(i+a)+"\\"+char(i+a)+".png",-1);
//        Mat  image_roi=imread(s1+"skin2.jpg");
//        int x0=4096,y0=2048,x1=0,y1=0;
//        Mat remove=RemoveEyebrow(ppt,img,1,image_roi,x0,y0,x1,y1);
//        imwrite(s1+"myfdfdr"+char(i+'1')+".png",remove);
//        waitKey();
//        int p1=x0,p2=y0,s=x1-x0;
//        Mat output;
//        output=ChangeEyebrow(remove,1,eyebrow,p1,p2,s,0);
//        imwrite(s1+"myr"+char(i+'1')+".png",output);
//        output=ChangeEyebrow(remove,0,eyebrow,p1,p2,s,15);
//        imwrite(s1+"myrr"+char(i+'1')+".png",output);
//        }
//        waitKey();
//
//}




//读取所有点的uv坐标
vector<Point> SkinDesignAnalyze::setPoint(string uvsPath)
{
    ifstream infile;
    infile.open(uvsPath);
    
    string s;
    getline(infile, s);
    
    vector<Point> poi;
    string coordinate;
    float x = 0;
    float y = 0;
    for (int i = 0; i < s.size(); i++)
    {
        if (s[i] == '(')
        {
            coordinate.clear();
            continue;
        }
        if (s[i] == ',')
        {
            x = atof(coordinate.c_str());
            continue;
        }
        if (s[i] == ' ')
        {
            coordinate.clear();
            continue;
        }
        if (s[i] == ')')
        {
            y = atof(coordinate.c_str());
            
            Point point = Point((int)(x * 4096), (int)(y * 2048));
            poi.push_back(point);
            continue;
        }
        coordinate.push_back(s[i]);
    }
    
    return poi;
    
    
}

int SkinDesignAnalyze::cal(int x) {//曲线蒙版的曲线函数
    
    if (x < 127) return (int)(1.0 * 159 / 127 * x);
    else return (int)(1.0 * 96 / 128 * (x - 127) + 159);
    
}
Mat SkinDesignAnalyze::ChangeFacecolor(Mat img) {
    cvtColor(img,img,CV_RGBA2RGB);
    Mat img_ori = img.clone();//先复制原彩色图
    Mat c[3];//通道数组
    split(img, c);
    Mat img_gaussian;
    blur(c[0], img_gaussian, Size(8, 8));
    c[0] = c[0] - img_gaussian + 127;//对蓝色通道高反差保留
    Mat img_b = c[0];
    for (int i = 0; i < 3; i++)//对高反差保留后的蓝色通道做三次强光
    {
        for (int y = 0; y < img.rows; y++) {
            
            for (int x = 0; x < img.cols; x++) {
                
                int r = (int)img_b.at<uchar>(y, x);
                if (r > 127.5) {
                    r = r + (255 - r)*(r - 127.5) / 127.5;
                    
                }
                else {
                    r = r * r / 127.5;
                    
                }
                r = r > 255 ? 255 : r;
                r = r < 0 ? 0 : r;
                img_b.at<uchar>(y, x) = (int)r;
            }
        }
    }
    
    
    for (int y = 0; y < img.rows; y++) {
        
        for (int x = 0; x < img.cols; x++) {
            
            int r = (int)img_b.at<uchar>(y, x);
            int t = (int)c[0].at<uchar>(y, x);
            if (t < 220) {
                img.at<Vec3b>(y, x)[0] = cal(img.at<Vec3b>(y, x)[0]);//把暗色部分用曲线函数调亮
                img.at<Vec3b>(y, x)[1] = cal(img.at<Vec3b>(y, x)[1]);
                img.at<Vec3b>(y, x)[2] = cal(img.at<Vec3b>(y, x)[2]);
            }
        }
    }
    
    Mat out;
    bilateralFilter(img_ori, out, 40, 25 * 2, 25 / 2);//对原图进行双边滤波
    split(img, c);
    blur(c[2], img_gaussian, Size(1, 1));
    c[2] = c[2] - img_gaussian + 127;//对红色通道进行高反差保留
    Mat img_r = c[2];
    for (int y = 0; y < img.rows; y++) {
        
        for (int x = 0; x < img.cols; x++) {
            
            
            int r = int(img_r.at<uchar>(y, x));
            
            img.at<Vec3b>(y, x)[0] = img.at<Vec3b>(y, x)[0] + 2 * r - 255;//线性光混合
            img.at<Vec3b>(y, x)[1] = img.at<Vec3b>(y, x)[1] + 2 * r - 255;
            img.at<Vec3b>(y, x)[2] = img.at<Vec3b>(y, x)[2] + 2 * r - 255;
            
            
            
        }
    }
    
    img = out * 0.65 + img * 0.35;//双边滤波图透明度为0.65
    
    
    return img;
    
    
    
    
}


//int main()
//{
//
//    Mat  img = imread(s1 + "3jpg", 1);//读取原彩色图
//
//    img = ChangeFacecolor(img);//美白磨皮函数
//
//    imwrite(s1 + "3磨皮后.png", img);
//    waitKey();
//
//
//}



//读取所有点的uv坐标
vector<Point> setPoint(string uvsPath)
{
    ifstream infile;
    infile.open(uvsPath);
    
    string s;
    getline(infile, s);
    
    vector<Point> poi;
    string coordinate;
    float x = 0;
    float y = 0;
    for (int i = 0; i < s.size(); i++)
    {
        if (s[i] == '(')
        {
            coordinate.clear();
            continue;
        }
        if (s[i] == ',')
        {
            x = atof(coordinate.c_str());
            continue;
        }
        if (s[i] == ' ')
        {
            coordinate.clear();
            continue;
        }
        if (s[i] == ')')
        {
            y = atof(coordinate.c_str());
            
            Point point = Point((int)(x * 4096), (int)(y * 2048));
            poi.push_back(point);
            continue;
        }
        coordinate.push_back(s[i]);
    }
    
    return poi;
    
    
}
string SkinDesignAnalyze::DetectSkinColor(Mat img, vector<Point> poi,Scalar s[][11]) {
    int faceContour[20] = { 73,113,112,111,54,52,13,11,9,3,0,4,10,12,14,53,55,114,115,116 };//检测皮肤的区域
    Point contour[20];
    for (int p_index = 0; p_index < 20; p_index++)
    {
        contour[p_index] = poi[faceContour[p_index]];
    }
    
    const Point* pts[] = { contour };//ppt类型为Point*，pts类型为Point**，需定义成const类型
    int npt[] = { 20 };  //npt的类型即为int*
    //填充多边形
    Mat mask(img.size(), CV_8U, Scalar(0));
    fillPoly(mask, pts, npt, 1, Scalar(255));
    Mat img_gray;
    cvtColor(img, img_gray, CV_BGR2GRAY);
    int blockSize = 49;
    int constValue = 10;
    Mat result;
    adaptiveThreshold(img_gray, result, 120, CV_ADAPTIVE_THRESH_MEAN_C, CV_THRESH_BINARY_INV, blockSize, constValue);
    //肤色计算平均值时要去掉五官
    mask.setTo(0, result == 120);
    
    int left = contour[0].x;
    int top = contour[0].y;
    int right = contour[0].x;
    int down = contour[0].y;
    
    for (int i = 1; i < 5; i++)
    {
        int now_x = contour[i].x;
        int now_y = contour[i].y;
        
        left = left > now_x ? now_x : left;
        top = top > now_y ? now_y : top;
        right = right < now_x ? now_x : right;
        down = down < now_y ? now_y : down;
        
    }
    Scalar color = (0, 0, 0);
    int n = 0;
    for (int y = top; y <= down; y++)
    for (int x = left; x <= right; x++) {
        if ((int)mask.at<uchar>(y, x) == 255) {
            color[0] = color[0] + img.at<Vec3b>(y, x)[0];
            color[1] = color[1] + img.at<Vec3b>(y, x)[1];
            color[2] = color[2] + img.at<Vec3b>(y, x)[2];
            n++;
        }
    }
    
    
    for (int i = 0; i < 3; i++)
    color[i] = (int)(1.0*color[i] / n);//计算肤色RGB的平均值
    Scalar sk = s[0][0];
    int xc = 0, yc = 0;
    int l = 255 * 255 * 3;
    for (int y = 0; y < 6; y++)
    for (int x = 0; x < 11; x++) {
        int dis = 0;
        for (int j = 0; j < 3; j++) {
            dis += (s[y][x][j] - color[j])*(s[y][x][j] - color[j]);//判断RGB离哪个肤色最近
        }
        if (dis < l) {
            l = dis;
            sk = s[y][x];
            xc = x;
            yc = y;
        }
    }
    string str = "";//str表示横向编号
    if (xc + 1 < 9)str = char(xc + 1) + '0';
    else str = "1"+char((xc+1-10)+'0');
    return  char(yc + 'A') + str ;//返回肤色编号
    
}










//
//int main()
//{
//
//    Mat  img = imread("C:/Users/jin/Pictures/skincolor.png", 1);//读取肤色卡
//    Scalar s[6][11];//肤色数组
//    for(int y=0;y<6;y++)
//    for (int x = 0; x < 11; x++) {
//        s[y][x]=img.at<Vec3b>(35+50*y, 90+40*x);
//    }
//    for (int i = 0; i < 6; i++) {
//        img = imread(s1 + char(i + '1') + ".jpg", 1);//读取原彩色图
//        vector<Point> poi = setPoint(s1 + char('1' + i) + ".txt");//读取坐标点
//        cout << DetectSkinColor(img, poi, s) << endl;//检测肤色
//    }
//    waitKey();
//
//
//}
