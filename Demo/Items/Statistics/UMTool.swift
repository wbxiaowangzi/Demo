//
//  UMTool.swift
//  sdrage3D
//
//  Created by YingZi on 2018/10/23.
//  Copyright © 2018年 影子. All rights reserved.
//

import UIKit

class UMTool: NSObject {

    /** 自定义事件, 数量统计.
     使用前，请先到友盟App管理后台的设置 -> 编辑自定义事件 中添加相应的事件ID，然后在工程中传入相应的事件ID
     
     @param  eventId 网站上注册的事件Id.
     @param  label 分类标签。不同的标签会分别进行统计，方便同一事件的不同标签的对比, 为nil或空字符串时后台会生成和eventId同名的标签.
     @param  accumulation 累加值。为减少网络交互，可以自行对某一事件ID的某一分类标签进行累加，再传入次数作为参数。
     @return void.
     */
    static func sdEvent(_ eventId: String?)  {
        guard eventId != nil else {
            return
        }
        MobClick.event(eventId)
    }
    
    /** 自定义事件, 数量统计.
     使用前，请先到友盟App管理后台的设置 -> 编辑自定义事件 中添加相应的事件ID，然后在工程中传入相应的事件ID
     */
    static func sdEvent(_ eventId: String?, label: String?)  {
        guard eventId != nil, label != nil else {
            return
        }
        MobClick.event(eventId, label: label)
    }
    
    /** 自动页面时长统计, 开始记录某个页面展示时长.
     使用方法：必须配对调用beginLogPageView: 和endLogPageView: 两个函数来完成自动统计，若只调用某一个函数不会生成有效数据。
     在该页面展示时调用beginLogPageView: ，当退出该页面时调用endLogPageView:
     @param pageName 统计的页面名称.
     @return void.
     */
    static func sdBeginLogPageView(_ pageName: String?)  {
        guard pageName != nil else {
            return
        }
        MobClick.beginLogPageView(pageName)
    }
    
    /** 自动页面时长统计, 结束记录某个页面展示时长.
     使用方法：必须配对调用beginLogPageView: 和endLogPageView: 两个函数来完成自动统计，若只调用某一个函数不会生成有效数据。
     在该页面展示时调用beginLogPageView: ，当退出该页面时调用endLogPageView:
     @param pageName 统计的页面名称.
     @return void.
     */
    static func sdEndLogPageView(_ pageName: String?)  {
        guard pageName != nil else {
            return
        }
        MobClick.endLogPageView(pageName)
    }
    
    /** 自定义事件, 时长统计.
     使用前，请先到友盟App管理后台的设置 -> 编辑自定义事件 中添加相应的事件ID，然后在工程中传入相应的事件ID.
     */
    static func sdEndEvent(_ eventId: String?)  {
        guard eventId != nil else {
            return
        }
        MobClick.endEvent(eventId)
    }
    
    /** 自定义事件, 时长统计.
     使用前，请先到友盟App管理后台的设置 -> 编辑自定义事件 中添加相应的事件ID，然后在工程中传入相应的事件ID.
     */
    static func sdEndEvent(_ eventId: String?, label: String?)  {
        guard eventId != nil, label != nil else {
            return
        }
        MobClick.endEvent(eventId, label: label)
    }
}

class UMEventId: NSObject {
    
    static let login      = "login"

    static let event_one  = "event_one"

    static let event_two  = "event_two"
}

class UMPageName: NSObject {

    static let home         = "homevc"

    static let loginvc      = "loginvc"

    static let searchVC     = "searchvc"
}
