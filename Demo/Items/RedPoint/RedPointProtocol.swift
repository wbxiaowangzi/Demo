//
//  RedPointProtocol.swift
//  Demo
//
//  Created by WangBo on 2019/6/6.
//  Copyright © 2019 wangbo. All rights reserved.
//

import Foundation
import UIKit

public protocol RedPointProtocol {
    /*
     *discuss:
     **一下思路是不对的，页面的展示是从root开始的，我们不可能先看到内部再看到外部，所以红点展示需要从外向内”分发“。这个时候可以根据 viewid检索。比如我们要给  SearchVC.searchBtn添加一个红点，而SearchVC是从HomaPageVC跳转过去的，那我们 在 HomePageVC的时候就需要看到 红点，假如就是 HomePageVC.searchView,SearchVC.searchBtn都要有红点，我们怎么展示呢？如果用一个 path展示呢？比如 “HomePageVC.searchView->SearchVC.searchBtn”，(这里有些问题，1，我该怎么拆开这个 str,如果vc之间用特殊字符连接比如："->"呢。2，这个path怎么组织呢？是服务器请求，还是本地创建，还是二者都有)，
     1，红点可以从最子层view开始显示，然后去查找 子层view的 superView去显示redpoint，一直找到某个rootview 比如 homevc.view或者superview为nil的 superview，讲道理这个也应该是一个自动的过程，自己需要显示红点了，就通知自己的父视图，父视图redPointViewCount+1，父视图再去检索自己的父视图，
     以此类推。
     2,清理红点：应该是一个自动的过程，自己清理自己的红点，通知一下父视图，父视图 redPointViewCount-1，父视图redPointViewCount为0时自动清理掉自己的红点并通知自己的父视图
     3，展示和清理红点这个检索或者通知父视图的逻辑是一致的，可以统一写出来。
     */
    
    
    /*
     思路2：
     1，红点路径由一个单例保存（路径更新和修改（网络或本地））
     2，遵守RedPointProtocol的视图出现的时候，单例检查其viewid是否包含在路径之内(这里应该是同一类，不同view，id不同)，包含的话调用 view的 showRedPoint方法
     3，当视图调用了clearRedPoint方法时，去 单例中删除对应的路径，
     4，单例检查自己所管理的路径，父路径没有子路径时清理掉自己，并向自己的父视图检查
     */
    /// view id for path
    var viewID:String{ get }
    
    /// 作为父视图时自己所拥有子redpointview的数量：用于清理红点判断，该值变化时（变为0或不为0）可用于自己显示、隐藏红点，通知父视图自己的变化
    var redPointViewCount:Int { get }
    
    /// super view behave RedPointProtocol
    var superView:RedPointProtocol? { get }
    
    /// 显示红点
    func showRedPoint()
    
    /// 隐藏红点
    func clearRedPoint()
    
}


struct RedPointPath {
    var viewID:String
    //var superPath:RedPointPath?
    var subPaths:[RedPointPath]?
    /*
     自己需要展示或者 subpaths 不为nil，则需要展示
     */
}

extension UIView{
    func addASimpleRedPoint(){
        
    }
}
