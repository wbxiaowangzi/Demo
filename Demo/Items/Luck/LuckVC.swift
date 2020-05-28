//
//  LuckVC.swift
//  Demo
//
//  Created by WangBo on 2019/3/12.
//  Copyright © 2019 wangbo. All rights reserved.
//

import UIKit

class LuckVC: BaseVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
    }

    /// 获取距今n次的平均值
    ///
    /// - Parameter times: 次数
    func getMeanValue(with times: Int) -> LuckNumberModel {

        return LuckNumberModel()
    }
}

