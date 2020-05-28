//
//  LearnCopyVC.swift
//  Demo
//
//  Created by WangBo on 2019/7/16.
//  Copyright © 2019 wangbo. All rights reserved.
//

import UIKit

class LearnCopyVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    func aboutArray() {
        
        var x = [1, 3, 3,4]

        var y = x
        print(x, y)
        let intsize = MemoryLayout<Int>.size
    }
    
}
