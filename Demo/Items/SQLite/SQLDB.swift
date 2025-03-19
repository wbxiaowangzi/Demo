//
//  SQLDB.swift
//  Demo
//
//  Created by YingZi on 2018/11/9.
//  Copyright © 2018 wangbo. All rights reserved.
//

import UIKit
import SQLite

class SQLDB: NSObject {
    
    static let DocumentPath = NSHomeDirectory() + "/Documents"

    static let SQLDBPath  = DocumentPath + "/SQLite"

    static let share = SQLDB()

    var DB = try? Connection(SQLDBPath)
    
    let Face_Table = Table("face")

    let Face_id = Expression<String>(value: "face_id")

    let User_ID = Expression<String>(value: "user_id")

    private override init() {
        super.init()
        creatFaceTable()
    }
    
    fileprivate func creatFaceTable() {
        try! DB?.run(Face_Table.create(temporary: true, ifNotExists: true, withoutRowid: true, block: { (t) in
            t.column(User_ID, primaryKey: true)
            t.column(Face_id)
        }))
    }
    
    func insertFace(model: FaceModel) {
        guard DB != nil else {
            return
        }
        let insert = Face_Table.insert(
            Face_id <- model.faceid,
            User_ID <- model.userid
        )
        let _ = try? DB!.run(insert)
    }
    
    func deleteFace(model: FaceModel) {

        deleteFace(with: model.faceid)
    }
    
    func deleteFace(with faceID: Int) {
        try! DB?.run(Face_Table.filter(self.Face_id == "\(faceID)").delete())
    }
    
    func deleteFace(with userID: String) {
        try! DB?.run(Face_Table.filter(self.User_ID == userID).delete())
    }
    
    func select(with faceID: Int) -> [FaceModel]  {
        let a = try! DB?.prepare(Face_Table.filter(self.Face_id == "\(faceID)"))
        return a!.map {FaceModel(faceid: $0[Face_id], userid: $0[User_ID])}
    }
    
    func isExist(faceid: Int) -> Bool {
        return select(with: faceid).count > 0
    }
}

struct FaceModel {
    var faceid = "0"

    var userid = "123"
    init(faceid: String, userid: String) {
        self.faceid = faceid
        self.userid = userid
    }
}
