//
//  MIAnalyzeAreaTexture.swift
//  MIHousekeeper
//
//  Created by 影子 on 2020/3/30.
//  Copyright © 2020 影子. All rights reserved.
//

import Foundation
import UIKit

/// 分析场景callback
public protocol MIAnalyzeAreaTextureDelegate: NSObjectProtocol {
    /// 当有面部区域被选中时该方法会被调用
    /// selectPart: 选中的区域名称
    /// features: 选中的区域包含的特征列表
    func analyzeTexture( selectPart: String, features: [String])
}

public class MIAnalyzeAreaTexture: NSObject {
    
    var view: UIView!

    ///底图
    var imageView: UIImageView!
    var tipsImageViews: [UIButton] = []
    var isEnabelHit: Bool = true

    var texture: UIImage!
    var modifyTexture: UIImage?
    
    private var instance_id: Int?
    
    private var showFeatures: [String] = []

    private var featurePartDic: [String: AnalyzePartModel] = [: ]

    private var selectPart: AnalyzePartModel?

    private var currentShowFeature: [AnalyzeFeatureModel] = []

    public weak var delegate: MIAnalyzeAreaTextureDelegate?
    
    var scale: CGFloat = 1

    var pos: CGPoint?

    private var pan: UIPanGestureRecognizer!
    
    var tips: UILabel!
    
    public init(rect: CGRect) {
        super.init()
        view = UIView.init(frame: rect)
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.blue.cgColor
        view.backgroundColor = .white
        imageView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: rect.width, height: rect.width))
        imageView.center = CGPoint.init(x: rect.width/2, y: rect.height/2)
        imageView.contentMode = .scaleAspectFill
        view.addSubview(imageView)
        
        texture = UIImage.init(named: "Resource/analyzeDiseTexture.jpg")
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapHandle(_: )))

        let pinch = UIPinchGestureRecognizer.init(target: self, action: #selector(pinchHandle(_: )))
        pan = UIPanGestureRecognizer.init(target: self, action: #selector(panHandle(_: )))
        view.addGestureRecognizer(pinch)
        view.addGestureRecognizer(tap)
        
        let l1 = UILabel.init(frame: CGRect(x: 42, y: 9, width: 144, height: 18))
        l1.text = "请先选择品项"
        l1.textColor = .gray
        l1.font = UIFont.systemFont(ofSize: 16)
        view.addSubview(l1)

        tips = l1
    }
    
    @objc func tapHandle(_ sender: UITapGestureRecognizer) {
        guard isEnabelHit else { return }
        
        let location = sender.location(in: imageView)
        let textureW = texture.size.width
        let textureH = texture.size.height
        
        let point = CGPoint.init(x: location.x/imageView.bounds.width * textureW, y: location.y/imageView.bounds.height * textureH)
        
        var nearestPartModel: AnalyzePartModel?
        var minimizeDistence: CGFloat = 1000
        
        for item in featurePartDic.values {
            let hit1 = hitPart(width: textureW, height: textureH, rect: item.rect, point: point)
            guard hit1.0 else { continue }
            if  hit1.1 < minimizeDistence {
                nearestPartModel = item
                minimizeDistence = hit1.1
            }
        }
        guard let t = nearestPartModel else { return }
        
        if selectPart?.partName == t.partName {
            selectPart = nil
            drawTextureAndReplace()
            let arr = showFeatures
            delegate?.analyzeTexture(selectPart: t.partName, features: arr)
            return
        }
        
        selectPart = t
        drawTextureAndReplace()
        let dic = AnalyzeAreaConfig.share.featureDic
        var featureArr: [String] = []
        for f in showFeatures {
            if dic[f]?.part.contains(t.partName) ?? false {
                featureArr.append(f)
            }
        }
        delegate?.analyzeTexture(selectPart: t.partName, features: featureArr)
    }
    
    @objc func panHandle(_ sender: UIPanGestureRecognizer) {
        if sender.state == .began {
            pos = imageView.center
        }
        
        if sender.state == .changed && pos != nil {
            let velocity = sender.translation(in: view)

            let p =  CGPoint(x: pos!.x+velocity.x, y: pos!.y + velocity.y)

            let width = imageView.bounds.width * scale

            let height = imageView.bounds.height * scale
            if p.x < -width || p.x > width || p.y < -height || p.x > height {
                return
            }
            imageView.center = p
        }
        
        if sender.state == .cancelled {
            pos = nil
        }
    }
    
    @objc func pinchHandle(_ sender: UIPinchGestureRecognizer) {
        if sender.state == .changed {
            let s = scale * sender.scale
            if s < 0.3 || s > 2.5 {
                return
            }
            scale = s
            imageView.transform = CGAffineTransform.init(scaleX: scale, y: scale)
        }
        
        if sender.state == .cancelled || sender.state == .ended {
            if scale > 1.3 {
                view.removeGestureRecognizer(pan)
                view.addGestureRecognizer(pan)
            }
            
            if scale <= 1 {
                view.removeGestureRecognizer(pan)
                UIView.animate(withDuration: 0.3, animations: {
                    self.imageView.transform = CGAffineTransform.init(scaleX: 1, y: 1)
                    self.imageView.center = CGPoint.init(x: self.view.bounds.width/2, y: self.view.bounds.height/2)
                }) { (b) in
                    self.scale = 1
                }
            }
        }
        
        sender.scale = 1
    }
    
    private func hitPart(width: CGFloat, height: CGFloat, rect: CGRect, point: CGPoint) -> (Bool, CGFloat) {
        let r = rect
        let x = point.x
        let y = point.y
        
        if x > r.minX && x < r.maxX && y > r.minY && y < r.maxY {
            let p = CGPoint.init(x: point.x-rect.midX, y: point.y-rect.midY)

            let distence = sqrt(p.x/rect.width * p.x/rect.width + p.y/rect.height * p.y/rect.height)
            return (true, distence)
        }
        return (false, CGFloat.infinity)
    }
    
    private func drawTextureAndReplace() {
        guard texture != nil else {
            return
        }
        
        var result: UIImage
        UIGraphicsBeginImageContext(texture.size)
        texture.draw(at: CGPoint(), blendMode: .color, alpha: 1)
        for cell in featurePartDic.values {
            
            var alpha: CGFloat = 0.4
            if cell.partName == selectPart?.partName {
                alpha = 1
            }
            
            if cell.isMirror {
                cell.textureRight?.draw(in: cell.rect, blendMode: CGBlendMode.multiply, alpha: alpha)
            } else {
                cell.texture?.draw(in: cell.rect, blendMode: CGBlendMode.multiply, alpha: alpha)
            }
            
        }
        
        result = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        if self.modifyTexture == imageView.image{
            imageView.image = result
        }
        self.modifyTexture = result
    }
    
    @objc private func onTextureBtnClick(_ sender: UIButton){
        for item in tipsImageViews{
            item.layer.borderColor = UIColor.white.cgColor
        }
        
        isEnabelHit = sender.restorationIdentifier == "-1"
        sender.layer.borderColor = UIColor.blue.cgColor
        if sender.restorationIdentifier == "-1"{
            self.imageView.image = modifyTexture
        }else{
            let image = sender.backgroundImage(for: .normal)
            self.imageView.image = image
        }
    }
    
    private func removeAllTipsView(){
        isEnabelHit = true
        for item in tipsImageViews{
            item.removeFromSuperview()
        }
        tipsImageViews.removeAll()
    }
}

extension MIAnalyzeAreaTexture{
    
    /// 需要展示的id列表
    func showFeatures(value: [(String, Bool)]) {
        showFeatures = value.map({$0.0})
        featurePartDic.removeAll()
        for item in value {
            let parts = AnalyzeAreaConfig.share.getPartByFeature(feature: item.0)
//            let parts = AnalyzeAreaConfig.share.getAllPart()
            if parts.count > 0 {
                for var part in parts {
                    if item.1 {
                        part.setMirror(item.1)
                        featurePartDic[part.partName] = part
                    } else if featurePartDic[part.partName] == nil {
                        featurePartDic[part.partName] = part
                    }
                }
            } else {
                print("分析模型错误：找不到对应的区域图片  feature_id: \(item)")
            }
        }
        drawTextureAndReplace()
    }
    
    func showAllFeatures() {
        featurePartDic.removeAll()
        let parts = AnalyzeAreaConfig.share.getAllPart()
        if parts.count > 0 {
            for var part in parts {
                part.setMirror(true)
                featurePartDic[part.partName] = part
            }
        }
        drawTextureAndReplace()
    }
    
    private func addTipsBtn(url: String?, id: Int, y: CGFloat){
        let btn = UIButton.init(frame: CGRect(x: 729, y: y, width: 55, height: 53))
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor.white.cgColor
        btn.restorationIdentifier = String(id)

        btn.setBackgroundImage(texture, for: .normal)
        btn.addTarget(self, action: #selector(onTextureBtnClick(_:)), for: .touchUpInside)
        self.view.addSubview(btn)
        tipsImageViews.append(btn)
    }
}
