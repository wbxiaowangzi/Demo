//
//  Router.swift
//  Demo
//
//  Created by 王波 on 2018/6/10.
//  Copyright © 2018年 wangbo. All rights reserved.
//

import UIKit

class Router: NSObject {

}

extension ViewController{
    
    func gotoCALayerVC() {
        let vc = CALayerVC()
        self.present(vc, animated: true, completion: nil)
    }
    
    func gotoCoreAnimationVC() {
        let vc = CoreAnimationVC()
        self.present(vc, animated: true, completion: nil)
    }
    
    func gotoMVVMVC() {
        let vc = MVVMVC()
        self.present(vc, animated: true, completion: nil)
    }
}

extension UINavigationController{
    func gotoCALayerVC() {
        let vc = CALayerVC()
        self.pushViewController(vc, animated: true)
    }
    
    func gotoCoreAnimationVC() {
        let vc = CoreAnimationVC()
        self.pushViewController(vc, animated: true)
    }
    
    func gotoMVVMVC() {
        let vc = MVVMVC()
        self.pushViewController(vc, animated: true)
    }
}
