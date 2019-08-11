//
//  SceneKitVC.swift
//  Demo
//
//  Created by YingZi on 2018/10/25.
//  Copyright © 2018 wangbo. All rights reserved.
//

import UIKit
import SceneKit

enum CollisionDetectionMask:Int {
    
    case none = 0
    case floor = 2
    case platform = 4
    case jumper = 8
    case oldPlatform = 16
    
}

let kMaxPressDuration = 2.0
let kMaxPlatFormRadius = 6
let kMinPlatformRadius = kMaxPressDuration - 4
let kGravityValue = 30

class SceneKitVC: UIViewController {
    
    var lastPlatform:SCNNode?
    var platform:SCNNode?
    var nextPlatform:SCNNode?
    var pressDate:Date?
    var score:NSInteger = 0
    var longG:UILongPressGestureRecognizer?
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        creatFirstPlatform()
        makeUI()
    }
    
    func makeUI() {
        self.scene.physicsWorld.contactDelegate = self
        self.sceneView.scene = scene
        sceneView.frame = self.view.bounds
        self.view.addSubview(sceneView)
        scene.rootNode.addChildNode(floor)
        camera.addChildNode(light)
        scene.rootNode.addChildNode(jumper)

        scene.rootNode.addChildNode(camera)
        let longPressGesture = UILongPressGestureRecognizer.init(target: self, action: #selector(accumulateStrength(recognizer:)))
        longPressGesture.minimumPressDuration = 0
        longG = longPressGesture
        view.addGestureRecognizer(longPressGesture)
        view.addSubview(scroLab)
    }
    
    func creatFirstPlatform() {
        let node = SCNNode()
        let cylinder = SCNCylinder(radius: 5, height: 2)
        cylinder.firstMaterial?.diffuse.contents = UIColor.yellow
        node.geometry = cylinder
        
        let body = SCNPhysicsBody.static()
        body.restitution = 0
        body.friction = 1
        body.damping = 0
        body.categoryBitMask = CollisionDetectionMask.platform.rawValue
        body.collisionBitMask = CollisionDetectionMask.jumper.rawValue|CollisionDetectionMask.platform.rawValue|CollisionDetectionMask.oldPlatform.rawValue
        node.physicsBody = body
        
        node.position = SCNVector3Make(0, 1, 0)
        self.scene.rootNode.addChildNode(node)
        self.platform = node
        moveCameraToCurrentPlatform()
    }
    
    
    @objc func accumulateStrength(recognizer:UILongPressGestureRecognizer)  {
        if recognizer.state == .began {
            pressDate = Date()
            updataeStrengthStatus()
        }else if recognizer.state == .ended {
            if let pd = pressDate{
                jumper.geometry?.firstMaterial?.diffuse.contents = UIColor.white
                jumper.removeAllActions()
                let pressDate = pd.timeIntervalSince1970
                let nowDate = Date().timeIntervalSince1970
                var power = nowDate - pressDate
                power = power > kMaxPressDuration ? kMaxPressDuration : power
                jumperWithPower(power)
            }
        }
    }
    
    func updataeStrengthStatus()  {
        let action = SCNAction.customAction(duration: kMaxPressDuration) {[weak self] (node, elapsedTime) in
            let percentage = Double(elapsedTime)/kMaxPressDuration
            self?.jumper.geometry?.firstMaterial?.diffuse.contents = UIColor(red: 1, green: CGFloat(1-percentage), blue: CGFloat(1-percentage), alpha: 1)
            
        }
        self.jumper.runAction(action)
    }
    
    func jumperWithPower( _ power: Double)  {
        let p = Float(power*30)
        if let platformPosition = self.nextPlatform?.presentation.position{
            let jumperPositon = self.jumper.presentation.position
            let subtractionX = platformPosition.x - jumperPositon.x
            let subtractionZ = platformPosition.z - jumperPositon.z
            let proportion = abs(subtractionX/subtractionZ)
            var x = sqrt(1/(pow(proportion, 2)+1))*proportion
            var z = sqrt(1/(pow(proportion, 2)+1))
            x *= subtractionX<0 ? -1 : 1
            z *= subtractionZ<0 ? -1 : 1
            let 动力 = SCNVector3Make(x*p, 20, z*p)
            self.jumper.physicsBody?.applyForce(动力, asImpulse: true)
        }
        
    }
    
    @objc func jumpCompleted() {
        self.score += 1
        print(score)
        scroLab.text = "分数：\(score)"
        self.lastPlatform  = self.platform
        self.platform = self.nextPlatform
        self.moveCameraToCurrentPlatform()
    }
    
    
    func moveCameraToCurrentPlatform() {
        if  var position = self.platform?.presentation.position{
            position.x += 20
            position.y += 30
            position.z += 20
            let move = SCNAction.move(to: position, duration: 0.4)
            self.camera.runAction(move)
            self.creatNextPlatform()
        }
    }
    
    func creatNextPlatform() {
        let node = SCNNode()
        //随机大小
        let radius = Int.random(in: 2...5)
        let cylinder = SCNCylinder.init(radius: CGFloat(radius), height: 2)
        //随机颜色
        let r = arc4random()%255
        let g = arc4random()%255
        let b = arc4random()%255
        let color = UIColor(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: 1)
        cylinder.firstMaterial?.diffuse.contents = color
        node.geometry = cylinder
        
        let body = SCNPhysicsBody.dynamic()
        body.restitution = 1
        body.friction = 1
        body.damping = 0
        body.allowsResting = true
        body.categoryBitMask = CollisionDetectionMask.platform.rawValue
        body.collisionBitMask = CollisionDetectionMask.jumper.rawValue|CollisionDetectionMask.floor.rawValue|CollisionDetectionMask.platform.rawValue|CollisionDetectionMask.oldPlatform.rawValue
        if #available(iOS 9.0, *) {
            body.contactTestBitMask = CollisionDetectionMask.jumper.rawValue
        } else {
            // Fallback on earlier versions
        }
        
        node.physicsBody = body
        
        //随机位置
        if var position = self.platform?.presentation.position{
            let a = Int.random(in: 0...1)
            if a == 0{
                position.x += 12
            }else{
                position.z -= 12
            }
            position.y += 5
            node.position = position
        }
        
        self.scene.rootNode.addChildNode(node)
        self.nextPlatform = node
    }
    
    @objc func gameDidOver() {
        print("****************----game over----*****************")
        restart()
    }
    
    private var scene:SCNScene = {
        let scene = SCNScene()
        scene.physicsWorld.gravity = SCNVector3(0, -kGravityValue, 0)
        return scene
    }()
    
    private var sceneView:SCNView! = {
        let view = SCNView()
        view.allowsCameraControl = false
        view.autoenablesDefaultLighting = false
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var floor:SCNNode = {
        let node = SCNNode()
        let floor = SCNFloor()
        floor.firstMaterial?.diffuse.contents = UIImage(named: "floor")
        node.geometry = floor
        
        let body = SCNPhysicsBody.static()
        body.restitution = 0
        body.friction = 1
        body.damping = 0.3
        body.categoryBitMask = CollisionDetectionMask.floor.rawValue
        body.collisionBitMask = CollisionDetectionMask.jumper.rawValue|CollisionDetectionMask.platform.rawValue|CollisionDetectionMask.oldPlatform.rawValue
        if #available(iOS 9.0, *) {
            body.contactTestBitMask = CollisionDetectionMask.jumper.rawValue
        } else {
            // Fallback on earlier versions
        }
        node.physicsBody = body
        
        return node
    }()
    
    private var jumper:SCNNode = {
        let node = SCNNode()
        let box = SCNBox.init(width: 1, height: 1, length: 1, chamferRadius: 0)
        box.firstMaterial?.diffuse.contents = UIColor.white
        node.geometry = box
        
        let body = SCNPhysicsBody.dynamic()
        body.restitution = 0
        body.friction = 1
        body.rollingFriction = 1
        body.damping = 0.3
        body.allowsResting = true
        body.categoryBitMask = CollisionDetectionMask.jumper.rawValue
        body.collisionBitMask = CollisionDetectionMask.floor.rawValue|CollisionDetectionMask.platform.rawValue|CollisionDetectionMask.oldPlatform.rawValue
        node.physicsBody = body
        node.position = SCNVector3.init(x: 0, y: 12, z: 0)
        return node
    }()
    

    private var camera:SCNNode = {
        let node = SCNNode()
        node.camera = SCNCamera()
        node.camera?.zFar = 200.0
        node.camera?.zNear = 0.1
        node.eulerAngles = SCNVector3.init(x: -0.7, y: 0.6, z: 0)
        return node
    }()
    
    
    private lazy var light:SCNNode = {
        let node = SCNNode()
        let light = SCNLight()
        light.color = UIColor.white
        light.type = SCNLight.LightType.omni
        node.light = light
        return node
    }()
    
    private lazy var scroLab:UILabel = {
        let l = UILabel(frame: CGRect(x: 20, y: 84, width: 300, height: 20))
        l.numberOfLines = 0
        l.textColor = UIColor.black
        l.text = "分数：0"
        return l
    }()
    
    private lazy var restartBtn:UIButton = {
        let b = UIButton(type: UIButton.ButtonType.custom)
        b.setTitle("RESTART", for: .normal)
        b.frame = CGRect(x: 220, y: 220, width: 200, height: 100)
        b.setTitleColor(UIColor.black, for: .normal)
        b.backgroundColor = UIColor.yellow
        b.addTarget(self, action: #selector(dprepare), for: .touchUpInside)
        return b
    }()
    
    @objc func restart() {

//        score = 0
//        lastPlatform = nil
//        platform = nil
//        nextPlatform = nil
//        restartBtn.center = view.center
//        if let l = longG {
//            view.removeGestureRecognizer(l)
//            longG = nil
//        }
//        sceneView.removeFromSuperview()
//        
//        UIView.animate(withDuration: 1, animations: {
//            self.view.addSubview(self.restartBtn)
//        }) { (_) in
//        }
    }
    
    @objc func dprepare() {
        restartBtn.removeFromSuperview()
        creatFirstPlatform()
        self.makeUI()
    }
}


extension SceneKitVC:SCNPhysicsContactDelegate{
    func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
        let bodyA = contact.nodeA.physicsBody
        let bodyB = contact.nodeB.physicsBody

        
        var jumper:SCNPhysicsBody?
        var another:SCNPhysicsBody?
        if bodyA?.categoryBitMask == CollisionDetectionMask.jumper.rawValue{
            jumper = bodyA
            another = bodyB
        }
        if bodyB?.categoryBitMask == CollisionDetectionMask.jumper.rawValue{
            jumper = bodyB
            another = bodyA
        }
        
        if let _ = jumper,let a = another{
            if a.categoryBitMask == CollisionDetectionMask.floor.rawValue{
                if #available(iOS 9.0, *) {
                    a.contactTestBitMask = CollisionDetectionMask.none.rawValue
                } else {
                    // Fallback on earlier versions
                }
                performSelector(onMainThread: #selector(gameDidOver), with: nil, waitUntilDone: false)
            }else if a.categoryBitMask == CollisionDetectionMask.platform.rawValue{
                a.categoryBitMask = CollisionDetectionMask.oldPlatform.rawValue
                performSelector(onMainThread: #selector(jumpCompleted), with: nil, waitUntilDone: false)
            }
            
        }
    }
}
