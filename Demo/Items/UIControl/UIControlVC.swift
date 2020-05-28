//
//  UIControlVC.swift
//  Demo
//
//  Created by WangBo on 2019/11/26.
//  Copyright © 2019 wangbo. All rights reserved.
//

import UIKit

class UIControlVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    private func segment(with titles: [String], frame: CGRect, superView:UIView) {
        let s = UISegmentedControl.init(items: titles)
        s.frame =  frame
        //s.setBackgroundImage(UIImage.color2UIImage(color: UIColor.init(hexString: "#3E97FF"), size: CGSize.init(width: 160, height: 46)), for: .selected, barMetrics: .default)
        //s.setBackgroundImage(UIImage.color2UIImage(color: UIColor.white, size: CGSize.init(width: 160, height: 46)), for: .normal, barMetrics: .default)
        let nd: [NSAttributedString.Key: Any] = [.font : UIFont.init(name: "PingFangSC-Regular", size: adaptH(22))!, .foregroundColor:UIColor.init(hexString: "#9B9B9B")]
        s.setTitleTextAttributes(nd, for: .normal)
        let sd: [NSAttributedString.Key: Any] = [.font : UIFont.init(name: "PingFangSC-Regular", size: adaptH(22))!, .foregroundColor:UIColor.white]
        s.setTitleTextAttributes(sd, for: .selected)
        s.selectedSegmentIndex = 0
        s.tintColor = UIColor.init(hexString: "#3E97FF")
        //s.addTarget(self, action: #selector(segmentValueChange(sender: )), for: .valueChanged)
        superView.addSubview(s)
    }
}
