//
//  Throttle.swift
//  Demo
//
//  Created by WangBo on 2019/4/18.
//  Copyright © 2019 wangbo. All rights reserved.
//

import Foundation

public class Throttler {
    
    private let queue: DispatchQueue = DispatchQueue.global(qos: .background)

    private var job: DispatchWorkItem = DispatchWorkItem(block: {})

    private var previousRun: Date = Date.distantPast

    private var maxInterval: Int

    fileprivate let semaphore: DispatchSemaphoreWrapper
    
    init(seconds: Int) {
        self.maxInterval = seconds
        self.semaphore = DispatchSemaphoreWrapper(withValue: 1)
    }
    
    func throttle(block: @escaping () -> ()) {
        
        self.semaphore.sync  { () -> () in
            job.cancel()
            job = DispatchWorkItem() { [weak self] in
                self?.previousRun = Date()
                block()
            }
            let delay = Date.second(from: previousRun) > maxInterval ? 0 : maxInterval
            queue.asyncAfter(deadline: .now() + Double(delay), execute: job)
        }
        
    }
}

private extension Date {
    static func second(from referenceDate: Date) -> Int {
        return Int(Date().timeIntervalSince(referenceDate).rounded())
    }
}
