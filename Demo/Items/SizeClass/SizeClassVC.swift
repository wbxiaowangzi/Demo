//
//  SizeClassVC.swift
//  Demo
//
//  Created by YingZi on 2018/12/14.
//  Copyright © 2018 wangbo. All rights reserved.
//

import UIKit

class SizeClassVC: ZKViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .landscapeRight
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return [.landscapeLeft,.portrait,.landscapeRight]
    }

}
