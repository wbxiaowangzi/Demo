//
//  YunweiMgr.swift
//  Mirage3D
//
//  Created by 影子.zsr on 2017/12/18.
//  Copyright © 2017年 影子. All rights reserved.
//

import Foundation
import RxSwift
import Moya
import RxCocoa
import ObjectMapper
import Reachability
import Alamofire

final class YunweiMgr {
    
    static let Instance: YunweiMgr = YunweiMgr.init()
    
    var apiProvider: MoyaProvider<ApiService>!

    fileprivate var streamProvider: MoyaProvider<ApiService>!
    /** 网络状态监听 **/
    private let reachability = Reachability()!

    private let remoteHostName = "www.baidu.com"

    private var _isReachability = true

    private var _connectState: ConnectState = .Not

    var isNetReachability: Bool {
        get {
            return self._isReachability
        }
    }
    
    var connectState: ConnectState {
        get {
            return self._connectState
        }
    }
    
    private init() {
        HttpCom.SetHeaderKey(key: "version", value: AppConfig.yunweiVersion)

        RefreshProvider()
        //accessTokenPlugin.completeDele = onComplete(_: )
    }
    
    let accessTokenPlugin : AccessTokenPlugin = AccessTokenPlugin.init { (a) -> URLCredential? in
        return URLCredential()
    }
    
    /** 刷新provider **/
    func RefreshProvider() {
        let commonEndpointClosure = { (target: ApiService) -> Endpoint in

            let URL = target.baseURL.appendingPathComponent(target.path).absoluteString
            
            var headFields = Dictionary<String, String>()
            headFields["token"] = HttpCom.Token
            let endpoint = Endpoint(url: URL,
                                    sampleResponseClosure: {.networkResponse(0, target.sampleData)},
                                    method: target.method,
                                    task: target.task, httpHeaderFields: headFields)
           
            // 添加 AccessToken
            var request = try? endpoint.urlRequest()
            request?.timeoutInterval = 15
            return endpoint
        }
        
        apiProvider = MoyaProvider<ApiService>(endpointClosure: commonEndpointClosure,
                                                 plugins: [],
                                                 trackInflights: false)
        let stubC = {(api: ApiService) -> StubBehavior in
            return .never
        }
        streamProvider = MoyaProvider<ApiService>(endpointClosure: commonEndpointClosure, stubClosure: stubC, plugins: [], trackInflights: false)
    }
    
    /** post **/
    private func _request(apiService: ApiService, callback: ((SingleEvent<Response>) -> Void)?) -> Observable<Response> {
        print("发送请求: \r url: \(apiService.baseURL)\(apiService.path)\r method: \(apiService.method)\r headers： \(String(describing: apiService.headers))\r paramas:\(apiService.parameters!))")
        
        let obserable = apiProvider.rx.request(apiService)

        let _ = obserable.subscribe { (e) in
            switch e {
            case.success(let response):

                let token = response.response?.allHeaderFields["token"]
                if token != nil {
                    let s = token as! String
                    if HttpCom.Token != s {
                        HttpCom.Token = s
                        self.RefreshProvider()
                        //CoreUserMgr.Instance.saveToken()
                    }
                }
                
                //let model = MapperUtil<TokenModel>.map(response)
                //print("接收应答:  \(String(describing: model.code))")
                //若token过期，则直接进入代理
//                if model.code == 606 {
//                    self.TokenOvertime()
//                    return
//                }
            
            case .error(_): break
            }
            callback?(e)
        }
    
        return obserable.asObservable()
    }

    /// yunwei通用接口
    ///
    /// - Parameters:
    ///   - apiService: ApiService
    ///   - event: callback
    func request(apiService: ApiService, event: ((SingleEvent<Response>) -> Void)?) -> Observable<Response> {

        return _request(apiService: apiService, callback: event)
        
    }
    
    func request(urlRequest: URLRequest, completionHandler: @escaping ((DataResponse<Any>) -> Void)) {

        Alamofire.request(urlRequest).responseJSON(completionHandler: completionHandler)
    }
    
    /// 带进度的请求
    ///
    /// - Parameters:
    ///   - apiService: apiService
    ///   - event: callback
    /// - Returns: ctrl
    func requestWithProgress(apiService: ApiService, event: @escaping (Event<ProgressResponse>) -> Void) -> Disposable {
        let disposable = apiProvider.rx.requestWithProgress(apiService).subscribe { (e) in
            event(e)
            
        }
        return disposable
    }
    
    func send() {
        
    }
    
    /** 开启网络状态监听 **/
    func startNetNotifier() {
        reachability.whenReachable = { reachability in
            if reachability.connection == .wifi {
                print("Reachable via WiFi")
                self._connectState = .WiFi
                self._isReachability = true
            } else {
                print("Reachable via Cellular")
                self._connectState = .Cellular
                self._isReachability = true
            }
        }
        
        reachability.whenUnreachable = { _ in
            print("Not reachable")
            self._connectState = .Not
            self._isReachability = false
        }
        
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
            //1秒后再次启动网络监听
            let _ = Timer.init(timeInterval: 1, repeats: false, block: { (time) in
                self.stopNetNotifier()
            }).fire()
        }
    }
    
    func stopNetNotifier() -> Void {
        reachability.stopNotifier()
    }

}

enum ConnectState {
    case WiFi
    case Cellular
    case Not
}

class MapperUtil<T: Mappable> {

    static func map(_ s: Any?) -> T? {
        return Mapper<T>().map(JSONObject: s)
    }
    
    static func map(_ r: Response) -> T {
        var json: Any
        do {
            json = try r.mapJSON()
        }catch {
            print(error.localizedDescription)
            let data = " {\"code\": -1111}".data(using: String.Encoding.utf8)!
            json = try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
            let model = MapperUtil<T>.map(json)!
            
            return model
        }
        
        return Mapper<T>().map(JSONObject: json)!
    }
    
    static func create() -> T {
        let data = " {\"code\": -1}".data(using: String.Encoding.utf8)!

        let json = try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary

        let model = MapperUtil<T>.map(json)!
        
        return model
    }
    
}

