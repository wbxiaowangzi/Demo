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
        makeRadarView()
    }

    func makeRadarView() {
        let radar = RadarView(frame: CGRect(x: 0, y: 100, width: 400, height: 400), radarData: [RadarModel(),RadarModel(),RadarModel(),RadarModel(),RadarModel(),RadarModel()])
        view.addSubview(radar)
    }
    
}
