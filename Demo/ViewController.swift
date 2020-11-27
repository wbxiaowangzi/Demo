//
//  ViewController.swift
//  Demo
//
//  Created by 王波 on 2018/6/10.
//  Copyright © 2018年 wangbo. All rights reserved.
//

import UIKit

enum SDAnimalEnum: CaseIterable {
    case dog
    case cat
    case pig
    case sheep
    case cow
    case bull
    case chicken
    case horse
    case duck
}

class ViewController: UIViewController {
        
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func testThrottle() {
        let throttle = Throttler.init(seconds: 5)
        throttle.throttle {
            var i = 0
            while i < 100 {
                sleep(1)
                NSLog("%d", i)
                i += 1
            }
        }
    }
    
    fileprivate func testOverTime() {
        let a = OverTimeHandler.init(with: 5) {
            print("5秒过去了，超时了")
            }.start()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            a.necessoryToExecuteHandler = false
        }
    }
    
    func login() {
        print("login...")
    }

    
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.lazyDatas().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()

        let name = self.lazyDatas()[indexPath.row]
        cell.textLabel?.text = name.rawValue
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let toValue = self.lazyDatas()[indexPath.row]
        switch toValue {
        case .CALayer:
            self.navigationController?.gotoCALayerVC()
        case .CoreAnimation:
            self.navigationController?.gotoCoreAnimationVC()
        case .MVVM:
            self.navigationController?.gotoMVVMVC()
        case .Transition:
            self.navigationController?.gotoTransitionVC()
        case .RotatyTable:
            self.navigationController?.gotoRotaryTableVC()
        case .GifBG:
            self.navigationController?.gotoGifBGVC()
        case .Metal:
            self.navigationController?.gotoMetalVC()
        case .SceneKit:
            self.navigationController?.gotoSceneKitVC()
        case .Radar:
            self.navigationController?.gotoRadarVC()
        case .OpenGL:
            self.navigationController?.gotoOpenGLVC()
        case .RXSwift:
            self.navigationController?.gotoRXSwiftVC()
        case .SQLite:
            self.navigationController?.gotoSQLiteVC()
        case .AvatarX:
            self.navigationController?.gotoAvatarXVC()
        case .SizeClass:
            self.navigationController?.gotoSizeClassVC()
        case .Luck:
            self.navigationController?.gotoLuckVC()
        case .JSPatchTestVC:
            self.navigationController?.gotoJSPatchTestVC()
        case .OCTestVC:
            self.navigationController?.gotoOCTestVC()
        case .SmoothTableVoew:
            self.navigationController?.gotoSmoothVC()
        case .ImagePicker:
            self.navigationController?.gotoImagePickerVC()
        case .caton:
            self.navigationController?.gotoCatonVC()
        case .buttons:
            self.navigationController?.gotoButtonsVC()
        case .trans:
            self.navigationController?.gotoTransVC()
        }
    }
}

extension ViewController {
    
    func lazyDatas() -> [VCType] {
        return [.SQLite,
                .RXSwift,
                .OpenGL,
                .Radar,
                .SceneKit,
                .Metal,
                .GifBG,
                .CoreAnimation,
                .AvatarX,
                .SizeClass,
                .CALayer,
                .Luck,
                .JSPatchTestVC,
                .OCTestVC,
                .SmoothTableVoew,
                .ImagePicker,
                .caton,
                .buttons,
                .trans]
    }
    
}

enum VCType: String {
    case CALayer
    case CoreAnimation
    case MVVM
    case Transition
    case RotatyTable
    case GifBG
    case Metal
    case SceneKit
    case Radar
    case OpenGL
    case RXSwift
    case SQLite
    case AvatarX
    case SizeClass
    case Luck
    case JSPatchTestVC
    case OCTestVC
    case SmoothTableVoew
    case ImagePicker
    case caton
    case buttons
    case trans
}
