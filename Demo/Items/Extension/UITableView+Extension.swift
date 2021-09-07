//
//  UITableView+Extension.swift
//  Mirage3D
//
//  Created by YingZi on 2018/12/6.
//  Copyright © 2018 影子. All rights reserved.
//

import Foundation
import UIKit

fileprivate let imageW = 183

fileprivate let imageH = 140

fileprivate let labH = 20

extension UITableView {
    func showNoDataView(with message: String, rowCount: NSInteger) {
//        if rowCount == 0 {
//            let v = UIView.init(frame: bounds)

//            let iv = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: imageW, height: imageH)))
//            iv.image = UIImage(named: "home_ic_nodata")
//            v.addSubview(iv)
//            iv.snp.makeConstraints {$0.center.equalToSuperview()}
//            let lab = UILabel.init(frame: CGRect(origin: .zero, size: CGSize(width: imageW, height: labH)) )
//            lab.textAlignment = .center
//            lab.text = message
//            lab.font = UIFont(name: "PingFangSC-Regular", size: labH)
//            lab.textColor = UIColor(hexString: "#AAAAAA")
//            v.addSubview(lab)
//            lab.snp.makeConstraints { (maker) in
//                maker.top.equalTo(iv.snp.bottom).offset(20)
//                maker.centerX.equalTo(iv)
//            }
//            self.backgroundView = v
//        } else {
//            self.backgroundView = nil
//        }
    }
}

extension UICollectionView {
    func showNoDataView(with message: String, rowCount: NSInteger) {
//        if rowCount == 0 {
//            let v = UIView.init(frame: bounds)

//            let iv = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: imageW, height: imageH)))
//            iv.image = UIImage(named: "home_ic_nodata")
//            v.addSubview(iv)
//            iv.snp.makeConstraints {$0.center.equalToSuperview()}
//            let lab = UILabel.init(frame: CGRect(origin: .zero, size: CGSize(width: imageW, height: labH)) )
//            lab.textAlignment = .center
//            lab.text = message
//            lab.font = UIFont(name: "PingFangSC-Regular", size: labH)
//            lab.textColor = UIColor(hexString: "#AAAAAA")
//            v.addSubview(lab)
//            lab.snp.makeConstraints { (maker) in
//                maker.top.equalTo(iv.snp.bottom).offset(20)
//                maker.centerX.equalTo(iv)
//            }
//            self.backgroundView = v
//        } else {
//            self.backgroundView = nil
//        }
    }
}


