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

//    func testThrottle() {
//        let throttle = Throttler.init(seconds: 5)
//        throttle.throttle {
//            var i = 0
//            while i < 100 {
//                sleep(1)
//                NSLog("%d", i)
//                i += 1
//            }
//        }
//    }
//
//    fileprivate func testOverTime() {
//        let a = OverTimeHandler.init(with: 5) {
//            print("5秒过去了，超时了")
//            }.start()
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
//            a.necessoryToExecuteHandler = false
//        }
//    }
    
    func login() {
        print("login...")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UMTool.sdBeginLogPageView(UMPageName.home)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UMTool.sdEndLogPageView(UMPageName.home)
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
        if let vc = toValue.theVC {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension ViewController {
    
    func lazyDatas() -> [VCType] {
        return [.Thread,
                .SQLite,
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
                .JSPatchTest,
                .OCTest,
                .SmoothTableVoew,
                .ImagePicker,
                .Caton,
                .Buttons,
                .Trans,
                .Filter,
                .TableView,
                .ppvc,
                .AVPlayer]
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
    case JSPatchTest
    case OCTest
    case SmoothTableVoew
    case ImagePicker
    case Caton
    case Buttons
    case Trans
    case Filter
    case Thread
    case TableView
    case ppvc
    case AVPlayer
    
    var theVC: UIViewController? {
        switch self {
        case .CALayer:
            return CALayerVC()
        case .CoreAnimation:
            return CoreAnimationVC()
        case .MVVM:
            return MVVMVC()
        case .Transition:
            return TransitionVC()
        case .RotatyTable:
            return RotaryTableVC()
        case .GifBG:
            return GifBGVC()
        case .Metal:
            return MetalVC()
        case .SceneKit:
            return SceneKitVC()
        case .Radar:
            return RadarVC()
        case .OpenGL:
            return OpenGLVC()
        case .RXSwift:
            return RXSwiftVC()
        case .SQLite:
            return SQLiteVC()
        case .AvatarX:
            return BaseVC()
        case .SizeClass:
            return SizeClassVC()
        case .Luck:
            return LuckVC()
        case .JSPatchTest:
            return JSPatchTestVC()
        case .OCTest:
            return OCTestVC()
        case .SmoothTableVoew:
            return SmoothTableView()
        case .ImagePicker:
            return ImagePickerVC()
        case .Caton:
            return CatonVC()
        case .Buttons:
            return ButtonsVC()
        case .Trans:
            return TransVC()
        case .Filter:
            return FilterVC()
        case .Thread:
            return ThreadVC()
        case .TableView:
            return TableViewTestVC()
        case .ppvc:
            return PPVC()
        case .AVPlayer:
            return AVPlayerVC()g
        }
    }
}


