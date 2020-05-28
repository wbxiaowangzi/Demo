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

extension ViewController {
    
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

extension UINavigationController {
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
    
    /*---Transition---*/

    func gotoTransitionVC() {
        let vc = TransitionVC()
        self.pushViewController(vc, animated: true)
    }
    
    /*---CALayer---*/
    
    func gotoShapeLayerVC() {
        let vc = CAShapeLayerVC()
        self.pushViewController(vc, animated: true)
    }
    
    func gotoGradientLayerVC() {
        let vc = CAGradientLayerVC()
        self.pushViewController(vc, animated: true)
    }
    
    func gotoGifBGVC() {
        let vc = GifBGVC()
        self.pushViewController(vc, animated: true)
    }
    
    func gotoRotaryTableVC() {
        let vc = RotaryTableVC()
        self.pushViewController(vc, animated: true)
    }
    
    func gotoMetalVC() {
        let vc = MetalViewController()
        self.pushViewController(vc, animated: true)
    }
    
    func gotoSceneKitVC() {
        let vc = SceneKitVC()
        self.pushViewController(vc, animated: true)
    }
    
    func gotoRadarVC() {
        let vc = RadarVC()
        self.pushViewController(vc, animated: true)
        
    }
    
    func gotoOpenGLVC() {
        let vc = OpenGLVC()
        self.pushViewController(vc, animated: true)
    }
    
    func gotoRXSwiftVC() {
        let vc = RXSwiftVC()
        self.pushViewController(vc, animated: true)
    }
    
    func gotoSQLiteVC() {
        let vc = SQLiteVC()
        self.pushViewController(vc, animated: true)
        
    }
    
    func gotoAvatarXVC() {
        let vc = BaseVC()
        self.pushViewController(vc, animated: true)
    }
    
    func gotoSizeClassVC() {
        let vc = SizeClassVC()
        self.pushViewController(vc, animated: true)
    }
    
    func gotoLuckVC() {
        let vc = LuckVC()
        self.pushViewController(vc, animated: true)
    }
    
    func gotoJSPatchTestVC() {
        let vc = JSPatchTestVC()
        self.pushViewController(vc, animated: true)
    }
    
    func gotoOCTestVC() {
        let vc = OCTestVC()
        self.pushViewController(vc, animated: true)
    }
    
    func gotoSmoothVC() {
        let vc = SmoothTableView()
        self.pushViewController(vc, animated: true)
    }
    
}

