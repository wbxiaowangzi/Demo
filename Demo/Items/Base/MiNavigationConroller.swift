//
//  MiNavigationConroller.swift
//  Mirage3D
//
//  Created by 影子.zsr on 2018/3/27.
//  Copyright © 2018年 影子. All rights reserved.
//

import Foundation
import UIKit

class ZKViewController: UIViewController {
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .portrait
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let back = UIBarButtonItem(title: nil, style: .done, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = back
        
    }    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func addImageGesture(imageView:UIImageView) -> Void {
        imageView.isUserInteractionEnabled = true
        let imgClick = UITapGestureRecognizer(target: self, action: #selector(imgShow(_:)));
        imageView.addGestureRecognizer(imgClick);
    }
    
    var tips:TipsView?
    func showTips(text:String,parentView:UIView) -> Void {
        if tips == nil{
            tips = TipsView.init(frame: CGRect.init(x: adaptW(202), y: adaptH(260), width: adaptW(620), height: adaptH(156)))
            parentView.addSubview(tips!)
        }
        
        tips?.label.text = text
        tips?.isHidden = false
    }
    
    func closeTips() -> Void {
        tips?.isHidden = true
    }
    
    //图片放大功能
    private var _imageParent:UIImageView?
    private var _imageView:UIImageView?
    private var _imageFrame:CGRect?
    
    @objc private func imgShow(_ sender:UITapGestureRecognizer){
        let imageView = sender.view as! UIImageView
        
        if imageView.image == nil {
            return
        }
        
        
        let image = imageView.image!
        imageView.image = nil
        _imageParent = imageView
        _imageFrame = _imageParent?.superview?.convert(imageView.frame, to: self.view)
        self._imageView = UIImageView.init(frame: _imageFrame!)
        self.view.addSubview(_imageView!)
        self._imageView?.image = image
        self._imageView?.frame = _imageFrame!
        let width = ScreenWidth > image.size.width ? image.size.width : ScreenWidth
        let height = (width/image.size.width) * image.size.height
        
        UIView.animate(withDuration: 0.15, animations: {
            self._imageView!.center = CGPoint.init(x: ScreenWidth/2, y: ScreenHeight/2)
            self._imageView!.bounds.size = CGSize.init(width: width, height: height)
        }) { (isOk) in
 
        }
    }
    
    func imgQuit() -> Void {
        if _imageParent == nil{
            return
        }
        
        UIView.animate(withDuration: 0.15, animations: {
            self._imageView?.frame = self._imageFrame!
        }) { (isOk) in
            self._imageParent?.image = self._imageView?.image
            self._imageView?.removeFromSuperview()
            self._imageFrame = nil
            self._imageView = nil
            self._imageParent = nil
        }
        
    }
    

}

//错误提示窗口
class TipsView: UIView {
    
    var label:UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        let dise = UIView.init(frame: CGRect.init(x: adaptW(20), y: adaptW(20), width: adaptW(620), height: adaptH(156)))
        dise.backgroundColor = UIColor.white
        dise.alpha = 0.2
        self.addSubview(dise)
        let background = UIView.init(frame: self.bounds)
        background.backgroundColor = UIColor.white
        self.addSubview(background)
        let tipsImage = UIImageView.init(frame: CGRect.init(x: -adaptW(44), y: -adaptH(48), width: adaptW(108), height: adaptW(108)))
        tipsImage.image = #imageLiteral(resourceName: "ic_homepage_warn")
        self.addSubview(tipsImage)
        
        label = UILabel.init(frame: CGRect.init(x: adaptW(89), y: adaptH(38), width: adaptW(443), height: adaptH(80)))
        label.numberOfLines = 2
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = UIColor.black
        self.addSubview(label)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class MiNavigationController: UINavigationController {
    
    override var shouldAutorotate: Bool {
        return self.viewControllers.last?.shouldAutorotate ?? false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return self.viewControllers.last?.supportedInterfaceOrientations ?? .portrait
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return self.viewControllers.last?.preferredInterfaceOrientationForPresentation ?? .portrait
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    override func popViewController(animated: Bool) -> UIViewController? {
        
        let vc = super.popViewController(animated: animated)
        
        return vc
    }

    
}


class MiNavigationBar: UINavigationBar {
    
    let barHeight:CGFloat = 84
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var amendedSize = super.sizeThatFits(size)
        amendedSize.height = barHeight
        return amendedSize;
    }
    
}
