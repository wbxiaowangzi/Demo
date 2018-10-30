//
//  RadarView.swift
//  Demo
//
//  Created by YingZi on 2018/10/30.
//  Copyright © 2018 wangbo. All rights reserved.
//

import UIKit

class RadarView: UIView {
    
    fileprivate var radarData:[RadarModel]?
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience  init(frame: CGRect,radarData:[RadarModel]) {
        self.init(frame: frame)
        self.radarData = radarData
    }
    
    
    
}

struct RadarModel {
    
    var name:String?
    var score:NSInteger? = 0
    init(name:String,score:NSInteger) {
        self.name = name
        self.score = score
    }

}
