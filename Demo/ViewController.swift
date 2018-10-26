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
        case self.lazyCellNames()[0]:
            self.navigationController?.gotoCALayerVC()
        case self.lazyCellNames()[1]:
            self.navigationController?.gotoCoreAnimationVC()
        case self.lazyCellNames()[2]:
            self.navigationController?.gotoMVVMVC()
        case self.lazyCellNames()[3]:
            self.navigationController?.gotoTransitionVC()
        case self.lazyCellNames()[4]:
            self.navigationController?.gotoRotaryTableVC()
        case self.lazyCellNames()[5]:
            self.navigationController?.gotoGifBGVC()
        case self.lazyCellNames()[6]:
            self.navigationController?.gotoMetalVC()
        case self.lazyCellNames()[7]:
            self.navigationController?.gotoSceneKitVC()
            
        default:
            print("error target viewController")
        }
    }
}

extension ViewController{
    
    func lazyCellNames() -> Array<String>{
        
        return ["CALayer","CoreAnimation","MVVM","Transition","RotatyTable","GifBG","Metal","SceneKit"]
    }
    
}

