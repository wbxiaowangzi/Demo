//
//  OverTimeHandler.swift
//  Demo
//
//  Created by WangBo on 2019/2/20.
//  Copyright © 2019 wangbo. All rights reserved.
//

import UIKit

class OverTimeHandler: NSObject {

    /**超时回调*/
    var overTimeBlock: (() -> Void)?
    /**超时时间阀值: 单位：秒*/
    private var thresholdTime: Int = 5
    /**判定条件*/
    var necessoryToExecuteHandler: Bool = true
    
    convenience init(with thresholdTime: Int, overtimeHandler: @escaping (() -> Void)) {
        self.init()
        self.thresholdTime = thresholdTime
        self.overTimeBlock = overtimeHandler
    }
    
    func start() -> OverTimeHandler {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(thresholdTime)) {
            if self.necessoryToExecuteHandler {
                self.overTimeBlock?()
            } else {
                print("没有超时")
            }
        }
        return self
    }
    
}
