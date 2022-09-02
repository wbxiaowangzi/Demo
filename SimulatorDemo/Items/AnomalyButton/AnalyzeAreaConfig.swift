//
//  AnalyzeAreaConfig.swift
//  MIHousekeeper
//
//  Created by 加冰 on 2020/2/12.
//  Copyright © 2020 影子. All rights reserved.
//

import Foundation
import UIKit
import simd

struct AnalyzeAreaModel {
    let areaName: String

    let position: float3

    let rotate: float3
}

struct AnalyzePartModel {
    let partName: String

    let area: String

    var isMirror: Bool

    let rect: CGRect

    let rectRight: CGRect?

    let texture: UIImage?

    let textureRight: UIImage?
    
    mutating func setMirror(_ value: Bool) {
        isMirror = value
    }
}

struct AnalyzeFeatureModel {
    let id: String

    let feature: String

    var part: [String]
    
    mutating func addPart(_ value: String) {
        var arr = [String]()
        for item in part {
            arr.append(item)
        }
        arr.append(value)
        part = arr
    }
}

class AnalyzeAreaConfig {
    
    static let share: AnalyzeAreaConfig = AnalyzeAreaConfig()
    
    var featureDic: [String: AnalyzeFeatureModel] = [: ]

    var partDic: [String: AnalyzePartModel] = [: ]

    var areaDic: [String: AnalyzeAreaModel] = [: ]
    
    private init() {
        let configPath = Bundle.main.path(forResource: "Resource/面部区域配置表3", ofType: "csv")!
        
        let reader = StreamReader.init(path: configPath)

        var part: String = ""

        var area: String = ""

        while let line = reader?.nextLine() {

            let arr = line.components(separatedBy: ",")
            
            //区域
            let areaArr = arr[3].components(separatedBy: "_")
            if arr[1] != "" && areaArr.count == 6 {
                 area = arr[1]
                 let position = float3(Float(areaArr[0])!, Float(areaArr[1])!, Float(areaArr[2])!)

                 let rotate = float3(Float(areaArr[3])!, Float(areaArr[4])!, Float(areaArr[5])!)
                 areaDic[area] = AnalyzeAreaModel.init(areaName: area, position: position, rotate: rotate)
             }
            
            //部位
            if arr[2] != "" && arr[2].components(separatedBy: ".").count == 2 {
                part = arr[2].components(separatedBy: ".")[1]
            }
            
            //特征
            let id = arr[8]

            let featureName = arr[6]

            if let feature = featureDic[id] {

                var p = feature.part
                p.append(part)
                let featureModel = AnalyzeFeatureModel.init(id: id, feature: featureName, part: p)
                featureDic[id] = featureModel
            } else {
                let featureModel = AnalyzeFeatureModel.init(id: id, feature: featureName, part: [part])
                featureDic[id] = featureModel
            }
            
            //部位纹理数据
            if arr[5] != "" {
                
                let rectArr = arr[5].components(separatedBy: "-")
                if rectArr.count < 4 {
                    continue
                }
                
                let isMirror = arr[4] == "0" ? false : true
                
                let rect = CGRect.init(x: Int(rectArr[0]) ?? 0,
                                       y: Int(rectArr[1]) ?? 0,
                                       width: Int(rectArr[2]) ?? 0,
                                       height: Int(rectArr[3]) ?? 0)
                var rectRight: CGRect?
                if isMirror {
                    let rectRightArr = arr[4].components(separatedBy: "-")
                    if rectRightArr.count == 4 {
                        rectRight = CGRect.init(x: Int(rectRightArr[0]) ?? 0,
                                           y: Int(rectRightArr[1]) ?? 0,
                                           width: Int(rectRightArr[2]) ?? 0,
                                           height: Int(rectRightArr[3]) ?? 0)
                    }
                }
                
//                let image = "Resource/切图/\(isMirror ? "左\(part)" : part).png"

                let imageRed = "Resource/切图2红/\(part).png"

                let image = "Resource/切图2/\(part).png"

                let partModel = AnalyzePartModel.init(partName: part, area: area, isMirror: false, rect: rect, rectRight: rectRight,
                                                      texture: UIImage.init(named: image),
                                                      textureRight: UIImage.init(named: imageRed))
                partDic[part] = partModel
            }
            
        }
    }
    
    func getFeaturesByPart(part: String) -> [AnalyzeFeatureModel] {
        var arr: [AnalyzeFeatureModel] = []
        for item in featureDic.values {
            if item.part.contains(part) {
                arr.append(item)
            }
        }
        return arr
    }
    
    func getPartByFeature(feature: String) -> [AnalyzePartModel] {
        var arr: [AnalyzePartModel] = []

        if let item = featureDic[feature] {
            for part in item.part {
                if let p = partDic[part] {
                    arr.append(p)
                }
            }
        }
        return arr
    }
    
    
    func getAllPart() -> [AnalyzePartModel] {
        var arr: [AnalyzePartModel] = []
        
        for item in partDic {
            arr.append(item.value)
        }
        return arr
    }
    
}

