//
//  TransVC.swift
//  Demo
//
//  Created by WangBo on 2020/11/27.
//  Copyright © 2020 wangbo. All rights reserved.
//

import UIKit

class TransVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

extension TransVC: UITableViewDataSource {
    
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

extension TransVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let toValue = self.lazyCellNames()[indexPath.row]
        switch toValue {
        case self.lazyCellNames()[0]:
            self.t1()
        case self.lazyCellNames()[1]:
            self.t2()
        case self.lazyCellNames()[2]:
            self.t3()
        case self.lazyCellNames()[3]:
            self.t4()
        case self.lazyCellNames()[4]:
            self.t5()
        case self.lazyCellNames()[5]:
            self.t6()
        default:
            print("error target viewController")
        }
    }
}

extension TransVC {
    
    func lazyCellNames() -> Array<String> {
        return ["渐显", "侧滑", "弹性Pop","扩散圆","底部卡片","Pop/Push开门动画"]
    }
    
    private func t1() {
        let vc = YMFadeFromViewController()
        let nav = UINavigationController.init(rootViewController: vc)
        self.present(nav, animated: true, completion: nil)
    }
    
    private func t2() {
        let vc = YMSwipeFromViewController()
        let nav = UINavigationController.init(rootViewController: vc)
        self.present(nav, animated: true, completion: nil)
    }
    
    private func t3() {
        let vc = YMPopupFromViewController()
        let nav = UINavigationController.init(rootViewController: vc)
        self.present(nav, animated: true, completion: nil)
    }
    
    private func t4() {
        let vc = YMCircleFromViewController()
        let nav = UINavigationController.init(rootViewController: vc)
        self.present(nav, animated: true, completion: nil)
    }
    
    private func t5() {
        let vc = YMCardFromViewController()
        let nav = UINavigationController.init(rootViewController: vc)
        self.present(nav, animated: true, completion: nil)
    }
    
    private func t6() {
        let vc = YMOpenViewController()
        self.navigationController?.delegate = vc
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
