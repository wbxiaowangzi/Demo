//
//  File.swift
//  MirageActor
//
//  Created by YingZi on 2018/11/16.
//  Copyright © 2018 YingZi. All rights reserved.
//
import UIKit

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

fileprivate let ScreenWidth = UIScreen.main.bounds.size.width
fileprivate let ratio = ScreenWidth/1024
func adaptW(value:CGFloat)->CGFloat{
    return value*ratio
}
extension UIView{
    func adjustSubLabelFont(){
        if self.subviews.count > 0 {
            for sub in self.subviews{
                if let lab = sub as? UILabel{
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
extension NSLayoutConstraint{
    @IBInspectable open var adapterScreen: Bool {
        get { return (objc_getAssociatedObject(self, AdapterScreenKey) as? Bool ?? true) }
        set {
            objc_setAssociatedObject(self, AdapterScreenKey, adapterScreen, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
            if adapterScreen {
                self.constant = self.constant*ratio
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

extension UIView{
    
    func adaptLayout(with type:MIAdaptScreenWidthType,exceptViews:[AnyClass]? = nil) {
        
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
        
        if adaptConstraint{
            for c in self.constraints{
                c.constant = adaptW(value: c.constant)
            }
        }
        if adaptFontSize{
            for sub in self.subviews{
                if let lab = sub as? UILabel{
                    let s = lab.font.pointSize
                    let n = lab.font.fontName
                    lab.font = UIFont(name: n, size: adaptW(value: s))
                }
            }
        }
        if adaptCornerRadius{
            self.layer.cornerRadius = adaptW(value: self.layer.cornerRadius)
        }
        
        for s in subviews{
            s.adaptLayout(with: type, exceptViews: exceptViews)
        }
    }
    
    func isExceptViewClass(with array:[AnyClass]?) -> Bool {
        if array == nil {
            return false
        }
        for i in array!{
            if self.isKind(of: i.class()){
                return true
            }
        }
        return false
    }
}
