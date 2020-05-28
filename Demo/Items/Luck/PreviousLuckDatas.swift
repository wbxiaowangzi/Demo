//
//  PreviousLuckDatas.swift
//  Demo
//
//  Created by WangBo on 2019/4/25.
//  Copyright © 2019 wangbo. All rights reserved.
//

import UIKit

private let CodingStringModels = "LuckNumberModel.models"

private let CodingStringRed = "LuckNumberModel.red"

private let CodingStringBlue = "LuckNumberModel.blue"

class PreviousLuckDatas: NSObject {

    var models: [LuckNumberModel]?
    
    func saveData() {
        let user = UserDefaults.standard
        user.set(models, forKey: CodingStringModels)
    }
    
    func getData() {
        let user = UserDefaults.standard

        if let ms = user.object(forKey: CodingStringModels) as? [LuckNumberModel] {
            self.models = ms
        }
    }
}

class LuckNumberModel: NSObject, NSCoding {

    var red: [Int]?

    var blue: [Int]?
    override init() {
        super.init()
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(red, forKey: CodingStringRed)
        aCoder.encode(blue, forKey: CodingStringBlue)
    }
    
    required init?(coder aDecoder: NSCoder) {
        if let r = aDecoder.decodeObject(forKey: CodingStringRed) as? [Int] {
            self.red = r
        }
        if let b = aDecoder.decodeObject(forKey: CodingStringBlue) as? [Int] {
            self.blue = b
        }
    }
}
