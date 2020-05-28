//
//  Solution.swift
//  Demo
//
//  Created by WangBo on 2020/4/14.
//  Copyright © 2020 wangbo. All rights reserved.
//

import Foundation

class Solution {
    
    /*
     给你两个 非空 链表来代表两个非负整数。数字最高位位于链表开始位置。它们的每个节点只存储一位数字。将这两数相加会返回一个新的链表。
     你可以假设除了数字 0 之外，这两个数字都不会以零开头。
     */
    func addTwoNumbers(_ l1: ListNode?, _ l2: ListNode?) -> ListNode? {
        var arr0 = [Int]()

        var arr1 = [Int]()

        var n0 = l1

        var n1 = l2
        while n0 != nil || n1 != nil {
            if n0 != nil {
                arr0.append(n0!.val)
                n0 = n0?.next
            } else {
                arr0.insert(0, at: 0)
            }
            if n1 != nil {
                arr1.append(n1!.val)
                n1 = n1?.next
            } else {
                arr1.insert(0, at: 0)
            }
        }
        
        var res = [Int]()

        var i = arr0.count-1

        var carry = 0
        while i>=0 {
            res.insert((arr1[i]+arr0[i]+carry)%10, at: 0)
            carry = (arr1[i]+arr0[i])/10
            i -= 1
        }
        if carry > 0 {
            res.insert(carry, at: 0)
        }
        //思路1：给长度不足的node添加value为0的node 然后直接给两个node按位相加对十取余
        //思路2：给所有的value提取成两个数组，然后让两个数组按约定相加，最后用结果创建新的node
        return node(from: res)
    }
    
    func node(from arr: [Int]) -> ListNode? {
        var result: ListNode?

        var currentNode: ListNode?
        for i in arr {
            let node = ListNode(i)
            if result == nil {
                result = node
                currentNode = node
            } else {
                currentNode!.next = node
                currentNode = node
            }
        }
        return result
    }
}
