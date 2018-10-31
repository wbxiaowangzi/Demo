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
    fileprivate let layerFloorCount = 6
    //绘制需要用到的数据
    fileprivate var radius:CGFloat!
    fileprivate var radarViewW:CGFloat!
    fileprivate var radarViewH:CGFloat!
    fileprivate var centerPoint:CGPoint!
    fileprivate var path = UIBezierPath()
    fileprivate var featureLabH = CGFloat(50)
    fileprivate var featureLabW = CGFloat(50)
    fileprivate var scorePoints:[CGPoint]!
    fileprivate var featurePoints:[CGPoint]!
    fileprivate var strokeLineW:CGFloat{
        get {
            return radius/2/CGFloat(layerFloorCount)
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
        radarViewH = frame.size.height - featureLabH*CGFloat(2)
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
        layer.strokeColor = UIColor.white.cgColor
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
        for i in 0..<featureCount{
            let realRadius = radius! * CGFloat(CGFloat(radarDatas![i].score)/100)
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
        scoreLayer.path = path.cgPath
        scoreLayer.strokeColor = UIColor(hexString: "#3E97FF").cgColor
        scoreLayer.fillColor = UIColor(hexString: "#3E97FF").withAlphaComponent(0.3).cgColor
        scorePoints = points
    }
    
    fileprivate func deawLabAndCircle(){
        
        if let fps = featurePoints{
            //画特征lab
        }
        
        if let sps = scorePoints{
            //画分数圆圈和lab
        }
    }
}

struct RadarModel {
    var name:String! = "特征"
    //满分100分
    var score:NSInteger! = 55

}
