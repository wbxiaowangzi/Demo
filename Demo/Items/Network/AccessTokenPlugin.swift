//
//  AccessTokenPlugin.swift
//  Mirage3D
//
//  Created by 影子.zsr on 2017/12/20.
//  Copyright © 2017年 影子. All rights reserved.
//

import Foundation
import Moya
import Result
import ObjectMapper

//yunwei通信token验证与刷新
internal final class AccessTokenPlugin: PluginType {

    var completeDele: ((_ code: Int) -> Void)?
    public typealias CredentialClosure = (TargetType) -> URLCredential?
    let credentialsClosure: CredentialClosure
    
    public init(credentialsClosure: @escaping CredentialClosure) {
        self.credentialsClosure = credentialsClosure
    }

    // MARK: Plugin
    
    public func willSend(_ request: RequestType, target: TargetType) {
        if let credentials = credentialsClosure(target) {
            _ = request.authenticate(usingCredential: credentials)
        }
        
        print("发送请求：" + target.baseURL.absoluteString + target.path)
    }
    
    func didReceive(_ result: Result<Moya.Response, MoyaError>, target: TargetType) {
        //print("didReceiveResponse")
        switch result {
        case .success(let response):
            //print(".success ======= " + String(response.statusCode))
            //print(".success ==== TOKEN === " + (response.request?.value(forHTTPHeaderField: "token"))!)
            var code: Int = -1
            do {
                let jsonObject = try! response.mapJSON()
            }
            
            let token = response.response?.allHeaderFields["token"]
            //print("接收应答: \(String.init(data: response.data, encoding: String.Encoding.utf8)!.replacingOccurrences(of: "\\", with: ""))")
            if token != nil {
                let s = token as! String
                if HttpCom.Token != s {
                    HttpCom.Token = s
                    print("refresh Token: success" + " --------\(s)")
                    YunweiMgr.Instance.RefreshProvider()
                }
            }
            completeDele?(code)
        case .failure(_):
            print("HttpConnect Error: " + result.error.debugDescription + " --------")
            completeDele?(-1)
        }
    }
    
}

