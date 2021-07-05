//
//  HYEndPlayView.swift
//  SuperPlayerDemo
//
//  Created by 黄益 on 2020/7/30.
//  Copyright © 2020 黄益. All rights reserved.
//  视频播放完毕之后的展示

import UIKit

class HYEndPlayView: UIView {
    
    /// 重播
    var replayBtn: UIButton = {
        let btn = UIButton()
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.layer.cornerRadius = 4
        btn.clipsToBounds = true
        btn.setTitle("重新播放", for: .normal)
        btn.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor.white.withAlphaComponent(0.8).cgColor
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        btn.titleLabel?.textAlignment = .center
        return btn
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        createUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createUI() {
        backgroundColor = .black
        
        addSubview(replayBtn)
        replayBtn.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.height.equalTo(42)
            make.width.equalTo(136)
        }
    }

}
