//
//  Navigator.swift
//  Demo
//
//  Created by WangBo on 2019/8/29.
//  Copyright © 2019 wangbo. All rights reserved.
//

import UIKit

class Navigator: NSObject {

}

public protocol Navigatable {
    static func opened(_ url: SDUrl) -> Any?
}

public class SDUrl {

    public var host: String!

    public var scheme: String?
    
    ///用于页面跳转时传参数
    private var innerDic = [String: Any?]()
    
    public init(with urlString: String) {
        let components = URLComponents(string: urlString)
        self.host = components?.host
        self.scheme = components?.scheme
        
    }
}
