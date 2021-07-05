//
//  extension.swift
//  Demo
//
//  Created by WangBo on 2021/1/15.
//  Copyright © 2021 wangbo. All rights reserved.
//

import Foundation

protocol BaseProtocol {
    func baseFunc()
}

extension BaseProtocol {
    func baseExtensionFunc() {
    }
}


protocol SubProtocol: BaseProtocol {
}

extension SubProtocol {
    func subProtocolExtensionFunc() {}
}

struct TheBaseStruct: BaseProtocol {
    func baseFunc() {
        baseExtensionFunc()
    }
}

struct TheSubStruct: SubProtocol {
    func baseFunc() {
        //自然可以调用自己的拓展方法
        subProtocolExtensionFunc()
        //同样可以调用父协议的拓展方法
        baseExtensionFunc()
        let one = ConstainStruct(rawValue: 0)
        let two = ConstainStruct(rawValue: 2)
        print(one.contains(two))
    }
}

struct ConstainStruct: OptionSet {
    
    var rawValue: UInt
    
}
