//
//  BaseVC.swift
//  Demo
//
//  Created by 王波 on 2018/7/18.
//  Copyright © 2018年 wangbo. All rights reserved.
//

import UIKit

class BaseVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension UIColor{
    
    convenience init(hexString:String) {
        if hexString.count <= 0 || hexString.count != 7 || hexString == "(null)" || hexString == "<null>" {
            self.init(red: 1, green: 1, blue: 1, alpha: 1)
            return
        }
        var red: UInt32 = 0x0
        var green: UInt32 = 0x0
        var blue: UInt32 = 0x0
        let redString = String(hexString[hexString.index(hexString.startIndex, offsetBy: 1)...hexString.index(hexString.startIndex, offsetBy: 2)])
        let greenString = String(hexString[hexString.index(hexString.startIndex, offsetBy: 3)...hexString.index(hexString.startIndex, offsetBy: 4)])
        let blueString = String(hexString[hexString.index(hexString.startIndex, offsetBy: 5)...hexString.index(hexString.startIndex, offsetBy: 6)])
        Scanner(string: redString).scanHexInt32(&red)
        Scanner(string: greenString).scanHexInt32(&green)
        Scanner(string: blueString).scanHexInt32(&blue)
        self.init(red: CGFloat(red)/255.0, green: CGFloat(green)/255.0, blue: CGFloat(blue)/255.0, alpha: 1)
    }
}

//超出父视图还能相应事件
class ANCView:UIView{
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        var view = super.hitTest(point, with: event)
        if view == nil {
            for v in self.subviews{
                let p = v.convert(point, from: self)
                if v.bounds.contains(p){
                    view = v
                }
            }
        }
        return view
    }
    
}
