//
//  File.swift
//  MirageActor
//
//  Created by YingZi on 2018/11/16.
//  Copyright © 2018 YingZi. All rights reserved.
//
import UIKit

let ScreenWidth = UIScreen.main.bounds.size.width

let ScreenHeight = UIScreen.main.bounds.size.height

let lerpW: CGFloat = ScreenWidth/1024

let lerpH: CGFloat = ScreenHeight/1366

@IBDesignable extension UIView {
    
    @IBInspectable open var cornerRadius: CGFloat {
        get { return layer.cornerRadius }
        set { layer.cornerRadius = newValue }
    }
    
    @IBInspectable open var borderColor: UIColor? {
        get { return layer.borderColor != nil ? UIColor(cgColor: layer.borderColor!) : nil }
        set { layer.borderColor = newValue?.cgColor }
    }
    
    @IBInspectable open var borderWidth: CGFloat {
        get { return layer.borderWidth }
        set { layer.borderWidth = newValue }
    }
    
    @IBInspectable open var shadowColor: UIColor? {
        get { return layer.shadowColor != nil ? UIColor(cgColor: layer.shadowColor!) : nil }
        set { layer.shadowColor = newValue?.cgColor }
    }
    
    @IBInspectable open var shadowRadius: CGFloat {
        get { return layer.shadowRadius }
        set { layer.shadowRadius = newValue }
    }
    
    @IBInspectable open var shadowOpacity: Float {
        get { return layer.shadowOpacity }
        set { layer.shadowOpacity = newValue }
    }
    
    @IBInspectable open var shadowOffset: CGSize {
        get { return layer.shadowOffset }
        set { layer.shadowOffset = newValue }
    }
}

fileprivate let ratio = ScreenWidth/1024

extension UIView {
    func adjustSubLabelFont() {
        if self.subviews.count > 0 {
            for sub in self.subviews {
                if let lab = sub as? UILabel {

                    let s = lab.font.pointSize

                    let n = lab.font.fontName
                    lab.font = UIFont(name: n, size: s*ratio)
                }
                sub.adjustSubLabelFont()
            }
        }
        
    }
}

let AdapterScreenKey = "AdapterScreenKey"
extension NSLayoutConstraint {
    @IBInspectable open var adapterScreen: Bool {
        get { return (objc_getAssociatedObject(self, AdapterScreenKey) as? Bool ?? true) }
        set {
            objc_setAssociatedObject(self, AdapterScreenKey, adapterScreen, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
            if adapterScreen {
                self.constant = adaptW(self.constant)
            }
        }
    }
}

enum MIAdaptScreenWidthType {
    case none
    case constraint
    case fontSize
    case all
}

extension UIView {
    
    func adaptLayout(with type: MIAdaptScreenWidthType, exceptViews: [AnyClass]? = nil) {
        
        guard  !isExceptViewClass(with: exceptViews) else {
            return
        }
        var adaptConstraint   = false

        var adaptFontSize     = false

        var adaptCornerRadius = false
        switch type {
        case .none:
            return
        case .all:
            adaptFontSize = true
            adaptConstraint = true
            adaptCornerRadius = true
        case .constraint:
            adaptConstraint = true
        case .fontSize:
            adaptFontSize = true
        }
        
        if adaptConstraint {
            for c in self.constraints {
                c.constant = adaptW(c.constant)
            }
        }
        
        if adaptFontSize {
            if let lab = self as? UILabel {

                let s = lab.font.pointSize

                let n = lab.font.fontName
                lab.font = UIFont(name: n, size: adaptW(s))
            } else if let tf = self as? UITextField {

                if let s = tf.font?.pointSize, let n = tf.font?.fontName {
                    tf.font = UIFont(name: n, size: adaptW(s))
                }
            }
        }
        
        if adaptCornerRadius {
           self.layer.cornerRadius = adaptW(self.layer.cornerRadius)
        }
        
        for s in subviews {
            s.adaptLayout(with: type, exceptViews: exceptViews)
        }
    }
    
    func isExceptViewClass(with array: [AnyClass]?) -> Bool {
        if array == nil {
            return false
        }
        for i in array! {
            if self.isKind(of: i.class()) {
                return true
            }
        }
        return false
    }
    
    static func getTextH(with text: String, font: UIFont, width:CGFloat) -> CGFloat {
        let rect = NSString.init(string: text).boundingRect(with: CGSize.init(width: width, height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        return rect.height
    }
}

//自适应高
func adaptH(_ value: CGFloat) -> CGFloat {
    return value * lerpH
}

func adaptH(_ value: Int) -> CGFloat {
    return CGFloat(value) * lerpH
}
func adaptH(_ value: Double) -> Double {
    return value * Double(lerpH)
}

//自适应宽
func adaptW(_ value: CGFloat) -> CGFloat {
    return value * lerpW
}

func adaptW(_ value: Int) -> CGFloat {
    return CGFloat(value) * lerpW
}

func adaptW(_ value: Double) -> Double {
    return value * Double(lerpW)
}

//获取通用时间字符串
func getCommonDateString(date: Date) -> String {
    let dateFormatter = DateFormatter.init()
    dateFormatter.dateFormat = "yyyy-MM-dd HH: mm"
    return dateFormatter.string(from: date)
}

func getCommonDateString(time: Int) -> String {
    let date = Date.init(timeIntervalSince1970: TimeInterval(time))

    let dateFormatter = DateFormatter.init()
    dateFormatter.dateFormat = "yyyy-MM-dd HH: mm"
    return dateFormatter.string(from: date)
}

//UIImage颜色
extension UIImage {
    
    func tintColor(color: UIColor, blendMode: CGBlendMode) -> UIImage {
        let drawRect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        //let context = UIGraphicsGetCurrentContext()
        //CGContextClipToMask(context, drawRect, CGImage)
        color.setFill()
        UIRectFill(drawRect)
        draw(in: drawRect, blendMode: blendMode, alpha: 1.0)
        let tintedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return tintedImage!
    }
    
}

extension CGPoint {
    
    static func -(left: CGPoint, right: CGPoint) -> CGPoint {
        return CGPoint.init(x: left.x - right.x, y: left.y - right.y)
    }
    static func +(left: CGPoint, right: CGPoint) -> CGPoint {
        return CGPoint.init(x: left.x + right.x, y: left.y + right.y)
    }
    
}

extension UIView {
    ///根据uiview的size自适应宽高，用于addchildvc时
    func adaptH(_ value: CGFloat) -> CGFloat {
        return value * (self.bounds.size.height/1366)
    }

    func adaptH(_ value: Int) -> CGFloat {
        return CGFloat(value) * (self.bounds.size.height/1366)
    }
    func adaptH(_ value: Double) -> Double {
        return value * Double(self.bounds.size.height/1366)
    }

    //自适应宽
    func adaptW(_ value: CGFloat) -> CGFloat {
        return value * (self.bounds.size.width/1024)
    }

    func adaptW(_ value: Int) -> CGFloat {
        return CGFloat(value) * (self.bounds.size.width/1024)
    }

    func adaptW(_ value: Double) -> Double {
        return value * Double(self.bounds.size.width/1024)
    }
    
    func adapt(_ origin: CGPoint) -> CGPoint {
        return CGPoint(x: origin.x * (self.bounds.size.width/1024), y: origin.y * (self.bounds.size.height/1366))
    }
    
    func adapt(_ size: CGSize) -> CGSize {
        return CGSize(width: size.width * (self.bounds.size.width/1024), height: size.height * (self.bounds.size.height/1366))
    }
    
    func adapt(_ frame: CGRect) -> CGRect {
        return CGRect.init(origin: self.adapt(frame.origin), size: self.adapt(frame.size))
    }
}
