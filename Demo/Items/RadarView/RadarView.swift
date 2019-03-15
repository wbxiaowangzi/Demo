//
//  RadarView.swift
//  Demo
//
//  Created by YingZi on 2018/10/30.
//  Copyright © 2018 wangbo. All rights reserved.
//

import UIKit

class RadarView: UIView {
    
    fileprivate var radarData:[RadarModel]!
    fileprivate var featureCount: NSInteger {
        get {
            return radarData.count
        }
    }
    fileprivate let layerFloorCount = 5
    //绘制需要用到的数据
    fileprivate var radius:CGFloat!
    fileprivate var radarViewW:CGFloat!
    fileprivate var radarViewH:CGFloat!
    fileprivate var centerPoint:CGPoint!
    fileprivate var path = UIBezierPath()
    fileprivate var featureLabH = CGFloat(20)
    fileprivate var featureLabW = CGFloat(40)
    fileprivate var scorePoints:[CGPoint]!
    fileprivate var featurePoints:[CGPoint]!
    fileprivate var strokeLineW:CGFloat{
        get {
            return radius/CGFloat(layerFloorCount)
        }
    }
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience  init(frame: CGRect,radarData:[RadarModel]) {
        self.init(frame: frame)
        backgroundColor = .black
        self.radarData = radarData
        centerPoint = CGPoint(x: frame.size.width/2, y: frame.size.height/2)
        radarViewH = frame.size.height - max(featureLabW, featureLabH)*CGFloat(2)
        radarViewW = radarViewH
        radius = radarViewW/2
        drawRadar()
    }
    
    /**
     分两步画
     1，画背景蜘蛛网图
     2，画分数图
     **/
    fileprivate func drawRadar() {
        drawRadarBackView(with: self.radarData.count)
        drawScoreView(with: self.radarData)
        deawLabAndCircle()
    }
    
}

extension RadarView{
    fileprivate func  drawRadarBackView(with featureCount:NSInteger?){
        guard featureCount != nil else {
            return
        }
        for i in 0..<layerFloorCount{
            let shapeLayer = CAShapeLayer()
            shapeLayer.frame = CGRect(x: 0, y: 0, width: radarViewW, height: radarViewH)
            layer.addSublayer(shapeLayer)
            setBackSpiderLayer(layer: shapeLayer, value: CGFloat(i)*0.2, index: i)
        }
    }
    
    fileprivate func setBackSpiderLayer(layer:CAShapeLayer,value:CGFloat,index:NSInteger){
        let realRadius = radius - (strokeLineW * CGFloat(index))
        let angle = CGFloat.pi*CGFloat(2)/CGFloat(featureCount)
        var points = [CGPoint]()
        for i in 0..<featureCount{
            let apa = CGFloat.pi/2.0 + CGFloat(i)*angle
            let px = centerPoint.x + realRadius*cos(apa)
            let py = centerPoint.y + realRadius*sin(apa)
            points.append(CGPoint(x: px, y: py))
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
        layer.path = path.cgPath
        //layer.strokeColor = UIColor.white.cgColor
        layer.fillColor = UIColor(hexString: "#FFFFFF").withAlphaComponent(0.3).cgColor
        if index == 0{
            featurePoints = points
        }
    }
}

extension RadarView{
    
    fileprivate func drawScoreView(with radarDatas:[RadarModel]?) {
        guard radarDatas != nil else {
            return
        }
        let scoreLayer = CAShapeLayer()
        scoreLayer.frame = CGRect(x: 0, y: 0, width: radarViewW, height: radarViewH)
        layer.addSublayer(scoreLayer)
        let angle = CGFloat.pi*CGFloat(2)/CGFloat(featureCount)
        var points = [CGPoint]()
        var lengths = [CGFloat]()
        for i in 0..<featureCount{
            let realRadius = radius! * CGFloat(CGFloat(radarDatas![i].score)/100)
            let apa = CGFloat.pi/2.0 + CGFloat(i)*angle
            let px = centerPoint.x + realRadius*cos(apa)
            let py = centerPoint.y + realRadius*sin(apa)
            points.append(CGPoint(x: px, y: py))
            lengths.append(realRadius)
        }
        scorePoints = points
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
    
    fileprivate func deawLabAndCircle(){
        
        if let fps = featurePoints{
            //画特征lab
            for i in 0..<fps.count{
                let model = radarData[i]
                let p = transportPointToCenter(point: fps[i])
                let lab = UILabel(frame: CGRect(x: 0, y: 0, width: featureLabW, height: featureLabH))
                lab.text = model.name
                lab.textAlignment = .center
                lab.center = p
                lab.font = UIFont(name: "PingFangSC-Medium", size: 16)
                lab.textColor = UIColor.white
                addSubview(lab)
            }
        }
        
        if let sps = scorePoints{
            //画分数圆圈和lab
            for i in 0..<sps.count{
                let model = radarData[i]
                let c = sps[i]
                drawCircle(with: c)
                let p = transportPointToCenter(point: c, isScore: true)
                let lab = UILabel(frame: CGRect(x: 0, y: 0, width: featureLabW, height: featureLabH))
                lab.textAlignment = .center
                lab.text = "\(model.score!)"
                lab.center = p
                lab.font = UIFont(name: "PingFangSC-Medium", size: 20)
                lab.textColor = UIColor(hexString: "#3E97FF")
                addSubview(lab)
            }
        }
    }
    
    fileprivate func drawCircle(with center:CGPoint){
        let path = UIBezierPath()
        path.addArc(withCenter: center, radius: 3, startAngle: 0, endAngle: CGFloat(2*Float.pi), clockwise: true)
        let layer = CAShapeLayer()
        layer.path = path.cgPath
        layer.strokeColor = UIColor(hexString: "#3E97FF").cgColor
        layer.fillColor = UIColor.white.cgColor
        self.layer.addSublayer(layer)
    }
    
    fileprivate func transportPointToCenter(point:CGPoint,isScore:Bool = false) ->CGPoint{
        let cx = centerPoint.x
        let cy = centerPoint.y
        var space = CGFloat(16)
        if isScore{
            space = 0
        }
        var center = point
        if fabsf(Float(point.x - cx)) < 5.0 {
            if point.y > cy{
                center.y += featureLabH/2 + space
            }else{
                center.y -= featureLabH/2 + space
            }
        }else if point.x > cx{
            center.x += featureLabW/2 + space
        }else{
            center.x -= featureLabW/2 + space
        }
        
        return center
    }
}

struct RadarModel {
    var name:String! = "特征"
    //满分100分
    var score:NSInteger! = 55
    
}
