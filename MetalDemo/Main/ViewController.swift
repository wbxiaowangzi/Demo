//
//  ViewController.swift
//  MetalDemo
//
//  Created by WangBo on 2022/8/29.
//  Copyright © 2022 wangbo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
    }
}

extension ViewController {
    
    func lazyDatas() -> [VCType] {
        return [.SceneKit,
                .Metal]
    }
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.lazyDatas().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let name = self.lazyDatas()[indexPath.row]
        cell.textLabel?.text = name.rawValue
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let toValue = self.lazyDatas()[indexPath.row]
        if let vc = toValue.theVC {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
