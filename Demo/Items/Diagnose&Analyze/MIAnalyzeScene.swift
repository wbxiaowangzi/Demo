////
////  MIAnalyzeScene.swift
////  MIHousekeeper
////
////  Created by 加冰 on 2020/2/10.
////  Copyright © 2020 影子. All rights reserved.
////
//
//import Foundation
//import MIMetal
//import MILaplaceDeform
//import QuartzCore
//import MINetwork
//import MICommonUI
//
///// 分析场景callback
//public protocol MIAnalyzeSceneDelegate: NSObjectProtocol {
//    /// 当有面部区域被选中时该方法会被调用
//    /// selectPart: 选中的区域名称
//    /// features: 选中的区域包含的特征列表
//    func analyzeScene(_ scene: MIAnalyzeScene, selectPart: String, features: [String])
//}
//
//public class MIAnalyzeScene: MIMetalScene {
//    
//    var texture: UIImage!
//    
//    private var showFeatures: [String] = []
//
//    private var featurePartDic: [String: AnalyzePartModel] = [: ]
//
//    private var selectFeature: AnalyzePartModel?
//
//    private var currentShowFeature: [AnalyzeFeatureModel] = []
//
//    public weak var delegate: MIAnalyzeSceneDelegate?
//    
//    var analyzeNode: MINode?
//
//    var testNode: MINode?
//
//    var imageView: UIImageView?
//
//    var sliders: [UISlider] = []
//    
//    var isDebug: Bool = false
//
//    var outputText: UITextView!
//
//    var moveBtns: [UIButton] = []
//
//    var moveTimer: Timer?
//    
//    lazy var black: (String) -> Void = {
//        return { [weak self] (name) in
//            print(self?.analyzeNode?.name ?? "")
//            print(name)
//        }
//    }()
//    
//    public override init(frame: CGRect) {
//        super.init(frame: frame)
//        
//        if AppConfig_Network.model.count > 5 {
//            let version = AppConfig_Network.model[4]
//
//            if let v = Int(version) {
//                if v > 6 {
//                    view.frameCount = 60
//                    view.setPaused(false)
//                }
//            }
//        }
//        
//        hitTestDelegate = self
//        render.bgRender.setTexture(texture: UIImage.color2UIImage(color: UIColor.init(hexString: "#20243b"), size: .init(width: 10, height: 10)))
//        //加载模型
//        DispatchQueue.init(label: "初始化模型").async {
//            self.initModel()
//        }
//        
//        camera.position = simd_float3(0, 0, 500)
//        camera.fieldOfView = 30
//        AnalyzeAreaConfig.share.areaDic["default"] = AnalyzeAreaModel.init(areaName: "default", position: camera.position, rotate: camera.rotate)
//        
//        rotateLimit = 0
//        view.gestureRecognizers?.removeAll()
//        let tap = UITapGestureRecognizer.init(target: self, action: #selector(tap(_: )))
//
//        let pan = UIPanGestureRecognizer.init(target: self, action: #selector(pan(_: )))
//        view.addGestureRecognizer(pan)
//        view.addGestureRecognizer(tap)
//        let pinch = UIPinchGestureRecognizer.init(target: self, action: #selector(pinch(_: )))  //缩放
//        view.addGestureRecognizer(pinch)
//        
////        addTestSlider(CGRect.adaptRect(x: 200, y: 10, width: 150, height: 50), "1")
////        addTestSlider(CGRect.adaptRect(x: 200, y: 70, width: 150, height: 50), "2")
////        addTestSlider(CGRect.adaptRect(x: 200, y: 130, width: 150, height: 50), "3")
//        
//        imageView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: 250, height: 150))
////        self.view.addSubview(imageView!)
//        
//        let debugBtn = UIButton.init(frame: CGRect.adaptRect(x: 10, y: 10, width: 150, height: 60))
//        debugBtn.backgroundColor = UIColor.white
//        debugBtn.addTarget(self, action: #selector(debugBtnClick(_: )), for: .touchUpInside)
//        self.view.addSubview(debugBtn)
//        outputText = UITextView.init(frame: CGRect.adaptRect(x: 550, y: 400, width: 250, height: 132))
//        outputText.backgroundColor = UIColor.white
//        outputText.isHidden = true
//        self.view.addSubview(outputText)
// 
//        addMoveBtn("左", CGRect.adaptRect(x: 30, y: 350, width: 50, height: 50))
//        addMoveBtn("右", CGRect.adaptRect(x: 150, y: 350, width: 50, height: 50))
//        addMoveBtn("上", CGRect.adaptRect(x: 90, y: 290, width: 50, height: 50))
//        addMoveBtn("下", CGRect.adaptRect(x: 90, y: 400, width: 50, height: 50))
//    }
//    
//    private func addMoveBtn(_ name: String, _ rect: CGRect) {
//        let btn = UIButton.init(frame: rect)
//        btn.restorationIdentifier = name
//        btn.setBackgroundImage(#imageLiteral(resourceName: "ic_miaobianyuanquan.png"), for: .normal)
//        btn.isHidden = true
//        btn.addTarget(self, action: #selector(debugMoveBtnTouch(_: )), for: .touchDown)
//        btn.addTarget(self, action: #selector(debugMoveCancel(_: )), for: [.touchCancel, .touchUpInside, .touchUpOutside])
//        moveBtns.append(btn)
//        view.addSubview(btn)
//    }
//    
//    @objc private func debugMoveBtnTouch(_ sender: UIButton) {
//        var dir = float3()
//        switch sender.restorationIdentifier {
//        case "左":
//            dir = self.camera.left
//        case "右":
//            dir = self.camera.right
//        case "上":
//            dir = float3.init(0, 1, 0)
//        case "下":
//            dir = float3.init(0, -1, 0)
//        default: break
//        }
//        
//        moveTimer?.invalidate()
//        moveTimer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true, block: { (time) in
//            self.camera.position += dir
//            self.showDebug()
//        })
//        
//        print("touch")
//    }
//    @objc private func debugMoveCancel(_ sender: UIButton) {
//        print("-------------")
//        moveTimer?.invalidate()
//    }
//    
//    @objc private func debugBtnClick(_ sender: UIButton) {
//        sender.isSelected = !sender.isSelected
//        isDebug = sender.isSelected
//        sender.backgroundColor = isDebug ? UIColor.ZKBlue : UIColor.white
//        outputText.isHidden = !isDebug
//        for item in moveBtns {
//            item.isHidden = !isDebug
//        }
//    }
//    
//    private func showDebug() {
//         let p = camera.position
//
//         let r = camera.rotate
//         DispatchQueue.main.async {
//             self.outputText.text = "\(p.x)_\(p.y)_\(p.z)_\(r.x)_\(r.y)_\(r.z)"
//         }
//    }
//    
//    private func addTestSlider(_ rect: CGRect, _ name: String) {
//        let slider = UISlider.init(frame: rect)
//        slider.restorationIdentifier = name
//        slider.minimumValue = 0
//        slider.maximumValue = 1
//        slider.addTarget(self, action: #selector(onValueChange(_: )), for: .valueChanged)
//        sliders.append(slider)
//        view.addSubview(slider)
//    }
//    
//    @objc func onValueChange(_ sender: UISlider) {
//        switch sender.restorationIdentifier {
//        case "1":
//            let value = float3(sliders[0].value, sliders[0].value, sliders[0].value)
//            print(value)
//            analyzeNode?.material?.setGrayColor(value)
//        case "2":
//            let value = sender.value
////            analyzeNode?.material?.setGrayEnable(<#T##enable: Bool##Bool#>)
//        default:
//            return
//        }
//        
//    }
//    
//    @objc func pinch(_ sender: UIPinchGestureRecognizer) {
//        
//        if sender.state == .changed {
//            if isDebug {
//                camera.position += (Float(sender.velocity)*camera.forword)
//                showDebug()
//            } else {
//                if sender.scale < 0.5 {
//                    moveCamere(area: "default")
//                    sender.scale = 1
//                }
//            }
//        }
//        
//    }
// 
//    func moveCamere(area: String, isRight: Bool = false) {
//        if let pose = AnalyzeAreaConfig.share.areaDic[area] {
//
//            let time = 0.8
////            camera.position = defaut.position
////            camera.rotate = defaut.rotate
//            var position = pose.position
//            position.x = isRight ? -position.x : position.x
//            var rotate = pose.rotate
//            rotate.y = isRight ? -rotate.y : rotate.y
//            let pAction = MIAction.moveBy(x: position.x, y: position.y, z: position.z, duration: time)
//
//            let rAction = MIAction.rotateBy(x: rotate.x, y: rotate.y, z: rotate.z, duration: time)
//            camera.runAction(pAction)
//            camera.runAction(rAction)
//        }
//    }
//    
//    @objc func tap(_ sender: UITapGestureRecognizer) -> Void {
//        let location = sender.location(in: view)
//
//        if let result = hitTest(location) {
//            hitTestDelegate?.hitTest(self, result: result)
//        }
//    }
//       
//    @objc func pan(_ sender: UIPanGestureRecognizer) -> Void {
//        let velocity = sender.velocity(in: view)
//
//        let k: CGFloat = 0.1
//        if sender.state == .changed {
//            //旋转
//            if isDebug {
//                rotateByPoint(velocity: CGPoint.init(x: velocity.x*k, y: velocity.y*k))
//                showDebug()
//            }
//        }
//    }
//    
//    /// 需要展示的id列表
//    func showFeatures(value: [String]) {
//        showFeatures = value
////        for item in value {
////            if let part = AnalyzeAreaConfig.share.getPartByFeature(feature: item) {
////                featurePartDic[part.part] = part
////            } else {
////                print("分析模型错误：找不到对应的区域图片  feature_id: \(item)")
////            }
////        }
//        drawTextureAndReplace()
//    }
//    
//    private func drawTextureAndReplace() {
//        guard texture != nil else {
//            return
//        }
//        
//        var result: UIImage
//        UIGraphicsBeginImageContext(texture.size)
//        
//        for item in featurePartDic.values {
//            var alpha: CGFloat = 0.5
//            if item.part == selectFeature?.part {
//                alpha = 0.8
//            }
//            
//            item.texture?.draw(in: item.rect, blendMode: .color, alpha: alpha)
//            if item.rectRight != nil {
//                item.textureRight?.draw(in: item.rectRight!, blendMode: .color, alpha: alpha)
//            }
//        }
//        
//        result = UIGraphicsGetImageFromCurrentImageContext()!
//        analyzeNode?.material?.setTexture(cgImage: result.cgImage!)
//        UIGraphicsEndImageContext()
//        
//        DispatchQueue.main.async {
//            self.imageView?.image = result
//        }
//    }
//    
//}
//
//extension MIAnalyzeScene: MIHitTestProtocol {
//    public func hitTest(_ scene: MIMetalScene, result: MIHitResult) {
//        let uv = result.textureCoordinates
//
//        let point = CGPoint.init(x: uv.x, y: uv.y)
//        for item in featurePartDic.values {
//            let width = texture.size.width
//
//            let height = texture.size.width
//            
//            var hit1 = hitPart(width: width, height: height, rect: item.rect, point: point)
//
//            var isRight = false
//            
//            if item.rectRight != nil {
//                isRight = hitPart(width: width, height: height, rect: item.rectRight!, point: point)
//                hit1 = hit1 || isRight
//            }
//            
//            guard hit1 else {
//                continue
//            }
//            
//            selectFeature = item
//            drawTextureAndReplace()
//            moveCamere(area: item.area, isRight: isRight)
//            let dic = AnalyzeAreaConfig.share.featureDic
//
//            var featureArr: [String] = []
//            for f in showFeatures {
//                if dic[f]?.part.contains(item.part) ?? false {
//                    featureArr.append(f)
//                }
//            }
//            delegate?.analyzeScene(self, selectPart: item.part, features: featureArr)
//            print(featureArr)
//            return
//        }
//    }
//    
//    private func hitPart(width: CGFloat, height: CGFloat, rect: CGRect, point: CGPoint) -> Bool {
//        let r = CGRect.init(x: rect.minX/width, y: rect.minY/height, width: rect.width/width, height: rect.height/height)
//        
//        let x = point.x
//
//        let y = point.y
//        if x > r.minX && x < r.maxX && y > r.minY && y < r.maxY {
//            return true
//        }
//        return false
//    }
//    
//    public func dragDirection(_ scene: MIMetalScene, direction: float3, touchPoint: CGPoint) {
//        
//    }
//    
//    public func dragHitTest(_ scene: MIMetalScene, result: MIHitResult) {
//        
//    }
//    
//    public func dragEnded(_ scene: MIMetalScene) {
//        
//    }
//    
//    public func move(_ scene: MIMetalScene, keypoint: [CGPoint]) {
//        
//    }
//}
//
//extension MIAnalyzeScene {
//    
//    private func initModel() {
////        texture = UIImage.init(named: "Resource/tex/DYYSZhuDan_face_3333.jpg")
//        texture = UIImage.color2UIImage(color: UIColor.white, size: CGSize.init(width: 2048, height: 2048))
//        
//        guard let objPath = Bundle.main.path(forResource: "Resource/8", ofType: ".obj") else {
//            print("分析模型obj文件缺失！！！")
//            return
//        }
//        let loader = ObjLoaderBridge.init()
//        loader.load(objPath)
//        
//        var v: [simd_float4] = []
//
//        var vt: [simd_float2] = []
//
//        var vn: [simd_float4] = []
//
//        var vecs: [MIVertex] = []
//
//        var tri: [UInt32] = []
//        
//        let _vs = loader.data_v!
//
//        let _vts = loader.data_vt!
//
//        let _vns = loader.data_vn!
//
//        let _face = loader.data_face!
//
//        let _faceVT = loader.data_faceVT!
//
//        let _faceVN = loader.data_faceVN!
//        
//        for i in 0..._vs.count/3 - 1 {
//            let x = (_vs[i*3] as! NSNumber).floatValue
//
//            let y = (_vs[i*3+1] as! NSNumber).floatValue
//
//            let z = (_vs[i*3+2] as! NSNumber).floatValue
//            v.append(simd_float4(x, y, z,1))
//        }
//        for i in 0..._vts.count/2 - 1 {
//            let u = (_vts[i*2] as! NSNumber).floatValue
//
//            let v = (_vts[i*2+1] as! NSNumber).floatValue
//            vt.append(simd_float2(u, v))
//        }
//        for i in 0..._vns.count/3 - 1 {
//            let x = (_vns[i*3] as! NSNumber).floatValue
//
//            let y = (_vns[i*3+1] as! NSNumber).floatValue
//
//            let z = (_vns[i*3+2] as! NSNumber).floatValue
//            vn.append(simd_float4(x, y, z,1))
//        }
//        
//        var vecDic: [Int: MIVertex] = [: ]
//
//        var vecHitTest: [MIVertex] = []
//        for i in 0..._face.count - 1 {
//            let tempV = (_face[i] as! NSNumber).intValue
//
//            let tempVt = (_faceVT[i] as! NSNumber).intValue
//
//            let tempVn = (_faceVN[i] as! NSNumber).intValue
//
//            let vec = MIVertex.init(position: v[tempV], normal: vn[tempVn], texcoord: vt[tempVt])
//
//            vecDic[tempV] = vec
//            
//            vecs.append(vec)
//            tri.append(UInt32(i))
//        }
//        for item in vecDic.values {
//            vecHitTest.append(item)
//        }
//        
//        let node = MINode.init()
//        node.mesh = MIMesh.init(vecs: vecs, face_uint32: tri)
//        node.rotate.y = Float.pi
//        node.mesh?.vecs = vecHitTest
//        node.material = MIMaterial.init()
//        node.material?.fragmentFuncName = "analyze_fragment"
//        node.material?.setTexture(cgImage: texture.cgImage!)
//        node.material?.setLightPos(simd_float3(-200, 50, 50))
//        node.material?.setGrayColor(simd_float3(0.35052916, 0.3614979, 0.38891983))
//        node.isUserInteractionEnabled = true
//        analyzeNode = node
//        
//        let mesh2 = MIModelCreater.sphere(radius: 5)
//        testNode = MIObject.init(mdlMesh: mesh2)
//        testNode?.material?.setColor(color: UIColor.ZKBlue)
//        testNode?.isHidden = false
//        
//        controlNode = camera
//        testNode?.addChildNode(node)
//        self.rootNode.addChildNode(testNode!)
//        
//        drawTextureAndReplace()
//        
////        showFeatures(value: ["p1_14_007", "p2_006_004"])
//    }
//    
//}
