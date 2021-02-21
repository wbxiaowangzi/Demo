////
////  MIAnalyzeAreaTexture.swift
////  MIHousekeeper
////
////  Created by 影子 on 2020/3/30.
////  Copyright © 2020 影子. All rights reserved.
////
//
//import Foundation
//import SDWebImage
//
///// 分析场景callback
//public protocol MIAnalyzeAreaTextureDelegate: NSObjectProtocol {
//    /// 当有面部区域被选中时该方法会被调用
//    /// selectPart: 选中的区域名称
//    /// features: 选中的区域包含的特征列表
//    func analyzeTexture(_ texture: MIAnalyzeAreaTexture, selectPart: String, features: [Int], featureIdArr: [Int])
//}
//
//public class MIAnalyzeAreaTexture: NSObject {
//    
//    var view: UIView!
//
//    var imageView: UIImageView!
//    var tipsImageViews: [UIButton] = []
//    var isEnabelHit: Bool = true
//
//    var texture: UIImage!
//    var texture_body: UIImage!
//    var modifyTexture: UIImage?
//    var currentSelected: String = "面部女"
//    
//    private var instance_id: Int?
//    
//    private var gender: Int = 0
//    
//    /// 展示的特征，同时是否为缺陷
//    private var showFeatures: [(TemplateFeatureModel, Bool)] = []
//
//    private var featurePartDic: [Int: AnalyzePartModel] = [:]
//
//    private var missFeatures: [Int] = []
//
//    private var selectPart: AnalyzePartModel?
//
//    public weak var delegate: MIAnalyzeAreaTextureDelegate?
//    
//    var scale: CGFloat = 1
//
//    var pos: CGPoint?
//
//    private var pan: UIPanGestureRecognizer!
//    
//    var tips: UILabel!
//    
//    public init(rect: CGRect) {
//        super.init()
//        view = UIView.init(frame: rect)
//        view.layer.cornerRadius = 10
//        view.layer.borderWidth = 2
//        view.layer.borderColor = UIColor.init(hexString: "#0372FF").cgColor
//        view.backgroundColor = .white
//        imageView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: rect.width, height: rect.width))
//        imageView.center = CGPoint.init(x: rect.width/2, y: rect.height/2)
//        imageView.contentMode = .scaleAspectFit
//        
//        view.addSubview(imageView)
//        imageView.snp.makeConstraints { (maker) in
//            maker.center.equalToSuperview()
//            maker.height.equalToSuperview()
//            maker.width.equalTo(imageView.snp.height)
//        }
//        texture = UIImage.init(named: "Resource/区域面部.jpg")
//        texture_body = UIImage.init(named: "Resource/区域躯干.jpg")
//        let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapHandle(_: )))
//
//        let pinch = UIPinchGestureRecognizer.init(target: self, action: #selector(pinchHandle(_: )))
//        pan = UIPanGestureRecognizer.init(target: self, action: #selector(panHandle(_: )))
//        view.addGestureRecognizer(pinch)
//        view.addGestureRecognizer(tap)
//        
//        let l1 = UILabel.init(frame: CGRect.adaptRect(x: 42, y: 9, width: 144, height: 18))
//        l1.text = "请先选择品项"
//        l1.textColor = UIStatic.Color.重度灰
//        l1.font = UIStatic.Word.标题Font
//        view.addSubview(l1)
//        l1.snp.makeConstraints { (maker) in
//            maker.center.equalToSuperview()
//        }
//        tips = l1
//        loadPartInfo()
//    }
//    
//    private func loadPartInfo() -> Void {
//        _ = YunweiMgr.Instance.request(apiService: .parts, event: { (e) in
//            switch e{
//            case .success(let r):
//                let m = MapperUtil<GetPartsModel>.map(r)
//                if m.code == 0{
//                    AnalyzeAreaConfig.share.setParts(m)
//                }
//            case .error(_):
//                return
//            }
//        })
//    }
//    
//    @objc private func tapHandle(_ sender: UITapGestureRecognizer) {
//        guard isEnabelHit else {
//            return
//        }
//        
//        let location = sender.location(in: imageView)
//
//        let point = CGPoint.init(x: location.x/imageView.bounds.width * 1000, y: location.y/imageView.bounds.height * 1000)
//        
//        var temp: AnalyzePartModel?
//
//        var tempDistence: CGFloat = 0
//        for item in featurePartDic.values {
//            guard item.belong == currentSelected else {
//                continue
//            }
//            
//            let width = texture.size.width
//
//            let height = texture.size.width
//            
//            let hit1 = hitPart(width: width, height: height, rect: item.rect, point: point)
//            
//            guard hit1.0 else {
//                continue
//            }
//            if temp == nil {
//                temp = item
//                tempDistence = hit1.1
//            } else {
//                temp = tempDistence < hit1.1 ? temp : item
//            }
//        }
//        
//        guard let t = temp else {
//            return
//        }
//        
//        /// 取消部位选择
//        if selectPart?.partId == t.partId {
//            selectPart = nil
//            drawTextureAndReplace()
//            let arr = showFeatures.map { (arg0) -> Int in
//                let (id, _) = arg0
//                return id.feature_id ?? 0
//            }
//            delegate?.analyzeTexture(self, selectPart: t.partName, features: arr, featureIdArr: [])
//            return
//        }
//        
//        /// 选中部位
//        selectPart = t
//        drawTextureAndReplace()
//        var featureArr: [Int] = []
//        let allParts = AnalyzeAreaConfig.share.getPartTree(t.partId)//.filter{ return $0.area == nil && featurePartDic[$0.part_id] == nil}
//        
//        for f in showFeatures{
//            if f.0.part_id == t.partId{
//                featureArr.append(f.0.feature_id ?? 0)
//            }
//        }
//        
//        for f in showFeatures {
//            for p in allParts{
//                if f.0.part_id == p.part_id{
//                    featureArr.append(f.0.feature_id ?? 0)
//                }
//            }
//        }
//        
////        featureArr.append(contentsOf: missFeatures)
//        delegate?.analyzeTexture(self, selectPart: t.partName, features: featureArr, featureIdArr: [])
////        print(featureArr)
//    }
//    
//    @objc func panHandle(_ sender: UIPanGestureRecognizer) {
//        if sender.state == .began {
//            pos = imageView.center
//        }
//        
//        if sender.state == .changed && pos != nil {
//            let velocity = sender.translation(in: view)
//
//            let p = pos! + velocity
//
//            let width = imageView.bounds.width * scale
//
//            let height = imageView.bounds.height * scale
//            if p.x < -width || p.x > width || p.y < -height || p.x > height {
//                return
//            }
//            imageView.center = p
//        }
//        
//        if sender.state == .cancelled {
//            pos = nil
//        }
//    }
//    
//    @objc func pinchHandle(_ sender: UIPinchGestureRecognizer) {
//        if sender.state == .changed {
//            let s = scale * sender.scale
//            if s < 0.3 || s > 2.5 {
//                return
//            }
//            scale = s
//            imageView.transform = CGAffineTransform.init(scaleX: scale, y: scale)
//        }
//        
//        if sender.state == .cancelled || sender.state == .ended {
//            if scale > 1.3 {
//                view.removeGestureRecognizer(pan)
//                view.addGestureRecognizer(pan)
//            }
//            
//            if scale <= 1 {
//                view.removeGestureRecognizer(pan)
//                UIView.animate(withDuration: 0.3, animations: {
//                    self.imageView.transform = CGAffineTransform.init(scaleX: 1, y: 1)
//                    self.imageView.center = CGPoint.init(x: self.view.bounds.width/2, y: self.view.bounds.height/2)
//                }) { (b) in
//                    self.scale = 1
//                }
//            }
//        }
//        
//        sender.scale = 1
//    }
//    
//    private func hitPart(width: CGFloat, height: CGFloat, rect: CGRect, point: CGPoint) -> (Bool, CGFloat) {
//        let r = rect
//
//        let x = point.x
//
//        let y = point.y
//        if x > r.minX && x < r.maxX && y > r.minY && y < r.maxY {
//            let p = CGPoint.init(x: point.x-rect.midX, y: point.y-rect.midY)
//
//            let distence = sqrt(p.x/rect.width * p.x/rect.width + p.y/rect.height * p.y/rect.height)
//            return (true, distence)
//        }
//        return (false, CGFloat.infinity)
//    }
//
//    
//    
//    private func drawTextureAndReplace() {
//        let showTexture = currentSelected == "面部女" ? texture! : texture_body!
//        
//        var result: UIImage
//        UIGraphicsBeginImageContext(showTexture.size)
//        showTexture.draw(at: CGPoint(), blendMode: .color, alpha: 1)
//        for cell in featurePartDic.values {
//            guard cell.belong == currentSelected else {
//                continue
//            }
//            
//            var alpha: CGFloat = 0.4
//            if cell.partName == selectPart?.partName {
//                alpha = 1
//            }
//            
//            if cell.isRed {
//                cell.textureRed?.draw(in: cell.rect, blendMode: .multiply, alpha: alpha)
//            } else {
//                cell.texture?.draw(in: cell.rect, blendMode: .multiply, alpha: alpha)
//            }
//        }
//        
//        result = UIGraphicsGetImageFromCurrentImageContext()!
//        UIGraphicsEndImageContext()
//        
//        imageView.image = result
//        
//        self.modifyTexture = result
//    }
//    
//    @objc private func onTextureBtnClick(_ sender: UIButton){
//        for item in tipsImageViews{
//            item.borderColor = .white
//        }
//        
//        sender.borderColor = .ZKBlue
//        let id = sender.restorationIdentifier
//        isEnabelHit = id == "-1" || id == "-2"
//        
//        if isEnabelHit{
//            currentSelected = id == "-2" ? "面部女" : "躯干"
//            drawTextureAndReplace()
//        }else{
//            let image = sender.backgroundImage(for: .normal)
//            self.imageView.image = image
//        }
//    }
//    
//    private func removeAllTipsView(){
//        isEnabelHit = true
//        for item in tipsImageViews{
//            item.removeFromSuperview()
//        }
//        tipsImageViews.removeAll()
//    }
//    
//}
//
//extension MIAnalyzeAreaTexture{
//    
//    func show(state: Int, features: [TemplateFeatureModel], urls: [String], userGender: Int?, instance_id: Int?){
//        gender = userGender ?? 0
//        tips.isHidden = true
//
//        ///更新区域选择
//        let values = features.map { (m) -> (TemplateFeatureModel, Bool) in
//            return (m, m.getDefectState(userGender: userGender) ?? false)
//        }
//        _ = showFeatures(value: values)
//        
//        ///更新图片
//        if self.instance_id != instance_id{
//            showTextures(urls: urls, state: state)
//        }
//        self.instance_id = instance_id
//        
//        /// 根据状态优先显示
//        switch state {
//        case 0:
//            onTextureBtnClick(tipsImageViews[0])
//        case 1:
//            onTextureBtnClick(tipsImageViews[1])
//        case 99:
//            if tipsImageViews.count > 3{
//                onTextureBtnClick(tipsImageViews[2])
//            }else{
//                onTextureBtnClick(tipsImageViews[0])
//            }
//            
//        default:
//            onTextureBtnClick(tipsImageViews[0])
//        }
//    }
//    
//    private func showTextures(urls: [String], state: Int){
//        removeAllTipsView()
//
//        var y:CGFloat = 25
//
//        addTipsBtn(url: nil, id: -2, y: y)
//        y += 55
//        addTipsBtn(url: nil, id: -1, y: y)
//        y += 55
//        
//        if urls.count > 0{
//            for i in 0...urls.count-1{
//                addTipsBtn(url: urls[i], id: i, y: y + CGFloat(i) * 55)
//                y += 55
//            }
//        }
//
//    }
//    
//    
//    /// 需要展示的id列表
//    private func showFeatures(value: [(TemplateFeatureModel, Bool)]){
//        showFeatures = value
//        featurePartDic.removeAll()
//        for item in value {
//            
//            if var part = AnalyzeAreaConfig.share.getPartByFeature(feature: item.0){
//                if item.1 {
//                    part.setRed(item.1)
//                    featurePartDic[part.partId] = part
//                } else if featurePartDic[part.partId] == nil {
//                    featurePartDic[part.partId] = part
//                }
//            }else {
//                missFeatures.append(item.0.feature_id ?? 0)
////                print("分析模型错误：找不到对应的区域图片  feature_name: \(item.0.name)")
//            }
//        }
//        drawTextureAndReplace()
////        delegate?.analyzeTexture(self, selectPart: "", features: missFeatures)
//    }
//    
//    
//    private func addTipsBtn(url: String?, id: Int, y: CGFloat){
//        let btn = UIButton.init(frame: CGRect.adaptRect(x: 729, y: y, width: 55, height: 53))
//        btn.borderWidth = 1
//        btn.borderColor = .white
//        btn.restorationIdentifier = String(id)
//        if let u = url{
//            let url = URL.init(string: u)
//            btn.sd_setBackgroundImage(with: url, for: .normal, completed: nil)
//        }else{
//            btn.setBackgroundImage(id == -2 ? texture : texture_body, for: .normal)
//        }
//        btn.addTarget(self, action: #selector(onTextureBtnClick(_:)), for: .touchUpInside)
//        self.view.addSubview(btn)
//        tipsImageViews.append(btn)
//        btn.snp.makeConstraints { (maker) in
//            maker.right.equalToSuperview().offset(Adapter.adaptW(-20))
//            maker.top.equalTo(y)
//            maker.size.equalTo(CGSize.adaptSize(width: 55, height: 53))
//        }
//    }
//    
//}
