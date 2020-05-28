//
//  Debouncer.swift
//  Demo
//
//  Created by WangBo on 2019/4/18.
//  Copyright © 2019 wangbo. All rights reserved.
//

import Foundation

class Debouncer {

    public let label: String

    public let interval: DispatchTimeInterval

    fileprivate let queue: DispatchQueue

    fileprivate let semaphore: DispatchSemaphoreWrapper

    fileprivate var workItem: DispatchWorkItem?
    
    public init(label: String, interval: Float, qos: DispatchQoS = .userInteractive) {
        self.interval  = .milliseconds(Int(interval * 1000))
        self.label     = label
        self.queue     = DispatchQueue(label: "com.farfetch.debouncer.internalqueue.\(label)", qos: qos)
        self.semaphore = DispatchSemaphoreWrapper(withValue: 1)
    }
    
    public func call(_ callback: @escaping (() -> ())) {
        self.semaphore.sync  { () -> () in
            self.workItem?.cancel()
            self.workItem = DispatchWorkItem {
                callback()
            }
            if let workItem = self.workItem {
                self.queue.asyncAfter(deadline: .now() + self.interval, execute: workItem)
            }
        }
    }
    
}

public struct DispatchSemaphoreWrapper {
    
    private let semaphore: DispatchSemaphore
    
    public init(withValue value: Int) {
        
        self.semaphore = DispatchSemaphore(value: value)
    }
    
    public func sync<R>(execute: () throws -> R) rethrows -> R {
        
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
        defer { semaphore.signal() }
        return try execute()
    }
}
