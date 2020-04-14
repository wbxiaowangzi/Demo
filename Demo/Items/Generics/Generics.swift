//
//  Generics.swift
//  Demo
//
//  Created by songdan on 2019/9/4.
//  Copyright © 2019 wangbo. All rights reserved.
//

import UIKit

class Generics: NSObject {
    func swapValue<T>(_ a: inout T, _ b: inout T){
        (a,b) = (b,a)
    }

    func swapTwoValues<W>(_ a: inout W, _ b: inout W){
        (a,b) = (b,a)
    }
    func 交换两个值<泛型类型>(_ a: inout 泛型类型, _ b: inout 泛型类型){
        (a,b) = (b,a)
    }
    
    func deferFunc(){
        var a = 10
        var b = 100
        交换两个值(&a, &b)
        defer{
            print("this must will be execute before return")
        }
        return
    }
    
}


class 这是个类名 {
    var 这是一个参数名:String?
    var 这是一个int参数:Int?
    func 这个是一个方法名(){
    }
    
    func 这是另一个方法名(){
        
    }
    
}

enum 这是一个枚举 {
    case 类型1
    case 类型2
    case 类型3
}


struct 这是一个结构体 {
    var  这是一个啥:Int?
    func lalal(){
        let b = aaaa<Int>()
        var a = 10
        b.test(&a)
    }
}

class aaaa<T> {
    func test(_ a:inout T){
        print("lalala")
        print(a)
    }
    
    
}

//protocol不允许使用泛型，可以使用关联类型替代泛型的作用
//protocol Aprotocol<T> {
//    func deal(value : T)
//}
