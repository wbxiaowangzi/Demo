//
//  Observable+ObjectMapper.swift
//  Mirage3D
//
//  Created by 影子.zsr on 2017/12/19.
//  Copyright © 2017年 影子. All rights reserved.
//

import Foundation
import RxSwift
import Moya
import ObjectMapper
import Result
extension Observable {
    func mapObject<T: Mappable>(type: T.Type) -> Observable<T> {
        return self.map { response in
            
            guard let r = response as? Response else{
                throw RxSwiftMoyaError.ParseJSONError
            }
            
            return MapperUtil<T>.map(r)
        }
    }
    
    func mapArray<T: Mappable>(type: T.Type) -> Observable<[T]> {
        return self.map { response in
            guard let dict = response as? [String: Any] else {
                throw RxSwiftMoyaError.ParseJSONError
            }
            
            if let error = self.parseError(response: dict) {
                throw error
            }
            return Mapper<T>().mapArray(JSONArray: [dict])
        }
    }
    
    func parseServerError() -> Observable {
        return self.map { (response) in
            let name = type(of: response)
            print(name)
            guard let dict = response as? [String: Any] else {
                throw RxSwiftMoyaError.ParseJSONError
            }
            if let error = self.parseError(response: dict) {
                throw error
            }
            return self as! Element
        }
    }
    
    fileprivate func parseError(response: [String: Any]?) -> NSError? {
        var error: NSError?
        if let value = response {
            var code:Int?
            var msg:String?
            if let errorDic = value["error"] as? [String:Any]{
                code = errorDic["code"] as? Int
                msg = errorDic["msg"] as? String
                error = NSError(domain: "Network", code: code!, userInfo: [NSLocalizedDescriptionKey: msg ?? ""])
            }
        }
        return error
    }
}

enum RxSwiftMoyaError: String {
    case ParseJSONError
    case OtherError
}
extension RxSwiftMoyaError: Swift.Error {}

