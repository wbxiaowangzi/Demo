//
//  UserDefaultStaticStrings.swift
//  Mirage3D
//
//  Created by WangBo on 2019/4/23.
//  Copyright © 2019 影子. All rights reserved.
//

import UIKit

public class UserDefaultStaticStrings: NSObject {
    
    /// 本地存储的国家区号
    public static let localSaveCountryCode = "local_Save_Country_Code"
    
    /// AppleLanguages
    public static let AppleLanguages = "AppleLanguages"
    
    /// version
    public static let version = "version"
    
    /*--------用户登录信息-------*/
    /// channel_id
    public static let channel_id = "channel_id"
    
    /// sale_id
    public static let sale_id = "sale_id"

    /// token
    public static let token = "token"
    
    /// scan_id
    public static let scan_id = "scan_id"
    
    /// permission_scan
    public static let permission_scan = "permission_scan"
    
    /// permission_qrscan
    public static let permission_qrscan = "permission_qrscan"
    
    /// permission_drequest
    public static let permission_drequest = "permission_drequest"
    
    /// token
    public static let permission_gsearch = "permission_gsearch"
    
    /// loginUserName
    public static let loginUserName = "mirage3d_user_login_name"
    
    /// loginPW
    public static let loginPW = "mirage3d_user_login_password"
    
    /*--------用户登录信息-------*/
    
    
    /// 检测皮肤功能是否被点击过
    public static let SkinFunction = "SkinFunction"
    
    
    /// 显示综合分数
    public static let NeedShowCombinedScore = "getNeedShowCombinedScore"
    
    /// 报告类型
    public static let ReportTypeKey = "ReportTypeKey"
    
    /// 专业版
    public static let professional = "ReportTypeKey.professional"
    
    /// 拓客版
    public static let expand = "ReportTypeKey.expand"
    
    /// 是否点击过我的收藏按钮
    public static let isMyFaboriteClicked = "HomePage.isMyFaboriteClicked"

}

extension UserDefaultStaticStrings{
    
    public static func boolForKey(with key:String)->Bool{
        if UserDefaults.standard.object(forKey: key) == nil{
            return false
        }
        return UserDefaults.standard.bool(forKey: key)
    }
    
    public static func setBool(value:Bool, key:String){
        UserDefaults.standard.set(value, forKey: key)
    }
}
