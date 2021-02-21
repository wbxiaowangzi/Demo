//
//  FilterVC.swift
//  Demo
//
//  Created by WangBo on 2020/12/2.
//  Copyright © 2020 wangbo. All rights reserved.
//

import UIKit

class ThreadVC: UIViewController {
    
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var topView: UIView!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension ThreadVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.lazyCellNames().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let name = self.lazyCellNames()[indexPath.row]
        cell.textLabel?.text = name
        return cell
    }
}

extension ThreadVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let toValue = self.lazyCellNames()[indexPath.row]
        switch toValue {
        case self.lazyCellNames()[0]:
            self.one()
        case self.lazyCellNames()[1]:
            self.two()
        case self.lazyCellNames()[2]:
            self.three()
        default:
            self.textView.text = ""
        }
    }
}

extension ThreadVC {

    func lazyCellNames() -> Array<String> {
        return ["1", "2", "3","clear"]
    }
    
    func taskOne() {
        self.display(content: "任务1")
    }
    
    func taskTwo() {
        self.display(content: "barrier任务2")
    }
    
    func taskThree() {
        self.display(content: "任务3")
    }
    
    private func executeQueue(queue: DispatchQueue) {
        self.display(content: "\r-------------------")
        queue.async {
            self.taskOne()
        }
        queue.async(flags: .barrier) {
            self.taskTwo()
        }
        queue.async {
            self.taskThree()
        }
    }
    
    private func one() {
        let q = DispatchQueue.global()
        for _ in 0..<10 {
            executeQueue(queue: q)
        }
    }
    
    private func two() {
        let q = DispatchQueue.init(label: "concurrent", qos: .default, attributes: .concurrent)
        executeQueue(queue: q)
    }
    
    private func three() {
        let q = DispatchQueue.init(label: "serial")
        executeQueue(queue: q)
    }
    
    private func display(content: String) {
        print(content)
        DispatchQueue.main.async {
            var t = self.textView.text ?? ""
            t += content + "\r"
            self.textView.text = t
            if t.count > 0 {
                let botom = NSMakeRange(t.count-1, 1)
                self.textView.scrollRangeToVisible(botom)
            }
        }
    }
}
