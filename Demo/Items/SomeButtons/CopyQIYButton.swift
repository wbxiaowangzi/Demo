//
//  LYCopyQIYButton.swift
//  点击Button水波纹效果
//
//  Created by Yoyo on 2018/4/23.
//  Copyright © 2018年 clearning. All rights reserved.
//

import UIKit

class CopyQIYButton: UIButton, CAAnimationDelegate {
    
    var strokColor:UIColor = UIColor.blue
    
    var lineWidth:CGFloat = 1.0
    
    var isAnimating = false
    
    let leftLineLayer = CAShapeLayer()
    
    let rightLintLayer = CAShapeLayer()
    
    let triangleLayer = CAShapeLayer()
    
    let arcLayer = CAShapeLayer()
    
    var buttonSize = CGSize(width: 0, height: 0)
    
    static let lineAnimationDuration: Float = 0.3
    
    static let transformAnimationDuration: Float = 0.5
    
    init(frame: CGRect, color:UIColor) {
        super.init(frame: frame)
        lineWidth = self.frame.size.width*0.2
        strokColor = color
        buttonSize = frame.size
//        self.backgroundColor = UIColor.black
        self.isSelected = true
        self.addTarget(self, action: #selector(stateChangeAction), for: UIControl.Event.touchUpInside)
        
        setupLeftLineLayer()
        setupRightLineLayer()
        setupTriangleLayer()
        setupArcLayer()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func stateChangeAction() {
        if !isAnimating {
            isAnimating = true
            if self.isSelected {
                //播放 !>
                self.isSelected = false
                linePlayAnimation()
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + TimeInterval(CopyQIYButton.lineAnimationDuration)) {
                    self.transformPlayAnimation()
                }
            } else {
                //暂停 !!
                self.isSelected = true
                transformPauseAnimation()
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + TimeInterval(CopyQIYButton.transformAnimationDuration)) {
                    self.linePauseAnimation()
                }
            }
            let time = CopyQIYButton.lineAnimationDuration+CopyQIYButton.transformAnimationDuration
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + TimeInterval(time)) {
                self.isAnimating = false
            }
        }
    }
    
    func addLayer(layer: CAShapeLayer, path: UIBezierPath, lineCap: String){
        layer.path = path.cgPath
        layer.lineJoin = CAShapeLayerLineJoin.round//圆形端点
        layer.lineCap = CAShapeLayerLineCap(rawValue: lineCap)//kCALineCapButt：无端点
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeColor = strokColor.cgColor
        layer.lineWidth = lineWidth
        self.layer.addSublayer(layer)
    }
    
    func setupLeftLineLayer() {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0.2*buttonSize.height, y: 0))
        path.addLine(to: CGPoint(x: 0.2*buttonSize.height, y: buttonSize.height))
        addLayer(layer: leftLineLayer, path: path, lineCap: CAShapeLayerLineCap.round.rawValue)
    }
    
    func setupRightLineLayer() {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0.8*buttonSize.height, y: 0))
        path.addLine(to: CGPoint(x: 0.8*buttonSize.height, y: buttonSize.height))
        addLayer(layer: rightLintLayer, path: path, lineCap: CAShapeLayerLineCap.round.rawValue)
    }
    
    func setupTriangleLayer() {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0.2*buttonSize.height, y: 0.2*buttonSize.height))
        path.addLine(to: CGPoint(x: 0.2*buttonSize.height, y: 0))
        path.addLine(to: CGPoint(x: buttonSize.height, y: 0.5*buttonSize.height))
        path.addLine(to: CGPoint(x: 0.2*buttonSize.height, y: buttonSize.height))
        path.addLine(to: CGPoint(x: 0.2*buttonSize.height, y: 0.2*buttonSize.height))
        triangleLayer.strokeEnd = 0//初始化式隐藏
        addLayer(layer: triangleLayer, path: path, lineCap: CAShapeLayerLineCap.round.rawValue)
    }
    
    func setupArcLayer() {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0.8*buttonSize.height, y: 0.8*buttonSize.height))
        path.addArc(withCenter: CGPoint(x: 0.5*buttonSize.height, y: 0.8*buttonSize.height), radius: 0.3*buttonSize.height, startAngle: 0, endAngle: CGFloat.pi, clockwise: true)
        arcLayer.strokeEnd = 0//初始化式隐藏
        addLayer(layer: arcLayer, path: path, lineCap: CAShapeLayerLineCap.butt.rawValue)
    }
    
    func setupAnimation(keyPath: String, from: Int, to: Int, layer:CAShapeLayer, duration: Float, animationName: String) {
        let animation = CABasicAnimation(keyPath: keyPath)
        if !(keyPath == "path") {
            //如果是strokeEnd、strokeStart
            animation.fromValue = from
            animation.toValue = to
        }
        animation.duration = TimeInterval(duration)
        animation.fillMode = CAMediaTimingFillMode.forwards
        animation.isRemovedOnCompletion = false
        animation.delegate = self
        //在代理方法里用anim.value(forKey:"animationName")获取动画名称
        animation.setValue(animationName, forKey: "animationName")
        layer.add(animation, forKey: "")
    }
    
    //播放动画，竖线
    func linePlayAnimation() {
        //左边线条缩短
        var path = UIBezierPath()
        path.move(to: CGPoint(x: 0.2*buttonSize.width, y: 0.4*buttonSize.width))
        path.addLine(to: CGPoint(x: 0.2*buttonSize.width, y: buttonSize.width))
        leftLineLayer.path = path.cgPath
        setupAnimation(keyPath: "path", from: 0, to: 0, layer: leftLineLayer, duration: CopyQIYButton.lineAnimationDuration/2, animationName: "leftLinePlayShrink")
        
        //右边线条上移
        path = UIBezierPath()
        path.move(to: CGPoint(x: 0.8*buttonSize.width, y: 0.8*buttonSize.width))
        path.addLine(to: CGPoint(x: 0.8*buttonSize.width, y: -0.2*buttonSize.width))
        rightLintLayer.path = path.cgPath
        setupAnimation(keyPath: "path", from: 0, to: 0, layer: rightLintLayer, duration: CopyQIYButton.lineAnimationDuration/2, animationName: "rightLinePlayUp")
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + TimeInterval(CopyQIYButton.lineAnimationDuration/2)) {
            //左线条上移
            path = UIBezierPath()
            path.move(to: CGPoint(x: 0.2*self.buttonSize.width, y: 0.8*self.buttonSize.width))
            path.addLine(to: CGPoint(x: 0.2*self.buttonSize.width, y: 0.2*self.buttonSize.width))
            self.leftLineLayer.path = path.cgPath
            self.setupAnimation(keyPath: "path", from: 0, to: 0, layer: self.leftLineLayer, duration: CopyQIYButton.lineAnimationDuration/2, animationName: "leftLinePlayUp")
            //右线条缩短
            path = UIBezierPath()
            path.move(to: CGPoint(x: 0.8*self.buttonSize.width, y: 0.8*self.buttonSize.width))
            path.addLine(to: CGPoint(x: 0.8*self.buttonSize.width, y: 0.2*self.buttonSize.width))
            self.rightLintLayer.path = path.cgPath
            self.setupAnimation(keyPath: "path", from: 0, to: 0, layer: self.rightLintLayer, duration: CopyQIYButton.lineAnimationDuration/2, animationName: "rightLinePlayUp")
        }
    }
    
    //播放动画，三角形，弧线
    func transformPlayAnimation() {
        //三角形从头到尾出现
        setupAnimation(keyPath: "strokeEnd", from: 0, to: 1, layer: triangleLayer, duration: CopyQIYButton.transformAnimationDuration, animationName: "trianglePlayFromTopShow")
        //弧线从头到尾出现
        setupAnimation(keyPath: "strokeEnd", from: 0, to: 1, layer: arcLayer, duration: CopyQIYButton.transformAnimationDuration/4, animationName: "arcPlayFromTopShow")
        //右线条从尾到头消失
        setupAnimation(keyPath: "strokeEnd", from: 1, to: 0, layer: rightLintLayer, duration: CopyQIYButton.transformAnimationDuration/4, animationName: "rightLinePlayFormBottomHidden")
        //弧线从头到尾消失
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + TimeInterval(CopyQIYButton.transformAnimationDuration/4)) {
            self.setupAnimation(keyPath: "strokeStart", from: 0, to: 1, layer: self.arcLayer, duration: CopyQIYButton.transformAnimationDuration/4, animationName: "arcPlayFromTopHidden")
        }
        //左线条从尾到头消失
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + TimeInterval(CopyQIYButton.transformAnimationDuration/2)) {
            self.setupAnimation(keyPath: "strokeEnd", from: 1, to: 0, layer: self.leftLineLayer, duration: CopyQIYButton.transformAnimationDuration/2, animationName: "leftLinePlayFromBottomHidden")
        }
    }
    
    //暂停动画，竖线
    func linePauseAnimation() {
        //左线条下移
        var path = UIBezierPath()
        path.move(to: CGPoint(x: 0.2*buttonSize.width, y: 0.4*buttonSize.width))
        path.addLine(to: CGPoint(x: 0.2*buttonSize.width, y: buttonSize.width))
        leftLineLayer.path = path.cgPath
        setupAnimation(keyPath: "path", from: 0, to: 0, layer: leftLineLayer, duration: CopyQIYButton.lineAnimationDuration/2, animationName: "leftLinePauseDown")
        //右线条向上伸长
        path = UIBezierPath()
        path.move(to: CGPoint(x: 0.8*buttonSize.width, y: 0.8*buttonSize.width))
        path.addLine(to: CGPoint(x: 0.8*buttonSize.width, y: -0.2*buttonSize.width))
        rightLintLayer.path = path.cgPath
        setupAnimation(keyPath: "path", from: 0, to: 0, layer: rightLintLayer, duration: CopyQIYButton.lineAnimationDuration/2, animationName: "rightLinePauseExtension")
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + TimeInterval(CopyQIYButton.lineAnimationDuration/2)) {
            //左线条向上延长
            path = UIBezierPath()
            path.move(to: CGPoint(x: 0.2*self.buttonSize.width, y: 0))
            path.addLine(to: CGPoint(x: 0.2*self.buttonSize.width, y: self.buttonSize.width))
            self.leftLineLayer.path = path.cgPath
            self.setupAnimation(keyPath: "path", from: 0, to: 0, layer: self.leftLineLayer, duration: CopyQIYButton.lineAnimationDuration/2, animationName: "leftLinePauseExtension")
            //右线条下移
            path = UIBezierPath()
            path.move(to: CGPoint(x: 0.8*self.buttonSize.width, y: self.buttonSize.width))
            path.addLine(to: CGPoint(x: 0.8*self.buttonSize.width, y: 0))
            self.rightLintLayer.path = path.cgPath
            self.setupAnimation(keyPath: "path", from: 0, to: 0, layer: self.rightLintLayer, duration: CopyQIYButton.lineAnimationDuration/2, animationName: "rightLinePauseDown")
        }
    }
    
    //暂停动画，三角形，弧线
    func transformPauseAnimation() {
        //三角形从尾到头消失
        setupAnimation(keyPath: "strokeEnd", from: 1, to: 0, layer: triangleLayer, duration: CopyQIYButton.transformAnimationDuration, animationName: "trianglePauseFromBottomHidden")
        //左线条从头到尾出现
        setupAnimation(keyPath: "strokeEnd", from: 0, to: 1, layer: leftLineLayer, duration: CopyQIYButton.transformAnimationDuration/2, animationName: "leftLinePauseFromTopShow")
        //弧线从尾到头出现
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + TimeInterval(CopyQIYButton.transformAnimationDuration/2)) {
            self.setupAnimation(keyPath: "strokeStart", from: 1, to: 0, layer: self.arcLayer, duration: CopyQIYButton.transformAnimationDuration/4, animationName: "ArcPauseFromBottomShow")
        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + TimeInterval(CopyQIYButton.transformAnimationDuration*3/4)) {
            //右线条从头到尾出现
            self.setupAnimation(keyPath: "strokeEnd", from: 0, to: 1, layer: self.rightLintLayer, duration: CopyQIYButton.transformAnimationDuration/4, animationName: "rightLinePauseFromTopShow")
            //弧线从尾到头消失
            self.setupAnimation(keyPath: "strokeEnd", from: 1, to: 0, layer: self.arcLayer, duration: CopyQIYButton.transformAnimationDuration/4, animationName: "arcPauseFromBottomHidden")
        }
    }
    
    //动画代理
    public func animationDidStart(_ anim: CAAnimation) {
        let name = anim.value(forKey:"animationName") as! String
        if name == "rightLinePauseFromTopShow" && self.isSelected {
            rightLintLayer.lineCap = CAShapeLayerLineCap.round
        }
        if name == "trianglePlayFromTopShow" && !self.isSelected {
            triangleLayer.lineCap = CAShapeLayerLineCap.round
        }
    }
    
    public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        let name = anim.value(forKey:"animationName") as! String
        if name == "rightLinePlayFormBottomHidden" && !self.isSelected  {
            rightLintLayer.lineCap = CAShapeLayerLineCap.butt
        }
        if name == "trianglePauseFromBottomHidden" && self.isSelected {
            triangleLayer.lineCap = CAShapeLayerLineCap.butt
        }
    }
}

enum QIYButtonState {
    case Pause
    case Play
}
