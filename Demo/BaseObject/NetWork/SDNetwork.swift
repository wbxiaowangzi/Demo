//
//  SDNetwork.swift
//  Demo
//
//  Created by WangBo on 2019/3/13.
//  Copyright © 2019 wangbo. All rights reserved.
//

import UIKit
import Moya

class SDNetwork {

    var provider: MoyaProvider<SDService>!
    
}

enum SDService {
    case getLuckNumber(count: Int)
    case defaultAPI
}

extension SDService: TargetType {
    var baseURL: URL {
        return URL.init(string: "www.baidu.com")!
    }
    
    var path: String {
        return "/login"
    }
    
    var method: Moya.Method {
        switch self {
        case .getLuckNumber(_):
            return .get
        default:
            return .post
        }
    }
    
    /**样本数据*/
    var sampleData: Data {
        return "this is a sampleData".data(using: .utf8)!
    }
    
    var task: Task {
        switch self {
        case .getLuckNumber(let count):
            return .requestParameters(parameters: ["pagesize": count], encoding: URLEncoding.default)
        default:
            return .requestParameters(parameters: ["paramater": 1], encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return ["Content-type": "application/json"]
    }
    
}

/**String 拓展，方便使用*/
private extension String {
    var urlEscaped: String {
        return addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
    
    var urf8Encoded: Data {
        return data(using: .utf8)!
    }
    
}
