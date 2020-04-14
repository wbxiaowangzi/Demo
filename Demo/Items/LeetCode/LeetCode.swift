//
//  File.swift
//  Demo
//
//  Created by WangBo on 2019/3/16.
//  Copyright © 2019 wangbo. All rights reserved.
//

import Foundation
//  Definition for singly-linked list.
public class ListNode {
    public var val: Int
    public var next: ListNode?
    public init(_ val: Int) {
        self.val = val
        self.next = nil
    }
    
}


class LeetCode{
    
    static func twoSum(_ nums: [Int], _ target: Int) -> [Int] {
        var dic = [Int:Int]()
        for i in 0..<nums.count{
            let t = target-nums[i]
            if dic.keys.contains(t),dic[t] != i{
                return [dic[t]!,i]
            }
            dic[nums[i]] = i
        }
        return [0]
    }
    //twoSum([1,2,3,4,5], 5)
    
    static func addTwoNumbers(_ l1: ListNode?, _ l2: ListNode?) -> ListNode? {
        var next1 = l1
        var next2 = l2
        var val1 = l1?.val
        var val2 = l2?.val
        var sumVal = 0
        var carry = 0
        let result = ListNode(0)
        var current = result
        while (next1 != nil || next2 != nil) {
            if next2 == nil{
                val2 = 0
            }
            if next1 == nil{
                val1 = 0
            }
            sumVal = val1! + val2! + carry
            carry = sumVal/10
            let tl = ListNode(sumVal%10)
            current.next = tl
            current = current.next!
            next1 = next1?.next
            next2 = next2?.next
            val1 = next1?.val
            val2 = next2?.val
        }
        if carry > 0 {
            current.next = ListNode(carry)
        }
        return result.next
    }
    
    
}
