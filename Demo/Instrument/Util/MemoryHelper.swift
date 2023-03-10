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
    
    static func usedMemory() -> UInt64 {
        var taskInfo = mach_task_basic_info()
        var count = mach_msg_type_number_t(MACH_TASK_BASIC_INFO_COUNT)
        let kerr = withUnsafeMutablePointer(to: &taskInfo) {
            taskInfoPtr in
            taskInfoPtr.withMemoryRebound(to: integer_t.self, capacity: 1) {
                taskInfoIntPtr in
                task_info(mach_task_self_,
                          task_flavor_t(MACH_TASK_BASIC_INFO),
                          taskInfoIntPtr,
                          &count)
            }
        }
        guard kerr == KERN_SUCCESS else { return 0 }
        return taskInfo.resident_size
    }
    
    static func freeMemory() -> UInt64 {
        var stats = vm_statistics_data_t()
        var count = UInt32(MemoryLayout<vm_statistics_data_t>.size / MemoryLayout<integer_t>.size)
        let result = withUnsafeMutablePointer(to: &stats) {
            $0.withMemoryRebound(to: integer_t.self, capacity: Int(count)) {
                host_statistics(mach_host_self(), HOST_VM_INFO, $0, &count)
            }
        }
        guard result == KERN_SUCCESS else { return 0 }
        let freeCount = UInt64(stats.free_count) * UInt64(vm_page_size)
        return freeCount
    }
}
