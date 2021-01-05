//
//  MIMotion.swift
//  MIHousekeeper
//
//  Created by WangBo on 2021/1/4.
//  Copyright © 2021 影子. All rights reserved.
//

import Foundation
import CoreMotion

class MIMotion {
    
    static let share = MIMotion()
        
    private let motionManager = CMMotionManager()
    
    private var direction: UIInterfaceOrientation = .portrait
 
    func getOriention() -> UIInterfaceOrientation? {
        if motionManager.isAccelerometerAvailable {
            motionManager.startAccelerometerUpdates()
            if let acceleration = motionManager.accelerometerData?.acceleration {
                return landscapeOtiention(acceleration: acceleration)
            }
        }
        return nil
    }
    
    func realTime() {
        motionManager.accelerometerUpdateInterval = 2
        let q = OperationQueue.current
        motionManager.startAccelerometerUpdates(to: q!) { (data, error) in
            let rota = data?.acceleration
            print("--------x:\(rota!.x)--------y:\(rota!.y)--------z:\(rota!.z)")
        }
    }
    
    @objc func landscapeOtiention(acceleration: CMAcceleration) -> UIInterfaceOrientation {
        
        let x = acceleration.x
        let y = acceleration.y
         
        if (fabs(x) > fabs(y)) {
            if (x < 0) {
                direction = .landscapeRight
            } else {
                direction = .landscapeLeft
            }
        }
        return direction
    }
    
    @objc func allOriention(acceleration: CMAcceleration) -> UIInterfaceOrientation {
        
        let x = acceleration.x
        let y = acceleration.y
        
        if (fabs(x) > fabs(y)) {
            if (x < 0) {
                direction = .landscapeRight
            } else {
                direction = .landscapeLeft
            }
        } else {
            if (y < 0) {
                direction = .portrait
            } else {
                direction = .portraitUpsideDown
            }
        }
        return direction
    }
    
    func stop() {
        motionManager.stopDeviceMotionUpdates()
    }
}
