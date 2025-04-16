//
//  LuckNumbersDb.swift
//  Demo
//
//  Created by WangBo on 2019/4/25.
//  Copyright © 2019 wangbo. All rights reserved.
//

import UIKit
import SQLite

class LuckNumbersDB: NSObject {

    static let DocumentPath = NSHomeDirectory() + "/Documents"

    static let SQLDBPath  = DocumentPath + "/SQLite/LuckNumbers"

    static let share = LuckNumbersDB()

    var DB = try? Connection(SQLDBPath)
    
    let Number_Table = Table("luck_number")

    let Face_id = Expression<String>(value: "face_id")

    let User_ID = Expression<String>(value: "user_id")

    let numbs = Expression<String>(value: "ints")
    
    private override init() {
        super.init()
        creatTable()
    }
    
    fileprivate func creatTable() {
        try! DB?.run(Number_Table.create(temporary: true, ifNotExists: true, withoutRowid: true, block: { (t) in
            t.column(User_ID, primaryKey: true)
            t.column(Face_id)
        }))
    }
    
    func insertModel(model: FaceModel) {
        guard DB != nil else {
            return
        }
        let insert = Number_Table.insert(
            Face_id <- model.faceid,
            User_ID <- model.userid
        )
        let _ = try? DB!.run(insert)
    }
    
    func deleteModel(model: FaceModel) {

        deleteModel(with: model.faceid)
    }
    
    func deleteModel(with faceID: Int) {
        try! DB?.run(Number_Table.filter(self.Face_id == "\(faceID)").delete())
    }
    
    func deleteModel(with userID: String) {
        try! DB?.run(Number_Table.filter(self.User_ID == userID).delete())
    }
    
    func select(with faceID: Int) -> [FaceModel]  {
        let a = try! DB?.prepare(Number_Table.filter(self.Face_id == "\(faceID)"))
        return a!.map {FaceModel(faceid: $0[Face_id], userid: $0[User_ID])}
    }
    
    func isExist(faceid: Int) -> Bool {
        return select(with: faceid).count > 0
    }
}

struct FLuckNumberModel {
    var faceid = 0

    var userid = "123"
    init(faceid: Int, userid: String) {
        self.faceid = faceid
        self.userid = userid
    }
}
