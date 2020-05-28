//
//  UINavigation+Extension.swift
//  Mirage3D
//
//  Created by YingZi on 2019/1/3.
//  Copyright © 2019 影子. All rights reserved.
//

import Foundation
import UIKit

extension UINavigationBar {
    
    func setBackgroundColor(color: UIColor) -> Void {
        let barView = UIView.init(frame: CGRect(x: 0, y: -20, width: UIScreen.main.bounds.size.width, height: 84))
        barView.backgroundColor = color
        self.setValue(barView, forKey: "backgroundView")
    }
    
}

extension UINavigationItem {
    func title(_ title: String, _ color: UIColor = UIColor.black) -> Void {
        let label = UILabel.init(frame: CGRect(x: 0, y: 0, width: 100, height: 44))
        label.text = title
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = color
        label.textAlignment = .center
        self.titleView = label
    }
}

