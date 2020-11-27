//
//  MISegment.swift
//  MICommonUI
//
//  Created by WangBo on 2020/11/25.
//

import UIKit

public class MISegment: UIView {
    
    public var selectedValueChangeBlock: ((Int)->Void)?

    private var selectedItemBackgroundColor: UIColor = .gray
    
    private var normalItemBackgroundColor: UIColor = .white
    
    private var selectedItemTitleColor: UIColor = .white
    
    private var normalItemTitleColor: UIColor = .gray
    
    private var itemCornetRadius: CGFloat = 20
    
    private var titleArray = [String]()
    
    private var allButtons = [UIButton]()
    
    private var currentSelectedButton = UIButton()
    
    private var bottomMoveLayer: CALayer!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public func selectItem(index: Int) {
        if let b = allButtons.first(where: {$0.tag == index}) {
            b.sendActions(for: .touchUpInside)
        }
    }
    
    public convenience init (frame: CGRect,
                      titles:[String],
                      selectedItemBackgroundColor: UIColor,
                      normalItemBackgroundColor: UIColor,
                      selectedItemTitleColor: UIColor,
                      normalItemTitleColor: UIColor,
                      itemCornetRadius: CGFloat) {
        self.init(frame: frame)
        self.selectedItemBackgroundColor = selectedItemBackgroundColor
        self.normalItemBackgroundColor = normalItemBackgroundColor
        self.selectedItemTitleColor = selectedItemTitleColor
        self.normalItemTitleColor = normalItemTitleColor
        self.itemCornetRadius = itemCornetRadius
        self.titleArray = titles
        self.ui()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func ui() {
        guard titleArray.count > 0  else {
            return
        }
        layer.masksToBounds = true
        layer.cornerRadius = itemCornetRadius
        backgroundColor = normalItemBackgroundColor
        
        let count = titleArray.count
        let itemW = self.bounds.width/CGFloat(count)
        let itemH = self.bounds.height
        
        bottomMoveLayer = CALayer()
        bottomMoveLayer.frame = CGRect.init(x: 0, y: 0, width: itemW, height: itemH)
        bottomMoveLayer.backgroundColor = selectedItemBackgroundColor.cgColor
        bottomMoveLayer.masksToBounds = true
        bottomMoveLayer.cornerRadius = itemCornetRadius
        layer.addSublayer(bottomMoveLayer)
        
        allButtons.removeAll()
        for i in 0..<count {
            _ = creatButton(with: titleArray[i], tag: i, frame: CGRect.init(x: CGFloat(i)*itemW, y: 0, width: itemW, height: itemH))
        }

    }
    
    private func creatButton(with title: String, tag: Int, frame: CGRect) -> UIButton {
        let b = UIButton.init(type: .custom)
        b.frame = frame
        b.addTarget(self, action: #selector(buttonClick(sender:)), for: .touchUpInside)
        b.setTitleColor(normalItemTitleColor, for: .normal)
        b.setTitleColor(selectedItemTitleColor, for: .selected)
        b.titleLabel?.font = UIFont.init(name: "PingFangSC-Regular", size: 20)
        b.setTitle(title, for: .normal)
        b.backgroundColor = .clear
        b.tag = tag
        if tag == 0 {
            b.isSelected = true
            currentSelectedButton = b
        }
        self.addSubview(b)
        allButtons.append(b)
        return b
    }
    
    @objc private func buttonClick(sender: UIButton) {
        moveBottomView(from: currentSelectedButton.tag, to: sender.tag)
        currentSelectedButton.isSelected = false
        currentSelectedButton = sender
        self.currentSelectedButton.isSelected = true
        selectedValueChangeBlock?(sender.tag)
    }
    
    private func moveBottomView(from: Int, to: Int) {
        let count = titleArray.count
        let itemW = self.bounds.width/CGFloat(count)
        
        let ani = CAKeyframeAnimation(keyPath: "transform.scale.x")
        ani.duration = 0.2
        ani.values = [1,1.8,1]
        ani.repeatCount = 1
        ani.fillMode = .forwards
        ani.isRemovedOnCompletion = false

        let ani1 = CAKeyframeAnimation(keyPath: "transform.translation.x")
        ani1.duration = 0.2
        ani1.values = [CGFloat(from)*itemW,CGFloat(to)*itemW]
        ani1.repeatCount = 1
        ani1.fillMode = .forwards
        ani1.isRemovedOnCompletion = false


        let g = CAAnimationGroup()
        g.animations = [ani,ani1]
        g.duration = 0.2
        g.fillMode = .forwards
        g.isRemovedOnCompletion = false
        g.delegate = self

        self.bottomMoveLayer.add(g, forKey: "anima")
    }
}

extension MISegment: CAAnimationDelegate {
    public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        print("did stop")
    }
}
