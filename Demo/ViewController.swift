//
//  ViewController.swift
//  Demo
//
//  Created by 王波 on 2018/6/10.
//  Copyright © 2018年 wangbo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        //testThrottle()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func testThrottle(){
        let throttle = Throttler.init(seconds: 5)
        throttle.throttle {
            var i = 0
            while i < 100{
                sleep(1)
                NSLog("%d", i)
                i += 1
            }
        }
    }
    
    fileprivate func testOverTime(){
        let a = OverTimeHandler.init(with: 5) {
            print("5秒过去了，超时了")
            }.start()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            a.necessoryToExecuteHandler = false
        }
    }
}

extension ViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.lazyCellNames().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let name = self.lazyCellNames()[indexPath.row]
        cell.textLabel?.text = name
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let toValue = self.lazyCellNames()[indexPath.row]
        switch toValue {
        case VCType.CALayer.rawValue:
            self.navigationController?.gotoCALayerVC()
        case VCType.CoreAnimation.rawValue:
            self.navigationController?.gotoCoreAnimationVC()
        case VCType.MVVM.rawValue:
            self.navigationController?.gotoMVVMVC()
        case VCType.Transition.rawValue:
            self.navigationController?.gotoTransitionVC()
        case VCType.RotatyTable.rawValue:
            self.navigationController?.gotoRotaryTableVC()
        case VCType.GifBG.rawValue:
            self.navigationController?.gotoGifBGVC()
        case VCType.Metal.rawValue:
            self.navigationController?.gotoMetalVC()
        case VCType.SceneKit.rawValue:
            self.navigationController?.gotoSceneKitVC()
        case VCType.Radar.rawValue:
            self.navigationController?.gotoRadarVC()
        case VCType.OpenGL.rawValue:
            self.navigationController?.gotoOpenGLVC()
        case VCType.RXSwift.rawValue:
            self.navigationController?.gotoRXSwiftVC()
        case VCType.SQLite.rawValue:
            self.navigationController?.gotoSQLiteVC()
        case VCType.AvatarX.rawValue:
            self.navigationController?.gotoAvatarXVC()
        case VCType.SizeClass.rawValue:
            self.navigationController?.gotoSizeClassVC()
        case VCType.Luck.rawValue:
            self.navigationController?.gotoLuckVC()
        default:
            print("error target viewController")
        }
    }
}

extension ViewController{
    
    func lazyCellNames() -> Array<String>{
        
        return [VCType.SQLite.rawValue,
                VCType.RXSwift.rawValue,
                VCType.OpenGL.rawValue,
                VCType.Radar.rawValue,
                VCType.SceneKit.rawValue,
                VCType.Metal.rawValue,
                VCType.GifBG.rawValue,
                VCType.CoreAnimation.rawValue,
                VCType.AvatarX.rawValue,
                VCType.SizeClass.rawValue,
                VCType.CALayer.rawValue,
                VCType.Luck.rawValue]
        
    }
    
}

enum VCType:String {
    case CALayer = "CALayer"
    case CoreAnimation = "CoreAnimation"
    case MVVM = "MVVM"
    case Transition = "Transition"
    case RotatyTable = "RotatyTable"
    case GifBG = "GifBG"
    case Metal = "Metal"
    case SceneKit = "SceneKit"
    case Radar = "Radar"
    case OpenGL = "Opengl"
    case RXSwift = "RXSwift"
    case SQLite = "SQLite"
    case AvatarX = "AvatarX"
    case SizeClass = "SizeClass"
    case Luck = "Luck"
}
