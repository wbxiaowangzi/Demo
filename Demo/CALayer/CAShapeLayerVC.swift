//
//  CAShapeLayer.swift
//  Demo
//
//  Created by YingZi on 2018/11/1.
//  Copyright © 2018 wangbo. All rights reserved.
//

import UIKit

class CAShapeLayerVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        drawSomething()
    }
    
    fileprivate func drawSomething(){
        
        let scoreLayer = CAShapeLayer()
        let radarViewW = 400
        let radarViewH = 400
        let featureCount = 5
        let radius = CGFloat(100)
        let centerPoint = view.center
        scoreLayer.frame = CGRect(x: 0, y: 0, width: radarViewW, height: radarViewH)
        view.layer.addSublayer(scoreLayer)
        let angle = CGFloat.pi*CGFloat(2)/CGFloat(featureCount)
        var points = [CGPoint]()
        var lengths = [CGFloat]()
        for i in 0..<featureCount{
            let realRadius = radius
            let apa = CGFloat.pi/2.0 + CGFloat(i)*angle
            let px = centerPoint.x + realRadius*cos(apa)
            let py = centerPoint.y + realRadius*sin(apa)
            points.append(CGPoint(x: px, y: py))
            lengths.append(realRadius)
        }
        let path = UIBezierPath()
        path.move(to: points.first!)
        for p in points{
            if p == points.first{
                continue
            }
            path.addLine(to: p)
            if p == points.last{
                path.close()
            }
        }
        
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = 0.5
        scoreLayer.add(animation, forKey: "transform.scale")
        
        scoreLayer.path = path.cgPath
        scoreLayer.strokeColor = UIColor(hexString: "#3E97FF").cgColor
        scoreLayer.fillColor = UIColor(hexString: "#3E97FF").withAlphaComponent(0.3).cgColor
        
    }
    
}
