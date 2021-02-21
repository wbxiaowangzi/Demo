//
//  CoreAnimationVC.swift
//  Demo
//
//  Created by 王波 on 2018/6/10.
//  Copyright © 2018年 wangbo. All rights reserved.
//

import UIKit

class CoreAnimationVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var rightView: UIView!

    @IBOutlet weak var suspend: UIButton!

    private var implicitLayer: CALayer?
    
    lazy var animateView: UIView = {

        let v = UIView()
        v.backgroundColor = UIColor.brown
        v.frame = CGRect(x: 20, y: 50, width: 150, height: 150)
        return v
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        showAnimateView()
        
    }
    
    @IBAction func suspendClick(_ sender: Any) {
        if suspend.title(for: .normal) == "暂停" {
            self.suspendAnimation()
            suspend.setTitle("继续", for: .normal)
        } else {
            self.continueAnmation()
            suspend.setTitle("暂停", for: .normal)
        }
    }
    
    private func UI() {
        let layer = CALayer()
        layer.frame = CGRect(x: 100, y: 100, width: 100, height: 100)
        layer.backgroundColor = UIColor.red.cgColor
        self.view.layer.addSublayer(layer)
        self.implicitLayer = layer
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let point = touches.first?.location(in: self.view) else { return }
        if ((self.implicitLayer?.presentation()?.hitTest(point)) != nil) {
            implicitAnimation()
        } else {
            CATransaction.begin()
            CATransaction.setAnimationDuration(4.0)
            implicitLayer?.position = point
            CATransaction.commit()
        }
    }
}

extension CoreAnimationVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.lazyCellNames().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let name = self.lazyCellNames()[indexPath.row]
        cell.textLabel?.text = name
        cell.textLabel?.adjustsFontSizeToFitWidth = true
        return cell
    }
}

extension CoreAnimationVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let toValue = self.lazyCellNames()[indexPath.row]
        switch toValue {
        case "抖一抖":
            showShakeAnimation()
        case "转一转":
            showRotateAnimation()
        case "换一换":
            showTransitionAnimation()
        case "隐式动画":
            implicitAnimation()
        default:
            print("to be continued")
        }
    }
}

extension CoreAnimationVC {
    
    func lazyCellNames() -> Array<String> {
        return ["抖一抖", "转一转", "换一换","隐式动画"]
    }
    
}

extension CoreAnimationVC {
    
    func showAnimateView() {
        let centerX = rightView.frame.size.width/2

        let centerY = rightView.frame.size.height/2
        self.animateView.center = CGPoint(x: centerX, y: centerY)
        print(animateView.center, rightView.center, rightView.frame)
        animateView.alpha = 0
        self.rightView.addSubview(self.animateView)
        UIView.animate(withDuration: 0.2) {
            self.animateView.alpha = 1
        }
        
    }
    
    func showShakeAnimation() {
        //print("抖一抖")
        let shake = CAKeyframeAnimation(keyPath: "transform.rotation")
        shake.duration = 0.3
        shake.values = [(-4/180.0*Double.pi), (4/180.0*Double.pi), (-4/180.0*Double.pi)]
        shake.repeatCount = 10
        
        animateView.layer.add(shake, forKey: "shakeAnimation")
    }
    
    func showRotateAnimation() {
        //print("转一转")
        let pathA = CAKeyframeAnimation(keyPath: "position")

        let path = UIBezierPath()
        path.move(to: animateView.layer.position)
        path.addCurve(to: CGPoint(x: 300, y: 400), controlPoint1: CGPoint(x: 100, y: 200), controlPoint2: CGPoint(x: 200, y: 250))
        pathA.path = path.cgPath
        pathA.duration = 5
        
        animateView.layer.add(pathA, forKey: "bezier path animation")
    }
    
    func showTransitionAnimation() {
        let t = CATransition()
        t.type = convertToCATransitionType("oglFlip")
        t.subtype = CATransitionSubtype.fromLeft
        t.duration = 5
        
        let isRed = (animateView.layer.backgroundColor == UIColor.red.cgColor)
        if isRed {
            animateView.layer.backgroundColor = UIColor.brown.cgColor
        } else {
            animateView.layer.backgroundColor = UIColor.red.cgColor
        }
        animateView.layer.add(t, forKey: "transtion animation")
    }
    
    private func implicitAnimation() {
        let r = CGFloat.random(in: 1...256)/256.0
        let g = CGFloat.random(in: 1...256)/256.0
        let b = CGFloat.random(in: 1...256)/256.0
        implicitLayer?.backgroundColor = UIColor(red: r, green: g, blue: b, alpha: 1.0).cgColor
    }
}

extension CoreAnimationVC {
    private func suspendAnimation() {
        let pausedTime = animateView.layer.convertTime(CACurrentMediaTime(), from: nil)
        animateView.layer.speed = 0.0
        animateView.layer.timeOffset = pausedTime
    }
    
    private func continueAnmation() {
        let pausedTime = animateView.layer.timeOffset
        animateView.layer.speed = 1.0
        
        ///修改为默认值
        animateView.layer.timeOffset = 0.0
        animateView.layer.beginTime = 0.0
        
        let timeSincePause = animateView.layer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        animateView.layer.beginTime = timeSincePause
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToCATransitionType(_ input: String) -> CATransitionType {
	return CATransitionType(rawValue: input)
}
