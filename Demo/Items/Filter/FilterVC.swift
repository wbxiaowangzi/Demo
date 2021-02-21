//
//  FilterVC.swift
//  Demo
//
//  Created by WangBo on 2020/12/2.
//  Copyright © 2020 wangbo. All rights reserved.
//

import UIKit

class FilterVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var topView: UIView!
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension FilterVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.lazyCellNames().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let name = self.lazyCellNames()[indexPath.row]
        cell.textLabel?.text = name
        return cell
    }
}

extension FilterVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let toValue = self.lazyCellNames()[indexPath.row]
        switch toValue {
        case self.lazyCellNames()[0]:
            self.blur()
        default:
            print("error target viewController")
        }
    }
}

extension FilterVC {
    /*
     {
     CLDefaultEmptyFilter,
     CISRGBToneCurveToLinear,
     CIVignetteEffect,
     CIPhotoEffectInstant,
     CIPhotoEffectProcess,
     CIPhotoEffectTransfer,
     CISepiaTone,
     CIPhotoEffectChrome,
     CIPhotoEffectFade,
     CILinearToSRGBToneCurve,
     CIPhotoEffectTonal,
     CIPhotoEffectNoir,
     CIPhotoEffectMono,
     CIColorInvert
     }
     */
    func lazyCellNames() -> Array<String> {
        return ["毛玻璃", "CISRGBToneCurveToLinear", "CIVignetteEffect","CIPhotoEffectInstant"]
    }
    
    private func blur() {
        let b = UIBlurEffect(style: .light)
        let v = UIVisualEffectView.init(effect: b)
        v.frame = imageView.bounds
        imageView.addSubview(v)
    }
    
}
