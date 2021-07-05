//
//  PPVC.swift
//  Demo
//
//  Created by WangBo on 2021/4/15.
//  Copyright © 2021 wangbo. All rights reserved.
//

import UIKit

class PPVC: UIViewController {

    @IBOutlet weak var topView: UIView!
    
    @IBOutlet weak var transButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func printClick(_ sender: Any) {
        let name = "皮肤报告.pdf"
        let path = Bundle.main.path(forResource: name, ofType: nil)
        guard path != nil else {
            print("报告为空")
            return
        }
        let data = try? Data(contentsOf: URL(fileURLWithPath: path!))
        guard data != nil else {
            print("报告为空")
            return
        }
        let pinfo = UIPrintInfo.printInfo()
        pinfo.outputType = .general
        pinfo.jobName = name
        pinfo.duplex = .longEdge
        
        let pvc = UIPrintInteractionController.shared
        pvc.printInfo = pinfo
        pvc.printingItem = data
        
        pvc.present(animated: true) { (vc, completed, error) in
            if completed {
                print("打印成功")
            } else if !completed && error != nil {
                print("打印失败：\(error!.localizedDescription)")
            }
        }
    }
    
    @IBAction func trans(_ sender: Any) {
        let name = "皮肤报告.pdf"
        let path = Bundle.main.path(forResource: name, ofType: nil)
        guard path != nil else {
            print("报告为空")
            return
        }
        let data = try? Data(contentsOf: URL(fileURLWithPath: path!))
        let vc = UIActivityViewController.init(activityItems: [data!], applicationActivities: nil)
        vc.excludedActivityTypes = [.print]
        let pop = vc.popoverPresentationController
        pop?.sourceView = self.transButton
        
        self.present(vc, animated: true, completion: nil)
    }

}
