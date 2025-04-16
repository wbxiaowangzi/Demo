//
//  TiledView.swift
//  Demo
//
//  Created by WangBo on 2025/4/16.
//  Copyright © 2025 wangbo. All rights reserved.
//

import UIKit

class TiledView: UIView {
    private var image: UIImage?
    
    override class var layerClass: AnyClass {
        return CATiledLayer.self
    }

    init(frame: CGRect, imageURL: URL) {
        super.init(frame: frame)
        backgroundColor = .clear
        self.image = UIImage(contentsOfFile: imageURL.relativePath)
        setupTiledLayer()
    }
    
    init(frame: CGRect, image: UIImage) {
        super.init(frame: frame)
        backgroundColor = .clear
        self.image = image
        setupTiledLayer()
    }


    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupTiledLayer()
    }

    private func setupTiledLayer() {
        if let tiledLayer = layer as? CATiledLayer {
            tiledLayer.tileSize = CGSize(width: 256, height: 256)
            tiledLayer.levelsOfDetail = 4
            tiledLayer.levelsOfDetailBias = 2
        }
    }

    override func draw(_ layer: CALayer, in ctx: CGContext) {
        if let ci = self.image?.cgImage {
            // 翻转上下文的坐标系
            ctx.translateBy(x: 0, y: layer.bounds.height)
            ctx.scaleBy(x: 1, y: -1)
            ctx.draw(ci, in: layer.bounds)
        }
    }
}
    
