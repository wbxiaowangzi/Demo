////
////  AnalyzeAreaConfig.swift
////  MIHousekeeper
////
////  Created by 加冰 on 2020/2/12.
////  Copyright © 2020 影子. All rights reserved.
////
//
//import Foundation
//import ObjectMapper
//
//struct AnalyzePartModel {
//
//    let id: Int
//
//    let partName: String
//
//    let partId: Int
//
//    let belong: String
//
//    var isMirror: Bool
//
//    var isRed: Bool
//
//    let rect: CGRect
//
//    let rectRight: CGRect?
//
//    let texture: UIImage?
//
//    let textureRed: UIImage?
//
//    mutating func setRed(_ value: Bool) {
//        isRed = value
//    }
//}
//
//
//class AnalyzeAreaConfig {
//
//    static let share: AnalyzeAreaConfig = AnalyzeAreaConfig()
//
////    var featureDic: [String: AnalyzeFeatureModel] = [: ]
//
//    private var areaTextureDic: [String: [String: AnalyzePartModel]] = [:]
//
//    private var partModel: GetPartsModel?
//
////    var partDic: [String: AnalyzePartModel] = [: ]
//
////    var areaDic: [String: AnalyzeAreaModel] = [: ]
//
//    private init() {
//        let configPath = Bundle.main.path(forResource: "Resource/面部区域配置表4", ofType: "csv")!
//
//        let reader = StreamReader.init(path: configPath)
//        var lineCount: Int = 0
//        _ = reader?.nextLine()
//        while let line = reader?.nextLine() {
//            lineCount += 1
//            let arr = line.components(separatedBy: ",")
//
//            guard arr.count >= 6, let id = Int(arr[0]), let part_id = Int(arr[2]) else {
//                print("----------- 面部区域图 配置读取失败 ------ 行数：\(lineCount)")
//                continue
//            }
//
//            //部位纹理数据
//            let rectArr = arr[5].components(separatedBy: "-")
//            if rectArr.count < 4 {
//                continue
//            }
//
//            let isMirror = arr[4] == "0" ? false : true
//
//            let rect = CGRect.init(x: Float(rectArr[0]) ?? 0,
//                                   y: Float(rectArr[1]) ?? 0,
//                                   width: Float(rectArr[2]) ?? 0,
//                                   height: Float(rectArr[3]) ?? 0)
//            var rectRight: CGRect?
//            if isMirror {
//                let rectRightArr = arr[4].components(separatedBy: "-")
//                if rectRightArr.count == 4 {
//                    rectRight = CGRect.init(x: Float(rectRightArr[0]) ?? 0,
//                                            y: Float(rectRightArr[1]) ?? 0,
//                                            width: Float(rectRightArr[2]) ?? 0,
//                                            height: Float(rectRightArr[3]) ?? 0)
//                }
//            }
//
//
//            let part = arr[1]
//            let imageRed = "Resource/切图2红/\(part).png"
//            let image = "Resource/切图2/\(part).png"
//            let partModel = AnalyzePartModel.init(id: id,
//                                                  partName: part,
//                                                  partId: part_id,
//                                                  belong: arr[3],
//                                                  isMirror: isMirror,
//                                                  isRed: false,
//                                                  rect: rect,
//                                                  rectRight: rectRight,
//                                                  texture: UIImage.init(named: image),
//                                                  textureRed: UIImage.init(named: imageRed))
//
//            if areaTextureDic[arr[3]] != nil{
//                areaTextureDic[arr[3]]?[part] = partModel
//            }else{
//                var partDic = [String: AnalyzePartModel]()
//                partDic[part] = partModel
//                areaTextureDic[arr[3]] = partDic
//            }
//
//        }
//    }
//
//    func setParts(_ parts: GetPartsModel){
//        self.partModel = parts
//
//        for item in areaTextureDic.values{
//            for area in item.values{
//                if let part = partModel?.getPart(by: area.partId){
//                    part.area = area
//                }
//            }
//        }
//    }
//
//    func getPartByFeature(feature: TemplateFeatureModel) -> AnalyzePartModel? {
////        var arr: [AnalyzePartModel] = []
////        let textureName = type == 0 ? "面部女" : "身体"
//        if let part_id = feature.part_id, let part = partModel?.getPart(by: part_id) {
//            if part.area != nil{
////                arr.append(part.area!)
//                return part.area
//            }else{
//                /// 没有精准图的话，继续搜索父区域图
//                if let parentPart = partModel?.getPart(by: part.parent_id){
//                    return parentPart.area
//                }
//            }
//
//
//        }
//        return nil
//    }
//
//    func getPartTree(_ part_id: Int) -> [PartModel]{
//        if let part = partModel?.getPart(by: part_id){
//            return partModel?.getAllPart(part) ?? []
//        }
//        return []
//    }
//
//}
//
//class GetPartsModel: MappableBase{
//
//    var parts: [PartModel] = []
//
//    override func mapping(map: Map) {
//        super.mapping(map: map)
//        parts <- map["data"]
//    }
//
//    func getPart(by id: Int) -> PartModel?{
//        if let part = findPart(id, nodes: parts){
//            return part
//        }
//
//        return nil
//    }
//
//    func getAllPart(_ part: PartModel) -> [PartModel] {
//        var arr: [PartModel] = []
//        arr.append(contentsOf: getAllChild(part))
//        arr.append(contentsOf: getAllParent(part))
//        arr.removeLast()
//        arr.append(contentsOf: parts)
//        return arr
//    }
//
//    private func getAllParent(_ part: PartModel) -> [PartModel]{
//        var arr: [PartModel] = []
//        if part.parent_id != 0, let parent = getPart(by: part.parent_id){
//            arr.append(parent)
//            arr.append(contentsOf: getAllParent(parent))
//        }
//
//        return arr
//    }
//
//    private func getAllChild(_ part: PartModel) -> [PartModel]{
//        var arr: [PartModel] = []
//
//        for item in part.children_nodes{
//            arr.append(item)
//            arr.append(contentsOf: getAllChild(item))
//        }
//        return arr
//    }
//
//    private func findPart(_ id: Int, nodes: [PartModel])-> PartModel?{
//        for item in nodes{
//            if item.part_id == id{
//                return item
//            }else{
//                if let part = findPart(id, nodes: item.children_nodes){
//                    return part
//                }
//            }
//        }
//        return nil
//    }
//
//}
//
//class PartModel: MappableBase {
//    var part_id: Int = 0
//    var part_name: String = ""
//    var children_nodes: [PartModel] = []
//    var parent_id: Int = 0
//    var area: AnalyzePartModel?
//
//    override func mapping(map: Map) {
//        part_id <- map["part_id"]
//        part_name <- map["part_name"]
//        if part_id == 0{
//            part_id <- map["id"]
//            part_name <- map["name"]
//        }
//        children_nodes <- map["children_nodes"]
//        for item in children_nodes{
//            item.parent_id = part_id
//        }
//    }
//
//}
//
//extension Array {
//
//    // 去重
//    func filterDuplicates<E: Equatable>(_ filter: (Element) -> E) -> [Element] {
//        var result = [Element]()
//        for value in self {
//            let key = filter(value)
//            if !result.map({filter($0)}).contains(key) {
//                result.append(value)
//            }
//        }
//        return result
//    }
//}
