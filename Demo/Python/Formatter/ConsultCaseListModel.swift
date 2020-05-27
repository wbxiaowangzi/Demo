//
//  ConsultCaseListModel.swift
//  LiMingTang
//
//  Created by WangBo on 2019/6/20.
//  Copyright © 2019 影子. All rights reserved.
//

import UIKit
import ObjectMapper
import MINetwork

class ConsultCaseListModel: MappableBase {

    var total_count: Int?

    var count: Int?

    var list: [ConsultCaseModel]?

    override func mapping(map: Map) {
        super.mapping(map: map)
        total_count <- map["data.total"]
        count       <- map["data.count"]
        list        <- map["data.list"]
    }
}

class ConsultCaseModel: NSObject, Mappable {

    var id: Int?

    
    var image_url: String?

    
    var image_type: Int?

    
    var image_number: Int?

    
    var name: String?

    
    var gender: Int?

    
    var age: Int?

    
    var occupation: String?

    
    var design_objective: String?

    
    var operate_time: Int?

    
    var photo_time: Int?

    
    var star: Int?

    
    var collect: Int?

    
    var doctor: ConsultCaseDoctorModel?

    
    var labels: [ConsultCaseLabeleModel]?

    
    var operations: [ConsultCaseOperationModel]?

    
    var solutions: [ConsultCaseSolutionModel]?

    
    var instances: [ConsultCaseInstanceModel]?

    
    override init() {
        super.init()
        labels = [ConsultCaseLabeleModel]()
        solutions = [ConsultCaseSolutionModel]()
        operations = [ConsultCaseOperationModel]()
    }
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        id         <- map["id"]
        image_url  <- map["image_url"]
        image_type <- map["image_type"]
        name       <- map["name"]
        gender     <- map["gender"]
        age        <- map["age"]
        doctor     <- map["doctor"]
        labels     <- map["labels"]
        operations <- map["operations"]
        solutions  <- map["solutions"]
        instances  <- map["instances"]
        occupation <- map["occupation"]
        design_objective <- map["design_objective"]
        operate_time     <- map["operate_time"]
        photo_time       <- map["photo_time"]
        star       <- map["star"]
        collect    <- map["collect"]
    }
    
}

class ConsultCaseDoctorModel: NSObject, Mappable {

    var id: Int?

    var name: String?

    var image: String?

    var phone: String?

    
    override init() {
        super.init()
    }
    
    required init?(map: Map) {
    }
    func mapping(map: Map) {
        id    <- map["id"]
        image <- map["image"]
        name  <- map["name"]
        phone <- map["phone"]
    }
}

class ConsultCaseLabeleModel: NSObject, Mappable {

    var id: Int?

    var full_name: String?

    var name: String?

    var degree: String?

    override init() {
        super.init()
    }
    
    required init?(map: Map) {
    }
    func mapping(map: Map) {
        id        <- map["id"]
        full_name <- map["full_name"]
        name      <- map["name"]
        degree    <- map["degree"]
    }
}

class ConsultCaseSolutionModel: NSObject, Mappable {

    override init() {
        super.init()
    }
    
    required init?(map: Map) {
    }
    
    var id: Int?

    var name: String?

    func mapping(map: Map) {
        id   <- map["id"]
        name <- map["name"]
    }
}

class ConsultCaseOperationModel: NSObject, Mappable {

    override init() {
        super.init()
    }
    
    required init?(map: Map) {
    }
    
    var id: Int?

    var name: String?

    func mapping(map: Map) {
        id   <- map["id"]
        name <- map["name"]
    }
}

class ConsultCaseInstanceModel: NSObject, Mappable {

    override init() {
        super.init()
    }

    required init?(map: Map) {
    }

    var id: Int?

    var name: String?

    func mapping(map: Map) {
        id   <- map["id"]
        name <- map["name"]
    }
}
