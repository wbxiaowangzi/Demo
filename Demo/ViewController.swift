//
//  ViewController.swift
//  Demo
//
//  Created by 王波 on 2018/6/10.
//  Copyright © 2018年 wangbo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

extension ViewController: UITableViewDataSource{
    
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

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let toValue = self.lazyCellNames()[indexPath.row]
        switch toValue {
        case "CALayer":
            self.navigationController?.gotoCALayerVC()
        case "CoreAnimation":
            self.navigationController?.gotoCoreAnimationVC()
        case "MVVM":
            self.navigationController?.gotoMVVMVC()
        default:
            print("error target viewController")
        }
    }
}

extension ViewController{
    
    func lazyCellNames() -> Array<String>{
        
        return ["CALayer","CoreAnimation","MVVM"]
    }
    
}

