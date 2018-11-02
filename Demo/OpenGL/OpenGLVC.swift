//
//  OpenGLVC.swift
//  Demo
//
//  Created by YingZi on 2018/11/2.
//  Copyright © 2018 wangbo. All rights reserved.
//

import UIKit

class OpenGLVC: UIViewController {
    
    
    var contentView:DrawingBoardView?
    @IBOutlet weak var drawView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        addDrawView()
    }
    func addDrawView() {
        guard contentView == nil else {
            return
        }
        let context = EAGLContext.init(api: EAGLRenderingAPI.openGLES1)
        let v = DrawingBoardView.init(frame: drawView.bounds, context: context!)
        drawView.addSubview(v)
        contentView = v
    }
    
    @IBAction func blackClick(_ sender: Any) {
        if let c = contentView{
            c.setPenColor(color: UIColor.black)
        }
    }
    
    @IBAction func redClick(_ sender: Any) {
        if let c = contentView{
            c.setPenColor(color: UIColor.red)
        }
    }
    
    @IBAction func yellowClick(_ sender: Any) {
        if let c = contentView{
            c.setPenColor(color: UIColor.yellow)
        }
    }
    @IBAction func blueClick(_ sender: Any) {
        if let c = contentView{
            c.setPenColor(color: UIColor.blue)
        }
        
    }
    
    @IBAction func stepBackClick(_ sender: Any) {
        if let c = contentView{
            c.remove()
        }
    }
}
