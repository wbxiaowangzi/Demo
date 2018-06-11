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
    
    lazy var animateView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.brown
        v.frame = CGRect(x: 20, y: 50, width: 150, height: 150)
        return v
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        showAnimateView()
        
    }
}

extension CoreAnimationVC: UITableViewDataSource{
    
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
        default:
            print("to be continued")
        }
    }
}

extension CoreAnimationVC{
    
    func lazyCellNames() -> Array<String>{
        return ["抖一抖","转一转","换一换"]
    }
    
}

extension CoreAnimationVC {
    
    func showAnimateView() {
        let centerX = rightView.frame.size.width/2
        let centerY = rightView.frame.size.height/2
        self.animateView.center = CGPoint(x: centerX, y: centerY)
        print(animateView.center,rightView.center,rightView.frame)
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
        shake.values = [(-4/180.0*Double.pi),(4/180.0*Double.pi),(-4/180.0*Double.pi)]
        shake.repeatCount = 10
        
        animateView.layer.add(shake, forKey: "shakeAnimation")
    }
    
    func showRotateAnimation(){
        print("转一转")
        let pathA = CAKeyframeAnimation(keyPath: "position")
        let path = UIBezierPath()
        path.move(to: animateView.layer.position)
        path.addCurve(to: CGPoint(x: 300, y: 400), controlPoint1: CGPoint(x: 100, y: 200), controlPoint2: CGPoint(x: 200, y: 250))
        pathA.path = path.cgPath
        pathA.duration = 1
        
        animateView.layer.add(pathA, forKey: "bezier path animation")
    }
    
    func showTransitionAnimation(){
        let t = CATransition()
        t.type = "oglFlip"
        t.subtype = kCATransitionFade
        t.duration = 1
        
        let isRed = (animateView.layer.backgroundColor == UIColor.red.cgColor)
        if isRed {
            animateView.layer.backgroundColor = UIColor.brown.cgColor
        }else {
            animateView.layer.backgroundColor = UIColor.red.cgColor
        }
        animateView.layer.add(t, forKey: "transtion animation")
    }
}


