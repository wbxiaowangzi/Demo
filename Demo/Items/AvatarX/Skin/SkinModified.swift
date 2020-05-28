//
//  SkinModified.swift
//  Mirage3D
//
//  Created by 影子.zsr on 2018/1/24.
//  Copyright © 2018年 影子. All rights reserved.
//

import Foundation
import CoreImage
import CoreGraphics
import Accelerate
import AVFoundation
import SceneKit

class SkinTest {
    
    private init() {
        
    }
    
    /// 皮肤光洁度
    ///
    /// - Parameter image: texture
    /// - Returns: texture
    static func glcm(image: UIImage) -> CGFloat {
        let lerp = SkinBridge.glcm(image)
        return CGFloat(lerp)
    }
    
    static func wrinkleAnalyze(image: UIImage) -> UIImage {
        return SkinBridge.wrinkleAnalyze(image)
    }
    
    /// 新版皱纹分析
    ///
    /// - Parameters:
    ///   - image: texture
    ///   - top: 上
    ///   - left: 左
    ///   - bottom: 下
    ///   - right: 右
    ///   - Top: 最顶部 额头上分割点
    /// - Returns: texture
    static func addAlphaPass(image: UIImage, top: Float, left:Float,bottom:Float,right:Float,Top:Float) -> UIImage {
        let alphaImage = SkinBridge.imageBlack(toTransparent: image, value1: top, value2: left, value3: bottom, value4: right, value5: Top)!
        UIGraphicsBeginImageContext(alphaImage.size)
        alphaImage.draw(at: CGPoint.init(), blendMode: CGBlendMode.color, alpha: 1)
        let resultingImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return resultingImage!
    }
    
    static func addAlphaPass(image: UIImage) -> UIImage {
        let image = SkinBridge.imageBlack(toTransparent: image)
        return image!
    }
    
    /// 新版皱纹分析
    ///
    /// - Parameters:
    ///   - image: texture
    ///   - points: 特征点
    /// - Returns: model
    static func wrinkleMultAnalyze(image: UIImage, points: [CGPoint]) -> WrinkleModel {
        let model = SkinBridge.wrinkleMultAnalyze(image, value2: points)
        
        return model!
    }
    
    /// 肤色不均
    ///
    /// - Parameter image: texture
    /// - Returns: texture
    static func colorDistributionAnalyze(image: UIImage) -> UIImage {
        let image = SkinBridge.colorDistributionAnalyze(image)
        return image!
    }
    
    /// 斑点
    ///
    /// - Parameters:
    ///   - image: texture
    ///   - points: 特征点
    /// - Returns: model
    static func blobSkinAnalyze(image: UIImage, points: [CGPoint]) -> BlobInfoModel {
        let model = SkinBridge.blobSkinAnalyze(image, value2: points)
        return model!
    }

    static func changeMeimao(image: UIImage, points: [CGPoint], path:String) -> UIImage {
        
        let out = SkinBridge.changeMeimao(image, roi: #imageLiteral(resourceName: "skin_roi.jpg"), value3: points, value4: path)
        return out!
    }
    
    static func skinWhiting(image: UIImage) -> UIImage {
        let out = SkinBridge.skinWhiting(image)
        return out!
    }
    
    static func skinBlend(ori: UIImage, image_left: UIImage, image_right:UIImage,value:CGFloat,alpha:CGFloat = 1) -> UIImage {
        var resultingImage: UIImage
        UIGraphicsBeginImageContext(ori.size)
        
        if value >= 0 {
            image_right.draw(at: CGPoint(), blendMode: CGBlendMode.color, alpha: value * alpha)
        } else {
            image_left.draw(at: CGPoint(), blendMode: CGBlendMode.color, alpha: abs(value) * alpha)
        }
        ori.draw(at: CGPoint.init(), blendMode: CGBlendMode.color, alpha: (1 - abs(value)) * alpha)
        resultingImage = UIGraphicsGetImageFromCurrentImageContext()!;
        
        UIGraphicsEndImageContext();
        return resultingImage
    }

    /// 镜面翻转图片
    ///
    /// - Parameter srcImage: source
    static func mirrorImage(srcImage: UIImage) -> UIImage {
        //Quartz重绘图片
        let rect = CGRect.init(x: 0, y: 0, width: srcImage.size.width, height: srcImage.size.height)

        //根据size大小创建一个基于位图的图形上下文
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 2)
        let currentContext =  UIGraphicsGetCurrentContext()!;//获取当前quartz 2d绘图环境
        currentContext.clip(to: rect)
        currentContext.rotate(by: CGFloat.pi)
        currentContext.translateBy(x: -rect.size.width, y: -rect.size.height)
        //平移， 这里是平移坐标系，跟平移图形是一个道理
        currentContext.draw(srcImage.cgImage!, in: rect)
        
        //翻转图片
        let drawImage =  UIGraphicsGetImageFromCurrentImageContext();//获得图片

        let flipImage =  UIImage(cgImage: drawImage!.cgImage!,
                                 scale: srcImage.scale,
                                 orientation: srcImage.imageOrientation)  //图片方向不用改
        UIGraphicsEndImageContext()
        return flipImage
    }
    
    static func skinBlendEyelid(ori: UIImage, eyelidImage: UIImage, rect:CGRect,alpha:CGFloat) -> UIImage {
        UIGraphicsBeginImageContext(ori.size)
        ori.draw(at: CGPoint.init(), blendMode: CGBlendMode.color, alpha: 1)
        eyelidImage.draw(in: rect, blendMode: CGBlendMode.color, alpha: alpha)
        let resultingImage = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        return resultingImage!
    }
    
}

