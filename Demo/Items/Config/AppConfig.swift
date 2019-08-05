//
//  AppConfig.swift
//  Mirage3D
//
//  Created by 影子.zsr on 2018/2/7.
//  Copyright © 2018年 影子. All rights reserved.
//

import Foundation

class AppConfig{
    
    static func initialize(){
        let infoDictionary = Bundle.main.infoDictionary!
        //设置应用程序信息
        
    }
    
    static func initPath() -> Void {
        //初始化文件夹路径
        pathCreator(path: FaceDataPath)
        pathCreator(path: PythonSourcePath)
        pathCreator(path: FaceDesignDataPath)
        pathCreator(path: PythonConfigPath)
    }
    
    private static func pathCreator(path:String){
        if FileManager.default.fileExists(atPath: path) == false{
            try! FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: false, attributes: nil)
        }
    }
    
    static var appDisplayName:String = ""  //程序名称
    static var appVersion:String = ""      //主程序版本号
    static var bundleVersion:String = ""   //版本号（内部标示）
    static var iosVersion:String = ""      //iOS版本
    static var identifierNumber:UUID!      //设备udid
    static var systemName:String = ""      //设备名称
    static var model:String = ""           //设备型号
    static var localizedModel:String = ""  //设备区域化型号如A1533
    

    
  
    
    //运维接口版本号
    static let yunweiVersion:String = "1"
    
    static let url_develop:String = "https://core-service.myreal3d.com/api/"        //外网开发环境
    static let url_test:String = "http://test-service.myreal3d.com/api/"            //测试环境
    static let url_production:String = "https://core-service-pro.myreal3d.com/api/"  //生产环境
    static let url_inside:String = "http://192.168.254.48:82/api/"                  //内网
    static let guide_url = "http://manual.myreal3d.com/" //知识库
    static let xiaofu_url = "https://api.xiaofutech.com/external/" //小肤
    static var url:String{
        get{
            switch AppConfig.APPEnviroment{
            case .local:
                return url_inside
            case .development:
                return url_develop
            case .production:
                return url_production
            case .test:
                return url_test
            }
        }
    }

    private static var _enviroment:EnvironmentType = .production
    static var APPEnviroment:EnvironmentType{
        get{
            return _enviroment
        }
    }
    
    static func setEnviroment(_ type:Int){
        //当前版本状态
        switch type{
        case -1://内网
            AppConfig._enviroment = .local
        case 0://开发
            AppConfig._enviroment = .development
        case 1://测试
            AppConfig._enviroment = .test
        case 2://生产
            AppConfig._enviroment = .production
        default:break
        }
    }
    
    static var getEnviromentString:String{

        switch AppConfig.APPEnviroment {
        case .local:
            return "内网版"
        case .development:
            return "开发"
        case .test:
            return ""
        case .production:
            return ""
        }
    }
    
    /********************** Path Config **********************/
    
    
    static var DocumentsPath:String{
        get{
            
            return NSHomeDirectory() + "/Documents"
        }
    }
    
    static var PythonSourcePath:String{
        get{
            return DocumentsPath + "/python"
        }
    }
    
    static var PythonFeaturePath: String{
        return AppConfig.PythonSourcePath + "/configPoint.txt"
    }
    
    static var PythonConfigPath: String{
        return DocumentsPath + "/python/py"
    }
    
    static var LMTConfigPath: String{
        return PythonConfigPath + "/相貌特征_立明堂3.csv"
    }
    
    static var LMTSymptomPartPath: String{
        return PythonConfigPath + "/相貌特征缺陷对应的部位.csv"
    }
    
    static var LMTSymptomAdvicePath: String{
        return PythonConfigPath + "/相貌特征缺陷对应的建议.csv"
    }
    
    static var LMTZongShuPartPath: String{
        return PythonConfigPath + "/全量综述.json"
    }
    
    static var LMTSymptomDescPath: String{
        return PythonConfigPath + "/相貌特征对应的描述.csv"
    }
    
    static var PythonBoundaryPath: String{
        return PythonConfigPath + "/deformBoundary.json"
    }
    
    static var CountryCodePath: String{
        return FaceDataPath + "/country_code.json"
    }
    
    static var PythonWhiteListPath: String{
        return PythonConfigPath + "/Config/ReportConfig.yaml"
    }
    
    static var FaceDataPath: String{
        get{
            return DocumentsPath + "/Data"
        }
    }
    
    static var FaceDesignDataPath: String{
        return DocumentsPath + "/DesignData"
    }
    
    /********************** Path Config **********************/
    
    enum EnvironmentType {
        case local
        case development
        case test
        case production
    }
    
}



