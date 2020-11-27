//
//  ButtonsVC.swift
//  Demo
//
//  Created by WangBo on 2020/11/5.
//  Copyright © 2020 wangbo. All rights reserved.
//

import UIKit

class ButtonsVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //水波纹效果
        let button: WaveTouchButton = WaveTouchButton(type: UIButton.ButtonType.custom)
        button.frame = CGRect(x: 50, y: 60, width: 250, height: 100)
        button.hightLightColor = UIColor(red: 61.0/255.0, green: 168.0/255.0, blue: 250.0/255.0, alpha: 1)
        button.backgroundColor = UIColor(red: 247.0/255.0, green: 197.0/255.0, blue: 52.0/255.0, alpha: 1)
        button.setTitle("点我", for: UIControl.State.normal)
        self.view.addSubview(button)
        
        //仿支付宝支付效果
        let aliPayButton = CopyAliPayButton(frame: CGRect(x: 20, y: 200, width: 330, height: 60), backgroundColor: UIColor(red: 61.0/255.0, green: 168.0/255.0, blue: 250.0/255.0, alpha: 1))
        self.view.addSubview(aliPayButton)
        
        //仿爱奇艺播放暂停按钮
        let qIYButton = CopyQIYButton(frame: CGRect(x: 100, y: 340, width: 100, height: 100), color:UIColor(red: 61.0/255.0, green: 168.0/255.0, blue: 250.0/255.0, alpha: 1))
        self.view.addSubview(qIYButton)
        
        //仿苹果的全局浮动按钮
        let b = MIMoveButton(frame: CGRect(x: 100, y: 500, width: 100, height: 100))
        b.backgroundColor = .black
        self.view.addSubview(b)
        
        let ss = STSegmentView.init(frame: CGRect(x: 100, y: 600, width: 200, height: 50))
        ss.titleArray = ["one","two"]
        ss.backgroundColor = .clear
        ss.selectedBackgroundColor = .red
        ss.topLabelTextColor = .yellow
        ss.bottomLabelTextColor = .purple
        ss.selectedBgViewCornerRadius = 25
        self.view.addSubview(ss)
        
        let ds = DWSegmentedControl.init(frame: CGRect(x: 10, y: 660, width: 200, height: 50))
        ds.backgroundColor = .white
        ds.selectedViewColor = .red
        ds.normalLabelColor = .green
        ds.titles = ["one","two"]
        self.view.addSubview(ds)
        
        let seg1 = MISegment(frame: CGRect.init(x: 210, y: 660, width: 200, height: 50),
                             titles: ["3D影像", "皮肤数据"],
                             selectedItemBackgroundColor: UIColor.init(hexString: "#0372FF"),
                             normalItemBackgroundColor: .white,
                             selectedItemTitleColor: .white,
                             normalItemTitleColor: UIColor.init(hexString: "#414550"),
                             itemCornetRadius: adaptW(25))
        seg1.layer.borderWidth = 1
        seg1.layer.borderColor = UIColor.init(hexString: "#0372FF").cgColor
        self.view.addSubview(seg1)
        seg1.selectedValueChangeBlock = { [weak self] tag in
            print(tag)
        }
    }

}
