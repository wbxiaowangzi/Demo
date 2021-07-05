//
//  TheCell2.swift
//  Demo
//
//  Created by WangBo on 2021/1/22.
//  Copyright © 2021 wangbo. All rights reserved.
//

import UIKit

class TheCell2: UITableViewCell {
    static let identifier = "TheCell2"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func bigger(_ sender: Any) {
        self.setNeedsDisplay()
    }
    
    @IBAction func smaller(_ sender: Any) {
        self.setNeedsDisplay()
    }
    
}
