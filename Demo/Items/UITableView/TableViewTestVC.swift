//
//  TableViewTestVC.swift
//  Demo
//
//  Created by WangBo on 2021/1/22.
//  Copyright © 2021 wangbo. All rights reserved.
//

import UIKit
import SnapKit
import UITableView_FDTemplateLayoutCell

class TableViewTestVC: UIViewController {

    var heights = [100,200,300]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        addPerfectView()
    }
    
    private func addPerfectView() {
        let t = self.createTable(with: CGRect(x: 0, y: 0, width: 636, height: 848))
        t.backgroundColor = .clear
        t.register(UINib.init(nibName: TheCell.identifier, bundle: Bundle.main), forCellReuseIdentifier: TheCell.identifier)
        t.register(UINib.init(nibName: TheCell2.identifier, bundle: Bundle.main), forCellReuseIdentifier: TheCell2.identifier)

//        t.estimatedRowHeight = adaptH(200)
//        t.rowHeight = UITableView.automaticDimension
        self.view.addSubview(t)
        t.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
    }
    
    func createTable(with frame: CGRect) -> UITableView {
        let t = UITableView.init(frame: frame,style: .plain)
        t.backgroundColor = .white
        t.dataSource = self
        t.delegate = self
        t.separatorStyle = .none
        t.showsVerticalScrollIndicator = false
        return t
    }

}

extension TableViewTestVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        print("-----tableView heightForRowAt")
        return tableView.fd_heightForCell(withIdentifier: TheCell.identifier, cacheBy: indexPath) { (cell) in
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("-----tableView cellForRowAt")

        if let cell = tableView.dequeueReusableCell(withIdentifier: TheCell.identifier) as? TheCell {
            cell.H.constant = CGFloat(heights[indexPath.row])
            cell.buttonClick = {[weak self] in
                self?.heights.insert(500, at: 0)
                tableView.reloadData()
            }
            return cell
        }
        return UITableViewCell()
    }
}
