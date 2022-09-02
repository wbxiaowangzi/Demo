//
//  AnomalyButtonVC.swift
//  SimulatorDemo
//
//  Created by WangBo on 2022/8/30.
//  Copyright © 2022 wangbo. All rights reserved.
//

import UIKit

class AnomalyButtonVC: UIViewController {
    
    @IBOutlet weak var theView: UIView!
    private var analyzeTexture: MIAnalyzeAreaTexture?

    override func viewDidLoad() {
        super.viewDidLoad()
        ui()
    }

}

extension AnomalyButtonVC {
    private func ui() {
        analyzeTexture = MIAnalyzeAreaTexture.init(rect: theView.bounds)
        analyzeTexture?.delegate = self
        theView.addSubview(analyzeTexture!.view)
        reloadModelView()
    }
    
    private func reloadModelView() {
    let arr = [("p2_009_001",true),("p2_002_002",true),("p2_010_008",true),("p2_009_007",true),("p2_003_038",true),("p2_004_029",true),
               ("p1_14_006",true),("p2_001_001",true)]
//        analyzeTexture?.showFeatures(value: arr)
        analyzeTexture?.showAllFeatures()
    }
}

extension AnomalyButtonVC: MIAnalyzeAreaTextureDelegate {
    
    func analyzeTexture(selectPart: String, features: [String]) {
        print(selectPart)
    }
}
