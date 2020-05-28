//
//  ApiService.swift
//  Mirage3D
//
//  Created by 影子.zsr on 2017/12/18.
//  Copyright © 2017年 影子. All rights reserved.
//

import Foundation
import Moya
import RxSwift

var formDataArr = [MultipartFormData]()

enum ApiService {
    // MARK: - 示例接口
    case demoApi(arg1: String, arg2: String)
    //
    case dataRequestApi
    //
    case uploadCompositeMultipart
}

extension ApiService : TargetType {
    
    var headers: [String : String]? {

        let arr = NSLocale.preferredLanguages
        if arr.first == "zh-Hans-CN" {
            return ["zh": "Accept-Language"]
        }
        return ["en": "Accept-Language"]
    }
    
    var baseURL: URL {
        switch self {
        case .demoApi(let url, _):
            return URL(string: url)!
        default:
            return URL(string: "www.demobaseurl.api/")!
        }
    }
    
    var xiaofuBaseURL: URL {
        return URL(string: "https: //api.xiaofutech.com/external/")!
    }
    
    var path: String {
        switch self {
        case .demoApi(_):
            return "demoapi"
        case .dataRequestApi:
            return "dataRequestApi"
        case .uploadCompositeMultipart:
            return "uploadCompositeMultipart"
        }
    }
    
    var method: Moya.Method {
        return .post
    }
    
    var parameters: [String : Any]? {

        var params: [String: Any] = [:]

        var data: [String: Any] = [:]
        params["version"] = HttpCom.httpVersion
        switch self {
        case .demoApi(let arg1, let arg2):
            data = ["arg1": arg1, "arg2" : arg2]
        case .dataRequestApi:
            data = ["arg1": "arg1"]
        case .uploadCompositeMultipart:
            data = ["arg1": "args"]
        }
        
        if data.count != 0 {
            params["data"] = data
        }
        let app = ["appversion": AppConfig.appVersion, "iosversion": AppConfig.iosVersion, "devicemodel": AppConfig.model]
        params["app"] = app
        return params
    }
    
    var sampleData: Data {
        switch self {
        case .demoApi(_):
            return " ".data(using: String.Encoding.utf8)!
        default:
            return " ".data(using: String.Encoding.utf8)!
        }
    }
    
    var task: Task {
        switch self {
        case .uploadCompositeMultipart:
            _ = parameters
            return .uploadCompositeMultipart(formDataArr, urlParameters: parameters!)
        case .dataRequestApi:
            let data = try! JSONSerialization.data(withJSONObject: parameters!, options: .prettyPrinted)
            return .requestData(data)
        default:
            return .requestParameters(parameters: parameters!, encoding: URLEncoding.default)
        }
    }
    
}

extension ApiService {
    
    func urlRequest() -> URLRequest {
        var request = URLRequest(url: URL(string: baseURL.absoluteString+path)!)
        request.httpMethod = method.rawValue
        for (_, item) in headers!.enumerated() {
            request.setValue(item.value, forHTTPHeaderField: item.key)
        }
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(HttpCom.Token, forHTTPHeaderField: "token")
        let data = try! JSONSerialization.data(withJSONObject: parameters!, options: .prettyPrinted)
        request.httpBody = data
        return request
    }
}

public class HttpCom {

    static var url: String = AppConfig.url
    
    static var guide_url: String = AppConfig.guide_url
    
    static var header = Dictionary<String, String>()
    
    static let httpVersion = AppConfig.yunweiVersion
    
    static var Token: String = " "
    
    static func SetHeaderKey(key: String, value: String) {
        header[key] = value
    }
    
}

