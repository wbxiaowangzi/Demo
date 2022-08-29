//
//  ItemType.swift
//  MetalDemo
//
//  Created by WangBo on 2022/8/29.
//  Copyright © 2022 wangbo. All rights reserved.
//

import Foundation
import UIKit

enum VCType: String {
    case Metal
    case SceneKit
    
    var theVC: UIViewController? {
        switch self {
        case .Metal:
            return MetalVC()
        case .SceneKit:
            return SceneKitVC()
        }
    }
}


