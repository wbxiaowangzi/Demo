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
        let radar = RadarView(frame: CGRect(x: 0, y: 100, width: 400, height: 400), radarData: [RadarModel.init(name: "额部", score: 84),
                                                                                                RadarModel.init(name: "侧脸", score: 54),
                                                                                                RadarModel.init(name: "正脸", score: 89),
                                                                                                RadarModel.init(name: "结构", score: 90),
                                                                                                RadarModel.init(name: "鼻部", score: 76),
                                                                                                RadarModel.init(name: "眼部", score: 62)])
        view.addSubview(radar)
    }
    
}
