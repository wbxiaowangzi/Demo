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
    
    case AnomalyButton
    case Video
    case WebView
    
    var theVC: UIViewController? {
        switch self {
        case .AnomalyButton:
            return AnomalyButtonVC()
        case .Video:
            return VideoVC()
        case .WebView:
            return WebVC()
        }
    }
}


