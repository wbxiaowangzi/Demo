//
//  SQLiteVC.swift
//  Demo
//
//  Created by YingZi on 2018/11/9.
//  Copyright © 2018 wangbo. All rights reserved.
//

import UIKit

class SQLiteVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        let m1 = FaceModel(faceid: 1, userid: "1231321")
        let m2 = FaceModel(faceid: 1, userid: "231231421")
        SQLDB.share.insertFace(model: m1)
        SQLDB.share.insertFace(model: m2)
        makealab()
    }

    func makealab() {
        let l = UILabel(frame: view.bounds)
        l.textColor = .black
        view.addSubview(l)
        let a = SQLDB.share.select(with: 1)
        l.text = String(a.flatMap{$0.userid+"-----"})
    }
}

