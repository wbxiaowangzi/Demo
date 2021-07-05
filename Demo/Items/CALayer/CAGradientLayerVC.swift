//
//  CAGradientLayerVC.swift
//  Demo
//
//  Created by WangBo on 2019/11/8.
//  Copyright © 2019 wangbo. All rights reserved.
//

import UIKit

class CAGradientLayerVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.constructUI()
    }
    
    private func constructUI() {
        self.view.backgroundColor = .white
        let layer1 = CAGradientLayer()
        layer1.frame = CGRect.init(x: 50, y: 200, width: 200, height: 200)
        layer1.colors = [UIColor.red.cgColor, UIColor.green.cgColor]
        layer1.locations = [0, 1]
        layer1.startPoint = CGPoint(x: 0, y: 0)
        layer1.endPoint = CGPoint(x: 0, y: 1)
        self.view.layer.addSublayer(layer1)
        
        let layer2 = CAGradientLayer()
        layer2.frame = CGRect.init(x: 260, y: 200, width: 200, height: 200)
        layer2.colors = [UIColor.red.cgColor, UIColor.green.cgColor]
        layer2.locations = [0, 1]
        layer2.startPoint = CGPoint(x: 0, y: 0)
        layer2.endPoint = CGPoint(x: 1, y: 0)
        self.view.layer.addSublayer(layer2)
        
        let layer3 = CAGradientLayer()
        layer3.frame = CGRect.init(x: 50, y: 410, width: 200, height: 200)
        layer3.colors = [UIColor.red.cgColor, UIColor.green.cgColor]
        layer3.locations = [0, 1]
        layer3.startPoint = CGPoint(x: 1, y: 0)
        layer3.endPoint = CGPoint(x: 0, y: 0)
        self.view.layer.addSublayer(layer3)
        
        let layer4 = CAGradientLayer()
        layer4.frame = CGRect.init(x: 260, y: 410, width: 200, height: 200)
        layer4.colors = [UIColor.red.cgColor, UIColor.green.cgColor]
        layer4.locations = [0, 1]
        layer4.startPoint = CGPoint(x: 0, y: 1)
        layer4.endPoint = CGPoint(x: 1, y: 0.5)
        self.view.layer.addSublayer(layer4)
        
        let view5 = ElelidAdjustImageView.init(frame: CGRect.init(x: 260, y: 600, width: 200, height: 200))
        view5.backgroundColor = .red
        self.view.addSubview(view5)
        
    }

}

class ElelidAdjustImageView: UIView {

    private var imageLayer: CALayer?

    private var image: UIImage?

    private var panViews = [UIView]()

    private var movingV: UIView?

    private var shapeLayer: CAShapeLayer?

    private var startPoint: CGPoint?

    private var panBeginPoint: CGPoint?

    private var movepanView: UIView?

    private var rotation: CGFloat?
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.constructUI()
        //self.backgroundColor = .red
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder: ) has not been implemented")
    }
    
    private func constructUI() {
        self.drawBorderLine()
        self.drawImageLayer()
        self.addMovePan()
    }
    
    func updateImage(with image: UIImage?) {
        if self.image != image {
            self.image = image
            self.imageLayer?.contents = image?.cgImage
        }
    }
    
    private func drawImageLayer() {
        if self.imageLayer == nil {
            let layer = CALayer()
            layer.frame = self.bounds
            layer.backgroundColor = UIColor.clear.cgColor
            layer.contentsGravity = .resize
            self.layer.insertSublayer(layer, at: 1)
            self.imageLayer = layer
        }
        self.imageLayer?.frame = self.bounds
    }
    
    private func addMovePan() {
        if movepanView == nil {
            let v = UIView.init(frame: CGRect(x: 12, y: 12, width: self.bounds.width - 24, height: self.bounds.height - 24))
            self.addSubview(v)
            let pan = UIPanGestureRecognizer.init(target: self, action: #selector(moveSelfPan(pan: )))
            v.addGestureRecognizer(pan)
            self.movepanView = v
            let rotate = UIRotationGestureRecognizer.init(target: self, action: #selector(rotateAction(rotate: )))
            v.addGestureRecognizer(rotate)
        } else {
            self.movepanView!.frame = CGRect(x: 12, y: 12, width: self.bounds.width - 24, height: self.bounds.height - 24)
            self.bringSubviewToFront(movepanView!)
        }
        
    }
    
    @objc private func rotateAction(rotate: UIRotationGestureRecognizer) {
        let touchCount = rotate.numberOfTouches
        if touchCount <= 1 {return}
        self.rotate(with: rotate.rotation)
        rotate.rotation = 0
        
    }
    
    @objc private func moveSelfPan(pan: UIPanGestureRecognizer) {
        let touchCount = pan.numberOfTouches
        if touchCount > 1 {return}
        if pan.state == .began {
            panBeginPoint = pan.location(in: self.superview)
            startPoint = self.center
        } else if pan.state == .changed {
            guard panBeginPoint != nil, startPoint != nil else {
                panBeginPoint = pan.location(in: self.superview)
                startPoint = self.center
                return
            }
            let p = pan.location(in: self.superview)

            let o = CGPoint(x: p.x - panBeginPoint!.x, y: p.y - panBeginPoint!.y)//p - panBeginPoint!

            var c = self.center
            c = CGPoint(x: o.x + startPoint!.x, y: o.y + startPoint!.y)//startPoint! + o
            self.center = c
        } else if pan.state == .ended || pan.state == .cancelled {
            self.startPoint = nil
            self.panBeginPoint = nil
        }
    }
    
    private func drawBorderLine() {
        var ps = [CGPoint]()
        let space: CGFloat = 6
        let w = self.bounds.width
        let h = self.bounds.height
        let p1 = CGPoint(x: space, y: space)
        let p2 = CGPoint(x: w/2, y: space)
        let p3 = CGPoint(x: w - space, y: space)
        let p4 = CGPoint(x: w - space, y: h/2)
        let p5 = CGPoint(x: w - space, y: h - space)
        let p6 = CGPoint(x: w/2, y: h - space)
        let p7 = CGPoint(x: space, y: h - space)
        let p8 = CGPoint(x: space, y: h/2)
        
        ps = [p1, p2, p3,p4,p5,p6,p7,p8]
        
        ///shape layer
        self.drawShapeLayer(with: ps)
        ///pan view
        self.makeTouchPoints(with: ps)
    }
    
    private func centerPoint(with p1: CGPoint, p2: CGPoint) -> CGPoint {
        return CGPoint(x: (p1.x + p2.x)/2, y: (p1.y + p2.y)/2)
    }
    
    private func drawShapeLayer(with points: [CGPoint]) {
        self.shapeLayer?.removeFromSuperlayer()
        let shapeLayer = CAShapeLayer.init()
        shapeLayer.frame = self.bounds
        let path = UIBezierPath()
        path.lineWidth = 1
        path.move(to: points.first!)
        for p in points {
            if p == points.first {
                continue
            }
            if p == points.last {
                path.close()
            }
            path.addLine(to: p)
        }
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = UIColor.white.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        //shapeLayer.lineDashPattern = [6, 6, 6]
        self.layer.insertSublayer(shapeLayer, at: 1)
        self.shapeLayer = shapeLayer
    }
    
    private func makeTouchPoints(with centers: [CGPoint]) {
        for (index, center) in centers.enumerated() {
            if index > panViews.count - 1 {
                let v = UIView.init(frame: CGRect.init(origin: center, size: CGSize.init(width: 12, height: 12)))
                v.center = center
                v.backgroundColor = UIColor.init(hexString: "#3E97FF")
                v.tag = index
                //v.addCornersRadius(.allCorners, adaptH(6))
                if index == 0 {
                    v.backgroundColor = .yellow
                }
                let pan = UIPanGestureRecognizer.init(target: self, action: #selector(panAction(with: )))
                v.addGestureRecognizer(pan)
                self.addSubview(v)
                self.panViews.append(v)
            } else {
                panViews[index].center = center
                self.bringSubviewToFront(panViews[index])
            }
        }
    }
    
    @objc func panAction(with pan: UIPanGestureRecognizer) {
        if pan.state == .began {
        } else if pan.state == .changed {
            let p = pan.location(in: self)
            pan.view!.center = p
            self.movingV = pan.view!
            changeSelfFrame()
        } else if pan.state == .ended || pan.state == .cancelled {
            self.movingV = nil
        }
    }
    
    private func changeSelfFrame() {
        
        guard movingV != nil else {return}
        let t = self.transform
        self.transform = .identity
        var indexs = [Int]()
        switch movingV!.tag {
        case 0:
            indexs = [0, 0, 2,4,0,0]
        case 1:
            indexs = [0, 1, 2,4,0,1]
        case 2:
            indexs = [0, 2, 2,4,0,2]
        case 3:
            indexs = [0, 0, 3,4,0,2]
        case 4:
            indexs = [0, 0, 4,4,0,0]
        case 5:
            indexs = [0, 0, 2,5,0,0]
        case 6:
            indexs = [6, 0, 2,6,6,0]
        case 7:
            indexs = [7, 0, 2,4,7,0]
        default:
            break
        }
        let x = panViews[indexs[0]].frame.minX
        let y = panViews[indexs[1]].frame.minY
        let w = panViews[indexs[2]].frame.maxX - panViews[indexs[4]].frame.minX
        let h = panViews[indexs[3]].frame.maxY - panViews[indexs[5]].frame.minY
        let frame = CGRect(x: x , y: y , width: CGFloat(fabsf(Float(w ))), height: CGFloat(fabsf(Float(h ))))

        if let rect = self.superview?.convert(frame, from: self) {
            self.frame = rect
            self.transform = t
            self.constructUI()
        }
    }
    
    func hideOrShowLineBar() {
        let currentStatue = self.shapeLayer?.isHidden
        self.shapeLayer?.isHidden = !currentStatue!
        for v in self.panViews {
            v.isHidden = !currentStatue!
        }
    }
    
    ///旋转
    private func rotate(with angle: CGFloat) {
        self.transform = self.transform.rotated(by: angle)
    }
    
    ///计算三个点的夹角∠AOB
    private func getAngles(with pA: CGPoint, pO: CGPoint, pB:CGPoint) -> CGFloat {
        let x1 = pA.x - pO.x
        let y1 = pA.y - pO.y
        let x2 = pB.x - pO.x
        let y2 = pB.y - pO.y
        let x = x1*x2 + y1*y2
        let y = x1*y2 - x2*y1
        var angle = acos(x/sqrt(x*x+y*y))
        print(angle)
        if angle > CGFloat.pi {
            angle *= -1
        }
        print(angle)
        return angle
    }
}
