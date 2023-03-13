//
//  MemoryHelper.swift
//  Demo
//
//  Created by WangBo on 2023/3/10.
//  Copyright © 2023 wangbo. All rights reserved.
//

import Foundation

class MemoryHelper {
    
    /*
     usedMemory()方法返回当前已经使用的内存大小（单位：字节），而freeMemory()方法返回当前空闲的内存大小（单位：字节）。
     请注意，这些方法使用了底层的系统调用来获取内存信息。因此，这些方法可能不适用于所有iOS版本和设备。此外，使用这些方法可能会对性能产生一定的影响，因此请谨慎使用。
     */
    
    func usedMemory() -> UInt64 {
        var info = task_basic_info()
        var count = mach_msg_type_number_t(MemoryLayout<task_basic_info>.size) / 4
        let kerr: kern_return_t = withUnsafeMutablePointer(to: &info) {
            $0.withMemoryRebound(to: integer_t.self, capacity: 4) {
                task_info(mach_task_self_, task_flavor_t(TASK_BASIC_INFO), $0, &count)
            }
        }

        guard kerr == KERN_SUCCESS else {
            return 0
        }

        return UInt64(info.resident_size)
    }

    func freeMemory() -> UInt64 {
        var vmStat = vm_statistics_data_t()
        var count = UInt32(MemoryLayout<vm_statistics_data_t>.size / MemoryLayout<integer_t>.size)
        let kerr: kern_return_t = withUnsafeMutablePointer(to: &vmStat) {
            $0.withMemoryRebound(to: integer_t.self, capacity: Int(count)) {
                host_statistics(mach_host_self(), HOST_VM_INFO, $0, &count)
            }
        }

        guard kerr == KERN_SUCCESS else {
            return 0
        }

        return UInt64(vmStat.free_count) * UInt64(vm_page_size)
    }

}
