//
//  SmoothTableViewCell.swift
//  Demo
//
//  Created by WangBo on 2020/4/23.
//  Copyright © 2020 wangbo. All rights reserved.
//

import UIKit

class SmoothTableViewCell: UITableViewCell {
    static let identifier = "SmoothTableViewCell"
    @IBOutlet weak var icon: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
