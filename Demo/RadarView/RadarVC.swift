//
//  RadarVC.swift
//  Demo
//
//  Created by YingZi on 2018/10/30.
//  Copyright © 2018 wangbo. All rights reserved.
//

import UIKit

class RadarVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
    }

    func makeRadarView() {
        let radar = RadarView()
        view.addSubview(radar)
    }
    
}
