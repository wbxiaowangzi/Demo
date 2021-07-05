//
//  TheCell.swift
//  Demo
//
//  Created by WangBo on 2021/1/22.
//  Copyright © 2021 wangbo. All rights reserved.
//

import UIKit

class TheCell: UITableViewCell {
    
    var buttonClick:(()->Void)?
    
    static let identifier = "TheCell"
    
    @IBOutlet weak var H: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func bigger(_ sender: Any) {
        buttonClick?()
    }
    
    @IBAction func smaller(_ sender: Any) {
        buttonClick?()
    }
    
}
