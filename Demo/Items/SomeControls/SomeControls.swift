//
//  File.swift
//  Demo
//
//  Created by WangBo on 2019/3/27.
//  Copyright © 2019 wangbo. All rights reserved.
//

import Foundation
import UIKit

enum CellAlignType {
    case left
    case center
    case right
}

class MenuFlowLayout: UICollectionViewFlowLayout {
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder: ) has not been implemented")
    }
    
    //cell间距
    var internalSpace: CGFloat = 0 {
        didSet {
            self.minimumInteritemSpacing = internalSpace
        }
    }
    //对齐方式
    var cellAlignType: CellAlignType = .center
    
    //当前行宽
    var lineCellsWidth: CGFloat = 0
    
    convenience init(with alignType: CellAlignType) {
        self.init()
        cellAlignType = alignType
    }
    
    convenience init(with alignType: CellAlignType, internalSpace: CGFloat) {
        self.init()
        cellAlignType = alignType
        self.internalSpace = internalSpace
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let layoutAttributes_super = super.layoutAttributesForElements(in: rect) ?? [UICollectionViewLayoutAttributes]()

        let layoutAttributes = NSArray(array: layoutAttributes_super, copyItems: true) as! [UICollectionViewLayoutAttributes]

        var layoutAttributes_t = [UICollectionViewLayoutAttributes]()
        for index in 0..<layoutAttributes.count {
            let currentAttr = layoutAttributes[index]

            let previousAttr = index == 0 ? nil : layoutAttributes[index-1]

            let nextAttr = index + 1 == layoutAttributes.count ?
                nil : layoutAttributes[index+1]
            
            layoutAttributes_t.append(currentAttr)
            lineCellsWidth += currentAttr.frame.size.width
            
            let previousY : CGFloat = previousAttr == nil ? 0 : previousAttr!.frame.maxY

            let currentY : CGFloat = currentAttr.frame.maxY

            let nextY: CGFloat = nextAttr == nil ? 0 : nextAttr!.frame.maxY
            
            if currentY != previousY && currentY != nextY {
                if currentAttr.representedElementKind == UICollectionView.elementKindSectionHeader {
                    layoutAttributes_t.removeAll()
                    lineCellsWidth = 0.0
                } else if currentAttr.representedElementKind == UICollectionView.elementKindSectionFooter {
                    layoutAttributes_t.removeAll()
                    lineCellsWidth = 0.0
                } else {
                    self.setCellFrame(with: layoutAttributes_t)
                    layoutAttributes_t.removeAll()
                    lineCellsWidth = 0.0
                }
            } else if currentY != nextY {
                self.setCellFrame(with: layoutAttributes_t)
                layoutAttributes_t.removeAll()
                lineCellsWidth = 0.0
            }
        }
        return layoutAttributes
    }
    
    /// 调整Cell的Frame
    ///
    /// - Parameter layoutAttributes: layoutAttribute 数组
    func setCellFrame(with layoutAttributes : [UICollectionViewLayoutAttributes]) {
        var nowWidth : CGFloat = 0.0
        switch cellAlignType {
        case .left:
            nowWidth = self.sectionInset.left
            for attributes in layoutAttributes {
                var nowFrame = attributes.frame
                nowFrame.origin.x = nowWidth
                attributes.frame = nowFrame
                nowWidth += nowFrame.size.width + self.internalSpace
            }
            break;
        case .center:
            nowWidth = (self.collectionView!.frame.size.width - lineCellsWidth - (CGFloat(layoutAttributes.count - 1) * internalSpace)) / 2
            for attributes in layoutAttributes {
                var nowFrame = attributes.frame
                nowFrame.origin.x = nowWidth
                attributes.frame = nowFrame
                nowWidth += nowFrame.size.width + self.internalSpace
            }
            break;
        case .right:
            nowWidth = self.collectionView!.frame.size.width - self.sectionInset.right
            for var index in 0 ..< layoutAttributes.count {
                index = layoutAttributes.count - 1 - index
                let attributes = layoutAttributes[index]

                var nowFrame = attributes.frame
                nowFrame.origin.x = nowWidth - nowFrame.size.width
                attributes.frame = nowFrame
                nowWidth = nowWidth - nowFrame.size.width - internalSpace
            }
            break;
        }
    }
    
}

