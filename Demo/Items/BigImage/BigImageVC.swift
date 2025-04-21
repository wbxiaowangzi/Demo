//
//  BigImageVC.swift
//  Demo
//
//  Created by WangBo on 2025/4/15.
//  Copyright © 2025 wangbo. All rights reserved.
//

import UIKit

class BigImageVC: BaseVC {
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "TiledView"
        view.backgroundColor = .black
        let imagePath = Bundle.main.path(forResource: "big", ofType: "jpg")!
        let imageURL = URL(fileURLWithPath: imagePath)
        let bigImageView = SmartBigImageView(frame: view.bounds, imageURL: imageURL)
        view.addSubview(bigImageView)
        print("lalalal")
    }
}
