//
//  MD5Model.swift
//  Mirage3D
//
//  Created by 影子.zsr on 2017/12/25.
//  Copyright © 2017年 影子. All rights reserved.
//

import Foundation
import ObjectMapper

class MD5Model: Mappable {
    required init?(map: Map) {
        
    }
    
    var md5:String?
    
    var error:String?
    
    
    func mapping(map: Map) {
        
        error <- map["error"]
        md5 <- map["md5"]
    }
        
}
